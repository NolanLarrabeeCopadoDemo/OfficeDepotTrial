/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQSyncService {
    global CPQSyncService() {

    }
    webService static List<CameleonCPQ.CPQSyncService.DocumentAttachment> getDocumentsList(String urlPrefixREST, String entityId) {
        return null;
    }
    webService static String getInitContext(List<CameleonCPQ.CPQSyncService.Tuple> contextInfo, String xmlSessionSettings) {
        return null;
    }
    webService static List<CameleonCPQ.CPQSyncService.Tuple> updateEntityFromMobile(Blob entityXML) {
        return null;
    }
    webService static String updateQuote(String sfdcEntityId, Blob quoteXML) {
        return null;
    }
global class DocumentAttachment {
    @WebService
    webService String attId;
    @WebService
    webService String descr;
    @WebService
    webService String lnkEntity;
    @WebService
    webService String name;
    @WebService
    webService String url;
}
global class Tuple {
    @WebService
    webService String key;
    @WebService
    webService String value;
}
}
