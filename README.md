# LinkSharing

**LinkSharing** is a full-stack web application built using **Grails (Groovy on Spring)** designed to enable users to share useful **links and documents** within topic-based communities. It supports both **public and private topics**, allowing collaborative content sharing, engagement through ratings, and access control via subscription and invitation.

## 🚀 Features

- **User Management**
  - Registration, login, logout
  - Forgot/reset password flow
  - Profile view/edit with image support

- **Topic Management**
  - Create public/private topics
  - Subscribe to public topics or invite-only private ones
  - Inline editing, delete, and visibility control (admin/creator-only)
  - Trending topics (based on subscription count)

- **Resource Sharing**
  - Share **links** or upload **documents**
  - Mark as read/unread
  - Rate resources
  - View top-rated and most recent posts
  - Resource access via topic subscription

- **Dashboards & Pages**
  - Public home page with recent and trending content
  - Personalized dashboard for logged-in users
  - Topic detail pages with paginated content and user lists
  - Admin panel with user management (deactivate/sort users)

- **Search**
  - Ajaxified search with pagination
  - Search by topic name or resource description
  - Admin can search all content

## 🛠️ Tech Stack

- **Backend**: Grails (Groovy on Spring Boot)
- **Frontend**: GSP (Groovy Server Pages), jQuery, AJAX
- **Database**: MySQL / H2 (configurable)
- **Security**: Spring Security Plugin
- **Build Tool**: Gradle

## 📌 Enums Used

- **Seriousness**: `SERIOUS`, `CASUAL`, `VERY_SERIOUS`
- **Visibility**: `PUBLIC`, `PRIVATE`

## 📂 Class Structure Highlights

- User ↔ Topic ↔ Subscription
- Topic ↔ Resource ↔ ReadingItem
- Topic ↔ Invitation
- Resource has type: Link or Document

## 📸 Screens (Optional for deployment)
Include images of:
- Home page
- Dashboard
- Topic view
- Post resource modal
- Profile page

## ⚙️ How to Run Locally

```bash
# Clone the repository
git clone https://github.com/RanajiAlok/LinkSharing.git
cd LinkSharing

# Run the app (default port: 8080)
./grailsw run-app
