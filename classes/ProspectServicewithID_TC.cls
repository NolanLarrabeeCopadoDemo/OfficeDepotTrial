@isTest
private class ProspectServicewithID_TC
{

    static testMethod void myUnitTest() 
    {
      List<ID> aid=new List<ID>();
        RecordType recType = [select id from recordtype where name = 'Prospect'];
        Account a=new Account();
        a.Name='Test Account';
        
        a.recordtype=rectype;
        insert a;
     
        RecordType recType1 = [select id from recordtype where name = 'Site'];
        Account a1=new Account();
        a1.Name='Test Account';
        a1.related_Account__c=a.id;
        
        a1.recordtype=rectype1;
        insert a1;
        system.debug('>>>>'+a.id);
        Prospect_Message__c pm = new Prospect_Message__c();
        pm.message_complete__c='NP';
        pm.account__c=a.id;
        insert pm;
       XREFHSE__c x = new XREFHSE__c(ODNID__c='123',ODS_ID__c='1234',Name='Test');
       insert x;
    
    sales_person__c salesperson = new sales_person__c(ExtIDSalesPerson__c = '1234', isactive__c=true,user__c =UserInfo.getUserId()  ,Role_Relate_Id__c ='1234'  , Primary__c=true );
    insert salesperson ;
    
    Keyvalue_Map_CS__c keyvalue = new Keyvalue_Map_CS__c(Name='reqsize', Data_Value__c ='1');
    insert keyvalue;
       
     ProspectServicewithID ps= new ProspectServicewithID();
     ProspectServicewithID.GetSubmittedProspects(pm.id);
     ProspectServicewithID.ServiceProspect  spro=new ProspectServicewithID.ServiceProspect();
     ProspectServicewithID.ServiceProspectSite spros = new  ProspectServicewithID.ServiceProspectSite(); 
    }
 }