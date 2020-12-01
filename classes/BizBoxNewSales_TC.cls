@isTest
public class BizBoxNewSales_TC {
        static recordtype getProsRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Prospect_BizBox'
                limit 1
        ];
        static ID prospectBizBox = getProsRTs.id;
        static RecordType getCustRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Customer_BizBox'
                limit 1
        ];
        static ID customerBizBox = getCustRTs.Id;
         static RecordType getLeadRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Lead'
                and developername = 'Lead_BizBox'
                limit 1
        ];
        static ID leadBizBox = getLeadRTs.Id;
    @istest static void testBasicInsert(){
        BizBox_Sales__c iBBSale = new BizBox_Sales__c(
        Business_Name__c = 'Miles test company',
        Sales__c = 123,
        Email__c = 'iamanemail@email.com',
        Recent_Order_Date__c = date.parse('1/1/2018')
        );
        test.startTest();
        insert iBBSale; 
        test.stopTest();        
    }
      @istest static void testBasicInsertAgainstProspect(){
        BizBox_Sales__c iBBSale = new BizBox_Sales__c(
        Business_Name__c = 'Miles test company',
        Sales__c = 123,
        Email__c = 'iamanemail@email.com',
        Recent_Order_Date__c = date.parse('1/1/2018')
        );
        Account iBBProspect = new Account(
            RecordTypeID = prospectBizBox,
            BizBox_Email__c = 'iamanemail@email.com',
            Name = 'My Test Account'
        );
        test.startTest();
        insert iBBProspect;
        insert iBBSale;
        test.stopTest();
    }
    
    @istest static void testBasicInsertAgainstLead(){
        BizBox_Sales__c iBBSale = new BizBox_Sales__c(
        Business_Name__c = 'Miles test company',
        Sales__c = 123,
        Email__c = 'iamanemail@email.com',
        Recent_Order_Date__c = date.parse('1/1/2018')
        );
        Lead iBBLead = new Lead(
            RecordTypeID = leadBizBox ,
            email= 'iamanemail@email.com',
            Company= 'My Test Account',
             LastName = 'lname'
        );
        test.startTest();
        insert iBBLead;
        insert iBBSale;
        test.stopTest();
    }
    
    @istest static void testBasicInsertAgainstCustomer(){
        BizBox_Sales__c iBBSale = new BizBox_Sales__c(
        Business_Name__c = 'Miles test company',
        Sales__c = 123,
        Email__c = 'iamanemail@email.com',
        Recent_Order_Date__c = date.parse('1/1/2018')
        );
        Account iBBCustomer = new Account(
            RecordTypeID = customerBizBox,
            BizBox_Email__c = 'iamanemail@email.com',
            Name = 'My Test Account'
        );
        test.startTest();
        insert iBBCustomer;
        insert iBBSale; 
        test.stopTest();      
    }
    
    @istest static void testBasicUpdateAgainstProspect(){
        BizBox_Sales__c iBBSale = new BizBox_Sales__c(
        Business_Name__c = 'Miles test company',
        Sales__c = 123,
        Email__c = 'iamanemail@email.com',
        Recent_Order_Date__c = date.parse('1/1/2018')
        );
        Account iBBProspect = new Account(
            RecordTypeID = prospectBizBox,
            BizBox_Email__c = 'iamanemail@email.com',
            Name = 'My Test Account'
        );
        test.startTest();
        insert iBBProspect;
        insert iBBSale;        
        iBBSale.Sales__c = 342;
        update iBBSale;
        test.stopTest();
    }

}