package Linksharing

import grails.converters.JSON

import javax.transaction.Transactional

@Transactional
class TopicController {

    TopicService topicService
    SubscriptionService subscriptionService
    ResourcesService resourcesService

    def index(Long id) {
        if (!id) {
            flash.message = "Topic Id is missing"
            redirect(controller: "dashboard", action: "index")
            return
        }
        try {
            User currentUser = session.user
            Topic topic = topicService.getTopicDetails(id)
            def isSubscribed = subscriptionService.isSubscribed(currentUser, topic)

            if (topic.visibility == Visibility.PRIVATE) {
                if (!currentUser.admin && !isSubscribed){
                    flash.error = "You don't have access to view this page"
                    redirect(controller: "dashboard", action: "index")
                    return
                }

            }

            def max = params.int('max') ?: 10
            def offset = params.int('offset') ?: 0
            def query = params.q

            def subscribersData = topicService.getSubscribers(id, max, offset)
            def subscriptionData = subscriptionService.getSubscriptions(session.user)
            def postItems = resourcesService.getResource(topic)

            render(view: "/Topic/index", model: [
                    topic: topic,
                    isSubscribed: isSubscribed,
                    subscribers: subscribersData.subscribers,
                    subscribersTotal: subscribersData.subscribersTotal,
                    postItems: postItems,
                    userTopicJson: (subscriptionData.subscriptions.collect {
                        [id: it.topicId, name: it.topic.topicName]
                    } as grails.converters.JSON).toString(),
                    params: params
            ])
        } catch (Exception e) {
            println("Error loading details for ID ${id}: ${e}")
        }
    }


    def createTopic(){
        String topicName = params.name?.trim()
        String visibilityParam = params.visibility

        if(!topicName || !visibilityParam){
            flash.error = "Topic name and visibility are required."
            redirect(controller: "dashboard" ,action: "index")
            return
        }
        if(topicName.length()> 255){
            flash.message = "Topic name exceeds 255 characters."
            redirect(controller: "dashboard", action: "index")
            return
        }
        println(params)

        try{
            Visibility visibilityEnum = Visibility.valueOf(visibilityParam.toUpperCase())
            User currentUser = session.user
            println(currentUser)
            def result  = topicService.createTopic(topicName,  visibilityEnum, currentUser)
            Topic topic = result.topic
            String error = result.error

            if(topic?.id){
                flash.message = "Topic '${topicName}' created successfully."
                redirect(controller: "dashboard" , action: "index")
                return
            }else{
                flash.error = error ?:"Topic failed to create"
            }
        }
        catch (IllegalArgumentException e){
            println("ARguments Error while creating the topic: ${e.message}")
        }
        catch (Exception e){
            println("Error while creating the topic: ${e.message}")
        }

        redirect(controller: "dashboard" , action: "index")
    }

    def updateName() {
        Long id = params.long('id')
        String newName = params.topicName?.trim()

        def result = topicService.updateTopicName(id, newName)
        if(!result){
            flash.error = "Topic Name is not Updated due to some error"
        }
        flash.message = "Topic Name updated successfully"
        render result as JSON
    }

    def delete(Long id) {
        def result = topicService.deleteTopic(id, session.user)

        flash.message = result.message
        redirect(controller: 'dashboard', action: 'index')
    }

    def updateVisibility() {
        println(params)
        def requestJson  = request.JSON

        Long topicId = requestJson.topicId as Long
        String newVisibility = requestJson.visibility

        if (!topicId || !newVisibility) {
            render status: 400, text: "Missing parameters"
            return
        }

        try {
            topicService.updateTopicVisibility(topicId, newVisibility)
            render status: 200, text: "Visibility updated successfully"
        } catch (IllegalArgumentException e) {
            render status: 400, text: e.message
        } catch (Exception e) {
            render status: 500, text: "An error occurred"
        }
    }

    def userTopics() {
        User user = session.user
        List<Topic> allTopics = topicService.getAllTopicCreatedByUser(user)
        render(template: "/templates/topicList", model: [topics: allTopics])
    }



    def showAllPublicTopic() {
        List<Topic> publicTopics = topicService.getAllPublicTopics()

        render(template: '/templates/publicTopicModalContent', model: [publicTopics: publicTopics])
    }

    def invite() {
        String email = params.email
        Long topicId   = params.topicId as Long
        if (!email || !topicId) {
            flash.error = "Email and Topic ID are required."
            redirect(controller: "dashboard", action: "index")
            return
        }
        try {
            topicService.inviteByEmail(email, topicId)
            flash.message = "Invitation sent to $email"
        } catch (Exception e) {
            flash.error = "Failed to send invitation: ${e.message}"
        }
        redirect(controller: "dashboard", action: "index")
    }

}