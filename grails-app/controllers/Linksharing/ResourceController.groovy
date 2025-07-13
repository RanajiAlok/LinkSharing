package Linksharing


class ResourceController {
    ResourcesService resourcesService
    TopicService topicService
    ReadingItemsService readingItemsService
    ResourceRatingService resourceRatingService
    SubscriptionService subscriptionService

    def index() {
        User currentUser = session.user
        def trendingTopic = topicService.getTrendingTopics(currentUser)
        Long resourceId = params.long('id')

        Resource resource = Resource.findById(resourceId)
        if (!resourcesService.canViewResource(resource, currentUser)) {
            flash.error = "You don't have permission to view this resource"
            redirect(controller: "dashboard", action: "index")
            return
        }
        if (!resource || resource.isDeleted) {
            flash.message = "Resource not found"
            redirect(controller: 'Topic', action: 'index')
            return
        }



        readingItemsService.markAsRead(resourceId, currentUser)
        def ratingValue = resourceRatingService.getAverageRating(resource)
        boolean isSubscribed = subscriptionService.isSubscribed(currentUser, resource.topic)
        def subscriptionData = subscriptionService.getSubscriptions(session.user)

        render(view: "/Topic/post", model: [
                user: currentUser,
                trendingTopics: trendingTopic,
                resource: resource,
                ratingValue: ratingValue,
                userTopicJson: (subscriptionData.subscriptions.collect {
                    [id: it.topicId, name: it.topic.topicName]
                } as grails.converters.JSON).toString(),
                isSubscribed: isSubscribed
        ])
    }

    def saveLinkResource(){
        String url = params.url
        String description = params.description

        if (!params.topicId) {
            flash.error = "Topic is required"
            redirect(controller: "dashboard", action: "index")
            return
        }

        Long topicId
        try {
            topicId = params.topicId.toLong()
        } catch (NumberFormatException e) {
            flash.message = "Invalid topic ID"
            redirect(controller: "dashboard", action: "index")
            return
        }
        if(url.length()>255){
            flash.message = "Link character exceeds 255 char"
            redirect(controller: "dashboard", action:"index")
            return
        }
        if(!topicId){
            flash.message = "Topic is required"
            redirect(controller: "dashboard", action: "index")
            return
        }
        def result = resourcesService.createLinkResource(url, description, topicId, session.user)
        println(params)

        if(result.success){
            flash.message = result.message
            println("linkresource is shared")
        }
        else {
            flash.error = result.message
            println("linkresource is not shared")
        }

        redirect( controller: 'dashboard' , action: 'index')

    }

    def saveDocumentResource(){

        def result = resourcesService.createDocumentResource(request,params,session.user)
        println(params)

        if(result.success){
            flash.message = result.message
            println("Document is shared successfully")
        }
        else {
            flash.error = result.message
            println("Document is not shared")
        }

        redirect( controller: 'dashboard' , action: 'index')

    }


    def update() {
        User currentUser = session.user
        def result = resourcesService.updateResource(params.long('id'), params.description, currentUser)

        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }

        redirect(action: "index", id: result.resource?.id ?: params.id)
    }

    def delete(Long id) {
        println(params)
        def currentUser = session.user
//        def resource=Resource.get(id)
//        if(currentUser.id != )

        def result = resourcesService.deleteResource(id, currentUser)

        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }

        redirect(controller: "dashboard", action: "index")
    }




}