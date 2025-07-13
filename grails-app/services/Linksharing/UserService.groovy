package Linksharing

class UserService {

    def index(params) {
        def photoFile = params.remove('photo')
        User user = new User(params)
        println(user.photo)

        if(photoFile && !photoFile.empty){
            user.photo = photoFile.bytes
        }

        return user

    }

    def updateUserProfile(User user, def params, def request) {
        try {
            user.firstName = params.firstName?.trim()
            user.lastName = params.lastName?.trim()

            def photoFile = request.getFile("photo")
            if (photoFile && photoFile.size > 0) {
                user.photo = photoFile.bytes
            }

            if (user.validate()) {
                user.save(flush: true)
                return [success: true]
            } else {
                return [success: false, message: "Validation failed."]
            }
        } catch (Exception e) {
            return [success: false, message: "An error occurred: ${e.message}"]
        }
    }

    def updateUserPassword(User user, String newPassword, String confirmPassword) {
        if (!newPassword || !confirmPassword || newPassword != confirmPassword) {
            return [success: false, message: "Passwords do not match or are empty."]
        }

        user.password = newPassword

        if (user.validate()) {
            user.save(flush: true)
            return [success: true]
        } else {
            return [success: false, message: "Password validation failed."]
        }
    }
}