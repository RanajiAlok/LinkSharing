package Linksharing

class AdminInterceptor {

      AdminInterceptor(){
            match(controller: "admin")
      }

      boolean before() {
            if(!session.user?.admin){
                  flash.message = "Access denied. Admins only."
                  redirect(controller: "dashboard", action:"index")
                  return false
            }
            return true
      }

      boolean after() { true }

      void afterView() {
        // no-op
      }

}