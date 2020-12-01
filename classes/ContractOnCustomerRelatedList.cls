//************************
//Created by : Akanksha Bhatia(27/10/2015) for story S-353013
//Purpose : This is a custom related list of the Contracts on the Customer Transition object.
//***********************
public class ContractOnCustomerRelatedList{
    private List<Contract> cont = new List<Contract>();
    public List<Contract> Conlistdisplay{get;set;}   
    private Customer_Transition__c accRec;
    public boolean grandParentAvail{get;set;}
    public String CustomerType{get;set;}
    public set<Id> accountid=new set<Id>();
    public string soql;
    Map<Id,String> definecustype=new Map<Id,String>();
    Map<Id,Account> mapAccCon= new Map<Id,Account>();
    List<Account> gpacc=new List<Account>();
    List<Account> pacc=new List<Account>();
    List<Account> prospectacc= new List<Account>();
    public string contdelid{get;set;}
    public List<WrapperClass> wrapperlist= new List<WrapperClass>();
    public ID recordId {get;set;}
    public ID accId {get;set;}
    public list<wrapperclass> getwrapperlist()
    {
        return wrapperlist;
    }
    public list<wrapperclass> setwrapperlist()
    {
        return wrapperlist;
    }
    public ContractOnCustomerRelatedList(ApexPages.StandardController controller) 
    {
        this.accRec= (Customer_Transition__c)controller.getRecord();
        recordId = accRec.id;
          
        if (recordId == null ) {
          recordId = ApexPages.currentPage().getParameters().get('customerId');
        }
          
        grandParentAvail = false; 
        accRec = [select id,Account__c from Customer_Transition__c where id =:recordId];
        Account acc= [Select id, Name, Parentid ,Grandparent__c,RecordType.Name,Grandparent_Name__c,Cust_ID__c,Parent.Parentid  FROM Account where id = :accRec.Account__c];
        accId = acc.id;
        Conlistdisplay=new List<Contract>();
        soql = 'Select id, Name,ContractNumber,StartDate,Contract_Status__c,Contract_Type__c,Account.RecordType.Name,Account.Grandparent_Name__c,Account.Grandparent__c,Account.Cust_ID__c,Account.Parent.Parentid,Account.Name, Account.Parentid, Date_current_Legal_Contract_expires__c, Contract_Lifecycle_Manager__r.name from Contract where Account.id = \''+acc.id+'\'';
            
        if(acc.Parent.Parentid!=null){    
            soql += ' or Account.id= \''+acc.Parent.Parentid+'\'';
            grandParentAvail = true;
        }
        if(acc.Parentid !=null){
            soql += ' or Account.id= \''+acc.Parentid+'\'';
        }
        soql += ' Order By ContractNumber Desc';
        
        system.debug('soql****'+soql);        
        Conlistdisplay = Database.query(soql);
        for(Contract c:Conlistdisplay)
        {
            if(c.Account.id!=null)
            {
               accountid.add(c.Account.id);
           }
        }
        system.debug('The ids are'+accountid);
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
            if(prospectacc.size() > 0 && prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())//'012E00000008dTb')
            {
              definecustype.put(alias,'Prospect');  // Not Applicable for Prospect
            }
            if(prospectacc.size() > 0 && prospectacc[0].recordtypeid==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId())//'012E00000008dTa')
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
    }
    
    
     public class WrapperClass
    {
        public String CustomerType{get;set;}
        public Contract WrapContract{get;set;}
        public Account WrapAccount{get;set;}
        public wrapperclass(String s,Contract alias,Account acc)
        {
            CustomerType=s;            
            WrapContract=alias;
            WrapAccount=acc;
        }
    }
    
    public pagereference deleteContractItem()
    {
        
        String ContractItem = ApexPages.currentPage().getParameters().get('selectedRecord');
        if(ContractItem!=null)
        {
            Contract ContractItemId=[Select id from Contract where id=:ContractItem];
            delete ContractItemId;
            PageReference pageRef = new PageReference('/'+recordId);
            pageRef.setredirect(true);
            return pageRef ;
        }
            return null;
     } 
}