package Linksharing


class ReadingItemsController {
    ReadingItemsService readingItemsService

    def index() {

    }
    def markAsRead() {
        Long itemId = params.long('itemId')
        if (itemId) {

            def readingItem = readingItemsService.markAsRead(itemId, session.user)
            if (readingItem) {
                render status: 200, text: "Marked as read"
            } else {
                render status: 400, text: "Failed to mark as read"
            }
        } else {
            render status: 400, text: "Invalid item ID"
        }
    }
}