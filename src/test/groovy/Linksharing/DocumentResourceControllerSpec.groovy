package Linksharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class DocumentResourceControllerSpec extends Specification implements ControllerUnitTest<DocumentResourceController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
