package Linksharing

import grails.converters.JSON


class ResourceRatingController {
    ResourceRatingService resourceRatingService

    static allowedMethods = [rate: "POST"]

    def rate() {
        def jsonData = request.JSON
        User user = session.user
        Long resourceId = jsonData.resourceId as Long
        int score = jsonData.score as int

        def result = resourceRatingService.saveRating(resourceId, score, user)
        render result as JSON
    }
}