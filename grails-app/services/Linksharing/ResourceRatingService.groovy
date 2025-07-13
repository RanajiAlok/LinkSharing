package Linksharing

import javax.transaction.Transactional

@Transactional
class ResourceRatingService {

    def doSomething() {

    }
    Double getAverageRating(Resource resource) {
        ResourceRating.createCriteria().get {
            projections {
                avg('score')
            }
            eq('resource', resource)
            eq('isDeleted', false)
        } ?: 0
    }

    def saveRating(Long resourceId, int ratingValue, User user) {
        Resource resource = Resource.findByIdAndIsDeleted(resourceId, false)
        if (!resource) {
            return [success: false, error: "Resource not found."]
        }

        ResourceRating resourceRating = ResourceRating.findByResourceAndUser(resource, user)

        if (!resourceRating) {
            resourceRating = new ResourceRating(resource: resource, user: user, score: ratingValue)
        } else {
            resourceRating.score = ratingValue
        }

        if (resourceRating.save(flush: true)) {
            def average = ResourceRating.createCriteria().get {
                projections {
                    avg("score")
                }
                eq("resource", resource)
                eq("isDeleted", false)
            }
            return [success: true, userRating: ratingValue, newAverage: average]
        } else {
            return [success: false, error: "Failed to save rating.", errors: resourceRating.errors]
        }
    }

}