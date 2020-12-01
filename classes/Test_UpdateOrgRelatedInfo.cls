@isTest(seealldata=true)
public class Test_UpdateOrgRelatedInfo {
    static testMethod void test_batch()
{
    Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        prospectAccount.OrgChildUpdate__C=True;
        insert prospectAccount;
    test.startTest();
    UpdateOrgRelatedInfo UpdateOrgRelatedInfoobj = new UpdateOrgRelatedInfo ();
        database.executebatch(UpdateOrgRelatedInfoobj);
    test.stopTest();
}

}