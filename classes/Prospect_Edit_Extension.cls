/*************************************************************
*Name : Prospect_Edit_Extension
*Created By : Abinaya
*Purpose : Validate the address of prospect account
****************************************************************/


public with sharing class Prospect_Edit_Extension {
        
        public Account account{get;set;}
        private Boolean skipCheckDuplicateAccount;
        public Boolean notvalidadd{get;set;}
        //public Boolean onetimeerror=false;
        public Boolean addressCorrection;  
        public Account accountAddress;
        //public string statevalue;
        public boolean isTestMode{get;set;}
        // To retain the old version of field values
        private string oldAddress1value;
        private string oldAddress2value;
        private string oldCityvalue;
        private string oldstatevalue;
        private string oldcontryvalue;
        private string oldZipvalue;
        
        //--End
        //Pricing Template and Parent Account Functioanlity
        //public Pricing_Template__c ptemp;
        public Account account1;
        //public boolean rerenderPAcc{get;set;}
        //public boolean enablesave{get;set;}
        public List<Account> Paccount{get;set;}
        public list<Account> Results{get;set;}
        Public string recordCatergory;
        public list<DMND_Duplicate__c> duplicaterecDetail = new list<DMND_Duplicate__c>(); 
        public list<DMND_Duplicate__c> DMND_Duplicate = new list<DMND_Duplicate__c>();
        public boolean addressDuplicationCheck; 
        public boolean updateDeDup;
        private boolean shownMessage;
        public boolean phoneDuplicationCheck;
        public boolean showiframe{get;set;}
        public boolean rerendererror{get;set;}
        public String pricingTemp;
        public string searchString{get;set;}
        public string aopsidsearch{get;set;}
        public boolean customerid{get;set;}
        public boolean pricingTempNotMatching;
        public list<Account> accs = new list<Account>();
        public list<Pricing_Template__c> PTList = new list<Pricing_Template__c>();
        public id gpAcc;
        public string parentAOPSId;
        public Set<Id> Parentid= new Set<Id>();
        public Set<Id> GrandParentid= new Set<Id>();
        public Set<Id> actualqueryset= new Set<Id>();
        
    //End...
        
        public Prospect_Edit_Extension(ApexPages.StandardController stdController) {
                this.account = (Account)stdController.getRecord();
                isTestMode = false;
                //rerenderPAcc=false;
                addressDuplicationCheck = false;
                updateDeDup = false;
                shownMessage = false;
                phoneDuplicationCheck = false;
                pricingTempNotMatching = false;
                showiframe=false;
                /*list<Pricing_Template__c> priceTemp= [select Name,Parent_Id__c from Pricing_Template__c where Name = :account.Pricing_template_cd__c and Parent_Id__c!=null];
                if(priceTemp.isEmpty()){
                    customerid=false;
                }else{
                    customerid=true;
                }*/                    
                customerid = true;    
                
                
        } 
        public PageReference populateparentaccount()
        {
            showiframe=false; 
            //customerid=true;   
            if(account.Pricing_template_cd__c!=null)
            { 
                PTList = [select Name,Parent_Id__c from Pricing_Template__c where Name = :account.Pricing_template_cd__c];   
                //ptemp=[select id,Parent_Id__c from Pricing_Template__c where Name=:account.Pricing_template_cd__c];
                system.debug('The  PTList is'+PTList);
                if(!PTList.isEmpty() && PTList[0].Parent_Id__c!=null)
                { 
                    string removezeros=PTList[0].Parent_Id__c.replaceFirst( '^0+', '');
                    system.debug('The string is'+removezeros);   
                    list<Account> accs =[Select id,name,Hierarchy__c,AOPS_Cust_Id__c,GrandParent__c from Account where AOPS_Cust_Id__c=:removezeros];
                    
                     if(!accs.isEmpty())
                     {
                         List<Account> parentforGP=[select id from Account where Parent.Parentid=:accs[0].id];
                        if(parentforGP.size()>0 && accs[0].GrandParent__c == 'Yes')
                        {
                            recordCatergory = 'GP';
                            account.Related_Pricing_Template_Account__c=null;
                            account.Related_Parent_Account__c=null;
                        }
                        else
                        {
                            recordCatergory = 'P';
                            account.Related_Pricing_Template_Account__c=accs[0].id;
                            account.Related_Parent_Account__c=accs[0].AOPS_Cust_Id__c;
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
                        account.Related_Pricing_Template_Account__c=null;
                        account.Related_Parent_Account__c=null;
                    }else{
                        //customerid=false;
                        recordCatergory = 'No Account';
                        account.Related_Pricing_Template_Account__c=null;
                        account.Related_Parent_Account__c=null;
                        pricingTempNotMatching = false;
                    }    
                }  
            }
            else
            {                
                pricingTempNotMatching = false;
                account.Related_Pricing_Template_Account__c=null;
                account.Related_Parent_Account__c=null;
            }  
            return null;      
        }
        public void filllookup()
        {
            showiframe=false;
            account.Related_Parent_Account__c = ApexPages.currentPage().getParameters().get('selectedRecord');
            account.Related_Pricing_Template_Account__c = ApexPages.currentPage().getParameters().get('selectedRecordid');
        }      
        public void openlookup()
        {
            showiframe=true;
            aopsidsearch=account.Related_Parent_Account__c;
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
                   pricingTemp=account.Pricing_template_cd__c;
        try{
            List<Id> gpAccountId = new List<Id>();
            list<Pricing_Template__c> PTList = [select Name,Parent_Id__c from Pricing_Template__c where Name = :pricingTemp];
            if(PTList[0].Parent_Id__c != null)
            {
                string removezeros=PTList[0].Parent_Id__c.replaceFirst( '^0+', '');
                system.debug('The string is'+removezeros);
                accs = [select id,name,Hierarchy__c,AOPS_Cust_Id__c,Parent.Parentid,Parentid,GrandParent__c from account where AOPS_Cust_Id__c = :removezeros];
                gpAcc = accs[0].id;
                parentAOPSId = PTList[0].Parent_Id__c;
                System.debug('accs'+accs);                
                if(!accs.isEmpty())
                {
                    List<Account> parentforGP=[select id from Account where Parent.Parentid=:accs[0].id];
                    if(parentforGP.size()>0 && accs[0].GrandParent__c == 'Yes')
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
            else
            {
                recordCatergory ='No Account';
                if((aopsidsearch==null || aopsidsearch=='') && (searchString==null || searchString==''))  
               {   
                    for(Account acc:[Select parentid, parent.name, parent.aops_cust_id__C from Account where Recordtype.name='Customer' and parent.status__c = 'Active' and Parentid!=null Limit 10000])
                    //for(Account acc:[Select id,name,AOPS_Cust_Id__c,parentid,Parent.parentid from Account where Recordtype.name='Customer' and Parentid!=null Limit 5000])
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
                    for(Account acc2:[Select parentid,parent.name,parent.AOPS_Cust_Id__c,Parent.parentid from Account where Recordtype.name='Customer' and parent.AOPS_Cust_Id__c LIKE :aopsidsearch+'%' and parent.name LIKE :searchString+'%' Limit 500])
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
                //soql = 'select id, Name, AOPS_Cust_Id__c,Hierarchy__c from account where parentid!=null and parent.parentid=null';//NOT(Id IN \''+gpAccountID+'\')'; //Hierarchy__c = \'P\'';
                System.debug('soql_none'+soql);
            }
        

        List<Account> AccList = new list<Account>();
    
        if(soql != null){
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
        }
        return AccList;
     }
     catch(Exception ex){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Pricing Template'));
        return null;
    }  
        } 
        public Boolean validateAddress()
        {
            try{
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
                  
                        oAddress.StreetNameOne = account.address1__c;
                        oAddress.StreetNameTwo = ''; 
                        oAddress.PostOfficeBox = '';
                        oAddress.CityName = account.City__c;
                        oAddress.StateName = account.state__c;
                        oAddress.ZipCode = account.zip__c;
                        oAddress.Province ='';
                        oAddress.Country=account.country__c;
                        oAddress.GeographicalCodeOne=0;
                        oAddress.GeographicalCodeTwo=0;
                        oAddress.CountyName='';
                        oAddress.Urbanization='';
                        oAddress.DeliveryPointCode='';
                        oAddress.ResidentialDeliveryIndicator='';
                
                        ct.ClientName = 'G';
                        ct.ApplicationName = 'AM';
                        ct.BusinessName = account.name;
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
                        
                        
                account.zip__c =  result.Address.ZipCode;
                account.address1__c = result.Address.StreetNameOne ;
                account.City__c = result.Address.CityName;
                account.state__c =  result.Address.StateName ;
                account.Country__c = result.Address.Country;
                account.name= result.BusinessName;
                
                notvalidadd=false;
                String  adrRc = string.valueof(result.AddressReturnCode);
                String  adrErrMsg = result.ErrorMessage.AddressErrorMessage;//AddressValidationReturnCode;//AddressErrorMessage;
                
                
                account.Address_Validation_Error__c  = adrErrMsg ;
                account.Address_Validated__c = true;
                // If address is not valid, display error message which is generated by websrvice
                if(!adrRc.equals('0') )
                {
                        system.debug('adrErrMsg: ' +adrErrMsg ) ;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS--'+adrErrMsg));
                        account.Address_Validated__c = false;
                        //account.Address_Validated__c = false;
                        notvalidadd=true;
                }else{
                    account.Address_Validation_Error__c  = null ;
                    account.Address_Validated__c = true;
                }
                system.debug('The variable-->'+notvalidadd);
               // system.debug('After : ' +name + street1  + city +state +  zip  + country  ) ;
                return notvalidadd;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS'));
                return true;
            } 
                
         }
    
        public boolean duCheck(){
            if(Account.Potential_DeDuplicate__c){
                duplicaterecDetail = [select Name,Disposition__c from DMND_Duplicate__c where Account__c=:ApexPages.currentPage().getParameters().get('id')];
                for(DMND_Duplicate__c DMND : duplicaterecDetail){
                    if((DMND.Disposition__c=='Inactive')){
                        addressDuplicationCheck = true;
                    }  
                }
                if((addressDuplicationCheck) && !shownMessage  ){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,'This record has been marked for Inactive. Do you wish to continue?'));
                        updateDeDup = true;
                        shownMessage = true;
                        return false;
                    
                 }
            }
            return true; 
        }
    
           public void closeLookupSection(){
              showiframe = false;
          }
 
          public PageReference SaveAllData(){
          
        
          showiframe=false;
          accParentRec(null);
          if(account.Related_Parent_Account__c!=null && account.Related_Parent_Account__c!=''){
              if(recordCatergory =='GP'){
               
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where ParentID =:gpAcc and AOPS_Cust_Id__c=:account.Related_Parent_Account__c ];
                  if(accListValue.size()==0 && account.Related_Parent_Account__c != null && account.Related_Parent_Account__c != ''){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Customer Id does not belong to the Grand Parent '));
                           return null;
                  }
              } else if(recordCatergory =='p'){
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c =:parentAOPSId and AOPS_Cust_Id__c=:account.Related_Parent_Account__c ];
                  if(accListValue.size()==0  && account.Related_Parent_Account__c != null && account.Related_Parent_Account__c != ''){
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Selected Customer Id does not match the Parent in the Pricing Template '));
                           return null;
                  }
              }else if(recordCatergory =='No Account')
              {
                  list<Account> accListValue =  [select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c=:account.Related_Parent_Account__c ];
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
          
          
          
         
          
          if(!customerid){
               list<Account> accfound=[Select id from Account where AOPS_Cust_Id__c=:account.Related_Parent_Account__c and parentid!=null and parent.parentid=null];
              if(accfound.size()>0)
              {
                  //Account is found
                  //account.Related_Parent_Account__c=accs[0].AOPS_Cust_Id__c;
                  account.Related_Pricing_Template_Account__c=accfound[0].id;
              }
              else if (account.Related_Parent_Account__c != null && account.Related_Parent_Account__c != '')
              {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'The Related Pricing Template Customer ID does not exist.'));
                   return null;
              }
          } 
          if(pricingTempNotMatching){
              account.Pricing_template_cd__c.addError('Invalid Pricing Template');
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Pricing Template, Please select valid one.'));
              return null;
          }
           
           try{
            if(!duCheck()){
               return null;
            }
            
            if(updateDeDup ){
                DMND_Duplicate = [select id,Name,Disposition__c,Dispostion_Reason__c from DMND_Duplicate__c where Account__c=:ApexPages.currentPage().getParameters().get('id')];
                for(DMND_Duplicate__c DDup :DMND_Duplicate){
                    DDup.Disposition__c = null;
                    DDup.Dispostion_Reason__c = null;
                }
                update DMND_Duplicate;
            }
            upsert Account;
           }
           catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
            }    
           
           
            
            // validate address when the country is USA
            if((account.country__c).trim()=='USA')
            { 
                accountAddress = [select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Account where id =:ApexPages.currentPage().getParameters().get('id')];
                if((accountAddress.address1__c!=account.address1__c)||(accountAddress.address2__c !=account.address2__c)||(accountAddress.City__c != account.City__c)||(accountAddress.state__c != account.state__c)||(accountAddress.country__c!=account.country__c)||(accountAddress.zip__c!=account.zip__c)){
                    if((oldAddress1value!=(account.address1__c).trim())||(oldCityvalue != (account.City__c).trim())||(oldstatevalue != (account.state__c).trim())||(oldcontryvalue != (account.country__c).trim())||(oldZipvalue != (account.zip__c).trim())||(oldAddress2value != account.address2__c)){
                            if(validateAddress())
                                {
                                    system.debug('validateAddress**'+validateAddress());
                                    system.debug('Old version of values----->Address1='+oldAddress1value+';City='+oldCityvalue+';State='+oldstatevalue+';Country='+oldcontryvalue+';Zip='+oldZipvalue);
                                    system.debug('New version of values----->Address1='+account.address1__c+';City='+account.City__c+';State='+account.state__c+';Country='+account.country__c+';Zip='+account.zip__c);
                                    //retaining old version of field value to compare
                                    oldAddress1value = (account.address1__c).trim();
                                    oldAddress2value = account.address2__c;
                                    oldCityvalue = (account.City__c).trim();
                                    oldstatevalue = (account.state__c).trim();
                                    oldcontryvalue = (account.country__c).trim();
                                    oldZipvalue = (account.zip__c).trim();
                                    return null;
                                    
                                }
                    }
                }else{ 
                account.Address_Validation_Error__c  = accountAddress.Address_Validation_Error__c;
                account.Address_Validated__c = accountAddress.Address_Validated__c;
                }
            }
              
            update account;
            return new PageReference('/'+ account.Id);
            
          }
}