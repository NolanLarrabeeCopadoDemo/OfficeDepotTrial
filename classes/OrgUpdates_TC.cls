@istest()
public class OrgUpdates_TC {

    public static testmethod void Orgupdate(){
      
    Org__c ogn1 = new Org__c();
    Org__c ogn2 = new Org__c();
        
    list<Org__c> orglist=new list<Org__c>{ogn1,ogn2};
    
    insert orglist;
      
        Account acct = Test_Utils.CreateAccount('Customer');
        acct.Org__c = ogn1.Id;
        insert acct;
        
        acct.Org__c = ogn2.Id;
        Update acct;
        
        
    }
    
}