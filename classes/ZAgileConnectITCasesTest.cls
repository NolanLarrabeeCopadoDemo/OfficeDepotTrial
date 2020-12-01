@isTest
public class ZAgileConnectITCasesTest {
    @isTest
    public  static void testconcatenateddescr()
    {
        list<Id> lstCase = new list<Id>();
        case c= new Case(Subject='hi i am going into jira',Description='Add me',
                         IT_Impact__c='Add me also',
                        priority='highest',Status='New',
                        IT_Environment__c='testingsandy',
                         Jira_Description__c = 'TestJiraDescription',
                        IT_Classification__c='buggy',
                        Origin='classy');
        insert c;
        lstCase.add(c.Id);
        ZAgileConnectITCases.zagileconcatenatedescription(lstCase);
    }
}