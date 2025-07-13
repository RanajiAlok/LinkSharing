package Linksharing

import grails.testing.web.interceptor.InterceptorUnitTest
import spock.lang.Specification

class AuthInterceptorSpec extends Specification implements InterceptorUnitTest<AuthInterceptor> {

    void "test interceptor matching"() {
        when:
        withRequest(controller: "auth")

        then:
        interceptor.doesMatch()
    }
}
