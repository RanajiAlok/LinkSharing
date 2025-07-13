package Linksharing

import org.springframework.web.multipart.MultipartFile

import javax.transaction.Transactional

@Transactional
class ResourcesService {

    SubscriptionService subscriptionService

    def doSomething() {

    }

    Map createLinkResource(String url, String description, Long topicId, User user){

        Topic topic = Topic.get(topicId)
        if(!topic){
            return [success: false , message: "Invalid topic selected"]
        }
        if (description?.length() > 255) {
            return [success: false, message: "Description exceeds word limit (max 255 characters)"]
        }

        LinkResource linkResource = new LinkResource(
                url: url,
                description: description,
                topic: topic,
                createdBy: user
        )
        println(linkResource.properties)
        if(linkResource.validate()){
            linkResource.save(flush: true , failOnError: true)
            return [success: true, message: "Link shared successfully"]
        }
        else{
            return [success: false, message: "Validation failed: ${linkResource.errors.allErrors*.defaultMessage.join(', ')}"]
        }
    }

    Map createDocumentResource(def request, Map params, User user) {
        MultipartFile file = request.getFile("document")
        String description = params.description
        Long topicId = params.long("topicId")

        if(!topicId){
            return [success: false, message: "Topic is required"]
        }

        if (!file || file.empty) {
            return [success: false, message: "No file uploaded"]
        }

        if (description?.length() > 255) {
            return [success: false, message: "Description exceeds word limit (max 255 characters)"]
        }

        String originalFileName = file.originalFilename?.toLowerCase()
        if (!originalFileName) {
            return [success: false, message: "Invalid file name"]
        }

        List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt', 'csv', 'xlsx']
        String extension = originalFileName.tokenize('.').last()

        if (!allowedExtensions.contains(extension)) {
            return [success: false, message: "File type .${extension} is not allowed"]
        }

        Topic topic = Topic.get(topicId)
        if (!topic) {
            return [success: false, message: "Invalid topic selected"]
        }

        String uploadDir = "/home/alokkumarsingh/Bootcamp/Bootcamp/Linksharing/grails-app/assets/uploads"
        File dir = new File(uploadDir)
        if (!dir.exists()) {
            dir.mkdirs()
        }

        String filePath = "${uploadDir}/${System.currentTimeMillis()}_${originalFileName}"
        file.transferTo(new File(filePath))

        DocumentResource documentResource = new DocumentResource(
                filepath: filePath,
                description: description,
                topic: topic,
                createdBy: user
        )

        if (documentResource.validate()) {
            documentResource.save(flush: true)
            return [success: true, message: "Document shared successfully"]
        } else {
            return [
                    success: false,
                    message: "Validation failed: ${documentResource.errors.allErrors*.defaultMessage.join(', ')}"
            ]
        }
    }

    def getNewAddedResource(User user, ArrayList<Topic> subscribedTopics){
        def allResources = Resource.createCriteria().list {
            'in'("topic", subscribedTopics)
            eq("isDeleted", false)
            ne("createdBy", user)
            order("lastUpdated", "desc")
        }
        def inboxResources = allResources.findAll { resource ->
            def readItem = ReadingItem.findByReaderAndResourceAndIsDeleted(user, resource, false)
            return !readItem || !readItem.isRead
        }

        return inboxResources
    }

    def getResource(Topic topic){
        def allResources = Resource.createCriteria().list {
            'in'("topic", topic)
            eq("isDeleted", false)
            order("lastUpdated", "desc")
        }
        return allResources
    }

    boolean canViewResource(Resource resource, User currentUser) {
        if (!resource || !currentUser || resource.isDeleted) {
            return false
        }
        def subscription = Subscription.findByTopicAndUserAndIsDeleted(resource.topic, currentUser, false)

        if (resource.topic.visibility==Visibility.PUBLIC){
            return true
        }else{
            if (resource.topic.visibility == Visibility.PRIVATE && (currentUser.admin || resource.createdBy.id == currentUser.id || subscription)) {
                return true
            }
        }

        return false
    }

