package Linksharing


class DocumentResourceController {
    DocumentResourceService documentResourceService
    def index() {

    }
    def download(Long id) {
        def downloadInfo = documentResourceService.prepareDocumentForDownload(id)

        if (!downloadInfo?.fileExists) {
            flash.message = "Requested file not found."
            redirect(controller: 'dashboard', action: 'index')
            return
        }

        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", "attachment; filename=${downloadInfo.filename}")
        response.outputStream << downloadInfo.bytes
        response.outputStream.flush()
    }

}