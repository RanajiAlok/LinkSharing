package Linksharing

import grails.testing.services.ServiceUnitTest
import spock.lang.Specification

class BootstrapServiceSpec extends Specification implements ServiceUnitTest<BootstrapService> {

     void "test something"() {
        expect:
        service.doSomething()
     }
}
