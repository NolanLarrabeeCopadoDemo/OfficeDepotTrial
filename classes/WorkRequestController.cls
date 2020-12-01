public class WorkRequestController {
    public class FlowData{
        @AuraEnabled  
        public Account accRec { get; set; }
        @AuraEnabled  
        public Opportunity oppRec { get; set; }
        @AuraEnabled  
        public String type { get; set; }
        @AuraEnabled  
        public String casetypevar { get; set; }
        @AuraEnabled  
        public String message { get; set; }
        
        public FlowData(Account accRec,Opportunity oppRec,String type,String casetypevar,String message){
            this.accRec =  accRec;
            this.oppRec =  oppRec;
            this.type =  type;
            this.casetypevar = casetypevar;
            this.message = message;
            
        }
    }
    
    @AuraEnabled
    public static FlowData getData(Id recId) {
        Account acc = new Account();
        Opportunity opp = new Opportunity();
        String type ='';
        String casetypevar ='';
        String errormessage ='';
        String OId=recId;
        String prefix_Acc = '001';
        String prefix_Opp = '006';
        Boolean result = OId.startsWith(prefix_Acc);
        Boolean result1 = OId.startsWith(prefix_Opp);
        if(OId.startsWith(prefix_Acc)){
            acc=[select id,RecordType_Name__c,YTD_Sales_LY__c,YTD_Sales_TY_IMU2__c,YTD_Sales_LY_IMU2__c,Account_Owner_Manager_Name__c,Sales_PersonID__r.User__r.Name,
                 Name,Owner.Name from Account where id=:recId];
           /* if(acc.Owner.Name=='Dataloader' && acc.Sales_PersonID__r.User__r.Name=='Dataloader'){
                errormessage = 'This account has an invalid Sales ID. Please ask your Manager to assign the account to a valid Sales Rep ID through Optymyze and then process your pricing request. Thank you.'; 
                
            }
            if(errormessage != null || errormessage !='')*/
                if(acc.RecordType_Name__c=='Customer'||acc.RecordType_Name__c=='GrandParent'||acc.RecordType_Name__c=='Great Grandparent'||acc.RecordType_Name__c=='Parent') 
            { 
                type = 'Customer'; 
                casetypevar = 'Renewal'; 
                system.debug('====type==='+type);
                system.debug('====casetypevar==='+casetypevar);
            } 
        }
        if(OId.startsWith(prefix_Opp)){
            List<case> case1 = new List<case>();
            case1 = [select id from case where WRF_Opportunity__c=:recId and recordtype.name ='Work Request'];
            system.debug('====Case1===='+case1);
            if(case1.Size() > 0){
                system.debug('---Hi---');
                errormessage = 'This opportunity is already tied to a Work Request case!';
            }
            opp = [select id,AccountId,Account.name,Account.Owner.Name,Account.Sales_PersonID__r.User__r.Name,Account.RecordType_Name__c from Opportunity where id=:recId];
            system.debug('=====opp.Account.Owner.Name======'+opp.Account.Owner.Name);
            system.debug('=====opp.Account.Sales_PersonID__r.User__r.Name======'+opp.Account.Sales_PersonID__r.User__r.Name);
           /* if(opp.Account.Owner.Name=='Dataloader' && opp.Account.Sales_PersonID__r.User__r.Name=='Dataloader'){
                errormessage = 'This account has an invalid Sales ID. Please ask your Manager to assign the account to a valid Sales Rep ID through Optymyze and then process your pricing request. Thank you.';
            }*/
            
            if(errormessage == null || errormessage ==''){
            
            if(opp.Account.RecordType_Name__c=='Prospect') 
            { 
                type = 'opp only'; 
                casetypevar = 'New Contract'; 
            } 
            
            
            if(opp.Account.RecordType_Name__c=='Customer'||opp.Account.RecordType_Name__c=='GrandParent'||opp.Account.RecordType_Name__c=='Great Grandparent'||opp.Account.RecordType_Name__c=='Parent' ||opp.Account.RecordType_Name__c=='Customer (OfficeMax)' 
               ||opp.Account.RecordType_Name__c=='Site (OfficeMax)') 
            { 
                type = 'opp only'; 
                casetypevar = 'Renewal'; 
            } 
            }
        }
        
        FlowData Data= new FlowData(acc,opp,type,casetypevar,errormessage);
        system.debug('====Data===='+Data);
        return Data;
    }
    
}