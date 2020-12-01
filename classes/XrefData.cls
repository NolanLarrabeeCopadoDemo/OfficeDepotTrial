// Functionality to bring the Cross REference Data for Customer Transition Object
public class XrefData{
//variable declaration
ID CTid;
List<OfficeMax_OfficeDepot_CrossReference__c> LoadData= new List<OfficeMax_OfficeDepot_CrossReference__c>();

public XrefData(ApexPages.StandardController controller) {
    //get Transition Id
    CTid =ApexPages.currentPage().getParameters().get('ID');
    customer_transition__C  acc=[Select OMX_primary_key__C, account__r.aops_cust_id__C from customer_transition__C where Id=:CTid ];
    String OMXKey=acc.OMX_primary_key__C ;
    string aopskey=acc.account__r.aops_cust_id__C;
    
    //get Cross Reference Data
     LoadData=[SELECT id, AOPS_Number__c, Created_Date__c, OMX_Key__c, Source__c,Source_Desc__C,aops_id__C
      from OfficeMax_OfficeDepot_CrossReference__c 
     where OMX_Key__c = :OMXKey  or aops_id__C=:aopskey];
}

// Loading Data
public List<OfficeMax_OfficeDepot_CrossReference__c> getLoadData(){
return LoadData;
}
}