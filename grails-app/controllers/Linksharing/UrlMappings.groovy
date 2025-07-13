package Linksharing

class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {

            }
        }

        "/"(view: "/home/index",controller: "home")
        "/home"(controller: "home")
        "/dashboard"(controller: "dashboard")
        "/topic"(controller: "topic", action: "index")
        "/resource"(controller: "resource", action: "index")
        "/admin"(controller: "admin", action: "users")

        "500"(view:'/error')
        "404"(view:'/notFound')

    }
}
