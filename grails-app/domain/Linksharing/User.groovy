package Linksharing

//import java.sql.Blob

class User {
    String userEmail
    String username
    String password
    String firstName
    String lastName
    byte[] photo
    Boolean admin = false
    Boolean active = true
    Date dateCreated = new Date()
    Date lastUpdated = new Date()
    boolean isDeleted = false


    String resetPasswordToken
    Date resetPasswordTokenExpiryDate

    static hasMany = [topics:Topic , subscriptions:Subscription , resources:Resource, readingItems:ReadingItem, resourceRatings:ResourceRating]
    static constraints = {
        userEmail nullable:false, blank:false, unique:true, email:true
        username nullable:false, blank:false, unique:true, size: 5..12
        password nullable:false, blank:false, minsize: 8
        firstName nullable:false, blank:false
        lastName nullable:true, blank:true
        photo nullable: true, blank:true
        admin nullable:false, blank:false
        active nullable:false, blank:false
        resetPasswordToken nullable: true
        resetPasswordTokenExpiryDate nullable: true
    }

    static mapping = {
        table 'AppUser'
        password column: '`password`'
        isDeleted deafultValue: false
    }

    String getFullName() {
        "${firstName} ${lastName}"
    }

    static namedQueries = {
        activeUsers {
            eq 'isDeleted', false
        }
    }

    void softDelete(){
        this.isDeleted = true

        this.topics.each {it.softDelete()}
        this.resources.each {it.softDelete()}
        this.readingItems.each {it.softDelete()}
        this.save(flush: true)
    }
}