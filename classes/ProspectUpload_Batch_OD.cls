/* Expected to handel one record at a time, due to the duplication issues with SOA

*/
global class ProspectUpload_Batch_OD implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery;
   
    private String DEFAULT_QUERY = 'Select Id, SalesRepID__C, Company_Name__c, Website__c, WCW_Count__c, Sector__c, Buying_Group__C, Segment__C, Error__c,'+
    'Address_Line_1__c, Address_Line_2__c, City__c, State__c, Zip__c, Country__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Title__c,'+
    'Contact_Phone__c,Contact_Email__c, Pricing_template_cd__c, Industry_OD_SIC_Rep__c, Primary_Product__c, Primary_Competitor__c, Anticipated_Close_Date__c,'+
    'Customer_Lifecycle__c, Status__c,ProspectID__c from Data_Staging_Table__c where Status__c = \'OD Not Started\' ';
    
    global ProspectUpload_Batch_OD(){
    System.debug('This is called1');
       
    }
    global ProspectUpload_Batch_OD(String query){
    System.debug('This is called2');
       
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){       
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<Data_Staging_Table__c> scope){
        if(scope.size()>1){
            system.debug('*******Please change the batch size to 1 to avoid the downstream SOA issues (as per the design)**************** ');
        }else{
            System.Savepoint dbsp = Database.setSavepoint();
            try{
                Map<String,Schema.RecordTypeInfo> Accountrectype = Schema.SObjectType.Account.getRecordTypeInfosByName();
                Set<String> salesPersonID =new Set<String>();
                Map<String, Sales_Person__c> SalesPersonMap = new Map<String, Sales_Person__c>();
                list<Account> ProspectTobeCreated = new list<Account>();
                list<Account> SiteTobeCreated = new list<Account>();
                list<Contact> ContactTobeCreated = new list<Contact>();
                Map<String,Account> CreatedProspects = new Map<String,Account>();
                
                for(Data_Staging_Table__c ds :  scope){
                    if(ds.SalesRepID__C != null){
                        salesPersonID.add(ds.SalesRepID__C);
                    }
                }
                // get the MAP of the SalesPersons
                for(Sales_Person__c sp:[Select id,name,User__c from Sales_Person__c where name in:salesPersonID and IsActive__c = true and Primary__c = true]){
                    SalesPersonMap.put(sp.name, sp);
                }
                
                
                // Create a New Account as Prospect
                for(Data_Staging_Table__c ds :scope){
                    if((SalesPersonMap.get(ds.SalesRepID__C) != null) && (ds.Company_Name__c != null)){
                        Account ODProspect = new Account();
                        ODProspect.Name = ds.Company_Name__c;
                        ODProspect.Org_WCW_Count_Rep__c = ds.WCW_Count__c;
                        ODProspect.Website = ds.Website__c;
                        ODProspect.Sector__c = ds.Sector__c;
                        ODProspect.Segment__c = ds.Segment__C;
                        ODProspect.Buying_Group__c = ds.Buying_Group__C;
                        ODProspect.Pricing_template_cd__c = ds.Pricing_template_cd__c;
                        ODProspect.Industry_OD_SIC_Rep__c = ds.Industry_OD_SIC_Rep__c;
                        ODProspect.Primary_Product__c = ds.Primary_Product__c;
                        ODProspect.Address1__c = ds.Address_Line_1__c;
                        ODProspect.Address2__c = ds.Address_Line_2__c;
                        ODProspect.City__c = ds.City__c;
                        ODProspect.State__c = ds.State__c;
                        ODProspect.Zip__c = ds.Zip__c;
                        ODProspect.Country__c = ds.Country__c;
                        ODProspect.OwnerId = SalesPersonMap.get(ds.SalesRepID__C).User__c;
                        ODProspect.Sales_PersonID__c = SalesPersonMap.get(ds.SalesRepID__C).id;
                        ODProspect.RecordTypeId = Accountrectype.get('Prospect').getRecordTypeId();
                        ProspectTobeCreated.add(ODProspect);
                    }
                    else{
                        ds.Status__c = 'Failed';
                        if(SalesPersonMap.get(ds.SalesRepID__C) == null)
                            ds.Error__c = 'Could not find SalesPerson ID ';
                        if(ds.Company_Name__c == null)
                            ds.Error__c = 'Company Name Is Null';
                        
                    }
                }
                
                //create Prospects
                if(ProspectTobeCreated.size() >0)
                insert ProspectTobeCreated;
                                 
                for(Account a: ProspectTobeCreated){                  
                    if(a.id != null){
                        CreatedProspects.put(a.Name+a.Address1__c, a);
                    }
                }
                
                for(Data_Staging_Table__c dse :scope){
                    if(CreatedProspects.get(dse.Company_Name__c+dse.Address_Line_1__c)!= null){
                        dse.ProspectID__c = CreatedProspects.get(dse.Company_Name__c+dse.Address_Line_1__c).id;
                        dse.Status__c ='Prospect Created';
                    }else{
                        dse.Error__c =  'Error creating prospect';
                        dse.Status__c = 'Failed';
                    }
                }
                
                
                
                //Create Site and Contact
                for(Data_Staging_Table__c dst :scope){
                    //Below Conditions filters out scope for only created prospects
                    if((SalesPersonMap.get(dst.SalesRepID__C) != null) && (dst.Company_Name__c != null) && (CreatedProspects.get(dst.Company_Name__c+dst.Address_Line_1__c)!= null)){
                        Account ODSite = new Account();
                        ODSite.Name = dst.Company_Name__c;
                        ODSite.Org_WCW_Count_Rep__c = dst.WCW_Count__c;
                        ODSite.Website = dst.Website__c;
                        ODSite.Sector__c = dst.Sector__c;
                        ODSite.Segment__c = dst.Segment__C;
                        ODSite.Buying_Group__c = dst.Buying_Group__C;
                        ODSite.Pricing_template_cd__c = dst.Pricing_template_cd__c;
                        ODSite.Industry_OD_SIC_Rep__c = dst.Industry_OD_SIC_Rep__c;
                        ODSite.Primary_Product__c = dst.Primary_Product__c;
                        ODSite.Address1__c = dst.Address_Line_1__c;
                        ODSite.Address2__c = dst.Address_Line_2__c;
                        ODSite.City__c = dst.City__c;
                        ODSite.State__c = dst.State__c;
                        ODSite.Zip__c = dst.Zip__c;
                        ODSite.Country__c = dst.Country__c;
                        ODSite.OwnerId = SalesPersonMap.get(dst.SalesRepID__C).User__c;
                        ODSite.Sales_PersonID__c = SalesPersonMap.get(dst.SalesRepID__C).id;
                        ODSite.RecordTypeId = Accountrectype.get('Site').getRecordTypeId();
                        ODSite.Related_Account__c = CreatedProspects.get(dst.Company_Name__c+dst.Address_Line_1__c).id;
                        ODSite.Primary_Site__c = true;
                        SiteTobeCreated.add(ODSite);
                        
                        //
                        
                        Contact ODContact = new Contact();
                        ODContact.OwnerId = SalesPersonMap.get(dst.SalesRepID__C).User__c;
                        ODContact.Primary_Contact__c = true;
                        ODContact.FirstName = dst.Contact_First_Name__c;
                        ODContact.LastName = dst.Contact_Last_Name__c;
                        ODContact.Title = dst.Contact_Title__c;
                        ODContact.Phone = dst.Contact_Phone__c;
                        ODContact.Email = dst.Contact_Email__c;
                        ODContact.AccountId = CreatedProspects.get(dst.Company_Name__c+dst.Address_Line_1__c).id;
                        ContactTobeCreated.add(ODContact);
                        
                    }
                    
                }
                
                //create Sites
                if(SiteTobeCreated.size() >0)
                    insert SiteTobeCreated;
                
                //create Contacts
                if(ContactTobeCreated.size() >0)
                    insert ContactTobeCreated;
            }catch(Exception e){
                   // Rollback everything done up until this point
                   Database.rollback(dbsp);
                   
                System.debug('exception has occurred: ' + e.getMessage());
                scope[0].Status__c = 'Failed';
                if(e.getMessage().length() > 240)
                    scope[0].error__c = e.getMessage().substring(1, 240);//e.getTypeName()+e.getCause();
                else
                    scope[0].error__c = e.getMessage();
                
            }

        update scope;
       }
     
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    global void execute(SchedulableContext sc){
        String strQuery = '';
        ProspectUpload_Batch_OD prospectUploadBatch = new ProspectUpload_Batch_OD(strQuery);
        database.executebatch(prospectUploadBatch, 1);
    }
    
}