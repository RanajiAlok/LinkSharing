package Linksharing

class Resource {
    String description
    User createdBy
    Topic topic
    Date dateCreated
    Date lastUpdated
    boolean isDeleted = false

    static belongsTo = [createdBy:User , topic:Topic]
    static hasMany = [readingItems:ReadingItem]
    static constraints = {
        description nullable: false, blank: false
        createdBy nullable: false, blank: false
        topic nullable: false, blank:false
        isDeleted defaultValue: false
    }

    static mapping = {
        table 'ResourceTable'
    }

    void softDelete(){
        this.isDeleted = true
        this.readingItems.each {it.softDelete()}
        this.save(flush:true)
    }
    static namedQueries = {
        activeUsers {
            eq 'isDeleted', false
        }
    }
}