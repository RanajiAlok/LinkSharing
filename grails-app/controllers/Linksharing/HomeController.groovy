package Linksharing

class HomeController {
    ResourcesService resourcesService

    def index() {
        String filter = params.recentFilter ?: 'Today'

        def recentShares = resourcesService.getRecentPublicShares(filter, 5)
        List<Resource> topPosts = resourcesService.getTopRatedResources(5)
        render(view: '/home/index' , model: [topPosts:topPosts, recentShares: recentShares , selectedFilter:filter])
    }

    def register(){
        String filter = params.recentFilter ?: 'Today'

        def recentShares = resourcesService.getRecentPublicShares(filter, 5)

        List<Resource> topPosts = resourcesService.getTopRatedResources()
        render(view: '/home/register', model: [topPosts:topPosts, recentShares: recentShares, selectedFilter:filter])
    }
    def login(){
        String filter = params.recentFilter ?: 'Today'

        def recentShares = resourcesService.getRecentPublicShares(filter, 5)

        List<Resource> topPosts = resourcesService.getTopRatedResources()

        render(view: '/home/login' , model: [topPosts:topPosts , recentShares: recentShares, selectedFilter:filter, targetUri: params.targetUri])
    }

    def resetPage(){
        String filter = params.recentFilter ?: 'Today'

        def recentShares = resourcesService.getRecentPublicShares(filter, 5)

        List<Resource> topPosts = resourcesService.getTopRatedResources()
        render(view: '/home/reset', model: [topPosts:topPosts , recentShares: recentShares, selectedFilter:filter])
    }

    def forgotPassword(){
        String filter = params.recentFilter ?: 'Today'

        def recentShares = resourcesService.getRecentPublicShares(filter, 5)

        List<Resource> topPosts = resourcesService.getTopRatedResources()

        render(view: '/home/forgotPassword', model: [topPosts:topPosts, recentShares:recentShares, selectedFilter:filter])
    }


}