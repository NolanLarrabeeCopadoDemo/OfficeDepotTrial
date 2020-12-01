@isTest
public class TotalSalesLYDefault_TC
{

public static testmethod  void TotalSalesLYDefault ()
{

Account acc = new Account(Name='Test Account');
acc.Paper_total_LY__c = null;
acc.Ink_Toner_total_LY__c=null;
acc.Furniture_total_LY__c = null;
acc.CBS_total_LY__c =null;
acc.CPD_total_LY__c=null;
acc.Tech_total_LY__c =null;
acc.Filing_Binding_total_LY__c =null;
acc.Labels_Forms_total_LY__c=null;
acc.Writing_Drafting_total_LY__c=null;
acc.Office_Essentials_total_LY__c =null;
acc.MPS_total_LY__c = null;
acc.Miscellaneous_total_LY__c=null;
insert acc;
TotalSalesLYDefault obj = new TotalSalesLYDefault();
database.executebatch(obj,1);
SchedulableContext sc;
obj.execute(sc);

}

}