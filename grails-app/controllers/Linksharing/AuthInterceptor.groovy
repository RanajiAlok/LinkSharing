package Linksharing

class AuthInterceptor {
      AuthInterceptor() {
            matchAll()
                    .excludes(controller: 'auth')
                    .excludes(controller: 'home')
      }
      boolean before() {
            if (!session.user) {
                  flash.message = "You must be logged in to access that page."
                  redirect(controller: "home", action: "login")
                  return false
            }
            return true
      }

      boolean after() { true }

      void afterView() {
        // no-op
      }

}