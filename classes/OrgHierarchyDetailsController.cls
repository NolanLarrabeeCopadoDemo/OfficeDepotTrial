public class OrgHierarchyDetailsController{
    // declaring the wrapper class
    public class AccountRelatedData{
        @AuraEnabled  
        public List<Contact> contactList { get; set; }
        @AuraEnabled  
        public List<Opportunity> oppList { get; set; }
        @AuraEnabled  
        public List<Case> caseList { get; set; }
        @AuraEnabled  
        public List<Task> taskList { get; set; }
        @AuraEnabled  
        public List<Sales_Data__C> salesList { get; set; }
        @AuraEnabled  
        public List<Sales_Person__c> salesRepList { get; set; }
        @AuraEnabled  
        public List<Account> sitesList { get; set; }
        @AuraEnabled  
        public List<Contract> contractList { get; set; }
        @AuraEnabled  
        public List<Note> noteList { get; set; }
        @AuraEnabled  
        public List<Pricing_Template__c> pricingList { get; set; }
        

        
        @AuraEnabled  
        public Integer countContact{ get; set; }
        @AuraEnabled  
        public Integer countOpportunity{ get; set; }
        @AuraEnabled  
        public Integer countCase{ get; set; }
        @AuraEnabled  
        public Integer countTask{ get; set; }
        @AuraEnabled  
        public Integer countSales{ get; set; }
        @AuraEnabled  
        public Integer countRep{ get; set; }
        @AuraEnabled  
        public Integer countSites{ get; set; }
        @AuraEnabled  
        public Integer countContract{ get; set; }
        @AuraEnabled  
        public Integer countNote{ get; set; }
        @AuraEnabled  
        public Integer countPricing{ get; set; }

Id  accid;
        @AuraEnabled  
        public Contact recentContact{ get; set; }
        @AuraEnabled  
        public Opportunity recentOpportunity{ get; set; }
        @AuraEnabled  
        public Case recentCase{ get; set;}
        @AuraEnabled  
        public Task recentTask{ get; set;}
        @AuraEnabled  
        public Sales_Data__C recentSales{ get; set;}
        @AuraEnabled  
        public Sales_Person__c recentRep{ get; set;}
        @AuraEnabled  
        public Account recentSite{ get; set;}
        @AuraEnabled  
        public Contract recentContract{ get; set;}
        @AuraEnabled  
        public Note recentNote{ get; set;}
        @AuraEnabled  
        public Pricing_Template__c recentPricing{ get; set;}

        
        
        public AccountRelatedData(List<Contact> contactList, List<Opportunity> oppList, 
        List<Case> CaseList,
         List<Task> taskList, List<Sales_Data__C> salesList,
         List<Sales_Person__c> salesRepList, List<Account> sitesList,List<Contract> 
         contractList,
         List<Note> noteList,List<Pricing_Template__c>pricingList,
         Integer countContact,Integer countOpportunity,
         Integer countCase,Integer countTask, Integer countSales,
         Integer countRep,Integer countsites,Integer countContract,
         Integer countNote,Integer countPricing,
         
         Contact recentContact, Opportunity recentOpportunity,
         Case recentCase,Task recentTask,Sales_Data__C recentSales,
         Sales_Person__c recentRep, Account recentSite, Contract recentContract, Note 
          recentNote,
         Pricing_Template__c recentPricing
           ){
            this.contactList = contactList;
            this.oppList = oppList;
            this.caseList = caseList;
            this.taskList =  taskList;
            this.salesList = salesList;
            this.salesRepList= salesRepList;
            this.sitesList= sitesList;
            this.contractList= contractList;
            this.noteList=noteList;
            this.pricingList=pricingList;
           
            this.countContact=countContact;
            this.countOpportunity=countOpportunity;
            this.countCase=countCase;
            this.countTask=countTask;
            this.countSales =countSales ;
            this.countRep=countRep;
            this.countsites=countsites;
            this.countContract=countContract;
            this.countNote=countNote;
            this.countPricing=countPricing;
           
            this.recentContact=recentContact;
            this.recentOpportunity=recentOpportunity;
            this.recentCase=recentCase;
            this.recentTask=recentTask;
            this.recentSales=recentSales;
            this.recentRep=recentRep;
            this.recentSite=recentSite;
            this.recentContract=recentContract;
            this.recentPricing=recentPricing;
            this.recentNote = recentNote;


        }
    }
    
        ///Extending the wrapper class    
       public class AccountRelatedDataExt{
        
        @AuraEnabled  
        public List<Account> customerList { get; set; }
                
        @AuraEnabled  
        public Integer countCustomer{ get; set; }
        
        @AuraEnabled  
        public Account recentCustomer{ get; set;}


        @AuraEnabled  
        public List<DML_Relation__c> DMLList { get; set; }
                
        @AuraEnabled  
        public Integer countDML{ get; set; }
        
        @AuraEnabled  
        public DML_Relation__c recentDML{ get; set;}


        public AccountRelatedDataExt(List<Account> customerList, Integer countCustomer, 
        Account recentCustomer,
        List<DML_Relation__c> DMLList, Integer countDML, DML_Relation__c  recentDML
           ){
            
            this.customerList=customerList;
           
            this.countCustomer=countCustomer;
            
            this.recentCustomer=recentCustomer;
            
            this.DMLList=DMLList;
           
            this.countDML=countDML;
            
            this.recentDML=recentDML;


           }
    }

     public class AccountRelatedDataExtn{
        
        @AuraEnabled  
        public List<Account> customerList { get; set; }
                
        @AuraEnabled  
        public Integer countCustomer{ get; set; }
        
        @AuraEnabled  
        public Account recentCustomer{ get; set;}


        @AuraEnabled  
        public List<DML__c> DMLList { get; set; }
                
        @AuraEnabled  
        public Integer countDML{ get; set; }
        
        @AuraEnabled  
        public DML__c recentDML{ get; set;}


        public AccountRelatedDataExtn(List<Account> customerList, Integer countCustomer, 
        Account recentCustomer,
        List<DML__c> DMLList, Integer countDML, DML__c  recentDML
           ){            
            this.customerList=customerList;           
            this.countCustomer=countCustomer;           
            this.recentCustomer=recentCustomer;            
            this.DMLList=DMLList;           
            this.countDML=countDML;            
            this.recentDML=recentDML;
           }
    }



  // get Id's of Customer and Site Recordtypes
      Public static Set<Id> getAccId( String type)
    {
       String sObjectName='Account';
        set<Id> recordTypeIds = new set<Id>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        if(sobjectResult != null)
        {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            if(recordTypeInfo != null)
            {
                for(Schema.RecordTypeInfo info : recordTypeInfo)
                {
                  if(type=='Customer'){
                    if(  info.getName().contains('Customer')  || info.getName().contains('Prospect') || info.getName().contains('Account Setup Requested'))
                    {
                    ////|| info.getName().contains('Prospect') 
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }
                  if(type=='CustomerOnly'){
                    if(  info.getName().contains('Customer')   )
                    {
                    ////|| info.getName().contains('Prospect') 
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }

                if(type=='Site'){
                    if(  info.getName().contains('Site')    )
                    {
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }

                  
                  
                }
            }
        }
        system.debug('recordtypes'+recordTypeIds);
        return recordTypeIds;
    }
  
    // Functionality to get Pricing Data 
        @AuraEnabled
        public static AccountRelatedData getPricingData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
            // System.debug('&&&&&&&&OrgString1'+OrgString1);
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }
       System.debug('&&&&&&&&getPricingDataOrgId'+OrgId);
       System.debug('&&&&&&&&getPricingDataParentOrg'+ParentOrg);
 
        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();
        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            try{
                Account currentRec=[select ownerId,Pricing_template_cd__c from Account where Id=:OrgId
                and org__C=:ParentOrg];
                if(currentRec!=null){
                String pricingtemplate= currentRec.Pricing_template_cd__c;
                if(pricingtemplate  !=null)
                pricingList= [select Id ,name,Count_of_accounts__c from Pricing_Template__c where name =:pricingtemplate];           
                }
             }
            catch(Exception e){}
        }
        else{
            
            List<Account> customers= [select OwnerId,Pricing_template_cd__c from account where recordtypeId=:Customer and Org__c=:OrgId ];
            
            List<String> pricingRecList= new List<String>();
            for(Account rec :customers){
  
            if(rec.Pricing_template_cd__c!=null)
            pricingRecList.add(rec.Pricing_template_cd__c);
            }
            pricingList= [select Id ,name ,Count_of_accounts__c from Pricing_Template__c where name in:pricingRecList];
            
              List<AggregateResult> prclist= [select COUNT(id) prc,
              Pricing_template_cd__c from 
              account  where recordtypeId=:Customer and Org__c=:OrgId and Pricing_template_cd__c in:pricingRecList
              group by Pricing_template_cd__c ];
              
                   Map<String, integer> mapPrice= new Map<String, integer>();  

                    for (AggregateResult ar : prclist) {                    
                    mapPrice.put (  (String)ar.get('Pricing_template_cd__c'),((decimal)ar.get('prc')).intValue());
                    }

              for(integer i=0;i<   pricingList.size();i++){
              pricingList[i].Count_of_accounts__c =mapPrice.get(pricingList[i].name);              
              }
              
                                    
          }
            if(pricingList.size()>0){
            countPricing=pricingList.size();
            recentPricing=pricingList[0];
            }




                 accOrOrgData = new  AccountRelatedData(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,
                 contractList,noteList,pricingList,
                 countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
        
        // Functionality to get Notes Data 

        @AuraEnabled
    public static AccountRelatedData getNoteData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }        
        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();
        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();

        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            Id customerOrg=[select org__C from account where Id=:OrgId].org__C;
            if(customerOrg !=null  &&  customerOrg==ParentOrg){           
            noteList=[select Id,ParentId,Title,CreatedBy.Name,LastModifiedBy.Name ,Parent.Name from Note where ParentId =:OrgId  
            //and IsPrivate=false
            order by createddate desc];
            }
        }
        else{
                       
           //noteList=[select Id,ParentId,Title,CreatedBy.LastName from Note where ParentId =:OrgId order by createddate desc];   
           noteList=[select Id,ParentId,Title,CreatedBy.Name,LastModifiedBy.Name ,Parent.Name from Note where ParentId
           in (select Id from account where Org__C =:OrgId  and recordtypeId in :Customer) order by createddate desc];                      
          }
          
          System.debug('&&&&&&noteList'+noteList);
            if(noteList.size()>0){
            countNote=noteList.size();
                system.debug('noteList[0].....'+noteList[0]);
            recentNote=noteList[0];
            }
          System.debug('&&&&&&recentNote'+recentNote.Title);

                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
    
     // Functionality to get Contract Data    
        @AuraEnabled
    public static AccountRelatedData getContractData(String OrgId) {    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

    
        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();
       
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
       // Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            contractList   = [select Id, Name,Customer_Number__C,Customer_Name__c,Account_Recordtype__c,  ContractNumber,Contract_Type__C,Contract_Status__C,Contract_Lifecycle_Manager__C,Date_Current_Legal_Contract_Expires__c from Contract where AccountId=:OrgId 
            and org__C=:ParentOrg order by createddate desc];            
            system.debug('contractlist'+ContractList);
        }
        else{
                           
            contractList   = [select Id, Name,Customer_Number__C,Customer_Name__c, Account_Recordtype__c, ContractNumber,Contract_Type__C,Contract_Status__C,Contract_Lifecycle_Manager__C,Date_Current_Legal_Contract_Expires__c from Contract where 
            account.org__C=:OrgId order by createddate desc];     
            system.debug('contractlist'+ContractList);
          }
            if(contractList.size()>0){
            countContract=contractList.size();
            recentContract=contractList[0]; 
            }

                 accOrOrgData = new  AccountRelatedData(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,
                 sitesList,contractList,noteList,pricingList,
                 countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,                 
                 recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);
      return accOrOrgData;
    }
    
    // Functionality to get Sales Data 
    
        @AuraEnabled
    public static AccountRelatedData getSalesData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
         List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
                List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();

        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
           salesDataLIst =[select Id, CopiersText__C,name,Rolling_12_month_sales__c,YTD_Sales_TY__c,
           Rolling_12_month_Sales_text__c,YTD_Sales_TY_text__c   from Sales_Data__C where 
           Account__c=:OrgId and account_type__C='Customer' and org__C=:ParentOrg order 
           by createddate desc Limit 1];
            
            
        }
        else{
            salesDataLIst =[select Id, CopiersText__C,name,Rolling_12_month_sales__c ,YTD_Sales_TY__c ,
            Rolling_12_month_Sales_text__c,YTD_Sales_TY_text__c      from Sales_Data__C where 
            Org__c=:OrgId and account_type__C='Org' order by createddate desc Limit 1];
            
          }
            
            if(salesDataLIst.size()>0){
            countSales=salesDataLIst.size();
            recentSales=salesDataLIst[0];
            }
            
                 accOrOrgData = new  AccountRelatedData
