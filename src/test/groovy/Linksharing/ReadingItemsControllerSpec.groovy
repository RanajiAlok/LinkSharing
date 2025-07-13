package Linksharing

import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class ReadingItemsControllerSpec extends Specification implements ControllerUnitTest<ReadingItemsController> {

     void "test index action"() {
        when:
        controller.index()

        then:
        status == 200

     }
}
