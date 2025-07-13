package Linksharing

import grails.testing.web.interceptor.InterceptorUnitTest
import spock.lang.Specification

class AdminInterceptorSpec extends Specification implements InterceptorUnitTest<AdminInterceptor> {

    void "test interceptor matching"() {
        when:
        withRequest(controller: "admin")

        then:
        interceptor.doesMatch()
    }
}
