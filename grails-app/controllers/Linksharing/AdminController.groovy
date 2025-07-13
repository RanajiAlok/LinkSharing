package Linksharing


class AdminController {
    AdminService adminService
    ResourcesService resourcesService
    SubscriptionService subscriptionService
    def index() {

    }

    def Users(){
        User currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Access denied. You do not have permission to view this page."
            redirect(controller: 'login', action: 'index')
            return
        }

        params.max = Math.min(params.int('max') ?: 20, 100)
        List<User> users = User.list(params)
        def userCount = User.count()
        def subscriptionData = subscriptionService.getSubscriptions(session.user)


        render(view: "/admin/users", model: [users: users, userCount: userCount,
                                             userTopicJson: (subscriptionData.subscriptions.collect {
                                                 [id: it.topicId, name: it.topic.topicName]
                                             } as grails.converters.JSON).toString()])
    }

    def showTopics(){
        def currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Access denied. You do not have permission to view this page."
            redirect(controller: 'login', action: 'index')
            return
        }

        params.max = Math.min(params.int('max') ?: 20, 100)
        List<Topic> topics = adminService.getAllTopics(params)
        def topicCount = adminService.getTopicCount()
        def subscriptionData = subscriptionService.getSubscriptions(session.user)


        render(view: "/admin/showTopics", model: [topics: topics, topicCount: topicCount,userTopicJson: (subscriptionData.subscriptions.collect {
            [id: it.topicId, name: it.topic.topicName]
        } as grails.converters.JSON).toString()])
    }

    def delete(Long id) {
        def result = adminService.deleteTopic(id)

        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }

        redirect(action: 'showTopics')
    }

    def activate(Long id) {
        def currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Unauthorized access."
            redirect(action: "users")
            return
        }

        def result = adminService.activateUser(id)
        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }
        redirect(action: "users")
    }

    def deactivate(Long id) {
        def currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Unauthorized access."
            redirect(action: "users")
            return
        }

        def result = adminService.deactivateUser(id)
        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }
        redirect(action: "users")
    }

    def makeAdmin(Long id) {
        def currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Unauthorized access."
            redirect(action: "users")
            return
        }

        def result = adminService.makeUserAdmin(id)
        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }
        redirect(action: "users")
    }

    def removeAdmin(Long id) {
        def currentUser = session.user
        if (!adminService.isAdmin(currentUser)) {
            flash.error = "Unauthorized access."
            redirect(action: "users")
            return
        }

        def result = adminService.removeUserAdmin(id)
        if (result.success) {
            flash.message = result.message
        } else {
            flash.error = result.message
        }
        redirect(action: "users")
    }


    def showPosts() {
        def result = resourcesService.getPaginatedResources(params)
        def subscriptionData = subscriptionService.getSubscriptions(session.user)


        render(view: '/admin/showPost', model: [resources: result.resources, resourceCount: result.total,
                                                userTopicJson: (subscriptionData.subscriptions.collect {
                                                    [id: it.topicId, name: it.topic.topicName]
                                                } as grails.converters.JSON).toString()])
    }

    def deleteResource(Long id) {
        if (resourcesService.deleteResource(id, session.user)) {
            flash.message = "Resource deleted successfully"
        } else {
            flash.error = "Failed to delete resource"
        }
        redirect(action: 'showPosts')
    }
}