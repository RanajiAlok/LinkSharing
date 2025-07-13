package Linksharing

import grails.testing.web.taglib.TagLibUnitTest
import spock.lang.Specification

class TimeCategoryTagLibSpec extends Specification implements TagLibUnitTest<TimeCategoryTagLib> {

     void "test simple tag as method"() {
       expect:
       tagLib.simple()
     }
}
