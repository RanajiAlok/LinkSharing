package Linksharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class InvitationControllerSpec extends Specification implements ControllerUnitTest<InvitationController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
