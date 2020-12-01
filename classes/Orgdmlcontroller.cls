public class Orgdmlcontroller {
   
    public class AccountRelatedData {
        @  AuraEnabled
            public List < Contact > contactList {  get;  set;  }
        @  AuraEnabled
            public List < Opportunity > oppList {  get; set; }
        @  AuraEnabled
            public List < Case > caseList {  get;   set; }
        @ AuraEnabled
            public List < Task > taskList {  get;  set; }
        @  AuraEnabled
            public List < Sales_Data__C > salesList { get;set;}
        @ AuraEnabled
            public List < Sales_Person__c > salesRepList {  get; set;}
        @ AuraEnabled
            public List < Account > sitesList {  get;  set;}
        @  AuraEnabled
            public List < Contract > contractList { get;  set; }
        @  AuraEnabled
            public List < Note > noteList { get; set; }
        @  AuraEnabled
            public List < Pricing_Template__c > pricingList { get; set;}
        @  AuraEnabled
            public Integer countContact { get; set;}
        @  AuraEnabled
            public Integer countOpportunity { get; set;}
        @  AuraEnabled
            public Integer countCase { get;  set;}
        @  AuraEnabled
            public Integer countTask { get; set; }
        @  AuraEnabled
            public Integer countSales { get; set;}
        @  AuraEnabled
            public Integer countRep { get;  set; }
        @  AuraEnabled
            public Integer countSites { get; set;}
        @ AuraEnabled
            public Integer countContract { get; set; }
        @ AuraEnabled
            public Integer countNote { get; set;}
        @  AuraEnabled
            public Integer countPricing { get; set;}
        Id accid;
        @  AuraEnabled
            public Contact recentContact { get;set;}
        @  AuraEnabled
            public Opportunity recentOpportunity {get; set;}
        @   AuraEnabled
            public Case recentCase { get; set;}
        @  AuraEnabled
            public Task recentTask { get; set; }
        @   AuraEnabled
            public Sales_Data__C recentSales {get; set;}
        @ AuraEnabled
            public Sales_Person__c recentRep {get;set; }
        @ AuraEnabled
            public Account recentSite {  get;  set;  }
        @    AuraEnabled
            public Contract recentContract { get; set;  }
        @    AuraEnabled
            public Note recentNote { get;set; }
        @    AuraEnabled
            public Pricing_Template__c recentPricing {get; set; }
        public AccountRelatedData(List < Contact > contactList, List < Opportunity > oppList,
                                  List < Case > CaseList,
                                  List < Task > taskList, List < Sales_Data__C > salesList,
                                  List < Sales_Person__c > salesRepList, List < Account > sitesList, List < Contract >
                                  contractList,
                                  List < Note > noteList, List < Pricing_Template__c > pricingList,
                                  Integer countContact, Integer countOpportunity,
                                  Integer countCase, Integer countTask, Integer countSales,
                                  Integer countRep, Integer countsites, Integer countContract,
                                  Integer countNote, Integer countPricing,
                                  Contact recentContact, Opportunity recentOpportunity,
                                  Case recentCase, Task recentTask, Sales_Data__C recentSales,
                                  Sales_Person__c recentRep, Account recentSite, Contract recentContract, Note recentNote,
                                  Pricing_Template__c recentPricing
                                 ) {
                                     this.contactList = contactList;
                                     this.oppList = oppList;
                                     this.caseList = caseList;
                                     this.taskList = taskList;
                                     this.salesList = salesList;
                                     this.salesRepList = salesRepList;
                                     this.sitesList = sitesList;
                                     this.contractList = contractList;
                                     this.noteList = noteList;
                                     this.pricingList = pricingList;
                                     this.countContact = countContact;
                                     this.countOpportunity = countOpportunity;
                                     this.countCase = countCase;
                                     this.countTask = countTask;
                                     this.countSales = countSales;
                                     this.countRep = countRep;
                                     this.countsites = countsites;
                                     this.countContract = countContract;
                                     this.countNote = countNote;
                                     this.countPricing = countPricing;
                                     this.recentContact = recentContact;
                                     this.recentOpportunity = recentOpportunity;
                                     this.recentCase = recentCase;
                                     this.recentTask = recentTask;
                                     this.recentSales = recentSales;
                                     this.recentRep = recentRep;
                                     this.recentSite = recentSite;
                                     this.recentContract = recentContract;
                                     this.recentPricing = recentPricing;
                                     this.recentNote = recentNote;
                                 }
    }
    public class AccountRelatedDataExt {
        @  AuraEnabled
            public List < Account > customerList { get; set; }
        @   AuraEnabled
            public Integer countCustomer { get;  set;}
        @  AuraEnabled
            public Account recentCustomer { get;set;}
        @  AuraEnabled
            public List < DML_Relation__c > DMLList {  get;  set; }
        @  AuraEnabled
            public Integer countDML {  get;  set;}
        @ AuraEnabled
            public DML_Relation__c recentDML { get; set; }
        public AccountRelatedDataExt(List < Account > customerList, Integer countCustomer,
                                     Account recentCustomer,
                                     List < DML_Relation__c > DMLList, Integer countDML, DML_Relation__c recentDML ) {
                                         this.customerList = customerList;
                                         this.countCustomer = countCustomer;
                                         this.recentCustomer = recentCustomer;
                                         this.DMLList = DMLList;
                                         this.countDML = countDML;
                                         this.recentDML = recentDML;
                                     }
    }
    public class AccountRelatedDataExtn {
        @  AuraEnabled
            public List < Account > customerList {  get;  set;}
        @   AuraEnabled
            public Integer countCustomer { get;  set; }
        @  AuraEnabled
            public Account recentCustomer {   get; set;}
        @ AuraEnabled
            public List < DML__c > DMLList { get; set;}
        @  AuraEnabled
            public Integer countDML { get; set;}
        @  AuraEnabled
            public DML__c recentDML { get; set;}
        public AccountRelatedDataExtn(List < Account > customerList, Integer countCustomer,
                                      Account recentCustomer,
                                      List < DML__c > DMLList, Integer countDML, DML__c recentDML
                                     ) {
                                         this.customerList = customerList;
                                         this.countCustomer = countCustomer;
                                         this.recentCustomer = recentCustomer;
                                         this.DMLList = DMLList;
                                         this.countDML = countDML;
                                         this.recentDML = recentDML;
                                     }
    }
    // get Id's of Customer and Site Recordtypes
    Public static Set < Id > getAccId(String type) {
        String sObjectName = 'Account';
        set < Id > recordTypeIds = new set < Id > ();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        if (sobjectResult != null) {
            List < Schema.RecordTypeInfo > recordTypeInfo = sobjectResult.getRecordTypeInfos();
            if (recordTypeInfo != null) {
                for (Schema.RecordTypeInfo info: recordTypeInfo) {
                    if (type == 'Customer') {
                        if (info.getName().contains('Customer') || info.getName().contains('Prospect')) {
                            ////|| info.getName().contains('Prospect') 
                            recordTypeIds.add(info.getRecordTypeId());
                        }
                    }
                    if (type == 'CustomerOnly') {
                        if (info.getName().contains('Customer')) {
                            ////|| info.getName().contains('Prospect') 
                            recordTypeIds.add(info.getRecordTypeId());
                        }
                    }
                    if (type == 'Site') {
                        if (info.getName().contains('Site')) {
                            recordTypeIds.add(info.getRecordTypeId());
                        }
                    }
                }
            }
        }
        system.debug('recordtypes' + recordTypeIds);
        return recordTypeIds;
    }
    
    @
    AuraEnabled
        public static AccountRelatedData getPricingData(String InputData ) {
           
            System.debug('InputData'+InputData);
           // String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
          List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
                try {
                    List < Account > currentRec = [select ownerId, Pricing_template_cd__c from Account where Id = : lstAlpha ];
                    List < String > priclist = new List < String > ();
                    if (currentRec.size() > 0) {
                        for (Account ac: currentRec) {
                            priclist.add(ac.Pricing_template_cd__c);
                        }
                        // String pricingtemplate= currentRec.Pricing_template_cd__c;
                        if (priclist.size() > 0)
                            pricingList = [select Id, name, Count_of_accounts__c from Pricing_Template__c where name = : priclist];
                    }
                } catch (Exception e) {}
            
            if (pricingList.size() > 0) {
                countPricing = pricingList.size();
                recentPricing = pricingList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList,
                                                  contractList, noteList, pricingList,
                                                  countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                  recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    @
    AuraEnabled
        public static AccountRelatedData getNoteData(String InputData) {
         System.debug('InputData'+InputData);
           // String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
          List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                noteList = [select Id, ParentId, Title, CreatedBy.Name, LastModifiedBy.Name, Parent.Name from Note where ParentId = : lstAlpha order by createddate desc Limit 100 ];
           
            System.debug('&&&&&&noteList' + noteList);
            if (noteList.size() > 0) {
                countNote = noteList.size();
                system.debug('noteList[0].....' + noteList[0]);
                recentNote = noteList[0];
            }
            System.debug('&&&&&&recentNote' + recentNote.Title);
            accOrOrgData = new AccountRelatedData
                (ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                 countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                 recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    @
    AuraEnabled
        public static AccountRelatedData getContractData(String InputData) {
            
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            //String OrgString = OrgId;
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            // Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                contractList = [select Id, Name, Customer_Number__C, Customer_Name__c, Account_Recordtype__c, ContractNumber, Contract_Type__C, Contract_Status__C, Contract_Lifecycle_Manager__C, Date_Current_Legal_Contract_Expires__c from Contract where AccountId = : lstAlpha order by createddate desc];
            
            if (contractList.size() > 0) {
                countContract = contractList.size();
                recentContract = contractList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList,
                                                  sitesList, contractList, noteList, pricingList, countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                  recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
    @
    AuraEnabled
        public static AccountRelatedData getSalesData(String InputData) {
            
             List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            //String OrgString = OrgId;
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
           
         
                salesDataLIst = [select Id, CopiersText__C, name, Rolling_12_month_sales__c, YTD_Sales_TY__c,
                                 Rolling_12_month_Sales_text__c, YTD_Sales_TY_text__c from Sales_Data__C where Account__c = : lstAlpha and account_type__C = 'Customer'   order  by createddate desc];
            
            if (salesDataLIst.size() > 0) {
                countSales = salesDataLIst.size();
                recentSales = salesDataLIst[0];
            }
            accOrOrgData = new AccountRelatedData
                (ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                 countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                 recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    @
    AuraEnabled
        public static AccountRelatedData getSiteData(String InputData) {
           System.debug('InputData'+InputData);
           // String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
          // List<String> Accountid=  (List<String>)System.JSON.deserialize(InputData, List<String>.class);
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
           
       
                // Id currentOrg=[select Org__C from Account where Id=:OrgId].org__C;
                if (InputData != null)
                    sitesList = [select LastModifiedDate, Owner.alias, Id, AOPS_Seq_ID__c, Name, Cust_ID__c, Primary_Site__c, Status__c, Address__c, YTD_Sales_TY__c, YTD_Sales_Diff__c, Weeks_Since_Last_Order__c from account where
                                 recordtypeId = : Site and Related_Account__c = : lstAlpha ];
                system.debug('sitelist1' + sitesList);
          
            if (sitesList.size() > 0) {
                countSites = sitesList.size();
                recentSite = sitesList[0];
            }
            accOrOrgData = new AccountRelatedData (ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                                                   countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                   recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
   @
    AuraEnabled
       public static AccountRelatedDataExt getDMLData(String InputData) {
            List < String > processList = new List < String > ();
           
         InputData = InputData.substring(2,InputData.length()-2);
System.debug('InputDataInputData'+InputData);
          // String InputDatas = InputData.escapeCsv();
			
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            //String OrgString = OrgId;
        
            AccountRelatedDataExt accOrOrgData;
            List < Account > customerList = new List < Account > ();
            Integer countCustomer = 0;
            Account recentCustomer = new Account();
            List < DML_Relation__c > DMLList1 = new List < DML_Relation__c > ();
            Integer countDML = 0;
            DML_Relation__c recentDML = new DML_Relation__c();
             List < DML_Relation__C > DMLList = new List < DML_Relation__C > ();
            Set < Id > Customer = getAccId('CustomerOnly');
            Set < Id > Site = getAccId('Site');
                if (lstAlpha.size() > 0) {
                    customerList = [select Id, name, AOPS_Cust_Id__c from account where Id in : lstAlpha];
                    system.debug('customerlist' + customerlist);
                }
            
            accOrOrgData = new AccountRelatedDataExt(customerList, countCustomer, recentCustomer, DMLList, countDML, recentDML);
            return accOrOrgData;
        }
    @
    AuraEnabled
        public static AccountRelatedDataExt getCustomerData(String InputData) {
   
            List <String> processList = new List <String> ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            //String OrgString = OrgId;
            AccountRelatedDataExt accOrOrgData;
            List < Account > customerList = new List < Account > ();
            Integer countCustomer = 0;
            Account recentCustomer = new Account();
            List < DML_Relation__c > DMLList = new List < DML_Relation__c > ();
            Integer countDML = 0;
            DML_Relation__c recentDML = new DML_Relation__c();
            // Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('CustomerOnly');
            Set < Id > Site = getAccId('Site');
           
                customerList = [select Id, name, AOPS_Cust_Id__c, Grandparent_Name__c, Grandparent_ID__c, Parent_Name__c, Parent_ID__c,
                                Address1__c, City__c, State__c, Account_Owner__c,Account_Owner_Name__c from account where Id = : lstAlpha and recordtypeId = : Customer ];
            
            if (customerList.size() > 0) {
                countCustomer = customerList.size();
                recentcustomer = customerList[0];
            }
            system.debug('countcustomer....' + countCustomer);
            accOrOrgData = new AccountRelatedDataExt(customerList, countCustomer, recentCustomer, DMLList, countDML, recentDML);
            return accOrOrgData;
        }
    
    @
    AuraEnabled
        public static AccountRelatedData getRepData(String InputData) {
             List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            //String OrgString = OrgId;
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                    List < Account > currentownerid = [select ownerId from Account where Id = : lstAlpha];
                    Set < Id > collectid = new Set < Id > ();
                    //  Id currentownerId=[select ownerId from Account where Id=:OrgId and org__C=:ParentOrg].ownerId;
                    for (Account ac: currentownerid) {
                        collectid.add(ac.ownerId);
                    }
                    Set < Id > repId = new Set < Id > ();
                    List < Sales_Person__c > salesRepListTemp = new List < Sales_Person__c > ();
                    salesRepListTemp = [select User_Name__C, ODP_Employee_Id__c, user__r.SmallPhotoUrl, SmallPhotoURL__c, User_Short_Title__C,
                                        User_Phone__c, User_Region__C, User_Manager__C, User_Market__c, ExtIDSalesPerson__c from Sales_Person__c  where user__C = : collectid and IsActive__c = true and Primary__c = true ];
                    for (Sales_Person__c rec: salesRepListTemp) {
                        if (!repId.contains(rec.user__C)) {
                            repId.add(rec.user__C);
                            salesRepList.add(rec);
                        }
                    }
                    System.debug('&&&&&salesRepList ' + salesRepList);
                
            if (salesRepList.size() > 0) {
                countRep = salesRepList.size();
                recentRep = salesRepList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                                                    countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                    recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
    @
    AuraEnabled
        public static AccountRelatedData getCaseData(String InputData) {
            Id ParentOrg;
            System.debug('InputData'+InputData);
           // String OrgString1 = OrgId;
            InputData = InputData.substring(2,InputData.length()-2);
            List < String > processList = new List < String > ();
          List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                caseList = [select id, CaseNumber, IT_Created_By__c, CreatedDate, subject, RecordtypeName__c, Status, Owner.name, LastModifiedDate from  case where AccountId = : lstAlpha order by createddate desc ];
           system.debug('caselist'+caseList);
            if (caseList.size() > 0) {
                countCase = caseList.size();
                recentCase = caseList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                                                  countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                  recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
    @
    AuraEnabled
        public static AccountRelatedData getTaskData(String InputData) {
            Id ParentOrg;
            //String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData task'+lstAlpha);
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
            taskList = [select id, Subject, Status, Call_Disposition__c, Disposition_Code__c, ActivityDate, Who.Name, Owner.Name from task where AccountId = : lstAlpha order by createddate desc];
           system.debug('taskList'+taskList);
            if (taskList.size() > 0) {
                countTask = taskList.size();
                recentTask = taskList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                                                  countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                  recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
    @
    AuraEnabled
        public static AccountRelatedData getOpportunityData(String InputData) {
            Id ParentOrg;
            //String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
            List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
           // String OrgString = OrgId;
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                oppList = [select id, Name, LBI__LatticeAccountName__c, LastModifiedDate, StageName, Product__c, Opportunity_Amount__c, IMU__c, CloseDate, NextStep, Owner.name from Opportunity where AccountId = : lstAlpha
                           order by createddate desc ];
           
            if (oppList.size() > 0) {
                countOpportunity = oppList.size();
                recentOpportunity = oppList[0];
            }
            accOrOrgData = new AccountRelatedData(ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                                                  countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                                                  recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
    
    
    @
    AuraEnabled
        public static AccountRelatedData getContactData(String InputData) {
            Id ParentOrg;
           // String OrgString1 = OrgId;
            List < String > processList = new List < String > ();
             InputData = InputData.substring(2,InputData.length()-2);
			List<String> lstAlpha = InputData.split(',');
            System.debug('InputData'+lstAlpha);
           // String OrgString = OrgId;
            AccountRelatedData accOrOrgData;
            List < Contact > ctList = new List < Contact > ();
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Sales_Data__C > salesDataList = new List < Sales_Data__C > ();
            List < Case > caseList = new List < Case > ();
            List < task > taskList = new List < Task > ();
            List < Sales_Person__c > salesRepList = new List < Sales_Person__c > ();
            List < Account > sitesList = new List < Account > ();
            List < Contract > contractList = new List < Contract > ();
            List < Note > noteList = new List < Note > ();
            List < Pricing_Template__c > pricingList = new List < Pricing_Template__c > ();
            Integer countContact = 0;
            Integer countOpportunity = 0;
            Integer countCase = 0;
            Integer countTask = 0;
            Integer countSales = 0;
            Integer countRep = 0;
            Integer countSites = 0;
            Integer countContract = 0;
            Integer countNote = 0;
            Integer countPricing = 0;
            Contact recentContact = new Contact();
            Opportunity recentOpportunity = new Opportunity();
            Sales_Data__C recentSales = new Sales_Data__C();
            Case recentCase = new Case();
            Task recentTask = new Task();
            Sales_Person__c recentRep = new Sales_Person__c();
            Account recentSite = new Account();
            Contract recentContract = new Contract();
            Note recentNote = new Note();
            Pricing_Template__c recentPricing = new Pricing_Template__c();
            //Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            //Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Set < Id > Customer = getAccId('Customer');
            Set < Id > Site = getAccId('Site');
            
                ctList = [select Id, name, email, Primary_Contact__c, Role__c, Title, Decision_Maker__c, Phone1_Rep__c, Phone_Type1__c from Contact where accountId = : lstAlpha order by createddate desc ];
            
            if (ctList.size() > 0) {                
                
                countContact = ctList.size();
                recentContact = ctList[0];
            }
            if (salesDataLIst.size() > 0) {
                countSales = salesDataLIst.size();
                recentSales = salesDataLIst[0];
            }
            accOrOrgData = new AccountRelatedData
                (ctList, oppList, caseList, taskList, salesDataLIst, salesRepList, sitesList, contractList, noteList, pricingList,
                 countContact, countOpportunity, countCase, countTask, countSales, countRep, countSites, countContract, countNote, countPricing,
                 recentContact, recentOpportunity, recentCase, recentTask, recentSales, recentRep, recentSite, recentContract, recentNote, recentPricing);
            return accOrOrgData;
        }
   
    @
    AuraEnabled
        public static List < Contact > getContactList(Id OrgId) {
            System.debug('&&&&&&&&' + OrgId);
            List < Contact > contactLIst = new List < Contact > ();
            String OrgString = OrgId;
            if (OrgString.substring(0, 3) == '001') {
                contactLIst = [select Id, name, email from Contact where AccountId = : OrgId];
            } else {
                contactLIst = [select Id, name, email from Contact where account.org__C = : OrgId ];
            }
            return contactLIst;
        }

}