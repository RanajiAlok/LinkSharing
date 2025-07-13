package Linksharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class ResourceRatingControllerSpec extends Specification implements ControllerUnitTest<ResourceRatingController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
