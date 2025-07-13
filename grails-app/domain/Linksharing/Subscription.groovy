package Linksharing

enum Seriousness{
    SERIOUS, VERY_SERIOUS, CASUAL
}
class Subscription {
    Topic topic
    User user
    Seriousness seriousness = Seriousness.CASUAL
    Date dateCreated
    boolean isDeleted

    static belongsTo = [user:User , topic:Topic]
    static constraints = {
        topic nullable: false, blank: false
        user nullable: false, blank: false
        seriousness(nullable: false)
        isDeleted defaultValue: false
    }

    void softDelete(){
        this.isDeleted = true
        this.save(flush:true)
    }
    static namedQueries = {
        activeUsers {
            eq 'isDeleted', false
        }
    }
}