(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,                
countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,                 
recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);
       return accOrOrgData;
    }

     // Functionality to get Site Data    
        @AuraEnabled
    public static AccountRelatedData getSiteData(String OrgId) {
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();

        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            // Id currentOrg=[select Org__C from Account where Id=:OrgId].org__C;
           
            sitesList=[select LastModifiedDate,Owner.alias,Id,AOPS_Seq_ID__c,Name,Cust_ID__c,Primary_Site__c,Status__c,Address__c,YTD_Sales_TY__c,YTD_Sales_Diff__c,Weeks_Since_Last_Order__c from account where 
            recordtypeId=:Site and Related_Account__c=:OrgId
            and Org__C=:ParentOrg];
            system.debug('sitelist1'+sitesList);
        }
        else{
            
            sitesList=[select LastModifiedDate,Owner.alias,Id,AOPS_Seq_ID__c,Name,Cust_ID__c,Primary_Site__c,Status__c,Address__c,YTD_Sales_TY__c,YTD_Sales_Diff__c,Weeks_Since_Last_Order__c from account where 
            recordtypeId=:Site and Org__C=:OrgId];
             system.debug('sitelist2'+sitesList);
          }
            if(sitesList.size()>0){
            countSites=sitesList.size();
            recentSite=sitesList[0];
            }

                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 

countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
    
    
     // Functionality to get DML Data   
       @AuraEnabled
    public static AccountRelatedDataExt getDMLData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }
        
        String OrgString=OrgId;
        AccountRelatedDataExt accOrOrgData;        
        List<Account>customerList   =new List<Account>();        
        Integer countCustomer=0;       
        Account recentCustomer = new Account();
        
        List<DML_Relation__c> DMLList= new List<DML_Relation__c>();
        Integer countDML=0;        
        DML_Relation__c recentDML= new DML_Relation__c();

        
       
        Set<Id> Customer=getAccId('CustomerOnly');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
           
            DMLList=[select DML_ID__c,DML_Details__c,DMLLink__c,Id,DECISIONMAKERID__c,DML_Segment__c,Customer_ID__c,New_DML_ID__c,New_DML__c,DML_Segment_Code__c,Decision_Maker_Name__c,DML_Rep_Name__c,DML_ZIP__c,CUSTOMERID__c,Customer_Name__c,Decision_Maker_Level_1_Manager_ID__c,Decision_Maker_Level_2_Manager_ID__c,Decision_Maker_Level_3_Manager_ID__c,DML_RepID__c,DML__r.DML_City__c, DML__r.DML_State__c,DML__r.Decision_Maker_Rep__r.User_Name__c
           from DML_Relation__c where account__C=:OrgId and org__c=:ParentOrg];
        }
        else{
            
            DMLList=[select DML_ID__c,DML_Details__c,DMLLink__c,Id,DECISIONMAKERID__c,DML_Segment__c,Customer_ID__c,New_DML_ID__c,DML_Segment_Code__c,New_DML__c,Decision_Maker_Name__c,DML_Rep_Name__c,DML_ZIP__c,CUSTOMERID__c,Customer_Name__c,Decision_Maker_Level_1_Manager_ID__c,Decision_Maker_Level_2_Manager_ID__c,Decision_Maker_Level_3_Manager_ID__c,DML_RepID__c,DML__r.DML_City__c, DML__r.DML_State__c,DML__r.Decision_Maker_Rep__r.User_Name__c
            from DML_Relation__c where Org__C=:OrgId];
               system.debug('DMLList....'+DMLList);
            
          }            
                  if(DMLList.size()>0){
                  Set<String> DMLSetId= new Set<String>();
                  for( integer i=0;i<DMLList.size();i++){
                      if( !DMLSetId.contains(  DMLList[i].DECISIONMAKERID__c))
                      DMLSetId.add(  DMLList[i].DECISIONMAKERID__c);
                  }
            //countDML=DMLList.size();
            countDML=DMLSetId.size();
            recentDML=DMLList[0];
            }          system.debug('countDML....'+countDML);

        accOrOrgData = new  AccountRelatedDataExt(customerList,countCustomer, recentCustomer,DMLList,countDML,recentDML);

       return accOrOrgData;
    }
    
    // Functionality to get Customer Data 
    
   @AuraEnabled
    public static AccountRelatedDataExt getCustomerData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }
        
        String OrgString=OrgId;
        AccountRelatedDataExt accOrOrgData;        
        List<Account>customerList   =new List<Account>();        
        Integer countCustomer=0;       
        Account recentCustomer = new Account();
        
        List<DML_Relation__c> DMLList= new List<DML_Relation__c>();
        Integer countDML=0;        
        DML_Relation__c recentDML= new DML_Relation__c();

        
       // Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('CustomerOnly');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
           
            customerList=[select Id, name,AOPS_Cust_Id__c,Grandparent_Name__c,Grandparent_ID__c,Parent_Name__c,Parent_ID__c,
            Address1__c,City__c,State__c,Account_Owner__c,owner.name,Account_Owner_Name__c,Rolling_12_month_sales__c
             from account where Id=:OrgId  and recordtypeId=:Customer  and org__c=:ParentOrg];
        }
        else{
            
            customerList=[select Id, name,AOPS_Cust_Id__c,Grandparent_Name__c,Grandparent_ID__c,Parent_Name__c,Parent_ID__c ,
            Address1__c,City__c,State__c,Account_Owner__c,owner.name,Account_Owner_Name__c,Rolling_12_month_sales__c
            from account where recordtypeId=:Customer and Org__C=:OrgId];
            
          }            
            if(customerList.size()>0){
            countCustomer=customerList.size();
            recentcustomer=customerList[0];
            }
          system.debug('countcustomer....'+countCustomer);

        accOrOrgData = new  AccountRelatedDataExt(customerList,countCustomer, recentCustomer,DMLList,countDML,recentDML);

       return accOrOrgData;
    }
 
        
    // Functionality to get Sales Rep Data     
        @AuraEnabled
    public static AccountRelatedData getRepData(String OrgId) {
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();
       
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            try{
            Id currentownerId=[select ownerId from Account where Id=:OrgId and org__C=:ParentOrg].ownerId;
            salesRepList =[select User_Name__C  ,ODP_Employee_Id__c,user__r.SmallPhotoUrl,SmallPhotoURL__c,
            User_Short_Title__C, User_Phone__c, User_Region__C,User_Manager__C,User_Market__c,ExtIDSalesPerson__c from Sales_Person__c 
            where user__C =:currentownerId and IsActive__c=true
            Limit 1];
            System.debug('&&&&&salesRepList '+salesRepList );
            }
            catch(Exception e){}
          }
        else{
            
            List<Account> customers= [select OwnerId from account where 
            recordtypeId=:Customer and Org__c=:OrgId ];
            List<Id> ownerIds= new List<Id>();
            for(Account rec :customers)
            ownerIds.add(rec.OwnerId);
            List<Sales_Person__c> salesRepListTemp = new List<Sales_Person__c>();
            Set<Id> repId  = new Set<Id>();
            salesRepListTemp =[select User_Name__C 
           ,ODP_Employee_Id__c,user__r.SmallPhotoUrl,SmallPhotoURL__c ,user__C ,
            User_Short_Title__C, User_Phone__c, User_Region__C,User_Manager__C,User_Market__c,ExtIDSalesPerson__c
            from Sales_Person__c 
            where user__C in :ownerIds and IsActive__c=true
            and Primary__c  =true];
            for(Sales_Person__c  rec :salesRepListTemp )
            {
              if( !repId.contains(rec.user__C)){
                repId.add(rec.user__C);
                salesRepList.add(rec);
              }
            }
            
          }
            
            if(salesRepList.size()>0){
            countRep=salesRepList.size();
            recentRep=salesRepList[0];
            }
            
                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 

countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }

    
    
    
        @AuraEnabled
    public static AccountRelatedData getCaseData(String OrgId) {
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();

        List<Note> noteList= new List<Note>();
                List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();

        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){        
            caseList = [select id,CaseNumber,IT_Created_By__c,CreatedDate,subject,RecordtypeName__c,Status,Owner.name,LastModifiedDate from case where AccountId=:OrgId
            and org__C=:ParentOrg order by createddate desc];
            
        }
        else{            
            caseList = [select id,CaseNumber,IT_Created_By__c,CreatedDate,subject,RecordtypeName__c,Status,Owner.name,LastModifiedDate  from case where accountId !=null and account.org__C =:OrgId order by createddate desc];
            
          }
            
            if(caseList.size()>0){
            countCase=caseList.size();
            recentCase=caseList[0];
            }
                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 

countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
    

    
     @AuraEnabled
    public static AccountRelatedData getTaskData(String OrgId) {
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();

        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
           
            taskList = [select id,Subject,Status,Call_Disposition__c,Disposition_Code__c,ActivityDate,Who.Name,Owner.Name from task where AccountId=:OrgId
            and org__C=:ParentOrg order by createddate desc];
            system.debug('parent'+ParentOrg);
            
        }
        else{
            
            taskList = [select id,Subject,Status,Call_Disposition__c,Disposition_Code__c,ActivityDate,Who.Name,Owner.Name from task  where account.org__C=:OrgId 
            order by createddate desc];
          }
            if(taskList.size()>0){
            countTask=taskList .size();
            recentTask=taskList[0]; 
            }
            
           accOrOrgData = new  AccountRelatedData
           (ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
           countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
           recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
    
   
    
    
        @AuraEnabled
    public static AccountRelatedData getOpportunityData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();
       
        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            oppList = [select id,Name,LBI__LatticeAccountName__c,LastModifiedDate,StageName,Product__c,Opportunity_Amount__c,IMU__c,CloseDate,NextStep,Owner.name from Opportunity where AccountId=:OrgId 
            and org__C=:ParentOrg order by createddate desc];
        }
        else{
            oppList = [select id,Name,LBI__LatticeAccountName__c,LastModifiedDate,StageName,Product__c,Opportunity_Amount__c,IMU__c,CloseDate,NextStep,Owner.name from Opportunity where accountId !=null and 
            (account.org__C=:OrgId or Related_Site__r.org__C=:OrgId)
              order by createddate desc];
          }
            if(oppList.size()>0){
            countOpportunity=oppList .size();
            recentOpportunity= oppList[0];
            }
                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 

countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);

       return accOrOrgData;
    }
    
        
       @AuraEnabled
    public static AccountRelatedData getContactData(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }

        String OrgString=OrgId;
        AccountRelatedData accOrOrgData;
        List<Contact> ctList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Sales_Data__C > salesDataList = new List<Sales_Data__C >();
        List<Case> caseList = new List<Case >();
        List<task> taskList = new List<Task>();
        List<Sales_Person__c>salesRepList = new List<Sales_Person__c>();
        List<Account>sitesList   =new List<Account>();
        
        List<Contract>contractList   =new List<Contract>();
        List<Note> noteList= new List<Note>();
        List<Pricing_Template__c> pricingList= new List<Pricing_Template__c>();

        
        Integer countContact=0;
        Integer countOpportunity=0;
        Integer countCase=0;
        Integer countTask=0;
        Integer countSales=0;
        Integer countRep=0;
        Integer countSites=0;
        Integer countContract=0;
        Integer countNote=0;
        Integer countPricing=0;
        
        Contact recentContact= new Contact();
        Opportunity recentOpportunity= new Opportunity();
        Sales_Data__C recentSales = new Sales_Data__C ();
        Case recentCase= new Case();
        Task recentTask = new Task();
        Sales_Person__c recentRep = new Sales_Person__c();
        Account recentSite = new Account();
        Contract recentContract = new Contract();
        Note recentNote = new Note();
        Pricing_Template__c recentPricing= new Pricing_Template__c();
        
        //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
            ctList = [select Id, name,email,Primary_Contact__c,Role__c,Title,Decision_Maker__c,Phone1_Rep__c,Phone_Type1__c from Contact where AccountId=:OrgId 
            and org__C=:ParentOrg order by createddate desc];
        }
        else{
           ctList = [select Id, name,email,Primary_Contact__c,Role__c,Title,Decision_Maker__c,Phone1_Rep__c,Phone_Type1__c from Contact where accountId !=null and 
           account.org__C=:OrgId order by createddate desc];
          }
            if(ctList.size()>0){
            countContact=ctList.size();
            recentContact=ctList[0];
            }
            if(salesDataLIst.size()>0){
            countSales=salesDataLIst.size();
            recentSales=salesDataLIst[0];
            }
                 accOrOrgData = new  AccountRelatedData

(ctList,oppList,caseList,taskList,salesDataLIst,salesRepList,sitesList,contractList,noteList,pricingList,
                 

countContact,countOpportunity,countCase,countTask,countSales,countRep,countSites,countContract,countNote,countPricing,
                 

recentContact,recentOpportunity,recentCase,recentTask,recentSales,recentRep,recentSite,recentContract,recentNote,recentPricing);
       return accOrOrgData;
    }
 
    
    
     
    
    @AuraEnabled
