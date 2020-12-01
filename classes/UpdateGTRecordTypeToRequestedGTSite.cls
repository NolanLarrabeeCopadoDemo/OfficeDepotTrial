public class UpdateGTRecordTypeToRequestedGTSite {

public void UpdateGTRecordTypeToRequestedGTSite (){

}

      public void updateRTGT() {
      
      Id accountId=ApexPages.currentPage().getParameters().get('id');
               RecordType setupRT = [SELECT Id, Name from recordtype where DeveloperName='Account_Setup_Requested_GT' and sobjecttype='Account'];
               Id requestedGTRT = setupRT.id;
               if(accountId!=null) {
                   Account acc = [select id, recordtypeid from Account where id=:accountId limit 1];
                   acc.recordTypeId = requestedGTRT;
                   acc.Customer_Setup_Requested__c=datetime.now();
                   try{
                       update acc;                      
                   }
                   catch(Exception ex){
                       system.debug('Exception occured while updating account.'+ex);
                   }
               }
       }
}