/*************************************************************
*Name : GTAProspectSetupExtension
*Created By : Akash (Appirio Off)--Cloned from ProspectSetupExtension
*Purpose :Business is requesting one standard input page during initial prospect setup that would capture prospect (Account recordtype=prospect),
          primary contact, and primary site (Account recordtype=site) info. 
          The contact & site records are child to the prospect via the Contact's: Contact.Account & Site's: Account.Related_Account__c fields.
****************************************************************/
public class GTAProspectSetupExtension{
  
  public Account prospectAccount{get;set;}
  public Contact contact {get;set;}
  public Account siteAccount {get;set;}
  public List<Account>accountPhoneList{get;set;}
  public List<Account>accountZipList{get;set;}
  private Boolean skipCheckDuplicateAccount;
  public Boolean notvalidadd{get;set;}
  Public string SalesPerson{get;set;}
 Public List <Sales_Person__c> SalesPerson1{get;set;}
 
/* public PageReference getSalesPerson() {

        return Null;
    }*/
  
  
  // To retain the old version of field values
        private string oldAddress1value;
        private string oldAddress2value;
        private string oldCityvalue;
        private string oldstatevalue;
        private string oldcontryvalue;
        private string oldZipvalue;
        //--End
        
  //Lookup functionality
  public boolean pricingTempNotMatching;
  public boolean showiframe{get;set;}
  public boolean customerid{get;set;}
  public string searchString{get;set;}
  public string aopsidsearch{get;set;}
  private boolean shownMessage;
  private string recordCatergory;
  public List<Account> Paccount{get;set;}
  public list<Account> Results{get;set;}
  public boolean rerendererror{get;set;}
  public String pricingTemp;
  public list<Account> accs = new list<Account>();
  public id gpAcc;
  public string parentAOPSId;
  public Set<Id> Parentid= new Set<Id>();
  public Set<Id> GrandParentid= new Set<Id>();
  public Set<Id> actualqueryset= new Set<Id>();
  
  //=================================================================//
  //Constructor required to make it a list controller avaliable on List Views
  //===============================================================//
  public GTAProspectSetupExtension(ApexPages.StandardController controller) {
    prospectAccount = new Account();
    contact = new Contact();
    siteAccount = new Account();
    accountPhoneList = new List<Account>();
    accountZipList = new List<Account>();
    
    

     SalesPerson1 = [select id,name,ExtIDSalesPerson__c from Sales_Person__c where user__c =:UserInfo.getUserId()  And IsActive__c=True And Primary__c=True limit 1];
 // for(Sales_Person__c sperson: SalesPerson1)
 // SalesPerson=sperson.name;
  if(SalesPerson1.size()==0){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'User creating Account does not have a valid SalesPerson ID')); }
   if( SalesPerson1.size()>0)
  SalesPerson=SalesPerson1[0].ExtIDSalesPerson__c;
  
 
  
    //===============================================================================================================//
    // The status of the boolean expression has been changed to true by Mohamad as required in the support# 150993 --> 
    // which require to Remove Custom Dup Check on Prospect Only. (skipCheckDuplicateAccount = false)
    // The status of the boolean expression has been changed to false by Mohamad as required in the support# 171364 -->
    // (skipCheckDuplicateAccount = true) "3/25/2014"
    //===============================================================================================================//
    skipCheckDuplicateAccount = false;
    pricingTempNotMatching = false;
    showiframe=false;
    customerid = true;
    shownMessage = false;
    
    PopulateRecordTypes();
  }
  
  //=================================================================================//
  //Populate Appropiate Record Types 
  //=================================================================================//
  private void PopulateRecordTypes() {
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    RecordTypeInfo prospectRecordType = rtMapByName.get('Prospect (GT)');
    RecordTypeInfo customerRecordType = rtMapByName.get('Customer (GT)');
    if(prospectRecordType != null) {
      this.prospectAccount.RecordTypeId = prospectRecordType.getRecordTypeId();
    }
    
    RecordTypeInfo siteRecordType = rtMapByName.get('Site (GT)');
    if(siteRecordType != null) {
      this.siteAccount.RecordTypeId = siteRecordType.getRecordTypeId();
    }
  }
  
  //==========================================================================//
  //Hack for SFDC bug, 
  //when an error occurs, and the transaction is rolled back, Id on the new record is not cleared
  //DeepCloning is the only way to clear Id of the record
  //===========================================================================//
  @TestVisible 
  private void DeepCloneAll(){
    Boolean preseveID = false;
    Boolean isDeepClone = true;
    Boolean preserveReadOnlyTimeStamp = true;
    Boolean preserveAutoNumber = true;
    prospectAccount = prospectAccount.clone(preseveID,isDeepClone,preserveReadOnlyTimeStamp,preserveAutoNumber);
    contact = contact.clone(preseveID,isDeepClone,preserveReadOnlyTimeStamp,preserveAutoNumber);
    siteAccount = siteAccount.clone(preseveID,isDeepClone,preserveReadOnlyTimeStamp,preserveAutoNumber);
  }
  
  //============================================================================================//
  //Check if the Specific owner assigned , does have a Sales Person associated record which is active
  // and Primary
  //===========================================================================================//
  @TestVisible
  private Boolean ValidateAssignSpecficOwner() {
    if(prospectAccount.Assign_Specific_Owner__c != null) {
      //prospectAccount.ownerid = prospectAccount.Assign_Specific_Owner__c;
      Sales_Person__c salesPerson = CheckIfSpecificOwnerIsAValidSalesRep(prospectAccount.Assign_Specific_Owner__c);
      
      //Invalid Owner
      if(salesPerson == null){
        prospectAccount.Assign_Specific_Owner__c.addError('An active and primary matching Sales Person record could not be found for the selected User');
        return false;
      }
      prospectAccount.Sales_PersonID__c = salesPerson.Id;
      prospectAccount.ownerId = salesPerson.User__c;
    }
    return true;
  }
