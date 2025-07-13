package Linksharing

class Invitation {
    String email
    String token
    Topic topic
    boolean used = false
    Date expiresAt
    Date dateCreated
    static constraints = {
        email email: true, blank: false, nullable: false
        token unique:true, blank: false, nullable: false
        topic nullable: false
        expiresAt nullable: true
    }

    static mapping = {
        table 'TopicInvitation'
    }

    boolean isExpired(){
        expiresAt ? (newDate() > expiresAt):false
    }
}