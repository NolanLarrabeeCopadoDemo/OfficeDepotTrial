global class QuoteUpdate{ 
 
 
   webservice static Id QuoteOperation(ServiceQuote serQuot) { 
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@ serQuot::'+serQuot);   

         Quote quot = new Quote();
         Set<String> TitleSet= new Set<String>();
	Try{  
         /* contact method */ 
         System.debug('REMARKS::'+serQuot.REMARKS);    
         if(serQuot.TOTAL_REBATE ==''||serQuot.TOTAL_REBATE==null){serQuot.TOTAL_REBATE='0.00';}
         if(serQuot.TOTAL_RETAIL ==''||serQuot.TOTAL_RETAIL==null){serQuot.TOTAL_REBATE='0.00';}
         if(serQuot.MISC ==''||serQuot.MISC ==null){serQuot.MISC ='0.00';}
         if(serQuot.AOPS_CUSTOMER_ID !=''){
                    serQuot.AOPS_CUSTOMER_ID = string.valueof(integer.ValueOf(serQuot.AOPS_CUSTOMER_ID));
         }
             
         Contact c;      
         if(serQuot.REMARKS == 'QUOTECUSOR'){
            c = setContactFields(serQuot);   
         }     
         String asid = string.valueof(integer.ValueOf(serQuot.AOPS_CUSTOMER_ID))+'-'+serQuot.CUSTOMER_SHIP_ID;
         List<Account> a = [select Id,Related_Account__c from  Account where Aops_seq_id__c =:asid limit 1];
         List<User> OppOwner = new List<User>();
         if(a.size()<1)
         {
           String excpName ='TECH DEPOT FALLOUT--110011';
           a = [select Id,Related_Account__c from  Account where name =:excpName limit 1];
         }
         User GmillOwner = new User();
             //if(SerQuot.QUOTE_SOURCE == 'G' && (SerQuot.GmillOwnerId != Null || SerQuot.GmillOwnerId != '')){ - Mohan CHnaged the below line
             if(SerQuot.QUOTE_SOURCE == 'G' && (SerQuot.GmillOwnerId != Null && SerQuot.GmillOwnerId != '')){
                 GmillOwner = [Select Id from user where OD_Employee_Id__C =: SerQuot.GmillOwnerId AND IsActive = true limit 1];
             }
         
         LisT<User> TSRUserList = new LisT<User>();
         List<Admin_Config__c> tech = new List<Admin_Config__c>();
         GmillOwner = Null; 
         if(GmillOwner == Null){
             tech = [Select Id,Tech_Depot_Title__c,Tech_Depot_Auto_Assign_Opp__c,Tech_Depot_User__c from Admin_Config__c where name ='Default'];
         }
         if((tech.size() >0)){
            for(String s:tech[0].Tech_Depot_Title__c.split(',')){
                TitleSet.add(s);
            }
         }  
    
         if(tech.size() > 0){
            TSRUserList=[SELECT Id, title from user where Short_Title__c IN : TitleSet AND Id IN (SELECT UserId from AccountTeamMember where AccountId =: a[0].Id) limit 100 ];                  
         }
        // Querried once for both the existing and new opportunities
         if(TSRUserList.size() < 1){
            if(tech.size() > 0){
                OppOwner = [SELECT id FROM User where Name =:tech[0].Tech_Depot_User__c];
            }
         }
        
         List<Quote> qotOppList = [select OpportunityId from quote where Quote_ID__c= :serQuot.QUOTE_ID and Opportunity.status__c!= 'Closed'  ];
         Set<String> OppIds= new Set<String>();

         for(Quote qt: qotOppList )
         { 
             OppIds.add(qt.OpportunityId);      
         }
         List<Opportunity> OpportunityList=[Select Id,Name from Opportunity where id IN : OppIds AND status__c != 'Closed' limit 100];
        
         list<opportunity> NuOppList= new list<opportunity>();
            // if((OpportunityList.size() < 1 )){
             if((OpportunityList.size() < 1 )&&(serQuot.REMARKS!='QUOTECUSCM')){
                 Opportunity opp = new Opportunity();
                 opp.Name = serQuot.QUOTE_NAME+' Quote Request';                
                  System.debug('Opportunity Onwer GmillOwner'+GmillOwner );
                 if(GmillOwner != Null && SerQuot.Quote_Source =='G'){
                  System.debug('Opportunity _ownerLogic depricated');
                     Opp.OwnerId = GmillOwner.Id;
                 }
                 
                 if(GmillOwner == Null){
                     if(TSRUserList.size() < 1 || !tech[0].Tech_Depot_Auto_Assign_Opp__c){                                     
                         System.debug('Assigning it to Salesforce'+TSRUserList.size()+'  '+tech[0].Tech_Depot_Auto_Assign_Opp__c);
                         opp.ownerId = OppOwner[0].id ;
                     }
                     else{ 
                     System.debug('Opportunity Owner ELSE CONTIONS');                 
                         opp.ownerId = TSRUserList[0].Id;
                     } 
                 }
                 
                 opp.Product__c ='Tech';
                 opp.Product_Subtype__c ='N/A';
                 opp.StageName = 'Pursue';
                 //  opp.CloseDate = Date.today();
                 opp.CloseDate =  date.parse(serQuot.CLOSE_DATE);
                 if(serQuot.QUOTE_SOURCE == 'G')
                     opp.LeadSource = 'GMILLquote';
                 //else if(serQuot.QUOTE_SOURCE == 'B' || serQuot.QUOTE_SOURCE == '' || serQuot.QUOTE_SOURCE == NULL)
                 else
                    opp.LeadSource = 'BSDNETquote';    
                 opp.Customer_Lifecycle__c = 'Penetration';
                 opp.Project_Ongoing__c = 'Project';

                 opp.Amount = Decimal.ValueOf((serQuot.TOTAL_RETAIL).replace(',','')) - Decimal.ValueOf((serQuot.TOTAL_REBATE).replace(',','')) + Decimal.ValueOf((serQuot.MISC).replace(',',''));
                 opp.AccountId =a[0].Related_Account__c;
                 opp.Related_Site__c=a[0].id;
                 NuOppList.add(opp);
                 insert NuOppList;
                 // setSubmitterContactFields(serQuot); 
                 quot = setQuoteFileds(serQuot,NuOppList[0].Id);                 
             }
             else{
                 for(Opportunity opp: OpportunityList){                                    
                     if(GmillOwner != NULL && SerQuot.Quote_Source == 'G'){
                     System.debug('Opportunity Owner - Update IF') ; 
                        // Opp.OwnerId = GmillOwner.Id; // Opportunity Owner should not be changed on Update Case #00209359
                     }
                     if(GmillOwner == NUll){
                     System.debug('Opportunity Owner - Update IF-2') ;                      
                         if(TSRUserList.size() < 1 || !tech[0].Tech_Depot_Auto_Assign_Opp__c){                                     
                            System.debug('Opportunity Owner - Update IF-3') ; 
                           //  opp.ownerId = OppOwner[0].id ; // Opportunity Owner should not be changed on Update Case #00209359
                         }
                         else{  
                         System.debug('Opportunity Owner - Update 4') ;                  
                            // opp.ownerId = TSRUserList[0].Id; // Opportunity Owner should not be changed on Update Case #00209359
                         } 
                     }
                     opp.Product__c ='Tech';
                     opp.StageName = 'Pursue';
                     // opp.CloseDate = Date.today();
                     opp.CloseDate = date.parse(serQuot.CLOSE_DATE);
                     if(serQuot.QUOTE_SOURCE == 'G')
                         opp.LeadSource = 'GMILLquote';                     
                     else
                         opp.LeadSource = 'BSDNETquote';                           
                     opp.Amount = Decimal.ValueOf((serQuot.TOTAL_RETAIL).replace(',','')) - Decimal.ValueOf((serQuot.TOTAL_REBATE).replace(',',''))+ Decimal.ValueOf((serQuot.MISC).replace(',',''));
                     //opp.Amount = Decimal.ValueOf((serQuot.TOTAL_AMOUNT).replace(',',''));//Decimal.ValueOf((serQuot.TOTAL_RETAIL).replace(',',''));
                     opp.Product_Subtype__c ='N/A';
                     opp.AccountId =a[0].Related_Account__c;
                     opp.Related_Site__c=a[0].id;
                     // if the quote is cancelled the Opportunity need to be reflected with the same
                     //28-04
                     if(serQuot.STATUS_DESC =='Quote Cancelled' ||  serQuot.STATUS == 'TQT9' || serQuot.STATUS == 'QT9' || serQuot.AOPS_QUOTE_STATUS == 'XXX')
                        { opp.StageName = 'Lost';
                          opp.Close_Reason__c = 'Delayed/Cancelled';
                          opp.CloseDate = Date.today();
                     }
                        
                          //28-04
                     /*if(serQuot.STATUS == 'TQT6' )
                        {
                        
                         opp.StageName = 'Lost';
                         opp.Close_Reason__c = 'Quote Expired';
                         opp.CloseDate = Date.today();
                        }
                     */   
                     if(serQuot.STATUS == 'QT6' || serQuot.AOPS_QUOTE_STATUS == 'EXP' )
                        {
                         opp.StageName = 'Lost';
                         opp.Close_Reason__c = 'Quote Expired';
                         opp.CloseDate = Date.today();
                      }  
                        // if the quote is Acceptedthe Opportunity need to be reflected with the same
                       if(serQuot.REMARKS == 'QUOTEACCPT' || serQuot.STATUS == 'N' || serQuot.AOPS_QUOTE_STATUS == 'ACC')
                       {
                          opp.StageName = 'Close';
                          opp.CloseDate = Date.today(); 
                          opp.close_reason__c ='Purchased';
                       }
                         
                        
                     NuOppList.add(opp);  
                                       
                 }                 
                 // setSubmitterContactFields(serQuot); 
                 quot = setQuoteFileds(serQuot,NuOppList[0].Id);   
                 try{         
                    update NuOppList;}catch (Exception e){
                    //Below code is very Important -- dont remove this
                    String qUpdate_json = JSON.serialize(serQuot);
                    updateExceptions(qUpdate_json,e.getMessage(),serQuot.QUOTE_ID);      
                 }
                 
             }

                
         
        
         //Insert/update submitter contact
        // calling Submitter contact method 
       
        // setSubmitterContactFields(serQuot); 
        // quot = setQuoteFileds(serQuot,NuOppList[0].Id);
          if(serQuot.REMARKS == 'QUOTECUSOR'){  
            if(c.Id != null){
                 quot.ContactId = c.Id;
                 quot.Email = c.Email;
                 quot.Phone = c.Phone;
             }
         }
         Update Quot;
    }
    catch(Exception e){
        System.Debug('Exception:'+e.getMessage());
        
        //Below code is very Important -- dont remove this
        String qUpdate_json = JSON.serialize(serQuot);
        updateExceptions(qUpdate_json,e.getMessage(),serQuot.QUOTE_ID);      
         //updateOpp(qUpdate_json );
        //END  code is very Important -- dont remove this

    }       
                   
         return quot.Id;
         
       
    }       
        
   private static Quote setQuoteFileds(ServiceQuote sQuot, String oId ){ 
        List<Quote> QuoteList = new List<Quote>();
        String aid ='';       
        Quote q; 
        // Checking if the quote exists or not
        QuoteList= [select name,Id, Status ,Account_Name__c,Description  from quote where Quote_ID__c =:sQuot.QUOTE_ID  and Opportunity.status__c!= 'Closed' ];
       // try{
         String asid =sQuot.AOPS_CUSTOMER_ID+'-'+sQuot.CUSTOMER_SHIP_ID;
         String excpName ='TECH DEPOT FALLOUT--110011';
           RecordType RecType=[SELECT id FROM RecordType where DeveloperName='Tech' AND SobjectType = 'Quote' LIMIT 1];
           List <Account> acc = [select Id,Name,Related_Account__c  from Account where  Aops_seq_id__c =:asid limit 1];
           List <Account> accExcp = [select Id,Name,Related_Account__c  from Account where  name =:excpName limit 1];
            if(acc.size()>0 )
            {
            aid= acc[0].Related_Account__c  ;
            asid = acc[0].id;
            }
            else
            {
            aid= accExcp[0].Related_Account__c  ;//adding default account
            asid = accExcp[0].id;
            }
            //if quote does not exist
            if(QuoteList.size()< 1 ){  
                q =new Quote();       
                q.Name = sQuot.QUOTE_NAME;
                q.opportunityId = oId ;
                q.Quote_ID__c = sQuot.QUOTE_ID;
                q.Status = sQuot.STATUS_DESC;
                q.Account_Number__c = sQuot.AOPS_CUSTOMER_ID;
                q.Total_Price__c = Decimal.ValueOf((sQuot.TOTAL_RETAIL).replace(',',''));
                q.Total_Rebate__c = Decimal.ValueOf((sQuot.TOTAL_REBATE).replace(',',''));
                if(sQuot.TOTAL_COST!= null && sQuot.TOTAL_COST!= '')              
                q.Total_Cost__c = Decimal.ValueOf((sQuot.TOTAL_COST).replace(',',''));
                q.Total__c = Decimal.ValueOf((sQuot.TOTAL_RETAIL).replace(',','')) - Decimal.ValueOf((sQuot.TOTAL_REBATE).replace(',','')) + Decimal.ValueOf((sQuot.MISC).replace(',',''));
                q.ExpirationDate = date.parse(sQuot.CLOSE_DATE);
                //q.recordtypeid='012M00000004breIAA';
                q.recordtypeid = RecType.Id;
                if(sQuot.COMMENT != ''){
                    q.Description = sQuot.COMMENT;
                }
                q.Misc_Charges__c   = Decimal.ValueOf((sQuot.MISC).replace(',',''));             
                insert q; 
                if(sQuot.COMMENT != ''){
                    Note note = new Note();
                    note.ParentId = q.Id;              
                   
                    if((sQuot.COMMENT).length()>70){  
                       note.Title='Tech Depot:'+(sQuot.COMMENT).substring(0,69);
                    }
                    else{
                       note.Title='Tech Depot:'+(sQuot.COMMENT);
                    }                  
                    note.IsPrivate = false;
                    note.Body =  sQuot.COMMENT + '  Reason: ' +sQuot.REMARKS ;
                    Insert note;
                } 
             
            
            }
            // if quote exists
            else{
                q = new Quote();            
                q.Id=QuoteList[0].Id;
                q.Status = sQuot.STATUS_DESC;
                if(sQuot.TOTAL_RETAIL!= null && sQuot.TOTAL_RETAIL!= '')
                q.Total_Price__c = Decimal.ValueOf((sQuot.TOTAL_RETAIL).replace(',',''));//Decimal.ValueOf((sQuot.TOTAL_AMOUNT).replace(',',''));//Decimal.ValueOf((sQuot.TOTAL_RETAIL).replace(',',''));
                q.Total_Rebate__c = Decimal.ValueOf((sQuot.TOTAL_REBATE).replace(',',''));
                if(sQuot.TOTAL_COST!= null && sQuot.TOTAL_COST!= '')
                q.Total_Cost__c = Decimal.ValueOf((sQuot.TOTAL_COST).replace(',',''));
                q.Total__c = Decimal.ValueOf((sQuot.TOTAL_RETAIL).replace(',','')) - Decimal.ValueOf((sQuot.TOTAL_REBATE).replace(',','')) + Decimal.ValueOf((sQuot.MISC).replace(',',''));
                q.ExpirationDate = date.parse(sQuot.CLOSE_DATE);
                q.Account_Number__c= sQuot.AOPS_CUSTOMER_ID;
                q.Name = sQuot.QUOTE_NAME;
                q.recordtypeid = RecType.Id;
                q.Misc_Charges__c   = Decimal.ValueOf((sQuot.MISC).replace(',',''));
                
                if(sQuot.REMARKS == 'QUOTEACCPT'){
                  q.Status= 'Accepted by Customer';
               }  
            //setting notes    
                if((QuoteList[0].Description != sQuot.COMMENT) && (sQuot.COMMENT != ''))
                {           
                    Note note = new Note();    
                    note.ParentId=q.Id;             
                  //note.owner = TechUserList[0];            
                    if((sQuot.COMMENT).length()>70)  
                        note.Title='Tech Depot:'+(sQuot.COMMENT).substring(0,69);
                    else
                        note.Title='Tech Depot:'+(sQuot.COMMENT);
                                              
                    note.IsPrivate = false;
                    note.Body =  sQuot.COMMENT + '  Reason: ' +sQuot.REMARKS ;
                    Insert note;
                 }
                 if(sQuot.COMMENT != ''){
                    q.Description = sQuot.COMMENT;
                }
                if(sQuot.STATUS_DESC == 'Quote Cancelled' || sQuot.REMARKS == 'QUOTEACCPT'){
                    q.ExpirationDate  = Date.today(); 
                }
                
                if(sQuot.AOPS_QUOTE_STATUS == 'EXP' || sQuot.STATUS == 'QT6'){
                    q.Status = 'Quote Expired';
                }
                if(sQuot.AOPS_QUOTE_STATUS == 'ACC' || sQuot.STATUS == 'N'){
                    q.Status = 'Accepted by Customer';
                }
                if(sQuot.AOPS_QUOTE_STATUS == 'XXX' || sQuot.STATUS == 'QT9'){
                    q.Status = 'Quote Cancelled';
                }
                
                
                update q;
            }
        
       
        return q;
    
    }
    
   //method to create/update contact
   private static Contact setContactFields(ServiceQuote sCont){ 
    
        if(sCont.CONTACT_PHONE == sCont.SUBMITTER_PHONE){
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@ Both Submitter and Contact is same');
            //Both the Submitter and the contact is same
        }
        
        /* ######## for contact update/insert ####### */
        Account acc1 = new Account();
        List<Contact> ContList = new List<Contact>(); 
        List<Contact> ContList_Contact = new List<Contact>(); 
        Contact AccountContact;
        Contact Cont = new Contact();
        Contact S = new Contact();
        Try{
        if((sCont.A0PS_CONTACT_NUMBER != '') && (sCont.A0PS_CONTACT_NUMBER != null)){ 
           ContList =[Select Id from Contact where AOPS_Contact_Number__c =: sCont.A0PS_CONTACT_NUMBER limit 10];
        }
           
           String asid =sCont.AOPS_CUSTOMER_ID+'-'+sCont.CUSTOMER_SHIP_ID;
           List <Account> accts = [select Id,Name,Related_Account__c  from Account where  Aops_seq_id__c =:asid limit 1];
           
            if(accts .size()<1){
                String excpName ='TECH DEPOT FALLOUT--110011';
                accts = [select Id,Related_Account__c from  Account where name =:excpName  and RecordType.Name ='Site' limit 1];
            } 

            
                
        if (accts.size() > 0){
            acc1=accts[0];
            ContList_Contact = [select id, lastname, firstname, AccountId,AOPS_Contact_Number__c,Phone,Email,AOPS_Account_Number__c from Contact where AccountId =:acc1.Related_Account__c];
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@Contact Size ==='+ContList_Contact.size());
            Boolean IsContactExist = false;
            for(Contact c: ContList_Contact){            
                if(c.Phone == sCont.CONTACT_PHONE){               
                    IsContactExist = true;
                    AccountContact = c;
                }
            }
            //This is quote Contact - Info
            if(IsContactExist){
                //Update the Existing Contact
                    Cont.Id = AccountContact.Id;
                    Cont.AccountId = acc1.Related_Account__c ;
                    Cont.FirstName = sCont.CONTACT_FNAME;
                    Cont.LastName = sCont.CONTACT_LNAME;
                    Cont.Phone = sCont.CONTACT_PHONE;
                    Cont.Email = sCont.CONTACT_EMAIL;
                    Cont.AOPS_Account_Number__c = sCont.AOPS_CUSTOMER_ID; 
                    if((sCont.CONTACT_LNAME != '')&&(sCont.CONTACT_LNAME != Null)){                 
                        Update Cont;
                    }
            }
            else{
                // Create a New contact
                    Cont.AccountId = acc1.Related_Account__c ;
                    Cont.FirstName = sCont.CONTACT_FNAME;
                    Cont.LastName = sCont.CONTACT_LNAME;
                    Cont.Phone = sCont.CONTACT_PHONE;
                    Cont.Email = sCont.CONTACT_EMAIL;
                    Cont.AOPS_Account_Number__c = sCont.AOPS_CUSTOMER_ID;
                    if((sCont.CONTACT_LNAME != '')&&(sCont.CONTACT_LNAME != Null)){
                        Insert Cont;
                    }
            
            }
                
            //This is a Submitter  INfo -- That need to be linked to the Account only   
            if(ContList.size() < 1){   
                    s.AccountId = acc1.Related_Account__c ;
                    s.AOPS_Contact_Number__c= sCont.A0PS_CONTACT_NUMBER; 
                    s.FirstName = sCont.SUBMITTER_FNAME;
                    s.LastName = sCont.SUBMITTER_LNAME;
                    s.Phone = sCont.SUBMITTER_PHONE;
                    s.Email = sCont.SUBMITTER_EMAIL;
                    s.AOPS_Account_Number__c = sCont.AOPS_CUSTOMER_ID;
                    if((sCont.SUBMITTER_LNAME != '')&&(sCont.SUBMITTER_LNAME != Null)){
                        Insert s;
                    }
            }else{ // Submitter is existing in system  - So updating the Information
                if(s.Id != ContList[0].Id || s.FirstName != sCont.SUBMITTER_FNAME || s.LastName != sCont.SUBMITTER_LNAME ||  s.Phone != sCont.SUBMITTER_PHONE || s.Email != sCont.SUBMITTER_EMAIL ){
                    s.Id = ContList[0].Id;
                    
                    s.AccountId = acc1.Related_Account__c ;
                    s.AOPS_Contact_Number__c = sCont.A0PS_CONTACT_NUMBER;
                    s.FirstName = sCont.SUBMITTER_FNAME;
                    s.LastName = sCont.SUBMITTER_LNAME;
                    s.Phone = sCont.SUBMITTER_PHONE;
                    s.Email = sCont.SUBMITTER_EMAIL;
                    s.AOPS_Account_Number__c = sCont.AOPS_CUSTOMER_ID; 
                    if((sCont.SUBMITTER_LNAME != '')&&(sCont.SUBMITTER_LNAME != Null)){                 
                        Update s; 
                    }   
                }
                    
            }
          } 
          } catch(Exception e){
               System.Debug('Exception:'+e.getMessage());
              //Below code is very Important -- dont remove this
                String qUpdate_json = JSON.serialize(sCont);
                updateExceptions(qUpdate_json,e.getMessage(),sCont.QUOTE_ID);      
           }  
          return cont;
     }
    
 
    
   /* Future call out to avoid the timing issue*/
   @future 
   static void updateOpp(String sq) {
       //Seep for a while if its an update call
       ServiceQuote obj = (ServiceQuote) Json.deserialize(sq, ServiceQuote.class);
       QuoteUpdate.QuoteOperation(obj);
   }
   
   private static void updateExceptions(String SOAMsg, String Exc, String QuoteID){
        SOA_Exception__c se = new SOA_Exception__c();
        se.Exceptions_Msg__c = Exc;
        se.SOAFeed__c = SOAMsg;
        se.Quote_ID__c = QuoteID;
       insert se;
   
   }        

   global class ServiceQuote{
   
        webservice String AOPS_CUSTOMER_ID ;
        webservice String QUOTE_NAME ;
        webservice String QUOTE_ID ;
        webservice String STATUS;
        webservice String CREATION_DATE ;
        webservice String LAST_UPDATE_DATE;
        webservice String CLOSE_DATE;
        webservice String QUANTITY ;
        webservice String TOTAL_AMOUNT ;
        webservice String TOTAL_COST;
        webservice String COMMENT ;
        webservice String CONTACT_FNAME ;
        webservice String CONTACT_LNAME;
        webservice String CONTACT_PHONE;
        webservice String CONTACT_EMAIL;
        webservice String A0PS_CONTACT_NUMBER;
        webservice String TOTAL_RETAIL;
        webservice String SUBMITTER_FNAME;
        webservice String SUBMITTER_LNAME;
        webservice String SUBMITTER_ROLE;
        webservice String SUBMITTER_PHONE;
        webservice String SUBMITTER_EMAIL ;
        webservice String SUBMITTER_USERNAME ;
        webservice String CUSTOMER_SHIP_ID;
        webservice String LINK_TO_BSD_SITE;
        webservice String REMARKS;
        webservice String DELIVERY_CHARGE;
        webservice String STATUS_DESC;
        webservice String TOTAL_REBATE;
        webservice String MISC;
        webservice String QUOTE_SOURCE;
        webservice String AOPS_QUOTE_STATUS;
        webservice String GmillOwnerId;
        webservice String IGM;
            
         
    }


}