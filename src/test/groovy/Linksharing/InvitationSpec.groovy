package Linksharing

import grails.testing.gorm.DomainUnitTest
import spock.lang.Specification

class InvitationSpec extends Specification implements DomainUnitTest<Invitation> {

     void "test domain constraints"() {
        when:
        Invitation domain = new Invitation()
        //TODO: Set domain props here

        then:
        domain.validate()
     }
}
