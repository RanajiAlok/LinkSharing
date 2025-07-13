package Linksharing

import javax.transaction.Transactional

@Transactional
class ReadingItemsService {

    def doSomething() {

    }
    boolean isResourceReadByUser(Resource resource, User user) {
        ReadingItem readingItem = ReadingItem.findByResourceAndReaderAndIsDeleted(resource, user , false)
        return readingItem?.isRead ?: false
    }

    def markAsRead(Long itemId, User currentUser) {
        Resource resource = Resource.get(itemId)
        if (!resource) return null

        ReadingItem readingItem = new ReadingItem(resource: resource, reader: currentUser, isRead: true)

        if (readingItem.validate()) {
            readingItem.save(flush: true, failOnError: true)
            return readingItem
        }

        return null
    }
}