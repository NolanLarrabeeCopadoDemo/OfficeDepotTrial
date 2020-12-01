@isTest
public class UpdateOMXXRef_TC{
    
    static testMethod void UpdateOMXXRef_TC() 
     {
          Sales_Person__c s =  new Sales_Person__c();
           s.ExtIDSalesPerson__c ='XXXX';
           s.IsActive__c=true;
             s.Primary__c=true;
               s.Role_Relate_Id__c ='123';  
               s.User__c='005E0000000lNbVIAU';
               s.Name = 'XXXX';
              //  s.OMX_Emp_Id__c ='1233';
          //s.OMX_Rep_ID__c ='11233'; 
               insert s;
          String rlid = 'XXXX';
          Sales_Person__c c = [select id,OMX_Emp_Id__c,OMX_Rep_ID__c from Sales_Person__c where Name = :rlid limit 1];
          c.OMX_Emp_Id__c ='123';
          c.OMX_Rep_ID__c ='1123';  
         update c;
     }

}