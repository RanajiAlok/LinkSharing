package Linksharing

import javax.transaction.Transactional

@Transactional
class SubscriptionService {

    def subscribe(User user, Topic topic, Seriousness seriousness=Seriousness.SERIOUS) {
        if(Subscription.findByUserAndTopicAndIsDeleted(user, topic, false)){
            return [success: false, message: "Already Subscribed"]
        }

        if (topic.visibility == Visibility.PRIVATE && !invitationService.hasValidInvite(user, topic)){
            return [success: false, message: "You need an invite to subscribe to this private topic"]
        }

        new Subscription(user: user, topic:topic, seriousness:seriousness).save(flush:true , failOnError: true)
        return [success: true, message: "Subscribed successfully"]
    }

    def autoSubscribeOnTopicCreation(User user, Topic topic){
        println("creating new instance of subscription")
        new Subscription(user:user , topic: topic, seriousness: Seriousness.VERY_SERIOUS).save(flush:true, failOnError:true)
        println("user auto subscribed")
    }

    def unsubscribe(User user, Topic topic) {
        if (topic.createdBy.id == user.id) {
            return [success: false, message: "Topic owner cannot unsubscribe"]
        }

        Subscription sub = Subscription.findByUserAndTopicAndIsDeleted(user, topic, false)
        if (sub) {
            sub.isDeleted = true
            sub.save(flush: true)
            return [success: true, message: "Unsubscribed successfully"]
        }

        return [success: false, message: "Not subscribed to topic"]
    }

    def updateSeriousness(User user, Topic topic, Seriousness newLevel) {
        Subscription sub = Subscription.findByUserAndTopicAndIsDeleted(user, topic,false)
        if (sub) {
            sub.seriousness = newLevel
            sub.save(flush: true)
            return [success: true, message: "Seriousness updated"]
        }

        return [success: false, message: "Subscription not found"]
    }

    def getSubscriptions(User user){
        List<Subscription> subscriptions = Subscription.createCriteria().list {
            eq("user", user)
            eq("isDeleted", false)
            topic {
                eq("isDeleted", false)
                order("lastUpdated", "desc")
            }
        }

        subscriptions.each { sub ->
            sub.topic.resources = sub.topic.resources?.findAll { !it.isDeleted }
            sub.topic.subscriptions = sub.topic.subscriptions?.findAll { !it.isDeleted }
        }
        return [
                subscriptions: subscriptions,
                count: subscriptions.size()
        ]
    }

    boolean isSubscribed(User user, Topic topic){
        return Subscription.findByUserAndTopicAndIsDeleted(user, topic, false) != null
    }

}