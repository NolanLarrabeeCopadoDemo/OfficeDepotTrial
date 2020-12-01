/**@@
    #CLASS NAME  :  BatchCreateQualifyingLeads_Test 
    #DESCRIPTION :  Test class for "BatchCreateQualifyingLeads" 
    #CREATEDDATE :  27-04-2020 (DD-MM-YYYY) 
NAIT-130850 02883861 - Qualifying Deal Data Updates one time batch will be deleted once the Qualifying Deal leads are created
@@**/
@IsTest
(SeeAllData=false)
public class BatchCreateQualifyingLeads_Test
{
	static testMethod void BatchCreateQualifyingLeads_method()
    {
        list<Opportunity> lstOpp = new list<Opportunity>();
        opportunity oppObj;
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        //List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
        if(accountList != null && accountList.size() > 0){
            oppObj = new opportunity( Name='Test Opp', AccountId = accountList[0].id,StageName='Qualify',closedate=date.today().adddays(2));
            insert oppObj;
            
            insert new Attachment(parentid=oppObj.Id,body=blob.valueOf('test Att'),Name='Test Attachment');
            insert new Note(parentid=oppObj.Id,body='test Note',Title='Test Attachment');
            insert new task(whatid=oppObj.Id,Subject='test Task');
            insert new event(whatid=oppObj.Id,Subject='test event',DurationInMinutes=50,ActivityDateTime=datetime.now().adddays(1));
        }
        
        if(oppObj != null)
        {
            BatchCreateQualifyingLeads objcls = new BatchCreateQualifyingLeads();
            objcls.toAddressesEmail = new list<String> {'rajendra.shahane@officedepot.com'};
            database.executebatch(objcls,200);
            system.debug('objcls strError : ' + objcls.strError);
            system.assertEquals(null, objcls.strError);
        }
        
    }
}