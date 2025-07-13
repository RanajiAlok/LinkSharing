package Linksharing

class DocumentResource extends Resource{
    String filepath
    boolean isDeleted = false

    static constraints = {
        filepath nullable: true
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