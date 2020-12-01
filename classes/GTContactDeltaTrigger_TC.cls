@isTest
public class GTContactDeltaTrigger_TC
{

    static testMethod void myUnitTest() 
    {
    
    Account Acc=new Account();
    Acc.name='TestAccount';
    acc.OMX_Primary_Key__c='1234-GT';
    Insert Acc;
    
    Account RelatedAcc=new Account();
    RelatedAcc.name='TestRelatedAccount';
    RelatedAcc.OMX_Primary_Key__c='S1234-GT';
    RelatedAcc.Related_Account__c=Acc.Id;
    Insert RelatedAcc;
    
    GTContact_Delta__c Con = new GTContact_Delta__c ();
    con.first_name__C='GT';
    Con.name='testcontact';
    con.Account_OMX_Primary_Key__c='S1234-GT';
    con.Processed_Status__c= 'Process Max';
    insert con;
    con.Processed_Status__c='Processed';
    update con;
    }
    }