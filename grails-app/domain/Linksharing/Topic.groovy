package Linksharing

import javax.transaction.Transactional

enum Visibility{
    PUBLIC, PRIVATE
}

class Topic {
    String topicName
    User createdBy
    Date dateCreated = new Date()
    Date lastUpdated = new Date()
    Visibility visibility = Visibility.PUBLIC

    boolean isDeleted = false
    static belongsTo = [createdBy:User]
    static hasMany = [subscriptions:Subscription, resources:Resource]
    static constraints = {
        topicName nullable:false, blank:false
        createdBy nullable: false, blank:false
        isDeleted defaultValue: false
        visibility nullable: false, blank:false
    }
    @Transactional
    void softDelete(){
        this.isDeleted = true
        this.resources.each {it.softDelete()}
        this.save(flush:true)
    }
    static namedQueries = {
        activeUsers {
            eq 'isDeleted', false
        }
    }

}