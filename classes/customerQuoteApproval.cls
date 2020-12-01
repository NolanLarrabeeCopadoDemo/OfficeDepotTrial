public class customerQuoteApproval {
    /*Recieves Customer Approval Information Id and returns the public download url
* */
    @Auraenabled(cacheable= true) 
    public static string getQuoteDocument(String custmrApprvlInfrmtnId) {
        System.debug('the customer approval information id recieved is'+custmrApprvlInfrmtnId);
        Customer_Approval_EA__c cstmrAprvl = new Customer_Approval_EA__c();
        try{
            cstmrAprvl= [select id,Content_Document_URL__c from Customer_Approval_EA__c where id= : custmrApprvlInfrmtnId];   
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while fetching the Documents public url');
        }
        return cstmrAprvl.Content_Document_URL__c;
    }
    /*Recieves Customer Approval information id , customer comments boolean value if the document was uploaded
* updates the customer approval information object quote
*/
    @Auraenabled
    public static string approvalHelper(String custmrApprvlInfrmtnId ,Boolean docUploaded,String customerComments) {
        system.debug('Approval:the Customer Approval information  is:'+custmrApprvlInfrmtnId+'Doc Uploaded'+docUploaded);
        try{
            if(docUploaded == false) {
                Customer_Approval_EA__c cstmrAprvl= [select id,Customer_Approval_Status__c,Customer_Approval_Date__c,Is_PO_uploaded_by_customer__c,Customer_Comments__c,ParentQuote__c from Customer_Approval_EA__c where id= :custmrApprvlInfrmtnId];
                cstmrAprvl.Customer_Comments__c = customerComments;
                cstmrAprvl.Customer_Approval_Status__c = label.TechSalesApprovalHelper;
                cstmrAprvl.Is_PO_uploaded_by_customer__c = false;
                cstmrAprvl.Customer_Approval_Date__c= system.now();
                update cstmrAprvl;
                updateQuote(cstmrAprvl.ParentQuote__c,label.TechSalesApprovalHelper);
                system.debug('the updated Customer Approval reocrd is:'+cstmrAprvl);   
            }   
            
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while Approving the Quote with no document');  
        }
        
        return 'success';
    }
    /*Recieves Customer Approval information id , customer comments 
* updates the customer approval information object and quote
*/
    @Auraenabled
    public static string rejectHelper(String custmrApprvlInfrmtnId,String customerComments) {
        system.debug('Rejection:the Customer Approval information  is:'+custmrApprvlInfrmtnId+'customer comments'+customerComments);
        try {
            Customer_Approval_EA__c cstmrAprvl= [select id,Customer_Approval_Status__c,Customer_Uploaded_PO__c,ParentQuote__c from Customer_Approval_EA__c where id= : custmrApprvlInfrmtnId];
            cstmrAprvl.Customer_Approval_Status__c = label.TechSalesRejectionHelper;
            cstmrAprvl.Customer_Comments__c = customerComments;
            update cstmrAprvl;  
            updateQuote(cstmrAprvl.ParentQuote__c,label.TechSalesRejectionHelper);
            system.debug('the updated Customer Approval reocrd is:'+cstmrAprvl);   
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while Rejecting the Quote with comments');  
            
        }
        return 'success';
    }
    /*Recieves Customer Approval information id , customer comments 
* updates the customer approval information object and quote
*/
    @Auraenabled
    public static string moreInfoHelper(String custmrApprvlInfrmtnId,String customerComments) {
        system.debug('More Information:the Customer Approval information  is:'+custmrApprvlInfrmtnId+'customer comments'+customerComments);
        
        try {
            Customer_Approval_EA__c cstmrAprvl= [select id,Customer_Approval_Status__c,ParentQuote__c from Customer_Approval_EA__c where id= :custmrApprvlInfrmtnId];
            cstmrAprvl.Customer_Approval_Status__c = label.TechSalesMoreInfoHelper;
            cstmrAprvl.Customer_Comments__c = customerComments;
            update cstmrAprvl;  
            updateQuote(cstmrAprvl.ParentQuote__c,label.TechSalesMoreInfoHelper);
            system.debug('the updated Customer Approval reocrd is:'+cstmrAprvl); 
        } 
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while Rejecting the Quote with comments');  
        }
        return 'success';   
    }
    /* When the Customer uploads  PO
* PO is attched to Customer Approval Information object
*/
    @AuraEnabled 
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data, Boolean pouploaded) {
        system.debug('Saving the file when Approved:the parentid is:'+idParent+'pouploaded'+pouploaded);
        Customer_Approval_EA__c cstmrAprvl= [select id,Customer_Approval_Status__c,Is_PO_uploaded_by_customer__c,Customer_Approval_Date__c,Customer_Comments__c,ParentQuote__c from Customer_Approval_EA__c where id= :idParent];
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = idParent;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        Insert cv;
        updateCustomerApprovalInformation(idParent);
        updateQuote(cstmrAprvl.ParentQuote__c,label.TechSalesApprovalHelper);
        return cv;
    }
    /* Update the Quote when a Document is uploaded
* 
**/
    @future
    public static void updateQuote(String parentID,String Status) {
        system.debug('the parent id is'+parentID);
        Quote q= [select id,Customer_Approval_Status__c,Customer_Response_Date__c,Id_Of_CAI_when_Email_Sent__c,Status from quote where id=: parentID];
        q.Customer_Approval_Status__c= label.TechSalesApprovalHelper;
        q.Status =label.TechSalesQuoteStatus;
        q.Customer_Response_Date__c=system.now();
        update q;    
    }
     /* Update the customer approval information when a Document is uploaded
* 
**/
    @future
        public static void updateCustomerApprovalInformation(Id parentID) {
        Customer_Approval_EA__c cstmrAprvl= [select id,Customer_Approval_Status__c,Is_PO_uploaded_by_customer__c,Customer_Approval_Date__c,Customer_Comments__c,ParentQuote__c from Customer_Approval_EA__c where id= :parentID];
        cstmrAprvl.Customer_Approval_Status__c = label.TechSalesApprovalHelper;
        cstmrAprvl.Is_PO_uploaded_by_customer__c = true;
        cstmrAprvl.Customer_Approval_Date__c = system.now();
        update cstmrAprvl;
        system.debug('the customer Approval Information with PO document uploaded '+cstmrAprvl);
        }
}