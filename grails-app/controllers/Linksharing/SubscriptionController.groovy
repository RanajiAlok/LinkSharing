package Linksharing


class SubscriptionController {
    def subscriptionService

    def index() {

    }

    def subscribe(Long topicId){
        Topic topic = Topic.get(topicId)
        def result = subscriptionService.subscribe(session.user, topic)
        flash.message = result.message
        redirect(controller: 'dashboard', action:"index" )
    }

    def unsubscribe(Long topicId){
        Topic topic = Topic.get(topicId)
        def result = subscriptionService.unsubscribe(session.user, topic)
        flash.message = result.message
        redirect(controller: 'dashboard', action: 'index')
    }

    def updateSeriousness(){
        Long topicId = params.long('topicId')
        Topic topic = Topic.get(topicId)
        def seriousness = params.seriousness as Seriousness
        def result = subscriptionService.updateSeriousness(session.user, topic, seriousness)
        flash.message = result.message
        redirect(controller: 'dashboard' , action: 'index')
    }
}