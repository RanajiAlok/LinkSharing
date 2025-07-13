package Linksharing

import grails.converters.JSON


class DashboardController {
    SubscriptionService subscriptionService
    TopicService topicService
    ResourcesService resourcesService
    ReadingItemsService readingItemsService

    def index() {
        User currentUser = session.user
        Integer max = params.int('max') ?: 5
        Integer offset = params.int('offset') ?: 0
        def subscriptionData = subscriptionService.getSubscriptions(currentUser)
        def totalTopicCount = topicService.getTopicCount(currentUser)

        def query = params.query?.trim()

        if (session.user) {
            List<Invitation> pendingInvites = Invitation.findAllByEmailAndUsed(currentUser.userEmail, false)

            pendingInvites.each { invite ->
                if (!invite.expiresAt || invite.expiresAt > new Date()) {
                    boolean alreadySubscribed = Subscription.findByUserAndTopic(currentUser, invite.topic)

                    if (!alreadySubscribed) {
                        new Subscription(user: currentUser, topic: invite.topic, seriousness: Seriousness.SERIOUS)
                                .save(flush: true, failOnError: true)
                        flash.message = (flash.message ?: "") + "Subscribed via invitation to topic '${invite.topic.topicName}'. "
                    } else {
                        flash.message = (flash.message ?: "") + "Already subscribed to invited topic '${invite.topic.topicName}'. "
                    }

                    invite.used = true
                    invite.save(flush: true)
                }
            }
        }



        ArrayList<Topic> subscribedTopics = subscriptionData.subscriptions*.topic
        def inboxItems = resourcesService.getNewAddedResource(currentUser, subscribedTopics)
        def totalInboxItems = inboxItems.size()
        def pagedsubscriptions = subscriptionData.subscriptions.drop(offset).take(max)
        def pagedInboxItems = inboxItems.drop(offset).take(max)

        def model = [
                user: currentUser,
                subscriptions: pagedsubscriptions,
                userSubscriptionCount: subscriptionData.count,
                userTopicCount: totalTopicCount,
                inboxItems: pagedInboxItems,
                totalInboxItems: totalInboxItems,
                userTopicJson: (subscriptionData.subscriptions.collect {
                    [id: it.topicId, name: it.topic.topicName]
                } as grails.converters.JSON).toString()
        ]

        if (query) {
            List<Resource> searchInboxItems = resourcesService.getResourcesInInboxItems(query, inboxItems)
            searchInboxItems.each { it.metaClass.isRead = readingItemsService.isResourceReadByUser(it, currentUser) }
            model.resources = searchInboxItems
            model.query = query
        }

        render(view: "/dashboard/index", model: model)
    }

    def showTrendingTopic(){
        User currentUser = session.user
        def trendingTopic = topicService.getTrendingTopics(currentUser)
        render (template: "/templates/trendingPosts" , model: [user: currentUser, trendingTopics: trendingTopic])
    }

    def loadSubscriptionsModalContent() {
        User currentUser = session.user
        def subscriptionData = subscriptionService.getSubscriptions(currentUser)
        def topics = subscriptionData.subscriptions*.topic

        topics = topics.sort { it.topicName?.toLowerCase() }

        render(template: '/templates/subscriptionList', model: [topics: topics])
    }

    def search(){
        User currentUser = session.user
        def trendingTopic = topicService.getTrendingTopics(currentUser)
        List<Resource> topPosts = resourcesService.getTopRatedResources()
        println(params)
        String query = params.query?.trim()

        if (!query || query.length() > 255) {
            flash.message = query?.length() > 255 ? "Search query must be less than 255 characters." : null
            render(view: "/Topic/Search", model: [
                    user: currentUser,
                    trendingTopics: trendingTopic,
                    topPosts: topPosts,
                    resources: [],
                    query: query
            ])
            return
        }

        List<Resource> matchingResources = resourcesService.searchResources(query)
        matchingResources.each { it.metaClass.isRead = readingItemsService.isResourceReadByUser(it, currentUser) }
        render(view: '/Topic/Search' , model: [user: currentUser, trendingTopics: trendingTopic , topPosts: topPosts, resources:matchingResources,
                                                                                                                      query    : query])
    }

}