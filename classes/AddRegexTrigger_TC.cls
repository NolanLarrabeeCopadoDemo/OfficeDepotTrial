@isTest
private class AddRegexTrigger_TC 
{
      static testMethod void AddRegexTriggerUnitTest()
        {
        Blacklisted_Word__c bWord1 = new Blacklisted_Word__c();
        bWord1.Custom_Expression__c = '/.*\\[|\\]/gi';
        insert bWord1;
        
        Blacklisted_Word__c bWord2 = new Blacklisted_Word__c();
        bWord2.Custom_Expression__c='';
        bWord2.Word__c = 'Test';
        bWord2.Match_Whole_Words_Only__c = true;
        insert bWord2;
        }
        
}