    def getTopRatedResources(int limit = 5) {
        def topIds = ResourceRating.executeQuery('''
        SELECT rr.resource.id
        FROM ResourceRating rr
        WHERE rr.isDeleted = false
        GROUP BY rr.resource.id
        ORDER BY AVG(rr.score) DESC
    ''', [max: limit])

        def resources = Resource.findAllByIdInList(topIds)

        def orderedResources = topIds.collect { id ->
            resources.find { it.id == id }
        }

        return orderedResources
    }

    def searchResources(String query) {
        def c = Resource.createCriteria()
        List<Resource> results = c.list {
            createAlias("topic", "t")
            or {
                ilike("description", "%${query}%")
                ilike("t.topicName", "%${query}%")

            }
            eq("isDeleted", false)
            order("lastUpdated", "desc")
        }
        return results
    }

    def getResourcesInInboxItems(String query, List<Resource> inboxItems ){
        if(!query) return []

        String lowerQuery = query.toLowerCase()
        List<Resource> filteredInboxItems = inboxItems.findAll{item ->
        item.description?.toLowerCase().contains(lowerQuery) || item.topic?.topicName?.toLowerCase().contains(lowerQuery)}

        return filteredInboxItems
    }

    def getPaginatedResources(params) {
        int max = params.int('max') ?: 20
        int offset = params.int('offset') ?: 0

        def resources = Resource.createCriteria().list(max: max, offset: offset) {
            eq("isDeleted", false)
            order("id", "desc")
        }

        def totalCount = Resource.count()

        return [resources: resources, total: totalCount]
    }

    def deleteResource(Long resourceId, User currentUser) {
        Resource resource = Resource.get(resourceId)

        if (!resource || resource.isDeleted) {
            return [success: false, message: "Resource not found"]
        }

        if (resource.createdBy.id != currentUser.id && !currentUser.admin) {
            return [success: false, message: "You don't have permission to delete this resource"]
        }

        try {
            resource.withTransaction {
                resource.isDeleted = true
                resource.readingItems*.isDeleted = true
                resource.save(flush: true)
            }
            return [success: true, message: "Resource deleted successfully"]
        } catch (Exception e) {
            return [success: false, message: "Failed to delete resource: ${e.message}"]
        }
    }

    def getRecentPublicShares(String filter, int maxResults) {
        Date fromDate
        switch (filter) {
            case 'Today':
                fromDate = new Date().clearTime()
                break
            case '1 week':
                fromDate = new Date() - 7
                break
            case '1 month':
                fromDate = new Date() - 30
                break
            case '1 year':
                fromDate = new Date() - 365
                break
            default:
                fromDate = new Date().clearTime()
        }

        return Resource.createCriteria().list(max: maxResults, sort: 'dateCreated', order: 'desc') {
            topic {
                eq('visibility', Visibility.PUBLIC)
            }
            eq("isDeleted", false)
            ge('dateCreated', fromDate)
        }
    }

    def updateResource(Long id, String description, User currentUser) {
        Resource resource = Resource.findByIdAndIsDeleted(id, false)

        if (!resource || resource.isDeleted) {
            return [success: false, message: "Resource not found"]
        }

        if (resource.createdBy.id != currentUser.id && !currentUser.admin) {
            return [success: false, message: "You don't have permission to update this resource"]
        }

        resource.description = description

        try {
            resource.save(flush: true, failOnError: true)
            return [success: true, message: "Resource updated successfully", resource: resource]
        } catch (Exception e) {
            return [success: false, message: "Failed to update resource: ${e.message}", resource: resource]
        }
    }


    def resourceCreatedByUser(User user){
        if (!user) return []

        return Resource.findAllByCreatedByAndIsDeleted(user, false, [sort: "lastUpdated", order: "desc"])
    }

}