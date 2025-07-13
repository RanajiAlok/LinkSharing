package Linksharing

class LinkResource extends Resource {
    String url
    boolean isDeleted =false

    static constraints = {
        url url: true
        isDeleted defaultValue: false
    }

    static mapping={
        table 'LinkResourceTable'
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