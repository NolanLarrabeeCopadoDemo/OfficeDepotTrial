/***********************************************************************************************
Name    : SendforCustomerApprovalCtrl_TC
VF Page : SendForApproval
Story   : 01889907
Desc    : Test class for the class "SendforCustomerApprovalCtrl"
***********************************************************************************************/
@isTest
public class SendforCustomerApprovalCtrl_TC {
    
    @TestSetup
    static void makeData() {
        List<User> usrs = DataFactory.createUserTestRecords('SubmitDOAApprovalTest', 5);
       

        Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
       
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Address1__c = 'New Testing';
        acc.City__c = 'City Test';
        acc.State__c = 'TMO';
        acc.Country__c = 'USA';
        acc.Zip__c = '12321';
        acc.RecordtypeId = Prospect_RecordTypeId;

        insert acc;
        
         Contact con = new contact();
        con.FirstName='Test';
        con.LastName='B';
        con.Phone='1232123211';
        con.Email='test@test.com';
        //con.Primary_Contact__c=true;
        con.AccountId=acc.Id;
        con.Role__c = 'test';
        insert con;
            
        
     /*   Opportunity opp = new Opportunity();
        opp.name = 'Test';
        opp.AccountId = Acc.Id;
        opp.StageName = 'Closed Won';
        opp.CloseDate = date.today();
        opp.Type = 'New Customers';
        opp.Decision_Date__c = system.today();
        insert opp; */

        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

      /*  DOA_Approval_Paremeters__c doaApprovalParameters = new DOA_Approval_Paremeters__c();
        doaApprovalParameters.CPD_Director__c = UserInfo.getUserId();
        doaApprovalParameters.CBFS_Director__c = UserInfo.getUserId();
        doaApprovalParameters.EVP__c = UserInfo.getUserId();
        doaApprovalParameters.CFO__c = UserInfo.getUserId();
        doaApprovalParameters.Sales_Threshold_1__c = 250000;
        doaApprovalParameters.Sales_Threshold_2__c = 3000000;
        doaApprovalParameters.Sales_Threshold_3__c = 5000000;
        doaApprovalParameters.Sales_Threshold_4__c = 10000000;
        insert doaApprovalParameters;
         */
        CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = acc.id;
        //pq.OpportunityId__c = opp.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        pq.Sales_Rep__c = usrs[0].Id;
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        pq.DOA_Approval_Status__c = 'Approval Submitted';
        pq.CameleonCPQ__Status__c='Approved Internally';
        pq.New_Contract_Amendment_DOA__c = True;
          pq.Primary_Quote__c = True;
          pq.Customer_Approval_Status__c = 'Approved';
           pq.DOA_Approval_Status__c='Approved';
           pq.Customer_communication_requirements__c = 'Notification';
        
        insert pq;
        pq.Sales_Rep__c = usrs[0].Id;
        update pq;
        
        
        
    }

    public testmethod static void SendforCustomerApprovalCtrl_testMethod(){
           
        CameleonCPQ__QxQuote__c PQ = [select Id,CameleonCPQ__AccountId__c from CameleonCPQ__QxQuote__c limit 1];
       
        Contact con = [Select Id, FirstName, LastName, Role__c, Email, Phone from contact limit 1];
       
       
     /*   CustomerApprovalLightningExtension.getProsDetails(PQ .Id);
       CustomerApprovalLightningExtension.requestInformation(PQ .id, 'Needs more information');
        CustomerApprovalLightningExtension.getInitHelper(PQ.id); 
         */
        
        
        Test.StartTest();
        ContentVersion contentVersion = new contentVersion();
        contentVersion.Title = 'Costomer Copy';
        contentVersion.PathOnClient = 'Costomer Copy.pdf';
        Blob afterblob = EncodingUtil.base64Decode('test');
        contentVersion.VersionData = afterblob;
        contentVersion.IsMajorVersion = true;
        
        insert contentVersion;
         
        Id contentDoc = [SELECT ContentDocumentId FROM ContentVersion Where Id =:contentVersion.Id].ContentDocumentId;
            
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.LinkedEntityId = PQ.Id;
            contentDocumentLink.ContentDocumentId = contentDoc;
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
            
            insert contentDocumentLink;
           
        SendforCustomerApprovalCtrl.getDocuments(PQ.id);
        SendforCustomerApprovalCtrl.getContacts(PQ.id);
        SendforCustomerApprovalCtrl.savecontact(PQ.id,con.id);
        SendforCustomerApprovalCtrl.sendEmail(con.id,PQ.id);
        SendforCustomerApprovalCtrl.searchForContacts(con.FirstName,con.LastName,con.Email,con.Phone,con.Role__c,PQ.id);
        SendforCustomerApprovalCtrl.getCustomerCommunication(PQ.id);
        PQ.Customer_communication_requirements__c = 'Notification & Approval';
        update PQ;
        SendforCustomerApprovalCtrl.sendEmail(con.id,PQ.id);
        
        CustomerApprovalLightningExtension.Save(PQ.id,'Auto Approved');
        //CustomerApprovalLightningExtension.reject(PQ.id, 'Rejected by customer');
        Test.StopTest();
        
    }  
}