package Linksharing


class ResourceTagLib {
    static namespace = "ls"

    def resourceService

    def topPosts = { attrs ->
        int max = attrs.max ? attrs.max.toInteger() : 5
        def topPosts = resourceService.getTopPosts(max)

        out << render(template: "/shared/topPosts", model: [topPosts: topPosts])
    }

    def recentShares = { attrs ->
        int max = attrs.max ? attrs.max.toInteger() : 5
        def recentShares = resourceService.getRecentShares(max)

        out << render(template: "/shared/recentShares", model: [recentShares: recentShares])
    }
}