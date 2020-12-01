public without sharing class CustomerRequestFormCtrl {
    static Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();

     /*******************************************************************************************************
    * @author Sandesh Ganjare 30 Sept 2020
    * @description Create Support type case (NAIT-150833)
    * @param newrequest=> Q/A note,custID=> Account Customer ID, file=>File content, fileName=> Name of attachment
    */        
    @AuraEnabled
    public static Boolean createCustomerRequest(string newrequest, String custID, string file, string fileName){
        System.debug('newrequest:' + newrequest);
        System.debug('custID:' + custID);
        String finalCustId = custID.leftPad(8,'0'); //Padding Zeros for making 8 digit Cust id
        Savepoint case_Savepoint;
        try{
            case_Savepoint = Database.setSavepoint();
            List<Account> lstAcc = [SELECT Id, Name, AOPS_Cust_Id__c,Cust_ID__c,Sales_PersonID__c,Sales_PersonID__r.User__c,Sales_PersonID__r.User__r.Email,Sales_PersonID__r.User__r.Phone FROM Account WHERE AOPS_Cust_Id__c=: finalCustId];
            
            List<Group> lstGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'TAM_Solutions' Limit 1];
            System.debug('lstAcc:' + lstAcc);
            System.debug('lstGroup:' + lstGroup);
            if(!lstGroup.isEmpty() && !lstAcc.isEmpty()){
                Case supportCase = new Case();
                supportCase.RecordTypeId = ScoeRT;
                supportCase.Status = 'New';
                
                System.debug('lstGroup[0].Id:' + lstGroup[0].Id);
                supportCase.AccountId = lstAcc[0].Id;
                //Support Requester: Map Account Manager details form the form
                if(lstAcc[0].Sales_PersonID__c != null){
                    System.debug('user:' + lstAcc[0].Sales_PersonID__r.User__c);
                    supportCase.Support_Requester__c = lstAcc[0].Sales_PersonID__r.User__c;
                    //supportCase.Outside_Support_Rep__c = lstAcc[0].Sales_PersonID__r.User__c;
                    newrequest = newrequest + '\n Account Manager Phone Number:' + lstAcc[0].Sales_PersonID__r.User__r.Phone;
                    newrequest = newrequest + '\n Account Manager Email:' + lstAcc[0].Sales_PersonID__r.User__r.Email;
                } 
                supportCase.ownerid = lstGroup[0].Id; //Support Owner: TAM Solutions
                supportCase.Subject = lstAcc[0].AOPS_Cust_Id__c+'- Customer Request Form'; //
                supportCase.Priority = '3-Medium';
                supportCase.Description = newrequest;
                
                system.debug('case=>'+supportCase);
                INSERT supportCase;

                if(file != null && file != ''){
                    String base62File = EncodingUtil.urlDecode(file, 'UTF-8');     
                    ContentVersion contentVersionRec = new ContentVersion(); 
                    contentVersionRec.Title = fileName;  
                    contentVersionRec.PathOnClient = '/' + fileName;  
                    contentVersionRec.FirstPublishLocationId = supportCase.Id;  
                    contentVersionRec.VersionData = EncodingUtil.base64Decode(base62File);  
                    contentVersionRec.IsMajorVersion = true;  
                    INSERT contentVersionRec;
                }

                
            }

            return true;
        }catch(exception e){
            Database.rollback(case_Savepoint);
            return false;
        }       
    }     
}