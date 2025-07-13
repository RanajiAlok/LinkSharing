package Linksharing

class BootStrap {
    def bootstrapService
    def init = { servletContext ->
        if(!User.findByUserEmail("aloksingh4975@gmail.com")){
            Map params=[
                    userEmail    : "aloksingh4975@gmail.com",
                    username : "admin",
                    password : "admin123",
                    firstName: "Alok",
                    lastName : "Sisodiya",
                    admin    : true,
                    active   : true,
                    isDeleted: false
            ]
            bootstrapService.createAdminUser(params)
        }
        else{
            println("ADMIN NHI BNA HAI ")
        }
    }
    def destroy = {
    }
}