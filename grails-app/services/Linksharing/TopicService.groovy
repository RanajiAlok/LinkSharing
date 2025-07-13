package Linksharing

import grails.converters.JSON
import Linksharing.Visibility
import grails.plugins.mail.MailService

import javax.transaction.Transactional

@Transactional
class TopicService {
    SubscriptionService subscriptionService
    MailService mailService
    def grailsApplication
    def grailsLinkGenerator

    Map createTopic(String topicName, Visibility visibilityEnum, User user){
        if(!topicName || !user || !visibilityEnum) return null


        boolean exists = Topic.findByTopicNameAndCreatedByAndIsDeleted(topicName, user, false)
        if (exists) return [topic: null, error: "You have already created a topic with this name."]

        Topic topic = new Topic(
                topicName: topicName,
                createdBy: user,
                visibility: visibilityEnum
        )

        println(topic.properties)

        if(topic.validate()){
            topic.save(flush:true, failOnError: true)
            subscriptionService.autoSubscribeOnTopicCreation(user, topic)
            return [topic: topic, error: null]
        }
        else{
            topic.errors.allErrors.each{
                println it
            }
            return [topic: null, error: "Validation failed while creating topic."]
        }

    }

    int getTopicCount(User currentUser){
        return Topic.countByCreatedByAndIsDeleted(currentUser, false)
    }

    def getTrendingTopics(User currentUser) {
        def topics = Topic.executeQuery("""
        SELECT t
        FROM Topic t
        WHERE t.visibility = :visibility
        And t.isDeleted = false
        ORDER BY SIZE(t.resources) DESC
    """, [visibility: Visibility.PUBLIC], [max: 5])

        def topicDataList = topics.collect { topic ->
            topic.resources = topic.resources?.findAll { !it.isDeleted }
            topic.subscriptions = topic.subscriptions?.findAll { !it.isDeleted }

            return [
                    topic       : topic,
                    isSubscribed: subscriptionService.isSubscribed(currentUser, topic),
                    isOwner     : currentUser?.id == topic.createdBy?.id
            ]
        }
        topicDataList = topicDataList.sort { -it.topic.resources?.size() ?: 0 }.take(5)

        return topicDataList
    }

    def updateTopicName(Long id, String newName) {
        Topic topic = Topic.findById(id)
        if (!topic) return [success: false, message: "Topic not found"]

        topic.topicName = newName

        if (!topic.save(flush: true, failOnError: true)) {
            return [success: false, message: "Validation failed"]
        }

        try {
            topic.save(flush: true, failOnError: true)
            return [success: true]
        } catch (org.springframework.orm.hibernate5.HibernateOptimisticLockingFailureException e) {
            log.error("Optimistic Locking Failed while updating topic ${topicId}: ${e.message}")
            throw new RuntimeException("Topic was modified by another user. Please refresh and try again.")
        }

        return [success: false]
    }

    def deleteTopic(Long topicId, User currentUser) {
        def topic = Topic.findById(topicId)

        if (!topic) {
            return [success: false, message: "Topic not found."]
        }

        if (currentUser?.id != topic.createdBy?.id && !currentUser?.admin) {
            return [success: false, message: "You are not authorized to delete this topic."]
        }

        try {
            topic.withTransaction {
                topic.isDeleted = true
                topic.resources.each { resource ->
                    resource.isDeleted = true
                    resource.save(flush: false)

                    resource.readingItems.each { readingItem ->
                        readingItem.isDeleted = true
                        readingItem.save(flush: false)
                    }
                }
                topic.subscriptions*.isDeleted = true
                topic.save(flush: true)
            }
            return [success: true, message: "Topic '${topic.topicName}' deleted successfully."]
        } catch (Exception e) {
            return [success: false, message: "Error deleting topic: ${e.message}"]
        }
    }

    Topic getTopicDetails(Long topicId){
        Topic topic = Topic.get(topicId)
        if(!topic){
            throw new IllegalArgumentException("Topic not found with Id: $topicId")
        }
        return topic
    }

    Map getSubscribers(Long topicId, Integer max =10, Integer offset = 0){
        def topic = Topic.get(topicId)
        if(!topic){
            throw new IllegalArgumentException("Topic not found for ID: $topicId")
        }

        def subscribers = Subscription.createCriteria().list(max:max, offset:offset){
            eq('topic', topic)
            eq('isDeleted', false)
        }

        def subscribersTotal = Subscription.countByTopic(topic)
        return [subscribers:subscribers, subscribersTotal:subscribersTotal, topic:topic]
    }

    def updateTopicVisibility(Long topicId, String visibilityStr) {
        Topic topic = Topic.findById(topicId)
        if (!topic) {
            throw new IllegalArgumentException("Topic not found")
        }

        try {
            topic.visibility = Visibility.valueOf(visibilityStr.toUpperCase())
            topic.save(flush: true, failOnError: true)
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid visibility value")
        }
    }

    List<Topic> getAllTopicCreatedByUser(User user){
        List<Topic> topics = Topic.findAllByCreatedByAndIsDeleted(user,false)
        return topics
    }

    List<Topic> getAllPublicTopics() {
        return Topic.findAllByVisibilityAndIsDeleted(Visibility.PUBLIC ,false, [sort: 'topicName', order: 'asc'])
    }

    List<Topic> getPaginatedTopicsByUser(User user, int max, int offset, String query = null) {
        List<Topic> allTopics = getAllTopicCreatedByUser(user)

        if (query) {
            allTopics = allTopics.findAll {
                it.topicName?.toLowerCase()?.contains(query.toLowerCase())
            }
        }

        return allTopics.drop(offset).take(max)
    }

    def getTopicsForProfile(User profileUser, boolean isCurrentUserOrAdmin, int max = 5, int offset = 0) {
        def topicCriteria = Topic.createCriteria()
        def topicsList = topicCriteria.list(max: max, offset: offset) {
            eq('createdBy', profileUser)
            eq('isDeleted', false)
            if (!isCurrentUserOrAdmin) {
                eq('visibility', Topic.Visibility.PUBLIC)
            }
            order('dateCreated', 'desc')
        }
        return topicsList
    }

    def getTopicsCountForProfile(User profileUser, boolean isCurrentUserOrAdmin) {
        def count = Topic.createCriteria().count {
            eq('createdBy', profileUser)
            eq('isDeleted', false)
            if (!isCurrentUserOrAdmin) {
                eq('visibility', Topic.Visibility.PUBLIC)
            }
        }
        return count
    }

    def inviteByEmail(String email, Long topicId) {
        String token = UUID.randomUUID().toString()
        Date expiration = new Date() + 1

        Topic topic = Topic.get(topicId)
        if (!topic) {
            throw new IllegalArgumentException("Invalid topic ID")
        }
        Invitation invite = new Invitation(
                token:    token,
                email:    email,
                topic:    topic,
                expiresAt: expiration
        )
        invite.save(flush: true)

        String acceptUrl = grailsLinkGenerator.link(
                controller: 'invitation', action: 'accept', absolute: true,
                params: [token: token]
        )
        mailService.sendMail {
            to       email
            subject  "You're invited to topic '${topic.topicName}'"
            text """Hello,

You have been invited to join the topic “${topic.topicName}”.

Please click the link below to accept the invitation:
$acceptUrl

If you cannot click the link, copy and paste it into your browser.

Regards,
Linksharing Team
"""
        }
        return invite
    }


}