package Linksharing

class UserController {
    SubscriptionService subscriptionService
    TopicService topicService
    UserService userService
    ResourcesService resourcesService

    def index() {
        User currentUser = session.user
        Integer max = params.int('max') ?: 5
        Integer offset = params.int('offset') ?: 0
        Long profileUserId = params.long('id')
        User profileUser = User.get(profileUserId)
        boolean isCurrentUser = (currentUser?.id == profileUserId)
        boolean isAdmin = (currentUser?.admin)

        boolean isCurrentUserOrAdmin = (isCurrentUser || isAdmin)
        def topicsList = topicService.getTopicsForProfile(profileUser, isCurrentUserOrAdmin, max, offset)
        def topicsTotalCount = topicService.getTopicsCountForProfile(profileUser, isCurrentUserOrAdmin)

        def subscriptionData = subscriptionService.getSubscriptions(currentUser)
        def totalTopicCount = topicService.getTopicCount(currentUser)

        List<Resource> getResourcesByUser = resourcesService.resourceCreatedByUser(currentUser)

        List<Subscription> pagedsubscriptions = subscriptionData.subscriptions.drop(offset).take(max)
        if (request.xhr) {
            render(template: '/templates/userTopicsList', model: [topicsList: topicsList, isCurrentUser: isCurrentUser, isAdmin: isAdmin])
            return
        }
        render(view: "/dashboard/profilepage" , model: [user:currentUser, userTopicCount: totalTopicCount, userSubscriptionCount: subscriptionData.count,
                subscriptions: pagedsubscriptions, postItems:getResourcesByUser , topicsList: topicsList, topicsTotal: topicsTotalCount, isAdmin: isAdmin, isCurrentUser: isCurrentUser,
                                                        userTopicJson: (subscriptionData.subscriptions.collect {
                                                            [id: it.topicId, name: it.topic.topicName]
                                                        } as grails.converters.JSON).toString(),])
    }

    def editProfile(){
        User currentUser = session.user
        def subscriptionData = subscriptionService.getSubscriptions(currentUser)
        def totalTopicCount = topicService.getTopicCount(currentUser)

        int max = params.int('max') ?: 10
        int offset = params.int('offset') ?: 0
        String query = params.query

        List<Topic> paginatedTopics = topicService.getPaginatedTopicsByUser(currentUser, max, offset, query)

        render(view: "/dashboard/editprofile" , model: [user  :currentUser, userTopicCount:totalTopicCount, userSubscriptionCount: subscriptionData.count,
                                                        topics: paginatedTopics, total: totalTopicCount, max: max, offset: offset,
                                                        userTopicJson: (subscriptionData.subscriptions.collect {
                                                            [id: it.topicId, name: it.topic.topicName]
                                                        } as grails.converters.JSON).toString(),])
    }

    def renderImage(Long id){
        User user = User.get(id)
        if(user?.photo){
            response.outputStream<<user.photo
            response.outputStream.flush()
        }
    }

    def updateProfile() {
        User user = session.user
        if (!user) {
            flash.error = "Session expired. Please log in again."
            redirect(controller: 'login', action: 'index')
            return
        }

        def result = userService.updateUserProfile(user, params, request)

        if (result.success) {
            flash.message = "Profile updated successfully."
        } else {
            flash.error = result.message ?: "Failed to update profile. Please check the inputs."
        }

        redirect(action: 'updateProfile')
    }

    def updatePassword() {
        User user = session.user
        if (!user) {
            flash.error = "Session expired. Please log in again."
            redirect(controller: 'login', action: 'index')
            return
        }

        def result = userService.updateUserPassword(user, params.password, params.confirmPassword)

        if (result.success) {
            flash.message = "Password updated successfully."
        } else {
            flash.error = result.message ?: "Failed to update password. Please try again."
        }

        redirect(action: 'index')
    }


}