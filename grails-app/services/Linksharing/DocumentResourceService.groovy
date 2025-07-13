package Linksharing

import javax.transaction.Transactional

@Transactional
class DocumentResourceService {

    def doSomething() {

    }

    def prepareDocumentForDownload(Long id) {
        DocumentResource documentResource = DocumentResource.get(id)

        if (!documentResource || !new File(documentResource.filepath).exists()) {
            return [fileExists: false]
        }

        File file = new File(documentResource.filepath)

        return [
                fileExists: true,
                filename  : file.name,
                bytes     : file.bytes
        ]
    }
}