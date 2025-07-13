package Linksharing

import grails.converters.JSON


class InvitationController {
    InvitationService invitationService
    TopicService topicService
    def index() {

    }

    def accept() {
        String token = params.token

        if (!token) {
            flash.error = "Invalid invitation link."
            redirect(controller: 'dashboard', action: 'index')
            return
        }

        session.inviteToken = token

        if (!session.user) {
            redirect(controller: 'home', action: 'login') // or 'register' if needed
            return
        }

        def result = invitationService.processInvitation(session.user, token)
        if (result.success) {
            flash.message = "You have been subscribed to the topic!"
        } else {
            flash.error = result.message
        }

        session.removeAttribute('inviteToken')
        redirect(controller: 'dashboard', action: 'index')
    }

    def afterLoginOrRegister() {
        if (session.inviteToken && session.user) {
            def result = invitationService.processInvitation(session.user, session.inviteToken)
            session.removeAttribute('inviteToken')

            if (result.success) {
                flash.message = "You have been subscribed to the topic!"
            } else {
                flash.error = result.message
            }
        }

        redirect(controller: 'dashboard', action: 'index')
    }

    def sendInvitationAjax() {
        String email = params.email
        Long topicId = params.long('topicId')

        if (!email || !topicId) {
            render([success: false, message: "Email or topic ID is missing"] as JSON)
            return
        }

        try {
            Invitation invitation = topicService.inviteByEmail(email, topicId)
            render([success: true, message: "Invitation sent successfully to ${email}"] as JSON)
        } catch (IllegalArgumentException e) {
            render([success: false, message: e.message] as JSON)
        } catch (Exception e) {
            log.error("Failed to send invitation", e)
            render([success: false, message: "Something went wrong. Please try again later."] as JSON)
        }
    }
}