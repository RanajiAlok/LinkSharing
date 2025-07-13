package Linksharing

import grails.testing.web.taglib.TagLibUnitTest
import spock.lang.Specification

class ResourceTagLibSpec extends Specification implements TagLibUnitTest<ResourceTagLib> {

     void "test simple tag as method"() {
       expect:
       tagLib.simple()
     }
}
