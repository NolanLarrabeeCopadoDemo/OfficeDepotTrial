@isTest
private class LeadTriggerHandlerTest {

@isTest(seealldata=true)

static void TriggerHandlerTest(){
    
    RecordType rt = [select id,Name from RecordType where SobjectType='Lead' and DeveloperName='Lead_Canada' Limit 1];
    RecordType rt1 = [select id,Name from RecordType where SobjectType='Lead' and DeveloperName='Lead_Deals' Limit 1];
    RecordType rt2 = [select id,Name from RecordType where SobjectType='Lead' and DeveloperName='Lead_Partner' Limit 1];
    RecordType rt3 = [select id,Name from RecordType where SobjectType='Lead' and DeveloperName='Lead_US' Limit 1];
    Sales_Person__c salesPerson = new Sales_Person__c(ExtIDSalesPerson__c = 'ext12345',primary__c=true,isActive__c=true,User__c = userinfo.getUserId(),Name = 'New Sales Person');
        insert salesPerson;
   list<Lead> lstLead = new list<Lead>();
    Lead l = new Lead(Company = 'Test Lead',
                      LastName = 'Lead Last Name',
                      Zip__c = '12345',
                      isConverted = false,
                      Amount_CAD__c = 2500,
                      Sales_Rep_Name__c = userinfo.getUserId(),
                      recordtypeid=rt.id
                        );
    lstLead.add(l);
    
    Lead l2 = new Lead(Company = 'Test Lead2',
                      LastName = 'Lead Last Name2',
                      Zip__c = '64468',
                      recordtypeid= rt1.id
                        );
    lstLead.add(l2);
    
    Lead l3 = new Lead(Company = 'Test Lead3',
                      LastName = 'Lead Last Name3',
                      Zip__c = '67789',
                      recordtypeid= rt2.id
                        );
    lstLead.add(l3);
    Lead l4 = new Lead(Company = 'Test Lead4',
                      LastName = 'Lead Last Name4',
                      Zip__c = '677894',
                      recordtypeid= rt3.id
                        );
    lstLead.add(l4);
    
    insert lstLead;
    leadAllHelperMeths.funcDuplicateCheck(lstLead );
    }

}