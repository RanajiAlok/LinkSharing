package Linksharing

class ReadingItem {
    Resource resource
    User reader
    boolean isRead
    boolean isDeleted = false
    static belongsTo = [reader:User, resource:Resource]
    static constraints = {
        resource nullable: false, blank:false
        reader nullable: false, blank:false
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