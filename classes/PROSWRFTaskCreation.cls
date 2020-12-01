public class PROSWRFTaskCreation {
    public list<WRF_Task__c> createCustomCoreRequestList = new list<WRF_Task__c>();
    Date myDate = system.today(); 
    //public boolean IsTask = false;
    public void createTask(List<CameleonCPQ__QxQuote__c> CPQList,Map<Id,CameleonCPQ__QxQuote__c> OldCPQMap){
        system.debug('enter***');
        for(CameleonCPQ__QxQuote__c cp:CPQList){
            CameleonCPQ__QxQuote__c oldval=OldCPQMap.get(cp.Id);
            system.debug('enter 1***'+cp.Customer_Id__c+'*'+cp.Go_Live_Date__c+'*'+cp.WRF__c+'*'+
                         cp.Account_Hosted_Flag__c+'*'+cp.Compliance_Approval_Status__c+'*'+
                        cp.WRF_Hosted_Catalog__c);
            //system.debug('enter 3***'+IsTask);
            if(cp.Customer_Id__c !=null && (cp.Go_Live_Date__c==myDate || cp.Go_Live_Date__c<myDate) 
            && cp.WRF__c!=null && cp.WRF_Hosted_Catalog__c=='Yes' &&
            cp.Account_Hosted_Flag__c==false 
            && (  (oldval.Compliance_Approval_Status__c!=cp.Compliance_Approval_Status__c)    &&
                cp.Compliance_Approval_Status__c=='Approved' ) && 
               (ConstantsExt.prosWRFCreation==true)

                ){
                system.debug('enter 2***');  
                WRF_Task__c wrf = new WRF_Task__c(WRF__c = cp.WRF__c,
                Disposition_Code__c = 'Hosted Catalog',
                Assignment_Group__c = 'BSD Pricing',
                Due_Date__c = myDate.addDays(14),
                Priority__c = 'Normal',
                Status__c = 'Not Started',
                Notification_Group__c = 'raji.mathew@officedepot.com',
                WRF_Stage__c = 'Not Started');
                createCustomCoreRequestList .add(wrf);
                system.debug('abc'+createCustomCoreRequestList);
                    
    
            }
        }
        
            
         if( createCustomCoreRequestList.size() > 0){
            insert createCustomCoreRequestList;  
            ConstantsExt.prosWRFCreation=false;
        }
    }
}