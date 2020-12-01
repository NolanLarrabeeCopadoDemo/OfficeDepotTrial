@isTest
private class QuickLinkCtrl_TC{
    static testMethod void testctrl(){
    TechDepotSetting__c TDS = new TechDepotSetting__c();
    TDS.Crypto_Key__c='Sz3oFf2pAWtdogFgIfN5nmQ1Jsz3L3muo/68QJYPKjw=';
    TDS.User_Title__c='THISISTITLE';
    TDS.Name='Key';
    insert TDS;
    
    Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
    User u1 = new User(alias = 'te125', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='785924',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='785924@proxy456.com',isactive=true);
    u1.MB_Expiration_Date__c=System.Today();
    u1.Token_Market_Builder__c='ITSATOKEN';
    insert u1; 
    
         QuikLnkCtrl q=new QuikLnkCtrl();
         System.RunAs(u1){    
             q.MarketPage();
             //  Calling a function QuikLnkCtrl()
             q.QuikLnkCtrl(); // Added by Jasvinder for Story S-437501 OD- 00800276
            
         }    
    }
}