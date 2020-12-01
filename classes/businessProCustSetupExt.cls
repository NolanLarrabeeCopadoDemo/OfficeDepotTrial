public class businessProCustSetupExt {

public Account bpAcct {get;set;}
public Contact bpContact {get;set;}
public class custException extends Exception{}
public list<BusinessProSetup__mdt> bproSetup {get;set;}

public businessProCustSetupExt(ApexPages.StandardController controller) {
    
 bproSetup = [select AccountRecordType__c,AccountRetURL__c,ContactRecordType__c,LeadRecordType__c,noOverrideEditURL__c,OpportunityRecordType__c,PublicGroupName__c from BusinessProSetup__mdt limit 1];
 system.debug('BusinessProCustSetup Constructor');
 bpAcct = new Account();
 bpContact = new Contact();
    if (bproSetup.size() > 0) {
      bpAcct.recordTypeID = acctRecordTypes(bproSetup[0].AccountRecordType__c);
      bpContact.recordTypeID = contactRecordTypes(bproSetup[0].ContactRecordType__c);
    }
}

public businessProCustSetupExt() {
   
}

public pageReference cancelProAcct() {
    if (bproSetup.size() > 0)
      return new PageReference(bproSetup[0].AccountRetURL__c);
    else
      return null;
}

public pageReference saveProAcct() {
  try
  {
   PageReference p;
   system.debug('Processing record save....');
   Database.SaveResult aresult = Database.insert(bpAcct);
   if (aResult.isSuccess()) {
     bpContact.AccountId = aresult.getId();
     p = new PageReference('/'+aresult.getId());
     //Database.SaveResult cresult = Database.insert(bpContact);
     //if (!cresult.isSuccess())
      // throw new CustException('Error During Contact Creation:'+ cresult.getErrors()[0].getMessage());
       
     return p;
   }
   else {
     throw new CustException('Error During Contact Creation:'+ aresult.getErrors()[0].getMessage());
   }
       
    
   }
   catch (DmlException d) {
    ApexPages.addMessages(d);  
    return null;
   }
   catch (custException ce) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ce.getMessage()));
      return null;
   }
   catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
      return null;
   }
   
}
@TestVisible
 private ID acctRecordTypes(String recType) {
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    RecordTypeInfo acctRecType = rtMapByName.get(recType);
    
    return acctRecType .getRecordTypeId();
  }    
    
  private ID contactRecordTypes(String recType) {
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Contact.getRecordTypeInfosByName();
    RecordTypeInfo contactRecType = rtMapByName.get(recType);
    
    return contactRecType .getRecordTypeId();
  }     
    
}