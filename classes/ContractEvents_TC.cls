@isTest
private class ContractEvents_TC
{

static testMethod void ContractEvents_TC()
{
    Account a = new Account();
    a.Name='Test Account';
    insert a;
    
    Contract c = new Contract();
    c.Name='Test COntract';
    c.AccountId = a.id;
    insert c;
    
    delete c;

}

}