public static String getreport(Id OrgId){

System.debug('&&&&&&&inside'+OrgId);


    //Using report id for example purpose
    Report reportRec = [SELECT
            Id
    FROM Report
    WHERE Id = '00O1k000000FQ08'];
    Id ReportId= reportRec.Id; 

        Reports.ReportDescribeResult myReportResult = 

Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata myReportMetaData = myReportResult.getReportMetadata();

        Reports.ReportFilter myFilters = myReportMetaData.getReportFilters()[0];
         system.debug('--------->'+myFilters);

        //set the filter value
        String org=OrgId;
        org=org.substring(0,15);
        myFilters.setValue(org);
        Reports.ReportResults reportResult  = Reports.ReportManager.runReport(reportId, myReportMetaData);
         system.debug('--------->reportResult  '+reportResult  );

    return JSON.serialize(reportResult  );
}

    

    
    @AuraEnabled
    public static List<Contact> getContactList(Id OrgId) { 
        System.debug('&&&&&&&&'+OrgId);
        List<Contact> contactLIst = new List<Contact>();
        String OrgString=OrgId;
        if(OrgString.substring(0,3)=='001'){
            contactLIst=[select Id, name,email from Contact
                         where AccountId=:OrgId];
        }
        else{
            contactLIst=[select Id, name,email from Contact
                         where account.org__C=:OrgId];
        }
        return contactLIst ;
    }

    @AuraEnabled
    public static List<items> getOrgHierarchy(Id OrgId) { 
        List<Org__C> top_accts= new List<Org__C>();
        List<items> wrapperList= new List<items>();
        
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C from Org__C where 
        Id=:OrgId];
        
        if(orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__r.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];
        else
        top_accts= [ Select Id, Business_name__C from Org__C where Id=:OrgId];

            //top_accts= new List<Org__C>();
        
        System.debug('&&&&&&top_accts'+top_accts);
        
        Map<Id,items> nodes = new Map<Id,items>();
        Set<Id> parent_acc_ids = new Set<Id>();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');

         List<Id> orgIdList = new List<Id>();
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                orgIdList.add(a.Id);
            }
        }
        
        
        List<Account> CustomerList1 = new List<Account>();
        map<Id,List<Account>> orgAccMap = new Map<Id,List<Account>>();
               
        //Id Site1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();  
        Set<Id> Site1=getAccId('Site');
        List<Account> SiteChildList1 = [select 
        id,related_account__C,org__c,related_account__r.org__C from account where 
        org__c in : orgIdList
        and RecordTypeId=:Site1 and related_account__C !=null];
                                                   
                                        
            Map<Id,Id > CustOrgMap1 =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers1=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList1 '+SiteChildList1 );                    

                
               Set<Id> siteSet1 = new Set<Id>();
               for( Account rec:SiteChildList1 ){
                 if(! siteSet1.contains(rec.related_account__C)){
                 siteSet1.add(rec.related_account__C);
                 CustOrgMap1.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers1.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet1'+siteSet1);                                    

        
        
        CustomerList1 =[select Id, name ,aops_cust_id__C,org__c from account where  ( 
        org__c in :orgIdList or Id in :siteSet1 )
        and RecordTypeId=:Customer ];
                                            
        System.debug('&&&&&&&& CustomerList1 '+CustomerList1 );                                    
                            
                                            
        for(Account acc :CustomerList1){
           Id currentOrg;
          /* if(acc.org__c==null)
           currentOrg=CustOrgMap1.get(acc.Id);
           else
           currentOrg=acc.Org__C;*/
           if(CustOrgMap1.get(acc.Id)  !=null)
           currentOrg=CustOrgMap1.get(acc.Id);
           else
           currentOrg=acc.Org__C;
           
           
            if(orgAccMap.containsKey(currentOrg)){
                List<account> accUpdatedList = orgAccMap.get(currentOrg);
                accUpdatedList.add(acc);
                 orgAccMap.put(currentOrg,accUpdatedList);                
            }else{
                List<Account> accList = new List<Account>();
                accList.add(acc);
                orgAccMap.put(currentOrg,accList);
            }
        }
        
        System.debug('&&&&&orgAccMap'+orgAccMap);
        
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                // Get all customers of Org Hierachy
               // List<Account> CustomerList=[select Id, name ,aops_cust_id__C,org__C from account where org__c =:a.Id
                 //                           and RecordTypeId=:Customer ];
                 List<Account> CustomerList = new List<Account>();
                if(orgAccMap.containsKey(a.Id)){
                    CustomerList = orgAccMap.get(a.Id);
                }                          
                
                List<Items> TopCustomers= new List<Items> ();
                for(integer i=0;i<CustomerList.size();i++){
                    items top_node_cust = new items();
                    
                    Id currentOrgId= CustomerList[i].org__C;

                    if(CustomerList[i].name != null){
                        if(currentOrgId==null  || currentOrgId != a.Id   )
                        top_node_cust.label=CustomerList[i].name +'-S';
                        else
                        top_node_cust.label= CustomerList[i].name; 

                    }                    
                    top_node_cust.expanded= true;
                    if(currentOrgId==null   || currentOrgId != a.Id   )
                    currentOrgId=OrphanCustomers1.get(CustomerList[i].Id);
                    
                    top_node_cust .name= CustomerList[i].Id +'-'+currentOrgId; 
                    top_node_cust .items= null;
                    TopCustomers.add(top_node_cust );
                }
                items top_node = new items();
                if(a.Business_Name__c != null){
                    top_node.label= a.Business_Name__c ; 
                }
                
                top_node.expanded= true;
                top_node.name= a.Id ; 
                if(top_node.items==null)
                    top_node.items=new List<items >();
                
                top_node.items.addall(TopCustomers);
                nodes.put(a.Id, top_node);
                
                //nodes.put(a.Id, new items(a));
                parent_acc_ids.add(a.Id);
            }
            System.debug('&&&&top'+nodes);
            //while (parent_acc_ids.size() > 0) {
                if(!parent_acc_ids.isEmpty()){
                Map<Id,Org__C> subordinate_accounts = new Map<Id,Org__C>([SELECT Id, Parent_Org__c, Business_Name__c
                FROM Org__c WHERE Parent_Org__c IN :parent_acc_ids  ]);                
                parent_acc_ids = subordinate_accounts.keySet();
                
                
                
                List<Account> SiteChildList = [select 
                id,related_account__C,org__c,related_account__r.org__C from account where 
                org__c in : parent_acc_ids
                and RecordTypeId=:Site1 and related_account__C !=null];
                                                           
                                        
            Map<Id,Id > CustOrgMap =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList '+SiteChildList );                    

                
               Set<Id> siteSet = new Set<Id>();
               for( Account rec:SiteChildList ){
                 if(! siteSet.contains(rec.related_account__C)){
                 siteSet.add(rec.related_account__C);
                 CustOrgMap.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet'+siteSet);                                    

                
                
                List<Account> CustomerListNode1=[select Id, name ,aops_cust_id__C,org__C from account where 
                (org__c in : parent_acc_ids or Id in :siteSet )

                and RecordTypeId=:Customer ];
                map<Id,List<Account>> orgAccMap1 = new Map<Id,List<Account>>();
                
                
                    
                    for(Account acc :CustomerListNode1){
                    
                      Id currentOrg;
                               if(CustOrgMap.get(acc.Id)  !=null)
                               currentOrg=CustOrgMap.get(acc.Id);
                               else
                               currentOrg=acc.Org__C;                                                          
                    
                        if(orgAccMap1.containsKey(currentOrg)){
                            List<account> accUpdatedList = orgAccMap1.get(currentOrg);
                            accUpdatedList.add(acc);
                            orgAccMap1.put(currentOrg,accUpdatedList);                
                        }else{
                            List<Account> accList = new List<Account>();
                            accList.add(acc);
                            orgAccMap1.put(currentOrg,accList);
                        }
                    }    
                    
                System.debug('&&&&&orgAccMap1'+orgAccMap1);
            
                for (Org__c acc : subordinate_accounts.values()) {
                    
                   // List<Account> CustomerListNode=[select Id, name ,aops_cust_id__C,org__C from account where org__c =:acc.Id
                   //                                 and RecordTypeId=:Customer ];
                    List<Account> CustomerListNode = new List<Account>();
                    if(orgAccMap1.containsKey(acc.id)){
                        CustomerListNode = orgAccMap1.get(acc.id);
                    }
                   
                    List<Items> NodeCustomersLIst= new List<Items> ();
                    for(integer i=0;i<CustomerListNode.size();i++){
                        items NodeCustomers= new items();
                        
                        
                        Id currentOrgId= CustomerListNode[i].org__C;

                      if(CustomerListNode[i].name != null){
                        if(currentOrgId==null  || currentOrgId != acc.Id   )
                        NodeCustomers.label=CustomerListNode[i].name +'-S';
                        else
                        NodeCustomers.label= CustomerListNode[i].name; 
                       }
                                                
                                                                        
                    NodeCustomers.expanded= true;
                    if(currentOrgId==null   || currentOrgId != acc.Id   )
                    currentOrgId=OrphanCustomers.get(CustomerListNode[i].Id);
                    
                    NodeCustomers.name= CustomerListNode[i].Id +'-'+currentOrgId; 
                        NodeCustomers.items= null;
                        NodeCustomersLIst.add(NodeCustomers);
                    }
                    
                    
                    items new_node = new items();
                    //system.debug('acc.Business_Name__c.......'+acc.Business_Name__c);
                    if(acc.Business_Name__c != null){
                        new_node.Label= acc.Business_Name__c; 
                    }
                    
                    new_node.name= acc.Id ; 
                    new_node.expanded= true;
                    //List<items >objRec = new List<items >();
                    //new_node.items=objRec ;
                    
                    if(new_node.items==null)
                        new_node.items=new List<items >();
                    
                    new_node.items.addall(NodeCustomersLIst);
                    
                    System.debug('&&&&&&&&new_node'+new_node);
                    nodes.put(acc.id, new_node);
                    System.debug('&&&&&&&&acc.Parent_Org__C'+acc.Parent_Org__C);
                    
                    items ref_node = nodes.get(acc.Parent_Org__C);
                    if(ref_node.items==null)
                        ref_node.items=new List<items >();
                    ref_node.items.add(new_node);
                    System.debug('&&&&&&&&ref_node '+ref_node );
                    
                }
            }
            
            System.debug('&&&&&&nodes'+nodes);
            System.debug('&&&&&&nodes'+nodes.keySet());
            
            
            //for(  Id recId: nodes.keySet()){
               if(top_accts.size()>0)
                wrapperList.add(nodes.get(top_accts[0].Id)); 
        }   
        
        // NO hierrachy single records
        /*if(orgRec.Parent_Org__C ==null){
            List<Org__C> Level1Org=[Select Id ,Business_Name__c from Org__C where 

Id=:orgRec.Id];
            for(Org__C  rec :Level1Org){
                items obj = new items();
                obj.label=rec.Business_Name__c ;
                obj.Name = rec.Id ;
                obj.expanded= true;
                obj.items= null;
                wrapperList.add(obj); 
                
            }           
        }*/
        system.debug('WrapperList :: ' + wrapperList);
        return wrapperList;
    }
    
    public class items {  
        @AuraEnabled  
        public string label { get; set; }  
        @AuraEnabled  
        public string name { get; set; }
        @AuraEnabled  
        public Boolean expanded { get; set; }
        @AuraEnabled  
        public List<items> items { get; set; }  
        
        public items(){}
        public items( String name, String label, Boolean expanded, List<items> items) {  
            this.label = label;  
            this.name = name;  
            this.expanded = expanded;  
            this.items = items;   
        }  
    }
    
    @AuraEnabled
    public static List<Org__C> findAllOrgs(Id OrgId) {
        List<Org__C> top_accts= new List<Org__C>();
        Set<id> orgSet = new Set<id> ();
        Set<Id> parent_acc_ids = new Set<Id>();
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C 

,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C from Org__C 
                       where Id=:OrgId];
        if(orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null)
            top_accts=[ Select Id, Business_name__C from Org__C where 

Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__r.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where 

Id=:orgRec.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where 

Id=:orgRec.Parent_Org__C];
        else
       top_accts= [ Select Id, Business_name__C from Org__C where Id=:OrgId];


       System.debug('&&&&&top_accts'+top_accts);
            //top_accts= new List<Org__C>();
        
        for (Org__C a : top_accts) {
            orgSet.add(a.Id);
            parent_acc_ids.add(a.Id);
        }
        
        while (parent_acc_ids.size() > 0) {
               System.debug('&&&&&inside');

            Map<Id,Org__C> subordinate_accounts =
                new Map<Id,Org__C>([
                    SELECT Id, Parent_Org__c, Business_Name__c
                    FROM Org__c
                    WHERE Parent_Org__c IN :parent_acc_ids
                ]);
            parent_acc_ids = subordinate_accounts.keySet();
            for (Org__C acc : subordinate_accounts.values()) {
                if(!orgSet.contains(acc.Id))             
                    orgSet.add(acc.Id);
            }
        }
       List<Org__C> orgList = [SELECT id, name,Business_Name__c, Location__Latitude__s, 

Location__Longitude__s
                FROM Org__C WHERE  Id in :orgSet
                // Location__Latitude__s != NULL AND Location__Longitude__s != NULL
                LIMIT 50];
         system.debug('orgList...'+orgList);
        return orgList;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


  // get Id's of Customer and Site Recordtypes
      Public static Set<Id> getAccIdOD( String type)
    {
       String sObjectName='Account';
        set<Id> recordTypeIds = new set<Id>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        if(sobjectResult != null)
        {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            if(recordTypeInfo != null)
            {
                for(Schema.RecordTypeInfo info : recordTypeInfo)
                {
                  if(type=='Prospect'){
                    if(   info.getName().contains('Prospect'  )   || info.getName().contains('Account Setup Requested'))
                    {
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }
                 else if(type=='Customer'){
                    if(  info.getName().contains('Customer'  ))
                    {
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }

             else{
                if(type=='Site'){
                    if(  info.getName().contains('Site'   ) )
                    {
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                  }
                }
                  
                  
                }
            }
        }
        system.debug('recordtypes'+recordTypeIds);
        return recordTypeIds;
    }




 @AuraEnabled
    public static List<items> getOrgHierarchyOD(Id OrgId,Boolean ProspectSelect, Boolean CustomerSelect,Boolean SiteSelect,Boolean OrphanSelect) { 
        List<Org__C> top_accts= new List<Org__C>();
        List<items> wrapperList= new List<items>();
        Set<Id> Site1=getAccIdOD('Site');
        Set<Id> Customer=getAccIdOD('Customer');
        Set<Id> Prospect=getAccIdOD('Prospect');
        Set<Id> allAccounts= new Set<Id>();
        
        
        
        
        Set<Id> SiteRecordtypeId=new Set<Id>();
        if(SiteSelect==true){
        SiteRecordtypeId=Site1;
        allAccounts.addAll(Site1);
        }
        Set<Id> CustomerRecordtypeId=new Set<Id>();
        if(ProspectSelect==true){
        CustomerRecordtypeId.addAll(Prospect);
        allAccounts.addAll(Prospect);
        }
        if(CustomerSelect==true){
        CustomerRecordtypeId.addAll(Customer);
        allAccounts.addAll(Customer);
        }
        
        
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C 
        from Org__C where Id=:OrgId];
        
        
        if(top_accts.size()==0  &&  orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
       
          Integer  countTop=[select count ()  from account where   
          org__c = :orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  and 
          (RecordTypeId  in :allAccounts )  ];
          if(countTop==0   && OrphanSelect==false )
          top_accts= new List<Org__C>();

        }
        if(top_accts.size()==0  &&   orgRec.Parent_Org__r.Parent_Org__C!=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];

          Integer  countTop=[select count ()  from account where  
                    org__c = :orgRec.Parent_Org__r.Parent_Org__C  and 
          (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();

        }
        if(top_accts.size()==0  &&  orgRec.Parent_Org__C!=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];


          Integer  countTop=[select count ()  from account where  
          org__c =:orgRec.Parent_Org__C  and 
           (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();

        }
        if(top_accts.size()==0){
        top_accts= [ Select Id, Business_name__C from Org__C where Id=:OrgId];

          Integer  countTop=[select count ()  from account where  
          org__c = :OrgId  and 
           (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();
        }

        
        System.debug('&&&&&&top_accts'+top_accts);
        
        Map<Id,items> nodes = new Map<Id,items>();
        Set<Id> parent_acc_ids = new Set<Id>();
        

         List<Id> orgIdList = new List<Id>();
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                orgIdList.add(a.Id);
            }
        }
        
        
        List<Account> CustomerList1 = new List<Account>();
        map<Id,List<Account>> orgAccMap = new Map<Id,List<Account>>();
               
        
        List<Account> SiteChildList1 = [select 
        id,related_account__C,org__c,related_account__r.org__C from account where 
        org__c in : orgIdList
        and RecordTypeId=:SiteRecordtypeId and related_account__C !=null];
                                                   
                                        
            Map<Id,Id > CustOrgMap1 =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers1=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList1 '+SiteChildList1 );                    

                
               Set<Id> siteSet1 = new Set<Id>();
               for( Account rec:SiteChildList1 ){
                 if(! siteSet1.contains(rec.related_account__C)){
                 siteSet1.add(rec.related_account__C);
                 CustOrgMap1.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers1.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet1'+siteSet1);                                    

        
        
        CustomerList1 =[select Id, name ,aops_cust_id__C,org__c from account where Id in :siteSet1  or
         ( org__c in :orgIdList 
         and RecordTypeId=:CustomerRecordtypeId  ) ];
                                            
        System.debug('&&&&&&&& CustomerList1 '+CustomerList1 );                                    
                            
                                            
        for(Account acc :CustomerList1){
           Id currentOrg;
           if(CustOrgMap1.get(acc.Id)  !=null)
           currentOrg=CustOrgMap1.get(acc.Id);
           else
           currentOrg=acc.Org__C;
           
           
            if(orgAccMap.containsKey(currentOrg)){
                List<account> accUpdatedList = orgAccMap.get(currentOrg);
                accUpdatedList.add(acc);
                 orgAccMap.put(currentOrg,accUpdatedList);                
            }else{
                List<Account> accList = new List<Account>();
                accList.add(acc);
                orgAccMap.put(currentOrg,accList);
            }
        }
        
        System.debug('&&&&&orgAccMap'+orgAccMap);
       
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                 List<Account> CustomerList = new List<Account>();
                if(orgAccMap.containsKey(a.Id)){
                    CustomerList = orgAccMap.get(a.Id);
                }                          
                
                List<Items> TopCustomers= new List<Items> ();
                for(integer i=0;i<CustomerList.size();i++){
                    items top_node_cust = new items();
                    
                    Id currentOrgId= CustomerList[i].org__C;

                    if(CustomerList[i].name != null){
                        if(currentOrgId==null  || currentOrgId != a.Id   )
                        top_node_cust.label=CustomerList[i].name +'-S';
                        else
                        top_node_cust.label= CustomerList[i].name; 

                    }                    
                    top_node_cust.expanded= true;
                    if(currentOrgId==null   || currentOrgId != a.Id   )
                    currentOrgId=OrphanCustomers1.get(CustomerList[i].Id);
                    
                    top_node_cust .name= CustomerList[i].Id +'-'+currentOrgId; 
                    top_node_cust .items= null;
                    TopCustomers.add(top_node_cust );
                }
                items top_node = new items();
                if(a.Business_Name__c != null){
                    top_node.label= a.Business_Name__c ; 
                }
                
                top_node.expanded= true;
                top_node.name= a.Id ; 
                if(top_node.items==null)
                top_node.items=new List<items >();
                
                top_node.items.addall(TopCustomers);
                if(OrphanSelect ==true )
                nodes.put(a.Id, top_node);
                else{
                if(TopCustomers.size()>0)
                nodes.put(a.Id, top_node);                
                }
                
                parent_acc_ids.add(a.Id);
            }
            System.debug('&&&&top'+nodes);
            
            
            
                if(!parent_acc_ids.isEmpty()){
                Map<Id,Org__C> subordinate_accounts = new Map<Id,Org__C>([SELECT Id, Parent_Org__c, Business_Name__c
                FROM Org__c WHERE Parent_Org__c IN :parent_acc_ids  ]);                
                parent_acc_ids = subordinate_accounts.keySet();
                
                
                
                List<Account> SiteChildList = [select 
                id,related_account__C,org__c,related_account__r.org__C from account where 
                org__c in : parent_acc_ids
                and RecordTypeId=:SiteRecordtypeId and related_account__C !=null];
                                                           
                                        
            Map<Id,Id > CustOrgMap =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList '+SiteChildList );                    

                
               Set<Id> siteSet = new Set<Id>();
               for( Account rec:SiteChildList ){
                 if(! siteSet.contains(rec.related_account__C)){
                 siteSet.add(rec.related_account__C);
                 CustOrgMap.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet'+siteSet);                                    

                                
                List<Account> CustomerListNode1=[select Id, name ,aops_cust_id__C,org__C from account where 
                
                (Id in :siteSet  and RecordTypeId=:CustomerRecordtypeId)
                
                  or 
                (org__c in : parent_acc_ids 
                and RecordTypeId=:CustomerRecordtypeId )];
                map<Id,List<Account>> orgAccMap1 = new Map<Id,List<Account>>();
                
                
                    
                    for(Account acc :CustomerListNode1){
                    
                      Id currentOrg;
                               if(CustOrgMap.get(acc.Id)  !=null)
                               currentOrg=CustOrgMap.get(acc.Id);
                               else
                               currentOrg=acc.Org__C;                                                          
                    
                        if(orgAccMap1.containsKey(currentOrg)){
                            List<account> accUpdatedList = orgAccMap1.get(currentOrg);
                            accUpdatedList.add(acc);
                            orgAccMap1.put(currentOrg,accUpdatedList);                
                        }else{
                            List<Account> accList = new List<Account>();
                            accList.add(acc);
                            orgAccMap1.put(currentOrg,accList);
                        }
                    }    
                    
                System.debug('&&&&&orgAccMap1'+orgAccMap1);
            
                for (Org__c acc : subordinate_accounts.values()) {
                    
                    List<Account> CustomerListNode = new List<Account>();
                    if(orgAccMap1.containsKey(acc.id)){
                        CustomerListNode = orgAccMap1.get(acc.id);
                    }
                   
                    List<Items> NodeCustomersLIst= new List<Items> ();
                    for(integer i=0;i<CustomerListNode.size();i++){
                        items NodeCustomers= new items();
                        
                        
                        Id currentOrgId= CustomerListNode[i].org__C;

                      if(CustomerListNode[i].name != null){
                        if(currentOrgId==null  || currentOrgId != acc.Id   )
                        NodeCustomers.label=CustomerListNode[i].name +'-S';
                        else
                        NodeCustomers.label= CustomerListNode[i].name; 
                       }
                                                
                                                                        
                    NodeCustomers.expanded= true;
                    if(currentOrgId==null   || currentOrgId != acc.Id   )
                    currentOrgId=OrphanCustomers.get(CustomerListNode[i].Id);
                    
                    NodeCustomers.name= CustomerListNode[i].Id +'-'+currentOrgId; 
                        NodeCustomers.items= null;
                        NodeCustomersLIst.add(NodeCustomers);
                    }
                    
                    
                    items new_node = new items();
                    if(acc.Business_Name__c != null){
                        new_node.Label= acc.Business_Name__c; 
                    }
                    
                    new_node.name= acc.Id ; 
                    new_node.expanded= true;
                    
                    if(new_node.items==null)
                        new_node.items=new List<items >();
                    
                    new_node.items.addall(NodeCustomersLIst);
                    
                    System.debug('&&&&&&&&new_node'+new_node);
                    if(OrphanSelect ==true )
                    nodes.put(acc.id, new_node);
                    else{
                          if(NodeCustomersLIst.size()>0 )
                          nodes.put(acc.id, new_node);                       
                    }
                    System.debug('&&&&&&&&acc.Parent_Org__C'+acc.Parent_Org__C);
                    
                    items ref_node = nodes.get(acc.Parent_Org__C);
                    if(ref_node.items==null)
                        ref_node.items=new List<items >();
                        
                   if(OrphanSelect ==true )     
                    ref_node.items.add(new_node);
                    else{
                          if(NodeCustomersLIst.size()>0 )
                          ref_node.items.add(new_node);

                    
                    }
                    System.debug('&&&&&&&&ref_node '+ref_node );
                    
                }
            }
            
            System.debug('&&&&&&nodes'+nodes);
            System.debug('&&&&&&nodes'+nodes.keySet());
            
            
               if(top_accts.size()>0)
                wrapperList.add(nodes.get(top_accts[0].Id)); 
        }   
        
        
        system.debug('WrapperList :: OD results...' + wrapperList);
        return wrapperList;
    }
    
   
    
    
    
    
    
          @AuraEnabled
    public static List<itemsImage> getOrgHierarchyImage(Id OrgId) { 
        List<Org__C> top_accts= new List<Org__C>();
        List<itemsImage> wrapperList= new List<itemsImage>();
        
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C
        from Org__C where 
        Id=:OrgId];
        
        if(orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__r.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];
        else
        top_accts= [ Select Id, Business_name__C from Org__C where Id=:OrgId];

            //top_accts= new List<Org__C>();
        
        System.debug('&&&&&&top_accts'+top_accts);
        
        Map<Id,itemsImage> nodes = new Map<Id,itemsImage>();
        Set<Id> parent_acc_ids = new Set<Id>();
        //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Set<Id> Customer=getAccId('Customer');

         List<Id> orgIdList = new List<Id>();
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                orgIdList.add(a.Id);
            }
        }
        
        
        List<Account> CustomerList1 = new List<Account>();
        map<Id,List<Account>> orgAccMap = new Map<Id,List<Account>>();
               
        //Id Site1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();  
        Set<Id> Site1=getAccId('Site');
        List<Account> SiteChildList1 = [select 
        id,related_account__C,org__c,related_account__r.org__C from account where 
        org__c in : orgIdList
        and RecordTypeId=:Site1 and related_account__C !=null];
                                                   
                                        
            Map<Id,Id > CustOrgMap1 =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers1=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList1 '+SiteChildList1 );                    

                
               Set<Id> siteSet1 = new Set<Id>();
               for( Account rec:SiteChildList1 ){
                 if(! siteSet1.contains(rec.related_account__C)){
                 siteSet1.add(rec.related_account__C);
                 CustOrgMap1.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers1.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet1'+siteSet1);                                    

        
        
        CustomerList1 =[select Id, name ,aops_cust_id__C,org__c,RecordType_Name__c from account where  ( 
        org__c in :orgIdList or Id in :siteSet1 )
        and RecordTypeId=:Customer ];
                                            
        System.debug('&&&&&&&& CustomerList1 '+CustomerList1 );                                    
                            
                                            
        for(Account acc :CustomerList1){
           Id currentOrg;
           if(CustOrgMap1.get(acc.Id)  !=null)
           currentOrg=CustOrgMap1.get(acc.Id);
           else
           currentOrg=acc.Org__C;
           
           
            if(orgAccMap.containsKey(currentOrg)){
                List<account> accUpdatedList = orgAccMap.get(currentOrg);
                accUpdatedList.add(acc);
                 orgAccMap.put(currentOrg,accUpdatedList);                
            }else{
                List<Account> accList = new List<Account>();
                accList.add(acc);
                orgAccMap.put(currentOrg,accList);
            }
        }
        
        System.debug('&&&&&orgAccMap'+orgAccMap);
        
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                // Get all customers of Org Hierachy
                List<Account> CustomerList = new List<Account>();
                if(orgAccMap.containsKey(a.Id)){
                    CustomerList = orgAccMap.get(a.Id);
                }                          
                
                List<itemsImage> TopCustomers= new List<itemsImage> ();
                for(integer i=0;i<CustomerList.size();i++){
                    itemsImage top_node_cust = new itemsImage();
                    
                    Id currentOrgId= CustomerList[i].org__C;

                    if(CustomerList[i].name != null){
                        if(currentOrgId==null  || currentOrgId != a.Id   ){
                        top_node_cust.label=CustomerList[i].name;
                        top_node_cust.type='-Site';
                        }
                        else{
                        top_node_cust.label= CustomerList[i].name; 
                        
                         String currentRecordtypeName=CustomerList[i].RecordType_Name__c;
                         System.debug('&&&&&&&&here'+currentRecordtypeName);
                         if(currentRecordtypeName.contains('Prospect')  || currentRecordtypeName.contains('Account Setup Requested'))
                         top_node_cust.type='-Prospect';
                         if(currentRecordtypeName.contains('Customer'))
                         top_node_cust.type='-Customer';

                        
                        }

                    }                    
                    top_node_cust.expanded= true;
                    if(currentOrgId==null   || currentOrgId != a.Id   )
                    currentOrgId=OrphanCustomers1.get(CustomerList[i].Id);
                    
                    top_node_cust .name= CustomerList[i].Id +'-'+currentOrgId; 
                    top_node_cust .itemsImage= null;
                    TopCustomers.add(top_node_cust );
                }
                itemsImage top_node = new itemsImage();
                if(a.Business_Name__c != null){
                    top_node.label= a.Business_Name__c ; 
                }
                
                top_node.type= '-Global';
                top_node.expanded= true;

                top_node.name= a.Id ; 
                if(top_node.itemsImage==null)
                    top_node.itemsImage=new List<itemsImage >();
                
                top_node.itemsImage.addall(TopCustomers);
                nodes.put(a.Id, top_node);                
                parent_acc_ids.add(a.Id);
            }
            System.debug('&&&&top'+nodes);
            //while (parent_acc_ids.size() > 0) {
                if(!parent_acc_ids.isEmpty()){
                Map<Id,Org__C> subordinate_accounts = new Map<Id,Org__C>([SELECT Id, Parent_Org__c, Business_Name__c
                FROM Org__c WHERE Parent_Org__c IN :parent_acc_ids order by Business_Name__c asc ]);                
                parent_acc_ids = subordinate_accounts.keySet();
                
                
                
                List<Account> SiteChildList = [select 
                id,related_account__C,org__c,related_account__r.org__C from account where 
                org__c in : parent_acc_ids
                and RecordTypeId=:Site1 and related_account__C !=null];
                                                           
                                        
            Map<Id,Id > CustOrgMap =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList '+SiteChildList );                    

                
               Set<Id> siteSet = new Set<Id>();
               for( Account rec:SiteChildList ){
                 if(! siteSet.contains(rec.related_account__C)){
                 siteSet.add(rec.related_account__C);
                 CustOrgMap.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers.put(rec.related_account__C, rec.org__c);
                 }
              }
          System.debug('&&&&&&&& siteSet'+siteSet);                                    

                
                
                List<Account> CustomerListNode1=[select Id, name ,aops_cust_id__C,org__C,RecordType_Name__c from account where 
                (org__c in : parent_acc_ids or Id in :siteSet )
                and RecordTypeId=:Customer ];
                map<Id,List<Account>> orgAccMap1 = new Map<Id,List<Account>>();
                
                
                    
                    for(Account acc :CustomerListNode1){
                    
                      Id currentOrg;
                               if(CustOrgMap.get(acc.Id)  !=null)
                               currentOrg=CustOrgMap.get(acc.Id);
                               else
                               currentOrg=acc.Org__C;                                                          
                    
                        if(orgAccMap1.containsKey(currentOrg)){
                            List<account> accUpdatedList = orgAccMap1.get(currentOrg);
                            accUpdatedList.add(acc);
                            orgAccMap1.put(currentOrg,accUpdatedList);                
                        }else{
                            List<Account> accList = new List<Account>();
                            accList.add(acc);
                            orgAccMap1.put(currentOrg,accList);
                        }
                    }    
                    
                System.debug('&&&&&orgAccMap1'+orgAccMap1);
            
                for (Org__c acc : subordinate_accounts.values()) {
                    
                   // List<Account> CustomerListNode=[select Id, name ,aops_cust_id__C,org__C from account where org__c =:acc.Id
                   //                                 and RecordTypeId=:Customer ];
                    List<Account> CustomerListNode = new List<Account>();
                    if(orgAccMap1.containsKey(acc.id)){
                        CustomerListNode = orgAccMap1.get(acc.id);
                    }
                   
                    List<itemsImage> NodeCustomersLIst= new List<itemsImage> ();
                    for(integer i=0;i<CustomerListNode.size();i++){
                        itemsImage NodeCustomers= new itemsImage();
                        
                        
                        Id currentOrgId= CustomerListNode[i].org__C;

                      if(CustomerListNode[i].name != null){
                        if(currentOrgId==null  || currentOrgId != acc.Id   ){
                        NodeCustomers.label=CustomerListNode[i].name;
                        NodeCustomers.type='-Site';
                        }
                        else
                        {
                        NodeCustomers.label= CustomerListNode[i].name; 
                         String currentRecordtypeName=CustomerListNode[i].RecordType_Name__c;
                         if(currentRecordtypeName.contains('Prospect')  || currentRecordtypeName.contains('Account Setup Requested'))
                         NodeCustomers.type='-Prospect';
                         if(currentRecordtypeName.contains('Customer'))
                         NodeCustomers.type='-Customer';
                        }
                       }
                                                
                                                                        
                    NodeCustomers.expanded= true;
                    if(currentOrgId==null   || currentOrgId != acc.Id   )
                    currentOrgId=OrphanCustomers.get(CustomerListNode[i].Id);
                    
                    NodeCustomers.name= CustomerListNode[i].Id +'-'+currentOrgId; 
                        NodeCustomers.itemsImage= null;
                        NodeCustomersLIst.add(NodeCustomers);
                    }
                    
                    
                    itemsImage new_node = new itemsImage();
                    //system.debug('acc.Business_Name__c.......'+acc.Business_Name__c);
                    if(acc.Business_Name__c != null){
                        new_node.Label= acc.Business_Name__c; 
                    }
                    
                    new_node.name= acc.Id ; 
                    new_node.type= '-Org';
                    new_node.expanded= true;

                    //List<itemsImage >objRec = new List<itemsImage >();
                    //new_node.itemsImage=objRec ;
                    
                    if(new_node.itemsImage==null)
                        new_node.itemsImage=new List<itemsImage >();
                    
                    new_node.itemsImage.addall(NodeCustomersLIst);
                    
                    System.debug('&&&&&&&&new_node'+new_node);
                    nodes.put(acc.id, new_node);
                    System.debug('&&&&&&&&acc.Parent_Org__C'+acc.Parent_Org__C);
                    
                    itemsImage ref_node = nodes.get(acc.Parent_Org__C);
                    if(ref_node.itemsImage==null)
                        ref_node.itemsImage=new List<itemsImage >();
                    ref_node.itemsImage.add(new_node);
                    System.debug('&&&&&&&&ref_node '+ref_node );
                    
                }
            }
            
            System.debug('&&&&&&nodes'+nodes);
            System.debug('&&&&&&nodes'+nodes.keySet());
            
            
            //for(  Id recId: nodes.keySet()){
               if(top_accts.size()>0)
                wrapperList.add(nodes.get(top_accts[0].Id)); 
        }   
        
        // NO hierrachy single records
        /*if(orgRec.Parent_Org__C ==null){
            List<Org__C> Level1Org=[Select Id ,Business_Name__c from Org__C where 

Id=:orgRec.Id];
            for(Org__C  rec :Level1Org){
                itemsImage obj = new itemsImage();
                obj.label=rec.Business_Name__c ;
                obj.Name = rec.Id ;
                obj.expanded= true;
                obj.itemsImage= null;
                wrapperList.add(obj); 
                
            }           
        }*/
        system.debug('WrapperList :: ' + wrapperList);
        return wrapperList;
    }
    
    public class itemsImage {  
        @AuraEnabled  
        public string label { get; set; }  
        @AuraEnabled  
        public string name { get; set; }
        @AuraEnabled  
        public Boolean expanded { get; set; }
        @AuraEnabled  
        public String type{ get; set; }

        @AuraEnabled  
        public List<itemsImage> itemsImage { get; set; }  
        
        public itemsImage(){}
        public itemsImage( String name, String label, Boolean expanded, List<itemsImage> itemsImage, String type) {  
            this.label = label;  
            this.name = name;  
            this.expanded = expanded;  
            this.itemsImage = itemsImage;   
            this.type=type;
        }  
 
    }
    
    
    
    
   
      @AuraEnabled
    public static List<itemsImage> getOrgHierarchyODImage(String OrgId,Boolean ProspectSelect, Boolean CustomerSelect,Boolean SiteSelect,Boolean OrphanSelect) { 
       
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[1];
         ParentOrg=processList[0];
         }
        

       
       
               System.debug('&&&&&&&&&&&Inside getOrgHierarchyODImage');
               System.debug('&&&&&&&&&&&ProspectSelect'+ProspectSelect);
               System.debug('&&&&&&&&&&&CustomerSelect'+CustomerSelect);
               System.debug('&&&&&&&&&&&SiteSelect'+SiteSelect);
               System.debug('&&&&&&&&&&&OrphanSelect'+OrphanSelect);


       
        List<Org__C> top_accts= new List<Org__C>();
        List<itemsImage> wrapperList= new List<itemsImage>();
        Set<Id> Site1=getAccIdOD('Site');
        Set<Id> Customer=getAccIdOD('Customer');
        Set<Id> Prospect=getAccIdOD('Prospect');
        Set<Id> allAccounts= new Set<Id>();
        
        
        
        
        Set<Id> SiteRecordtypeId=new Set<Id>();
        if(SiteSelect==true){
        System.debug('&&&&inside site');
        SiteRecordtypeId=Site1;
        allAccounts.addAll(Site1);
        }
        Set<Id> CustomerRecordtypeId=new Set<Id>();
        if(ProspectSelect==true){
        System.debug('&&&&inside Prospect');
        CustomerRecordtypeId.addAll(Prospect);
        allAccounts.addAll(Prospect);
        }
        if(CustomerSelect==true){
        System.debug('&&&&inside Customer');
        CustomerRecordtypeId.addAll(Customer);
        allAccounts.addAll(Customer);
        }
        
        
        System.debug('&&&&&&&&&&&allAccounts'+allAccounts);
        System.debug('&&&&&&&&&&&CustomerRecordtypeId'+CustomerRecordtypeId);

        
        
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C 
        from Org__C where Id=:OrgId];
        
        
        if(top_accts.size()==0  &&  orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
       
          /*Integer  countTop=[select count ()  from account where   
          org__c = :orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  and 
          (RecordTypeId  in :allAccounts )  ];
          if(countTop==0   && OrphanSelect==false )
          top_accts= new List<Org__C>();
          */

        }
        if(top_accts.size()==0  &&   orgRec.Parent_Org__r.Parent_Org__C!=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];

        /*  Integer  countTop=[select count ()  from account where  
                    org__c = :orgRec.Parent_Org__r.Parent_Org__C  and 
          (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();*/

        }
        if(top_accts.size()==0  &&  orgRec.Parent_Org__C!=null){
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];


         /* Integer  countTop=[select count ()  from account where  
          org__c =:orgRec.Parent_Org__C  and 
           (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();*/

        }
        if(top_accts.size()==0){
        top_accts= [ Select Id, Business_name__C from Org__C where Id=:OrgId];

         /* Integer  countTop=[select count ()  from account where  
          org__c = :OrgId  and 
           (RecordTypeId  in :allAccounts )  ];
          if(countTop==0  && OrphanSelect==false)
          top_accts= new List<Org__C>();*/
        }

        
        System.debug('&&&&&&top_accts'+top_accts);
        
        Map<Id,itemsImage> nodes = new Map<Id,itemsImage>();
        Set<Id> parent_acc_ids = new Set<Id>();
        

         List<Id> orgIdList = new List<Id>();
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                orgIdList.add(a.Id);
            }
        }
        
        
        List<Account> CustomerList1 = new List<Account>();
        map<Id,List<Account>> orgAccMap = new Map<Id,List<Account>>();
               
        
        List<Account> SiteChildList1 = [select 
        id,related_account__C,org__c,related_account__r.org__C,related_account__r.recordtypeId from account where 
        org__c in : orgIdList
        and RecordTypeId=:SiteRecordtypeId and related_account__C !=null
        
        and related_account__r.recordtypeId in :CustomerRecordtypeId  
     ////////////   and related_account__r.aops_cust_id__C !=null
        ];
                                                   
                                        
            Map<Id,Id > CustOrgMap1 =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers1=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList1 '+SiteChildList1 );                    

                
               Set<Id> siteSet1 = new Set<Id>();
               for( Account rec:SiteChildList1 ){
                 /*if(! siteSet1.contains(rec.related_account__C)){
                 siteSet1.add(rec.related_account__C);
                 CustOrgMap1.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers1.put(rec.related_account__C, rec.org__c);
                 }*/
                 
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c ){
                 if(! siteSet1.contains(rec.related_account__C))
                 siteSet1.add(rec.related_account__C);
                 CustOrgMap1.put(rec.related_account__C, rec.org__c);
                 OrphanCustomers1.put(rec.related_account__C, rec.org__c);
                 }
                 
                 
                 
                 
                 
              }
          System.debug('&&&&&&&& siteSet1'+siteSet1);                                    

        
        
        CustomerList1 =[select Id, name ,aops_cust_id__C,org__c,RecordType_Name__c,Rolling_12_month_sales__c from account where 
        (Id in :siteSet1  and RecordTypeId=:Customer)
        
         or
         ( org__c in :orgIdList 
         and RecordTypeId=:CustomerRecordtypeId  ) ];
                                            
        System.debug('&&&&&&&& CustomerList1 '+CustomerList1 );                                    
                            
                                            
        for(Account acc :CustomerList1){
           Id currentOrg;
           if(CustOrgMap1.get(acc.Id)  !=null)
           currentOrg=CustOrgMap1.get(acc.Id);
           else
           currentOrg=acc.Org__C;
           
           
            if(orgAccMap.containsKey(currentOrg)){
                List<account> accUpdatedList = orgAccMap.get(currentOrg);
                accUpdatedList.add(acc);
                 orgAccMap.put(currentOrg,accUpdatedList);                
            }else{
                List<Account> accList = new List<Account>();
                accList.add(acc);
                orgAccMap.put(currentOrg,accList);
            }
        }
        
        System.debug('&&&&&orgAccMap'+orgAccMap);
       
        if(top_accts.size()>0){
            for (Org__c a : top_accts) {
                 List<Account> CustomerList = new List<Account>();
                if(orgAccMap.containsKey(a.Id)){
                    CustomerList = orgAccMap.get(a.Id);
                }                          
                
                List<itemsImage> TopCustomers= new List<itemsImage> ();
                
                
                for(integer i=0;i<CustomerList.size();i++){
                    itemsImage top_node_cust = new itemsImage();
                    
                    Id currentOrgId= CustomerList[i].org__C;

                    if(CustomerList[i].name != null){
                        if(currentOrgId==null  || currentOrgId != a.Id   ){
                        top_node_cust.label=CustomerList[i].name;
                        top_node_cust.type='-Site';
                        }
                        else{
                        top_node_cust.label= CustomerList[i].name; 
                        
                         String currentRecordtypeName=CustomerList[i].RecordType_Name__c;
                         System.debug('&&&&&&&&here'+currentRecordtypeName);
                         if(currentRecordtypeName.contains('Prospect')  ||  currentRecordtypeName.contains('Account Setup Requested') )  
                         top_node_cust.type='-Prospect';
                         if(currentRecordtypeName.contains('Customer'))
                         top_node_cust.type='-Customer';

                        
                        }

                    }
                    top_node_cust.expanded= true;
                    if(currentOrgId==null   || currentOrgId != a.Id   )
                    currentOrgId=OrphanCustomers1.get(CustomerList[i].Id);
                    
                    top_node_cust .name= CustomerList[i].Id +'-'+currentOrgId; 
                    top_node_cust .itemsImage= null;
                    TopCustomers.add(top_node_cust );
                }
                itemsImage top_node = new itemsImage();
                if(a.Business_Name__c != null){
                    top_node.label= a.Business_Name__c ; 
                }
                
                top_node.expanded= true;
                top_node.type= '-Global';

                top_node.name= a.Id ; 
                if(top_node.itemsImage==null)
                top_node.itemsImage=new List<itemsImage >();
                
                top_node.itemsImage.addall(TopCustomers);
                if(OrphanSelect ==true )
                nodes.put(a.Id, top_node);
                else{
                ///////////////////if(TopCustomers.size()>0)
                nodes.put(a.Id, top_node);                
                }
                
                parent_acc_ids.add(a.Id);
            }
            System.debug('&&&&top'+nodes);
            
            
            
                if(!parent_acc_ids.isEmpty()){
                Map<Id,Org__C> subordinate_accounts = new Map<Id,Org__C>([SELECT Id, Parent_Org__c, Business_Name__c
                FROM Org__c WHERE Parent_Org__c IN :parent_acc_ids order by Business_Name__c asc ]);                
                parent_acc_ids = subordinate_accounts.keySet();
                
                
                
                List<Account> SiteChildList = [select 
                id,related_account__C,org__c,related_account__r.org__C ,related_account__r.recordtypeId from account where 
                org__c in : parent_acc_ids
                and RecordTypeId=:SiteRecordtypeId and related_account__C !=null
                        and related_account__r.recordtypeId in :CustomerRecordtypeId  

                ];
                                                           
                                        
            Map<Id,Id > CustOrgMap =  new Map<Id,Id >();  
            Map<Id,Id > OrphanCustomers=  new Map<Id,Id >();  

                                                   
            System.debug('&&&&&&&& SiteChildList '+SiteChildList );                    

                
               Set<Id> siteSet = new Set<Id>();
               for( Account rec:SiteChildList ){
               
               
                 /*if(! siteSet.contains(rec.related_account__C)){
                 siteSet.add(rec.related_account__C);
                 CustOrgMap.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers.put(rec.related_account__C, rec.org__c);*/
                 
                 
                 
             if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c ){
                                 if(! siteSet.contains(rec.related_account__C))
                 siteSet.add(rec.related_account__C);
                 CustOrgMap.put(rec.related_account__C, rec.org__c);
                 if(rec.related_account__r.org__c==null  || rec.related_account__r.org__c!= rec.org__c )
                 OrphanCustomers.put(rec.related_account__C, rec.org__c);

                 
                 
                 }
              }
          System.debug('&&&&&&&& siteSet'+siteSet);                                    

                                
                List<Account> CustomerListNode1=[select Id, name ,aops_cust_id__C,org__C,RecordType_Name__c 
                from account where 
                (Id in :siteSet and RecordTypeId=:Customer)
                 or 
                (org__c in : parent_acc_ids 
                and RecordTypeId=:CustomerRecordtypeId )];
                
                
                map<Id,List<Account>> orgAccMap1 = new Map<Id,List<Account>>();
                
                
                    
                    for(Account acc :CustomerListNode1){
                    
                      Id currentOrg;
                               if(CustOrgMap.get(acc.Id)  !=null)
                               currentOrg=CustOrgMap.get(acc.Id);
                               else
                               currentOrg=acc.Org__C;                                                          
                    
                        if(orgAccMap1.containsKey(currentOrg)){
                            List<account> accUpdatedList = orgAccMap1.get(currentOrg);
                            accUpdatedList.add(acc);
                            orgAccMap1.put(currentOrg,accUpdatedList);                
                        }else{
                            List<Account> accList = new List<Account>();
                            accList.add(acc);
                            orgAccMap1.put(currentOrg,accList);
                        }
                    }    
                    
                System.debug('&&&&&orgAccMap1'+orgAccMap1);
            
                for (Org__c acc : subordinate_accounts.values()) {
                    
                    List<Account> CustomerListNode = new List<Account>();
                    if(orgAccMap1.containsKey(acc.id)){
                        CustomerListNode = orgAccMap1.get(acc.id);
                    }
                   
                    List<itemsImage> NodeCustomersLIst= new List<itemsImage> ();
                    for(integer i=0;i<CustomerListNode.size();i++){
                        itemsImage NodeCustomers= new itemsImage();
                        
                        
                     Id currentOrgId= CustomerListNode[i].org__C;

                      if(CustomerListNode[i].name != null){
                        if(currentOrgId==null  || currentOrgId != acc.Id   ){
                        NodeCustomers.label=CustomerListNode[i].name;
                        NodeCustomers.type='-Site';
                        }
                        else
                        {
                        NodeCustomers.label= CustomerListNode[i].name; 
                         String currentRecordtypeName=CustomerListNode[i].RecordType_Name__c;
                         if(currentRecordtypeName.contains('Prospect')  ||  currentRecordtypeName.contains('Account Setup Requested'))
                         NodeCustomers.type='-Prospect';
                         if(currentRecordtypeName.contains('Customer'))
                         NodeCustomers.type='-Customer';
                        }
                       }
                                                
                                                                        
                    NodeCustomers.expanded= true;
                    if(currentOrgId==null   || currentOrgId != acc.Id   )
                    currentOrgId=OrphanCustomers.get(CustomerListNode[i].Id);
                    
                    NodeCustomers.name= CustomerListNode[i].Id +'-'+currentOrgId; 
                        NodeCustomers.itemsImage= null;
                        NodeCustomersLIst.add(NodeCustomers);
                    }
                    
                    
                    itemsImage new_node = new itemsImage();
                    if(acc.Business_Name__c != null){
                        new_node.Label= acc.Business_Name__c; 
                    }
                    
                    new_node.name= acc.Id ; 
                    new_node.expanded= true;
                    new_node.type= '-Org';

                    
                    if(new_node.itemsImage==null)
                        new_node.itemsImage=new List<itemsImage >();
                    
                    new_node.itemsImage.addall(NodeCustomersLIst);
                    
                    System.debug('&&&&&&&&new_node'+new_node);
                    if(OrphanSelect ==true )
                    nodes.put(acc.id, new_node);
                    else{
                          //////////////////if(NodeCustomersLIst.size()>0 )
                          nodes.put(acc.id, new_node);                       
                    }
                    System.debug('&&&&&&&&acc.Parent_Org__C'+acc.Parent_Org__C);
                    
                    itemsImage ref_node = nodes.get(acc.Parent_Org__C);
                    if(ref_node.itemsImage==null)
                        ref_node.itemsImage=new List<itemsImage >();
                        
                   if(OrphanSelect ==true )     
                    ref_node.itemsImage.add(new_node);
                    else{
                          if(NodeCustomersLIst.size()>0 )
                          ref_node.itemsImage.add(new_node);

                    
                    }
                    System.debug('&&&&&&&&ref_node '+ref_node );
                    
                }
            }
            
            System.debug('&&&&&&nodes'+nodes);
            System.debug('&&&&&&nodes'+nodes.keySet());
            
            
               if(top_accts.size()>0)
                wrapperList.add(nodes.get(top_accts[0].Id)); 
        }   
        
        
        system.debug('WrapperList :: OD results...' + wrapperList);
        return wrapperList;
    }
    
    /*
        @AuraEnabled
    public static AccountRelatedDataExtn getDMLDatas(String OrgId) {
    
         Id ParentOrg;
         String OrgString1=OrgId;
         List<String> processList= new List<String>();
         if(OrgString1.contains('-')){
         processList=OrgString1.split('-');
         OrgId=processList[0];
         ParentOrg=processList[1];
         }
        
        String OrgString=OrgId;
        AccountRelatedDataExtn accOrOrgData;        
        List<Account>customerList   =new List<Account>();        
        Integer countCustomer=0;       
        Account recentCustomer = new Account();
        
        List<DML__c> DMLList= new List<DML__c>();
        Integer countDML=0;        
        DML_Relation__c recentDML= new DML_Relation__c();

        
       
        Set<Id> Customer=getAccId('CustomerOnly');
        Set<Id> Site=getAccId('Site');
        
        if(OrgString.substring(0,3)=='001'){
           
            //DMLList=[select DML_Details__c,DMLLink__c,Id,DECISIONMAKERID__c,DML_Segment__c,Decision_Maker_Name__c,DML_ZIP__c,CUSTOMERID__c,Decision_Maker_Level_1_Manager_ID__c,Decision_Maker_Level_2_Manager_ID__c,Decision_Maker_Level_3_Manager_ID__c,DML_RepID__c,DML__r.DML_City__c, DML__r.DML_State__c,DML__r.Decision_Maker_Rep__r.User_Name__c
           //from DML_Relation__c where account__C=:OrgId and org__c=:ParentOrg];
        }
        else{
           Id  accid = [Select Id  from Account where org__C=:Orgstring].Id;
            DMLList=[select id
            from DML__C where Org__C=:OrgId];
            
          }            
                  if(DMLList.size()>0){
                  Set<String> DMLSetId= new Set<String>();
                  for( integer i=0;i<DMLList.size();i++){
                      if( !DMLSetId.contains(  DMLList[i].DECISIONMAKERID__c))
                      DMLSetId.add(  DMLList[i].DECISIONMAKERID__c);
                  }
            //countDML=DMLList.size();
            countDML=DMLSetId.size();
            recentDML=DMLList[0];
            }          system.debug('countDML....'+countDML);

        accOrOrgData = new  AccountRelatedDataExtn(customerList,countCustomer, recentCustomer,DMLList,countDML,recentDML);

       return accOrOrgData;
    }
*/



}