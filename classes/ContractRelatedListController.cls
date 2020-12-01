public class ContractRelatedListController {
    @AuraEnabled
    public static List<WrapperClass> fetchContracts(Id AccountRecordId) {
        Set<Id> accountid=new Set<Id>();
		Boolean grandParentAvail;    
         String accountIdstring;
       List<WrapperClass> wrapperlist= new List<WrapperClass>();
        List<Account> gpacc=new List<Account>();
    List<Account> pacc=new List<Account>();
        Map<Id,String> definecustype=new Map<Id,String>();
         List<Account> prospectacc= new List<Account>();
        Map<Id,Account> mapAccCon= new Map<Id,Account>();
       /* if(AccountId != null)
        {
            List<Contract> contractList = [SELECT Id,ContractNumber, Name, primary__c, Customer_Type__c, Contract_Type__c,
                                           Contract_Status__c, Contract_Lifecycle_Manager__r.Name, Date_current_Legal_Contract_expires__c from Contract where AccountId =: AccountId];
            
            return contractList;
        }
        else
            return null;
        */
        
          Id recordId = AccountRecordId;
          
        
         
        grandParentAvail = false;   
        Account acc= [Select id, Name, Parentid ,Grandparent__c,RecordType.Name,Grandparent_Name__c,Cust_ID__c,Parent.Parentid,Parent.Parent.ParentId  FROM Account where id = :recordId];
        List <Contract>Conlistdisplay=new List<Contract>();
        String soql = 'Select id, Name,ContractNumber,primary__c,StartDate,Contract_Status__c,Customer_Type__c,Contract_Type__c,RecordType.Name,Account.RecordType.Name,Account.Grandparent_Name__c,Account.Grandparent__c,Account.Cust_ID__c,Account.Parent.Parentid,Account.Name, Account.Parentid,Contract_Owner__c, Date_current_Legal_Contract_expires__c  from Contract where Account.id = \''+acc.id+'\'';
        
        if(acc.Parent.Parent.ParentId!=null)
        {
            soql += ' or Account.id= \''+acc.Parent.Parent.ParentId+'\'';
        }
        if(acc.Parent.Parentid!=null){    
            soql += ' or Account.id= \''+acc.Parent.Parentid+'\'';
            grandParentAvail = true;
        }
        if(acc.Parentid !=null){
            soql += ' or Account.id= \''+acc.Parentid+'\'';
        }
        soql += ' Order By ContractNumber Desc';
        
        system.debug('soql****'+soql);  
        List<contract> listContract =new List<contract>();
        listContract = Database.query(soql);
        Set<Id> accountid1=new Set<Id>();
        for(Contract c:listContract){
            if(c.Contract_Status__c !='Expired' && c.Contract_Status__c !='Closed/Cancelled' && c.Recordtype.Name != 'Agreement' && c.Recordtype.Name != 'DocuSign'){
                Conlistdisplay.add(c);
           }
             if(c.Account.id!=null)
            {
               accountid1.add(c.Account.id);
           }
            
        }
        //Conlistdisplay = Database.query(soql);
        for(Contract c:Conlistdisplay)
        {
            if(c.Account.id!=null)
            {
               accountid.add(c.Account.id);
           }
        }
        system.debug('The ids are'+accountid1);
      
        integer count = 0;
        for(Id accid: accountid1){
            
            String s = String.valueOf(accid).substring(0, 15) + ',';
            if(count ==0){
                 accountIdstring = s ;
            }
            else {
                 accountIdstring += s ;
            }
           
            count++;
            
        }
        
        List<Account> Conacc= [Select id,name,Cust_ID__c,RecordType.Name from Account where id in:accountid];
        for(Account acc1:Conacc)
        {
            mapAccCon.put(acc1.id,acc1);
        }
        System.debug('The account map'+mapAccCon);
        for(Id alias:accountid)
        {
            //The maximum level can be of 3
            prospectacc=[Select id,recordtypeid from Account where id=:alias];
            //JSchilling Case 145634 1/4/2016 start
            //Added logic to account for the GT and OfficeMax record types
            if(prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId() ||
               prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (GT)').getRecordTypeId() ||
               prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (OfficeMax)').getRecordTypeId())//'012E00000008dTb')
            {
              definecustype.put(alias,'Prospect');  // Not Applicable for Prospect
            }
            if(prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId() ||
               prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId() ||
               prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId() ||
               prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId()
               || prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId()
               || prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId())//'012E00000008dTa')
            //JSchilling Case 145634 1/4/2016 end
            {
                gpacc=[Select id,name from Account where parent.parentid=:alias limit 10];
                if(gpacc.size()>0)
                {
                    definecustype.put(alias,'Grand Parent');
                } 
                else
                {
                    pacc=[Select id from Account where parentid=:alias limit 10];
                    if(pacc.size()>0)
                    {
                        definecustype.put(alias,'Parent');
                    }
                    else
                    {
                        definecustype.put(alias,'Child');
                    }
                }
            }
        } 
        System.debug('The map is'+definecustype);
        for(Contract c4:Conlistdisplay)
        {
            String custype=definecustype.get(c4.Account.id);
            system.debug('ProsCus'+custype);
            if(custype=='Prospect')
            {
                Account acccon= mapAccCon.get(c4.Account.id);
                WrapperClass w=new WrapperClass('N/A',c4,acccon);//custype,c4,acccon);
                wrapperlist.add(w);
            }
        }  
        for(Contract c1:Conlistdisplay)
        {
            String custype=definecustype.get(c1.Account.id);           
            system.debug('GPCus'+custype);
            if(custype=='Grand Parent')
            {
                Account acccon= mapAccCon.get(c1.Account.id);
                system.debug('GPAcc'+acccon);
                WrapperClass w=new WrapperClass(custype,c1,acccon);
                wrapperlist.add(w);
            }
        }  
        for(Contract c2:Conlistdisplay)
        {
            String custype=definecustype.get(c2.Account.id);
            
            system.debug('PCus'+custype);
            if(custype=='Parent')
            {
                Account acccon= mapAccCon.get(c2.Account.id);
                system.debug('PAcc'+acccon);
                WrapperClass w=new WrapperClass(custype,c2,acccon);
                wrapperlist.add(w);
            }
        }
        for(Contract c3:Conlistdisplay)
        {
            String custype=definecustype.get(c3.Account.id);
            
            system.debug('CCus'+custype);
            if(custype=='Child')
            {
                Account acccon= mapAccCon.get(c3.Account.id);
                system.debug('CAcc'+acccon);
                WrapperClass w=new WrapperClass(custype,c3,acccon);
                wrapperlist.add(w);
            }
        }    
        
       system.debug('wrapperList-->'+wrapperlist);
       return wrapperlist;
    }
    
    //Delete Contract Code
    @AuraEnabled
     public static String deleteContractRecord(String contractToDelete)
    {
        
        String ContractItem = contractToDelete;
        if(ContractItem!=null)
        {
            Contract ContractItemId=[Select id from Contract where id=:ContractItem];
            delete ContractItemId;
                             
            return 'Success' ;
        }
            return 'Failure';
     } 
    
    
    public class WrapperClass
    {
        @AuraEnabled public String CustomerType{get;set;}
        @AuraEnabled public Contract WrapContract{get;set;}
        @AuraEnabled public Account WrapAccount{get;set;}
        public wrapperclass(String s,Contract alias,Account acc)
        {
            CustomerType=s;            
            WrapContract=alias;
            WrapAccount=acc;
        }
    }
    
    

}