package Linksharing


class AuthController {

    def authenticationService
    UserService userService
    def mailService
    def index() {

    }

    def login(){
         if(request.method == 'POST'){
             println(params)
            User user = authenticationService.authenticate(params.username, params.password)
            println("Let's go! authenticate the user")
             if(user){
                 session.user = user
                 def targetUri = params.targetUri ?: createLink(controller: 'dashboard', action: 'index')

                 redirect(url: targetUri)
             }
             else{
                 flash.message = "User not exists or wrong credentials"
                 redirect(controller: 'home', action: 'login')
                 return
             }
         }
    }

    def register(){
        if(request.method == 'POST'){
            User user = userService.index(params)

            println(params)
            println(user.properties)

            if (params.password != params.confirmPassword) {
                flash.message = "Password and Confirm Password do not match!"
                flash.messageType = "danger"
                redirect(controller: 'home', action: 'register')
                return
            }
            if(authenticationService.save(user)){
                println("save method is called")
                flash.message = "User is created"
                redirect(controller: 'home' ,action: 'login')
            }
            else{
                flash.errors = user.errors.allErrors.collect { error ->
                    message(error: error)
                }
                redirect(controller: "home" , action: "register")
            }

        }
        else{
            redirect(controller: 'home',action:'register')
        }
    }

    def logout(){
        session.invalidate()
        flash.message= "You have been logged out successfully"
        redirect(controller: "home" , action: "login")
    }



    def sendPassword() {
        User user = User.findByUserEmail(params.email)
        if (user) {
            authenticationService.generateResetPasswordToken(user)
            flash.message = "Password reset link has been sent to your email."
        } else {
            flash.error = "Email not found"
        }
        redirect(controller: 'home', action: 'login')
    }


    def reset() {
        String token = params.token
        User user = User.findByResetPasswordTokenAndIsDeleted(token, false)

        if (!user || user.resetPasswordTokenExpiryDate < new Date()) {
            flash.message = "Invalid or expired token."
            redirect(controller: 'home', action: 'forgotPassword')
            return
        }

        [token: token]
    }

    def updatePassword() {
        String token = params.token
        String newPassword = params.newPassword
        String confirmPassword = params.confirmPassword

        def result = authenticationService.resetPassword(token, newPassword, confirmPassword)

        if (!result.success) {
            flash.message = result.message
            redirect(action: 'reset', params: [token: token])
            return
        }

        flash.message = result.message
        redirect(controller: 'home', action: 'login')
    }

}