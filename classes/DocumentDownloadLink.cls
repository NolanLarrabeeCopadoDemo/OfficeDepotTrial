/*******************************************************************************************************
 * @author Adam Albright, adam.albright@officedepot.com
 * @date 14-January-2019
 * @description This class is used to get the links for files in SFDC. 
 * @coverage DocumentDownloadLink_TC
 */

public class DocumentDownloadLink {
    @TestVisible
    class DocumentDownloadLinkException extends Exception{}


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 14-January-2019
     * @description Returns the document url to either download or view the document.
     * @param String documentName The name of the document we want a URL for.
     * @param Boolean publicURL Should we return the public for the document?
     */
    @TestVisible
    static String getDocumentURL(String documentName, Boolean publicURL){
        // https://officedepot--adamdev2--c.cs64.content.force.com/sfc/servlet.shepherd/version/download/0680q0000006Wo8?asPdf=false&operationContext=CHATTER
        List<ContentVersion> myDocuments;
        try {
            myDocuments = [SELECT Id, Title, ContentURL FROM ContentVersion WHERE IsLatest=True];
        } catch (QueryException e){
            System.debug(LoggingLevel.ERROR, 'Failed to locate the document ' + documentName);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            throw new AuraHandledException('Failed to locate the document for download: ' + documentName);
        }
        
        ContentVersion match;

        for(ContentVersion content: myDocuments){
            if(content.Title.toLowerCase() == documentName.toLowerCase()){
                match = content;
                break;
            }
        }

        if(match == null)
            throw new DocumentDownloadLinkException('No Document Link Found for ' + documentName);

        if(publicURL)
            return getPublicLink(match.Id);

        return URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + match.Id;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 14-January-2019
     * @description Gets the public download link for the content version associated with the content id.
     * @param Id myContentVersionId The Id of the ContentVersion we need a public URL for. 
     */
    @TestVisible
    static String getPublicLink(Id myContentVersionId){
        ContentDistribution myPublicContent;

        try {
            myPublicContent = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =: myContentVersionId LIMIT 1];
        } catch (QueryException e){
            System.debug(LoggingLevel.ERROR, 'Failed to locate the document with the following ContentId' + myContentVersionId);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            throw new DocumentDownloadLinkException('Failed to locate the document for download. Please create a ticket mentioning the page you are on.');
        }

        return myPublicContent.DistributionPublicUrl;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 14-January-2019
     * @description Aura Wrapper to get the document Urls. 
     * @param String documentName The name of the document we want a URL for.
     * @param Boolean publicURL Should we return the public for the document?
     */
    @AuraEnabled
    public static String retrieveDocumentURL(String documentName, Boolean publicURL){

        try{
            return getDocumentURL(documentName, publicURL);
        } catch (Exception e){
            // Make Log Here
            throw new AuraHandledException('Retrieving the document download link failed. Please make a support ticket mentioning this page and error.');
        }
    }
}