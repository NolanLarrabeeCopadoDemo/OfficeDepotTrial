/***
Description: The test Class  for the Notesreportcontroller controller class for Notesreport page.
Created By: Ankur Pradhan
Created Date: 14-Jun-2012

Modified By:
Modified Date:

Modify Reason:
**/
@isTest
private class Notesreportcontroller_TC
{
    public static testMethod void Notesreport_page_TC() 
    {
       /*Account Creation*/ 
       Account acc = new Account ();
       acc.name = 'Ank Test Account';
       acc.BillingStreet = '1040 N 326 W';
       acc.billingcity = 'Orem';
       acc.BillingState = 'UT';
       acc.Billingcountry = 'USA';
       acc.Buying_Group__c = 'Buying Groups Federal';
       acc.Sector__c = 'Public';
       acc.Segment__c = 'Federal';
       acc.Oracle_Party_Id__c = 'testdata';
       acc.AOPS_Cust_Id__c = '123456';
       acc.AOPS_Seq_ID__c = '123456';
       insert acc;
        
       Account accSite = new Account ();
       accSite.name = 'Ank Test Account1';
       accSite.BillingStreet = '1040 N 326 W';
       accSite.billingcity = 'Orem';
       accSite.BillingState = 'UT';
       accSite.Billingcountry = 'US';
       accSite.Address1__c = '4785 S Citation Drive';
       accSite.Address2__c = '202';
       accSite.City__c = 'Delray Beach';
       accSite.State__c = 'FL';
       accSite.zip__c ='33351';
       accSite.Country__c = 'USA';
       accSite.County__c = 'US';
       accSite.Related_Account__c = acc.id;
       accSite.Primary_Site__c= true;
       accSite.Oracle_Party_Site_Id__c = 'testdata';
       accSite.AOPS_Cust_Id__c = '12345678';
       accSite.AOPS_Seq_ID__c = '12345678';
       insert accSite;
        
        PageReference pageRefnotesreport = Page.notesreport;
        Test.setCurrentPage(pageRefnotesreport);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        Notesreportcontroller reprt_notes = new Notesreportcontroller ();
        reprt_notes.nextBtnClick();
        reprt_notes.getTotalPageNumber();
        reprt_notes.getNextButtonDisabled();
        reprt_notes.getPreviousButtonEnabled();
        reprt_notes.getPageSize();
        reprt_notes.getPageNumber();
        reprt_notes.refreshnote();
        reprt_notes.previousBtnClick();
        
    }
}