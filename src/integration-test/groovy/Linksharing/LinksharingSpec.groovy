package Linksharing
import grails.gorm.transactions.Rollback
import grails.testing.mixin.integration.Integration

import geb.spock.*

/**
 * See https://www.gebish.org/manual/current/ for more instructions
 */
@Integration
@Rollback
class LinksharingSpec extends GebSpec {

    void "test something"() {
        when:"The home page is visited"
            go '/'

        then:"The title is correct"
            title == "Welcome to Grails"
    }

}