/* @TestVisible  
private Boolean validateAddress()
{
try
{
// instantiate webservice 
//Addressvalidation.AOPS_G1_AddressValidation avws = new Addressvalidation.AOPS_G1_AddressValidation();

// instantiate response variable
//Addressvalidation.AOPS_G1_AddressValidationProcessResponse_element result =new Addressvalidation.AOPS_G1_AddressValidationProcessResponse_element();

// execute Web service.
//notvalidadd=false;
//String zip = siteAccount.zip__c;
//String street1 = siteAccount.address1__c;
//String city  = siteAccount.City__c;
//String state = siteAccount.state__c;
//if(state==null)
//{
  // state='';
//}
//String  name = prospectAccount.name;
//String country = siteAccount.country__c;
//system.debug('Before : ' +name + street1  + city +state +  zip  + country  ) ;
//result= avws.process('G', 'AM', 'Y', 'Y', 'N', 'N', 'N', 'N',name ,street1 , ' ', ' ', city  , state , zip , ' ', country , 0, 0, ' ', ' ',  ' ', ' ');
                G1AddressValidation.G1AddressValidationService_pt   av = new G1AddressValidation.G1AddressValidationService_pt  ();
                G1AddressValidation.CustomerResponseType result= new G1AddressValidation.CustomerResponseType();                
                
                //New change for the Security
                av.inputHttpHeaders_x = new Map<String, String>();
                String myData = 'sfdcuser:sfdcuser123';       
                
                String encodedusernameandpassword = EncodingUtil.base64Encode(Blob.valueOf(myData));
                av.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                
                //End New change for the Security

                
                G1AddressValidation.CustomerType ct = new G1AddressValidation.CustomerType();
                G1AddressValidation.AddressType oAddress = new G1AddressValidation.AddressType();
                  
                        oAddress.StreetNameOne = siteAccount.address1__c;
                        oAddress.StreetNameTwo = ''; 
                        oAddress.PostOfficeBox = '';
                        oAddress.CityName = siteAccount.City__c;
                        oAddress.StateName = siteAccount.state__c;
                        oAddress.ZipCode = siteAccount.zip__c;
                        oAddress.Province ='';
                        oAddress.Country=siteAccount.country__c;
                        oAddress.GeographicalCodeOne=0;
                        oAddress.GeographicalCodeTwo=0;
                        oAddress.CountyName='';
                        oAddress.Urbanization='';
                        oAddress.DeliveryPointCode='';
                        oAddress.ResidentialDeliveryIndicator='';
                
                        ct.ClientName = 'G';
                        ct.ApplicationName = 'AM';
                        ct.BusinessName = prospectAccount.name;
                        ct.ValidateAddress = 'Y';
                        ct.DetailGeographicalCode = 'N';
                        ct.IfMultipleOriginReturnOrigin = 'N';
                        ct.AddressValidated = 'N';
                        ct.AddressOverriden = 'N';
                        ct.MiscellaneousDataCleanup = 'Y';
                        ct.Address = oAddress;
                        System.debug('>>>>>>>>>>>>>>>>>>>>ALL GOOD');
                        result= av.process(ct);
                        System.debug('result**'+result);
                        
siteAccount.zip__c =  result.Address.ZipCode;
siteAccount.address1__c = result.Address.StreetNameOne ;
siteAccount.City__c = result.Address.CityName;
siteAccount.state__c =  result.Address.StateName ;
siteAccount.country__c = result.Address.Country;
prospectAccount.name=  result.BusinessName;

notvalidadd=false;
String  adrRc = string.valueof(result.AddressReturnCode);
String  adrErrMsg = result.ErrorMessage.AddressErrorMessage;



siteAccount.Address_Validation_Error__c  = adrErrMsg ;
siteAccount.Address_Validated__c = true;
prospectAccount.Address_Validation_Error__c  = adrErrMsg ;
prospectAccount.Address_Validated__c = true;
if(!adrRc.equals('0') )
{
system.debug('adrErrMsg: ' +adrErrMsg ) ;
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS--'+adrErrMsg));

siteAccount.Address_Validated__c = false;
prospectAccount.Address_Validated__c = false;
notvalidadd=true;
}
else
{
   siteAccount.Address_Validation_Error__c  = null ;
   siteAccount.Address_Validated__c = true;
   prospectAccount.Address_Validation_Error__c  = null ;
   prospectAccount.Address_Validated__c = true;
   
}

//system.debug('After : ' +name + street1  + city +state +  zip  + country  ) ;
return notvalidadd;
}
catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS'));
                return true;
            } 
}*/
  //======================================================================================================//
  //Insert Prospect Account and do other steps
  //======================================================================================================//
  @TestVisible
  private void InsertProspectAccount() {
    
    prospectAccount.zip__c = siteAccount.zip__c;
    prospectAccount.address1__c = siteAccount.address1__c;
    prospectAccount.address2__c = siteAccount.address2__c;
    prospectAccount.city__c = siteAccount.City__c;
    prospectAccount.state__c = siteAccount.state__c;
    prospectAccount.Location_Type__c = siteAccount.Location_Type__c;
    
    prospectAccount.country__c = siteAccount.country__c;
    prospectAccount.type = 'Prospect';
    prospectAccount.Assign_Specific_Owner__c = null;
    prospectAccount.status__c = 'Active';
    if(SalesPerson1.size()>0){
    prospectAccount.Sales_PersonID__c=SalesPerson1[0].id;
   
     insert prospectAccount;}
    //If Auto Assign is set to true, retrieve the newly created, Owner
  
      List<Account> lstAccount = [select ownerId,Sales_PersonID__c from Account where id = :prospectAccount.Id];
      if(lstAccount.size() > 0) {
        prospectAccount.ownerID = lstAccount[0].OwnerId;
        prospectAccount.Sales_PersonID__c =  lstAccount[0].Sales_PersonID__c;
      }  
  
  }
  
  //===================================================================================//
  //Check if the Specific owner is avaliable as a valid Sales Person in the system
  //==================================================================================//
  @TestVisible
  private Sales_Person__c CheckIfSpecificOwnerIsAValidSalesRep(Id inputUserId) {
    List<Sales_Person__c> lstSalesPerson = [SELECT ExtIDSalesPerson__c,User__c FROM Sales_Person__c
                                            WHERE User__c = :inputUserId AND User__r.IsActive = true AND IsActive__c = true AND Primary__c = true];
    if(lstSalesPerson.size() == 0) {
      return null;
    }
    return lstSalesPerson[0];
  }
  
  
  //==========================================================================================//
  //Insert Site Account,use details
  //==========================================================================================//
 @TestVisible 
  private void InsertSiteAccount() {
    /*
    if(prospectAccount.Auto_Assign__c) {
      siteAccount.Ownerid = this.prospectAccount.OwnerId;
    }
    if(prospectAccount.Assign_Specific_Owner__c != null) {
        siteAccount.OwnerId = prospectAccount.Assign_Specific_Owner__c;
    }*/
   if(ProspectAccount.id!=null){
    siteAccount.OwnerId = prospectAccount.OwnerId;
    siteAccount.Sales_PersonID__c = prospectAccount.Sales_PersonID__c;
    siteAccount.Related_Account__c = prospectAccount.Id;
    if(siteAccount.phone == null){
    siteAccount.phone = prospectAccount.phone;
    } 

    siteAccount.Site_Primary_Contact__c = contact.Id;
    siteAccount.primary_site__c = true;
    siteAccount.name = prospectAccount.name;
    siteAccount.Industry_OD_SIC_Rep__c = prospectAccount.Industry_OD_SIC_Rep__c;
    siteAccount.Type = 'Site';  
    siteAccount.Initial_Site_Flag__c = true;    
    siteAccount.status__c = 'Active';
    insert siteAccount;}
  }
  
  
  //===========================================================================================//
  //Insert contact related to the record
  //===========================================================================================//
  @TestVisible
  private void InsertContact() {
  
  if(ProspectAccount.id!=null){
    //Assign Owner to Contact record
    if(prospectAccount.Auto_Assign__c) {
      this.contact.OwnerId = this.prospectAccount.OwnerId;
    }
    if(prospectAccount.Assign_Specific_Owner__c != null) {
      this.contact.Ownerid = prospectAccount.Assign_Specific_Owner__c;
    }
    contact.AccountId = prospectAccount.Id;
    contact.primary_contact__c = true;
    
    //Copy the site Account address to contact Record    
    contact.mailingstreet = siteAccount.Address1__c;
    contact.mailingcity = siteAccount.City__c;
    contact.mailingstate = siteAccount.State__c;
    contact.mailingpostalcode = siteAccount.zip__c;
    contact.mailingcountry = siteAccount.country__c;
    
    insert contact;}
    
  }
  
  
  //====================================================================//
  // Save with duplicate account, skip duplicate checking
  //====================================================================//
  public PageReference SaveDuplicateAccount(){      
    skipCheckDuplicateAccount = true;
    return SaveAllData();
  }
  
  //====================================================================//
  // Check if duplicate account exist add message
  //====================================================================//
  public Boolean CheckIfDuplicateAccountExist(){
    // Initialize both lists
    accountZipList = new List<Account>();  
    accountPhoneList = new List<Account>();
     
    // call methods, these methods add values in both lists   
    GetMatchingDuplicateAccountPhone();
    GetMatchingDuplicateAccount();
    
    // Check if match account found        
    if(accountPhoneList.size() > 0 || accountZipList.size() > 0){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,label.Prospect_Duplicate_Message_lbl));
        return true;
    }
    return false;
  }
  
  
  //----------------------------------------Lookup functionality in page block table-------------------
  
  public PageReference populateparentaccount()
        {
            showiframe=false; 
            //customerid=true;   
            if(ProspectAccount.Pricing_template_cd__c!=null)
            { 
                list<Pricing_Template__c> PTList = [select Name,Parent_Id__c from Pricing_Template__c where Name = :ProspectAccount.Pricing_template_cd__c];   
                //ptemp=[select id,Parent_Id__c from Pricing_Template__c where Name=:account.Pricing_template_cd__c];
                if(!PTList.isEmpty() && PTList[0].Parent_Id__c!=null)
                { 
                    string removezeros=PTList[0].Parent_Id__c.replaceFirst( '^0+', '');
                    system.debug('The string is'+removezeros);   
                    list<Account> accs =[Select id,name,Hierarchy__c,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c=:removezeros];
                    
                     if(!accs.isEmpty())
                     {
                         List<Account> parentforGP=[select id from Account where Parent.Parentid=:accs[0].id];
                        if(parentforGP.size()>0)
                        {
                            recordCatergory = 'GP';
                            ProspectAccount.Related_Pricing_Template_Account__c=null;
                            ProspectAccount.Related_Parent_Account__c=null;
                        }
                        else
                        {
                            recordCatergory = 'P';
                            ProspectAccount.Related_Pricing_Template_Account__c=accs[0].id;
                            ProspectAccount.Related_Parent_Account__c=accs[0].AOPS_Cust_Id__c;
                        }
                     }
                     pricingTempNotMatching = false;                
                }
                else
                {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Pricing Template.'));
                    if(PTList.isEmpty()){
                        customerid=true;
                        pricingTempNotMatching = true;
                        ProspectAccount.Related_Pricing_Template_Account__c=null;
                        ProspectAccount.Related_Parent_Account__c=null;
                    }else{
                        //customerid=false;
                        recordCatergory = 'No Account';
                        ProspectAccount.Related_Pricing_Template_Account__c=null;
                        ProspectAccount.Related_Parent_Account__c=null;
                        pricingTempNotMatching = false;
                    }    
                }  
            }
            else
            {                
                pricingTempNotMatching = false;
                ProspectAccount.Related_Pricing_Template_Account__c=null;
                ProspectAccount.Related_Parent_Account__c=null;
            }  
            return null;      
        }
   public void filllookup()
        {
            showiframe=false;
            ProspectAccount.Related_Parent_Account__c = ApexPages.currentPage().getParameters().get('selectedRecord');
            ProspectAccount.Related_Pricing_Template_Account__c = ApexPages.currentPage().getParameters().get('selectedRecordid');
        }      
   public void openlookup()
        {
            showiframe=true;
            aopsidsearch=ProspectAccount.Related_Parent_Account__c;
            Search();
        }
        public void Search()
        {
            Results=accParentRec(aopsidsearch);
        }
        public List<Account> accParentRec(String aopsidsearch)
        {
                   String soql = null;                   
                   rerendererror=false;
               //    pricingTemp=ProspectAccount.Pricing_template_cd__c;
        try{
            List<Id> gpAccountId = new List<Id>();
            list<Pricing_Template__c> PTList = [select Name,Parent_Id__c from Pricing_Template__c where Name = :pricingTemp];
            system.debug('Y not enter if??????'+PTList[0].Parent_Id__c);//debugged by Sushma
            /*
    if(PTList.size()>0)
     {
            if(PTList[0].Parent_Id__c != null)
            {
                string removezeros=PTList[0].Parent_Id__c.replaceFirst( '^0+', '');
                system.debug('The string is'+removezeros);
                accs = [select id,name,Hierarchy__c,AOPS_Cust_Id__c,Parent.Parentid,Parentid from account where AOPS_Cust_Id__c = :removezeros];
                gpAcc = accs[0].id;
                parentAOPSId = PTList[0].Parent_Id__c;
                System.debug('accs'+accs);                
                if(!accs.isEmpty())
                {
                    List<Account> parentforGP=[select id from Account where Parent.Parentid=:accs[0].id];
                    if(parentforGP.size()>0)
                    //if(accs[0].Parentid!=null)
                    {
                        //It is a Grand Parent
                        recordCatergory ='GP';
                        soql = 'select id, Name, AOPS_Cust_Id__c,Hierarchy__c from account where ParentID = \''+accs[0].id+'\'';
                        System.debug('soql_g'+soql);
                    }
                    else
                    {
                        //It is a parent
                        recordCatergory ='P';
                        soql = 'select id, Name, AOPS_Cust_Id__c,Hierarchy__c from account where AOPS_Cust_Id__c = \''+PTList[0].Parent_Id__c+'\'';
                        System.debug('soql_p'+soql);              
                    }                    
                }
            }
            //}
            else
            {
                recordCatergory ='No Account';                 
               if((aopsidsearch==null || aopsidsearch=='') && (searchString==null || searchString==''))  
               {   
                    for(Account acc:[Select parentid, parent.name, parent.aops_cust_id__C from Account where Recordtype.name='Customer' and parent.status__c = 'Active' and Parentid!=null Limit 10000])
                    //for(Account acc:[Select id,name,AOPS_Cust_Id__c,parentid,Parent.parentid from Account where Recordtype.name='Customer' and Parentid!=null Limit 1000])
                    {                                             
                            Parentid.add(acc.parentid);                                       
                    }
                    system.debug('Parentid size-->'+Parentid.size());
                    system.debug('aopsidsearch-->'+aopsidsearch) ;
                    system.debug('searchString-->'+searchString);
                    for(Account acc1:[Select id,parentid,AOPS_Cust_Id__c from Account where id in:Parentid])
                    {
                        if(acc1.AOPS_Cust_Id__c.startsWith('0') || acc1.AOPS_Cust_Id__c.length()<8)                       
                        {                              
                        } 
                        else
                        {
                            actualqueryset.add(acc1.id);
                        }
                    }
                    system.debug('actualqueryset size-->'+actualqueryset.size());
                   
                }   
                else
                {
                    system.debug('Test else');
                    system.debug('aopsidsearch111-->'+aopsidsearch) ;
                    system.debug('searchString111-->'+searchString);
                    for(Account acc2:[Select parentid,parent.name,parent.AOPS_Cust_Id__c,Parent.parentid from Account where Recordtype.name='Customer' and parent.AOPS_Cust_Id__c LIKE :aopsidsearch+'%' and parent.name LIKE :searchString+'%' and status__c = 'Active' Limit 500])
                    {
                        if(acc2.parent.AOPS_Cust_Id__c.startsWith('0') || acc2.parent.AOPS_Cust_Id__c.length()<8)                       
                        {                              
                        } 
                        else
                        {
                            actualqueryset.add(acc2.parentid);
                        }
                    }                  
                    
                    system.debug('test'+actualqueryset);
                }                    
                soql = 'select id, Name, AOPS_Cust_Id__c,Hierarchy__c from account where id in :actualqueryset';             
                System.debug('soql_none'+soql);
            }
        
}

*/
        List<Account> AccList = new list<Account>();
    
       /* if(soql != null){
            if(searchString != '' && searchString != null)
                soql = soql +  ' and name LIKE \'' + String.escapeSingleQuotes(searchString) +'%\''; //\'%
            if(aopsidsearch !='' && aopsidsearch != null)
                soql=soql + ' and AOPS_Cust_Id__c LIKE \'' + String.escapeSingleQuotes(aopsidsearch) +'%\''; //\'%
            soql = soql + ' limit 50';
            System.debug('soql_total'+soql);
            AccList = database.query(soql); 
            system.debug('Acclist'+AccList.size());          
            if(AccList.size()==50)
            {
                system.debug('abc');
                rerendererror=true;
            } 
           system.debug('errorshow'+rerendererror);
        }*/
        return AccList;
     }
     catch(Exception ex){
         //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'User creating Account does not have a valid SalesPerson ID'));
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Pricing Template'));
        return null;
    }  
        } 
        
        
 //-------------------------The end of lookup functionality----------------
  
  //====================================================================//
  //Save Account,Contact and Site records
  //====================================================================//
  public PageReference SaveAllData(){
    // Check if duplicate account exist return
    if(!skipCheckDuplicateAccount){
      if(CheckIfDuplicateAccountExist()){
        return null;
      }
    }
    
    if(!ValidateAssignSpecficOwner()) {
      return null;
    }
    
    //---------------Lookup Functionality---------------------
     /* The field is optional now
     if(ProspectAccount.Related_Parent_Account__c==null || ProspectAccount.Related_Parent_Account__c==''){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Related Pricing Template Customer ID:You must enter the value.'));
              return null;
          } */
          
    showiframe=false;
          accParentRec(null);
          /*
          if(ProspectAccount.Related_Parent_Account__c!=null && ProspectAccount.Related_Parent_Account__c != ''){
              if(recordCatergory =='GP'){
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where ParentID =:gpAcc and AOPS_Cust_Id__c=:ProspectAccount.Related_Parent_Account__c ];
                  if(accListValue.size()==0){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Customer Id does not belong to the Grand Parent '));
                           return null;
                  }
              } else if(recordCatergory =='p'){
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c =:parentAOPSId and AOPS_Cust_Id__c=:ProspectAccount.Related_Parent_Account__c ];
                  if(accListValue.size()==0){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Customer Id does not match the Parent in the Pricing Template'));
                           return null;
                  }
              }else if(recordCatergory =='No Account'){
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c=:ProspectAccount.Related_Parent_Account__c ];
                  list<Account> checkparent=[Select id from Account where parentid in:accListValue limit 10];
                  list<Account> checkgparent=[Select id from Account where parent.parentid in:accListValue limit 10];
                  system.debug('checkparent-->'+checkparent.size()+'--checkgparent-->'+checkgparent.size());
                  if(checkparent.size()==0 || checkgparent.size()>0)
                  {
                          system.debug('No Account');
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Customer Id is not a parent Account'));
                          return null;
                  }
              }
          }
          
          
          
          /*List<String> accParentList = accParentRecValue();
          if(accParentList!=null && account.Related_Parent_Account__c!=null){
              for(string accAPOSID : accParentList){
                  if(accAPOSID != account.Related_Parent_Account__c){
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Parent Id is not matching with Pricing Template,Please select valid ID '));
                       return null;
                  }
              }
          }*/
          
        /*  if(!customerid){
               list<Account> accfound=[Select id from Account where AOPS_Cust_Id__c=:ProspectAccount.Related_Parent_Account__c and parentid!=null and parent.parentid=null];
              if(accfound.size()>0)
              {
                  //Account is found
                  //account.Related_Parent_Account__c=accs[0].AOPS_Cust_Id__c;
                  ProspectAccount.Related_Pricing_Template_Account__c=accfound[0].id;
              }
              else
              {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'The Related Pricing Template Customer ID does not exist.'));
                   return null;
              }
          } 
          if(pricingTempNotMatching){
              //account.Pricing_template_cd__c.addError('Invalid Pricing Template');
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Pricing Template, Please select valid one.'));
              return null;
          }
          */
          //-------------End of lookup functionality------
   
            if((siteAccount.country__c).trim()=='USA')
            {
               if((oldAddress1value!=(siteAccount.address1__c).trim())||(oldCityvalue != (siteAccount.City__c).trim())||(oldstatevalue != (siteAccount.state__c).trim())||(oldcontryvalue != (siteAccount.country__c).trim())||(oldZipvalue != (siteAccount.zip__c).trim())||(oldAddress2value != siteAccount.address2__c)){
                    //if(validateAddress()){  
                        oldAddress1value = (siteAccount.address1__c).trim();
                        oldAddress2value = siteAccount.address2__c;
                        oldCityvalue = (siteAccount.City__c).trim();
                        oldstatevalue = (siteAccount.state__c).trim();
                        oldcontryvalue = (siteAccount.country__c).trim();
                        oldZipvalue = (siteAccount.zip__c).trim();
                        return null;
                    //}
               }
            }
            /*else{
                ProspectAccount.Address_Validation_Error__c  = 'Address outside USA';
                ProspectAccount.Address_Validated__c = false;
                siteAccount.Address_Validation_Error__c  = 'Address outside USA';
                siteAccount.Address_Validated__c = false;
            }*/
           
    DeepCloneAll();
    Savepoint sp = Database.setSavepoint();
    try {
      InsertProspectAccount();
      InsertContact();
      //InsertSiteAccount();
    }
    catch(Exception ex){        
      Database.rollback(sp);
      ApexPages.addMessages(ex);
      return null;
    }
    //Move to the tab section
    if(prospectAccount.Id!=null) {
        return new PageReference('/'+ prospectAccount.Id);
    }
    else {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'User creating Account does not have a valid SalesPerson ID'));
        return null;
    }
    
    
  }
  
  //============================================================================================//
  //Check if the Account already exist --- CHECKING PHONE & RECORDTYPE
  //===========================================================================================//
  @TestVisible
  private void GetMatchingDuplicateAccountPhone() {     
    Set<Account> zipAndAddressAccountSet;  
    
    accountPhoneList = [Select Id, Name, Cust_Id__c, RecordTypeId, OwnerId From Account Where phone = :ProspectAccount.phone And RecordTypeId != :siteAccount.RecordTypeId and phone!=null and Recordtype.name like '%GT%' ];
                                /*address1__c = :siteAccount.address1__c And zip__c = :siteAccount.zip__c*/
     
  }
    
  public void closeLookupSection(){
      showiframe = false;
  }  
  //============================================================================================//
  //Check if the Account already exist ---- CHECKING NAME & ZIP
  //===========================================================================================//
  @TestVisible
  private void GetMatchingDuplicateAccount() {
    Set<Account> nameAndAddressAccountSet;
    accountZipList = [Select Id, Name, Cust_Id__c, RecordTypeId, OwnerId From Account Where 
                                         Zip__c = :siteAccount.Zip__c And Name = :prospectAccount.Name and Recordtype.name like '%GT%']; 
  }



 }