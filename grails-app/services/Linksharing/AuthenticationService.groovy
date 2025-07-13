package Linksharing

import grails.core.GrailsApplication
import grails.plugins.mail.MailService
import grails.util.Holders
import groovy.sql.Sql
import java.util.UUID
import javax.transaction.Transactional


@Transactional
class AuthenticationService {
    MailService mailService
    GrailsApplication grailsApplication
    def grailsLinkGenerator

    def authenticate(String usernameOrEmail , String password){

        User user = User.findByUsernameAndPassword(usernameOrEmail,password)


        if (!user) {
            user = User.findByUserEmailAndPassword(usernameOrEmail,password)
        }
        if (user && user.active) {
            return user
        }

        return null
    }

    def save(User user){
        println("save method of authentication is called")

        if(!user.validate()){
            return false
        }
        try{

            if (user.save(flush:true, failOnError: true)){
                println("SUCCESSFULLY VALIDATE")
                true
            }
        }catch(Exception e){
            println("error while saving user: ${e.message}")
            return false
        }
    }

    def generateResetPasswordToken(User user) {
        user.resetPasswordToken = UUID.randomUUID().toString()
        user.resetPasswordTokenExpiryDate = new Date() + 1
        user.save(flush: true)

        sendPasswordResetEmail(user)
    }

    def sendPasswordResetEmail(User user) {
        String resetLink = grailsLinkGenerator.link(controller: 'home', action: 'resetPage', params: [token: user.resetPasswordToken], absolute: true)

        mailService.sendMail {
            to user.userEmail
            subject "Your Password Reset Link"
            body """Hello ${user.username},

        We received a request to reset your password.

        Click the link below to reset your password:
        ${resetLink}

        If you did not request a password reset, please ignore this email.

        Regards,
        Support Team"""
        }
    }

    def resetPassword(String token, String newPassword, String confirmPassword) {
        User user = User.findByResetPasswordTokenAndIsDeleted(token, false)

        if (newPassword != confirmPassword) {
            return [success: false, message: "Passwords do not match"]
        }
        if (!user || user.resetPasswordTokenExpiryDate < new Date()) {
            return [success: false, message: "Invalid or expired token"]
        }

        user.password = newPassword
        user.resetPasswordToken = null
        user.resetPasswordTokenExpiryDate = null
        user.save(flush: true, failOnError: true)

        return [success: true, message: "Password successfully updated"]
    }


}