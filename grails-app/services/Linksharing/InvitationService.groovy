package Linksharing

import javax.transaction.Transactional

@Transactional
class InvitationService {

    def doSomething() {

    }
    def processInvitation(user, String token) {
        Invitation invitation = Invitation.findByToken(token)

        if (!invitation) {
            return [success: false, message: "Invalid invitation."]
        }

        if (invitation.used) {
            return [success: false, message: "This invitation has already been used."]
        }

        if (invitation.expiresAt && new Date() > invitation.expiresAt) {
            return [success: false, message: "This invitation has expired."]
        }

        if (!invitation.email.equalsIgnoreCase(user.userEmail)) {
            return [success: false, message: "This invitation is not intended for your account."]
        }

        if (!Subscription.findByUserAndTopic(user, invitation.topic)) {
            new Subscription(user: user, topic: invitation.topic).save(flush: true)
        }

        invitation.used = true
        invitation.save(flush: true)

        return [success: true]
    }
}