@isTest
public class ProspectService_TC
{
   public static testMethod void ProspectService_TC() 
    {
    
        List<ID> aid=new List<ID>();
        RecordType recType = [select id from recordtype where name = 'Prospect'];
        RecordType recType1 = [select id from recordtype where name = 'Site'];
        Account a=new Account();
        a.Name='Test Account';
        
        a.recordtype=rectype;
        insert a;
        system.debug('>>>>'+a.id);
        Prospect_Message__c pm = new Prospect_Message__c();
        pm.message_complete__c='NP';
        pm.account__c=a.id;
        insert pm;
        system.debug('>>>>'+pm.id);
        a.Name='Test Account1';
        update a;
        Account a1=new Account();
        a1.Name='Test Account';
        a1.related_account__c=a.id;
        a1.recordtype=rectype1;
        insert a1;
        /*Account a1=new Account();
        a1.name='Test Account 2';
        a1.related_account__r.id=a.id;
        insert a1;*/
        aid.add(pm.account__c);
        Map<Id,Account> pro= new Map<Id,Account>();
        ProspectService ps= new ProspectService();
        ProspectService.GetSubmittedProspects();
        ProspectService.ServiceProspect spro = new ProspectService.ServiceProspect ();
        ProspectService.ServiceProspectSite spros = new ProspectService.ServiceProspectSite ();
       // ServiceProspectSite sps=new ServiceProspectSite();
    }
}