package Linksharing

class ResourceRating {
    Resource resource
    User user
    int score
    boolean isDeleted = false

    static belongsTo = [user:User , resource:Resource]
    static constraints = {
        score nullable:false, blank: false
        user nullable: false, blank:false
        score nullable:false, blank:false
        resource nullable: false, blank:false
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