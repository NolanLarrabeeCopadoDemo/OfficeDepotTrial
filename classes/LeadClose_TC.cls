@isTest

public class LeadClose_TC {

public boolean matchingLeadsFound {get; set;}

static testMethod void LeadClose_TC()

 {
 
   
   boolean  matchingLeadsFound = False;
   Lead ldrec = new Lead();
    ldrec.RecordtypeId = '012E000000093HI';
    ldrec.Company = 'Lead1';
    ldrec.LastName = 'LeadTest';
    ldrec.FirstName = 'FirstLead';
    //Lead.Name = 'FirstLead LeadTest';
    ldrec.Zip__c = '33496';
    ldrec.State__c = 'FL';
    ldrec.Status = 'Closed';
    ldrec.Sub_Status__c = 'Lead Duplicate';
    ldrec.address1__c = '6600 North Military Trail';
    ldrec.address2__c = 'Blvd 50';
    ldrec.Closed_Date__c = System.today();
    ldrec.Close_Reason__c = 'Other';
    ldrec.LeadSource = 'BSD NET';
    ldrec.Lead_Duplicates__c = 'Lead Test 2';
    ldrec.OwnerId = '005E0000003vsUc';
    insert ldrec;
    
    
    Lead rec = new Lead();
    rec.RecordtypeId = '012E000000093HI';
    rec.Company = 'Lead2';
    rec.LastName = 'LeadTest2';
    rec.FirstName = 'SecondLead';
    //Lead.Name = 'LeadTest2 SecondLead';
    rec.Zip__c = '33436';
    rec.State__c = 'FL';
    rec.Status = 'Closed';
    rec.Sub_Status__c = 'Lead Duplicate';
    rec.address1__c = '133 Congress Ave';
    rec.address2__c = 'Ave 21';
    rec.Closed_Date__c = System.today();
    rec.Close_Reason__c = 'Other';
    rec.LeadSource = 'Finance';
    rec.Lead_Duplicates__c = 'Lead Test';
    rec.OwnerId = '00GE0000000umec';
    insert rec;
    
    
    
    
    
    }
    
    







}