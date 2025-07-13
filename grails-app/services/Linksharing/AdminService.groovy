package Linksharing

import javax.transaction.Transactional

@Transactional
class AdminService {

    def doSomething() {

    }
    def activateUser(Long id) {
        User user = User.get(id)
        if (user) {
            user.active = true
            user.save(flush: true)
            return [success: true, message: "User activated successfully."]
        }
        return [success: false, message: "User not found."]
    }

    def deactivateUser(Long id) {
        User user = User.get(id)
        if (user) {
            user.active = false
            user.save(flush: true)
            return [success: true, message: "User deactivated successfully."]
        }
        return [success: false, message: "User not found."]
    }

    def isAdmin(user) {
        return user?.admin == true
    }

    List<Topic> getAllTopics(Map params) {
        return Topic.findAllByIsDeleted(false, params)
    }


    def getTopicCount() {
        return Topic.countByIsDeleted(false)
    }

    def deleteTopic(Long id) {
        def topic = Topic.findByIdAndIsDeleted(id, false)
        if (topic) {
            topic.isDeleted = true

            topic.resources.each { resource ->
                resource.isDeleted = true
                resource.save(flush: false)

                resource.readingItems.each { readingItem ->
                    readingItem.isDeleted = true
                    readingItem.save(flush: false)
                }
            }

            topic.subscriptions.each { subscription ->
                subscription.isDeleted = true
                subscription.save(flush: false)
            }

            topic.save(flush: true)
            return [success: true, message: "Topic deleted successfully."]
        }
        return [success: false, message: "Topic not found or already deleted."]
    }

    def makeUserAdmin(Long userId) {
        User user = User.get(userId)
        if (!user) {
            return [success: false, message: "User not found."]
        }

        if (user.admin) {
            return [success: false, message: "User is already an admin."]
        }

        user.admin = true
        if (user.save(flush: true)) {
            return [success: true, message: "${user.username} is now an admin."]
        } else {
            return [success: false, message: "Failed to assign admin role."]
        }
    }

    def removeUserAdmin(Long userId) {
        User user = User.get(userId)
        if (!user) {
            return [success: false, message: "User not found."]
        }

        if (!user.admin) {
            return [success: false, message: "User is not an admin."]
        }

        user.admin = false
        if (user.save(flush: true)) {
            return [success: true, message: "Admin role removed from ${user.username}."]
        } else {
            return [success: false, message: "Failed to remove admin role."]
        }
    }

//    def searchUsers(Map params) {
//        def max = Math.min(params.int('max') ?: 20, 100)
//        def offset = params.offset ? params.int('offset') : 0
//        def query = params.search?.trim()
//
//        def criteria = User.createCriteria()
//        def filteredUsers = criteria.list() {
//            if (query) {
//                or {
//                    ilike('username', "%${query}%")
//                    ilike('userEmail', "%${query}%")
//                    ilike('firstName', "%${query}%")
//                    ilike('lastName', "%${query}%")
//                }
//            }
//        }
//
//        def userCount = filteredUsers.size()
//
//        def paginatedUsers = filteredUsers.drop(offset).take(max)
//
//        return [users: paginatedUsers, userCount: userCount]
//    }
}