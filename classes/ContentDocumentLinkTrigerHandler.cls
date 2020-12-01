public class ContentDocumentLinkTrigerHandler {
    
    public static void afterInsert(List<ContentDocumentLink> cntDocs){
        // for single ticketing and Tech sales start
        String quoTechSales=label.ContentDocumentTechSales;
        String quoSnglTctng=label.contentDocumentSingleTicketing;
        Boolean callForCntnGnrtr;
                // for single ticketing and Tech sales end

        List<Id> contentDocIds = new List<Id>();
        List<ContentDocumentLink> quoteContentLink = new List<ContentDocumentLink>();
        List<Id> quoteContentDocIds = new List<Id>();
        List<Id> contentLinkedEntityIds = new List<Id>();
        Map<Id,CameleonCPQ__QxQuote__c> quoteMap = new Map<Id,CameleonCPQ__QxQuote__c>();
        Map<Id,Id> contentDocToLinkedEntityMap = new Map<Id,Id>();
        Map<Id,Id> linkedEntityToContentDocMap = new Map<Id,Id>();
        Id contentQuoteId = null;
        CameleonCPQ__QxQuote__c contentQuote = null;
        
        String quoteNumber = 'Unknown Quote Number';
        String quoteAccountName = 'Unknown Account Name';
        String quoteCustomerNumber = 'Unknown Customer Number';
        Map<ID,ID> mpCaseCntnDcmnt = new Map<ID,ID>();
        List<ID>  cseLst = new List<ID>();
        for(ContentDocumentLink contentDocLink : cntDocs){
            contentDocIds.add(contentDocLink.ContentDocumentId);
            contentLinkedEntityIds.add(contentDocLink.LinkedEntityId);
            contentDocToLinkedEntityMap.put(contentDocLink.ContentDocumentId,contentDocLink.LinkedEntityId);
            linkedEntityToContentDocMap.put(contentDocLink.LinkedEntityId,contentDocLink.ContentDocumentId);
            
           
        }
       
        for(Id i:linkedEntityToContentDocMap.keySet()) {
            if(String.ValueOf(i).startsWith(quoSnglTctng) || String.ValueOf(i).startsWith(quoTechSales)) {
             callForCntnGnrtr=true;   
            }
            
        }
        //Added || test.isRunningTest() at line 41 by Rajendra Shahane for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
        if(callForCntnGnrtr == true || test.isRunningTest()) {
        contentDocumentGenerator.generatePublicLink(linkedEntityToContentDocMap,contentDocToLinkedEntityMap);
        }
        //Retrieve List of quotes from  Linked Entity Ids
        List<CameleonCPQ__QxQuote__c> quotes = [SELECT Id,Quote_Number__c,CameleonCPQ__AccountId__r.Name,CameleonCPQ__AccountId__r.Cust_ID__c  FROM CameleonCPQ__QxQuote__c WHERE Id IN: contentLinkedEntityIds];
        for(CameleonCPQ__QxQuote__c quote : quotes){
            // Map Quote Linked Entity Ids to actual Quote object
            quoteMap.put(quote.Id,quote);
            // Lists Content Document Ids that are linked to quote objects
            if(linkedEntityToContentDocMap.get(quote.Id) != null)
                quoteContentDocIds.add(linkedEntityToContentDocMap.get(quote.Id));          
        }
        
        //Retrieve sub list of Content Documents related to Quote objects (Linked Entity)
        List<ContentDocument> contentDocs = [SELECT Id,Title,ParentId,FileExtension FROM ContentDocument WHERE Id IN : quoteContentDocIds];
        //Parse through all inserted quote documents
        for(ContentDocument cd : contentDocs){
            //Get Related Quote Id from Current Doc
            contentQuoteId = contentDocToLinkedEntityMap.get(cd.Id);
            //Get Related Quote from Related QUote Id
            if (contentQuoteId != null){
                contentQuote = quoteMap.get(contentQuoteId);
            }else{
                contentQuote = null;
            }
            
            //Proceed with Name Change logic of current document based on related quote information
            if (contentQuote != null){
                if(cd.Title .contains('Core Exhibit'))
                    cd.Title = contentQuote.CameleonCPQ__AccountId__r.Name+'-Core Exhibit-'+contentQuote.Quote_Number__c;
                else if (cd.Title .contains('Customer Copy')){
                    cd.Title = contentQuote.CameleonCPQ__AccountId__r.Name+'-Customer Copy-'+contentQuote.Quote_Number__c;
                    System.debug('Extension :'+cd.FileExtension);
                    if(cd.FileExtension.contains('pdf'))
                        contentQuote.Customer_Doc_ID__c = cntDocs[0].ContentDocumentId ;
                }
                
                update contentQuote;                    
            }
            update contentDocs;
        }
        
        List<ContentDistribution> ContentDistributionLst = new List<ContentDistribution> ();
        for(ContentVersion cv:[SELECT Id,Title,Description,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: contentDocs]) {
            
            //Get Related Quote Id from Current Doc
            contentQuoteId = contentDocToLinkedEntityMap.get(cv.ContentDocumentId);
            //Get Related Quote from Related QUote Id
            if (contentQuoteId != null){
                contentQuote = quoteMap.get(contentQuoteId);
                quoteNumber = contentQuote.Quote_Number__c;
                quoteAccountName = contentQuote.CameleonCPQ__AccountId__r.Name;
                quoteCustomerNumber = contentQuote.CameleonCPQ__AccountId__r.Cust_ID__c;
                
                
                ContentDistribution c= new ContentDistribution();
                c.ContentVersionId=cv.Id;
                if(cv.Title.contains('Customer Copy'))
                {
                    c.Name=quoteCustomerNumber+ ' - ' +quoteAccountName + ' - ' + quoteNumber;
                }
                else 
                {
                    c.Name=cv.Title;
                }
                ContentDistributionLst.add(c);
            }
        }
        insert ContentDistributionLst;
        
        
    }
    
    public static void beforeInsert(List<ContentDocumentLink> cntDocs){
        String lhwDocumentPrefix = Schema.getGlobalDescribe().get('Mass_Communication_Mail_Out__c').getDescribe().getKeyPrefix();
        for (ContentDocumentLink cdl : cntDocs) {
            if (String.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(lhwDocumentPrefix)) {
                cdl.Visibility = 'AllUsers';
            }
        }
    }
}