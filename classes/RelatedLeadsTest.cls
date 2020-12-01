@isTest
public class RelatedLeadsTest {

    @isTest
    public static void test1() {
        Test.startTest();
        createRecords();
        /*
        AggregateResult[] ar = [SELECT COUNT(ID) cnt FROM Lead];
        Object avgAmount = ar[0].get('cnt');
        System.assertEquals(10, avgAmount);
        */
        
        Lead master = [SELECT ID FROM LEAD WHERE Company = 'MasterLead 1'];
        List<Lead> testLeads = RelatedLeads.getLeads(master.Id, master.Id);
        Test.stopTest();
        System.assertEquals(true, RelatedLeads.writeLead());
        System.assertEquals(testLeads.size(), 2);


    }

    public static void createRecords() {
        Lead mL = new Lead(Company='MasterLead 1', lastname = 'Last 1', status = 'Open');
        insert mL;

        List<Lead> leads = new List<Lead>();
        for(Integer j=0;j<2;j++) {
            Lead lead = new Lead(Company='TestLead' + j, lastname = 'Last' + j, status = 'Open', Master_Lead__c = mL.id);
            leads.add(lead);
        }
        insert leads;
    }
}