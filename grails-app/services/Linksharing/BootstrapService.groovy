package Linksharing

import groovy.transform.CompileStatic

@CompileStatic
class BootstrapService {

    def doSomething() {

    }

    def createAdminUser(Map params){
        try{
            User user = new User(
                    userEmail: params.userEmail,
                    username: params.username,
                    password: params.password,
                    firstName: params.firstName,
                    lastName: params.lastName,
                    admin: params.admin,
                    active: params.active,
                    isDeleted: params.isDeleted
            )
            if(user.validate()){
                user.save(flush:true, failOnError: true)
                println("admin user is created")
            }
            else{
                println("failed to create admin user")
            }
        }
        catch (Exception e){
            println("Exception while creating admin user: ${e.message}")
        }
    }
}