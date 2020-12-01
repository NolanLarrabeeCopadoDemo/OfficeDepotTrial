// Functionality to bring the WRFF for the accounts

public class  CTWRFData{
//variable declaration
ID CTid;
List<Case> cases= new List<Case>();

public CTWRFData(ApexPages.StandardController controller) {
    //get Transition Id
    CTid =ApexPages.currentPage().getParameters().get('ID');
    customer_transition__C  acc=[Select account__C  from customer_transition__C where Id=:CTid ];
    Id accountId=acc.account__C  ;
    Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
    Id recordtypeId=CaseRecType.get('Work Request').getRecordTypeId();
    
    //get WRF  Data
     cases=[SELECT id ,subject,casenumber, status from Case 
     where accountId=:accountId and 
     recordtypeId =:recordtypeId  and
     WRF_Request_Type__c='Transition' order by createddate desc];
}

// Loading Data
public List<Case> getcases(){
return cases;
}
}