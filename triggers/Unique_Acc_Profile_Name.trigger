trigger Unique_Acc_Profile_Name on Account_Profile__c (before insert, before update) {
    boolean Log_Go = False;
    Id Tax_Type = Schema.SObjectType.Account_Profile__c.getRecordTypeInfosByName().get('TaxCertStatus').getRecordTypeId(); 
    // Line below Related to 00485655
    Id Log_Tax_Type = Schema.SObjectType.Log_Object__c.getRecordTypeInfosByName().get('Tax Exempt Email Notification').getRecordTypeId();
  if(Trigger.isInsert) {// This is to do the validation
     try {
      Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account_Profile__c; 
      Map<String,Schema.RecordTypeInfo> AccProfRecType = d1.getRecordTypeInfosByName();
      Id recType1=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
      for(Account_profile__c accp: trigger.new) {
          /* 10jun2015 Appirio,Inc S-306768 - do not overwrite Profile Unique Name when already supplied for tax cert status records */         
          accp.Profile_Unique_Name__c = accp.Profile_Unique_Name__c != null && accp.Name == 'Tax Certificate Status' ? accp.Profile_Unique_Name__c : accp.RecordTypeId +'-'+accp.Account__c;  
      }
    }catch(DMLException e){
      for (Account_Profile__c accp : trigger.new) {
        accp.addError('Account Profile For This Record Type Already Exists');
      }
    }
  }
  if(Trigger.isInsert || Trigger.isUpdate ) {
    Set<ID> ids= new Set<ID>();  
    List<Log_Object__c> Log_Inserts = New List<Log_Object__c>();
    for(Account_profile__c  ap:Trigger.New) {ids.add(ap.Account__c);}
      //Added 2 Fields to below SOQL query to populate Level 1 and level 2 Managers for an option to send email to related user - 00485655 
    Map<Id, Account> Owner_Acc_Map = new Map<Id, Account>([SELECT id, owner.name, owner.managerid, owner.manager.managerid from account where id in:ids]);
      Map<string, string> Upn_Log_Map = new Map<string, string>();
      // 2 Lines below related - 00485655 
        List<Log_Object__c> LOc = New List<Log_Object__c>([SELECT Profile_Unique_Name__c, Process_Fired__c from Log_Object__c where Related_Account__c in:Ids]);          
      	For(Log_Object__c pLOc: LOc) {UPn_Log_Map.put(string.valueof(pLOc.Profile_Unique_Name__c), string.valueof(pLOC.Process_Fired__c) );}
    for(Account_profile__c accp: trigger.new) {
      IF(Owner_Acc_Map.get(accp.Account__c) != null) {
        	accp.Account_Owner__c = Owner_Acc_Map.get(accp.Account__c).owner.name;
          	if(accp.RecordTypeId == Tax_Type) {
                // Lines below related - 00485655 
        		accp.Account_Owner_Manager__c = Owner_Acc_Map.get(accp.Account__c).owner.managerid;
        		accp.Account_Owner_Manager_Lvl_2__c = Owner_Acc_Map.get(accp.Account__c).owner.manager.managerid;
                //System.Debug('accp.Days_Until_Tax_Cert_Expires__c => ' + string.valueof(accp.Days_Until_Tax_Cert_Expires__c) + 'accp.Tax_Email_Required__c =>  ' + accp.Tax_Email_Required__c);
                //Added to check the Log Object for this Profile_Unique_Name__c + Tax_Day__c as a string value - Specific to this recordtype not an External ID                   
                    IF(accp.Days_Until_Tax_Cert_Expires__c <= 60 && accp.Days_Until_Tax_Cert_Expires__c > 0){
                        Accp.WF_Fired__c = Accp.Account__c + ' - Send Expiration Soon Email ' + accp.Tax_Day__c;     
                    	string PUN_TaxDay = '' + string.valueof(accp.Profile_Unique_Name__c) + '-' + string.Valueof(Accp.Expiration_Date__c) + '-' + string.valueof(accp.Tax_Day__c) + '';      
						if( Upn_Log_Map.get(PUN_TaxDay) != null  )  {
                            accp.Tax_Email_Required__c = False;
                            accp.WF_Fired__c = null;
                        }else {
                               accp.Tax_Email_Required__c = True;
                               Log_Object_Methods LOMs = new Log_Object_Methods();
                               Log_Inserts.add(LOMs.CreateLog(accp.WF_Fired__c, PUN_TaxDay , accp.Address_State__c, accp.Tax_Day_Exp_Date__c, accp.Account__c, Log_Tax_Type ));
                               Log_Go = true;
                    		  }
                	}Else{
                        Accp.WF_Fired__c = null;
                    	Accp.Tax_Email_Required__c = False;
                    }
                // End of Entire If Statement Related to - 00485655
      		}     
      }Else{
        system.debug('Account ID not found');
      }    
    }
// Entire Statement below Related to 00485655
	IF(Log_Go == true) {
      Database.SaveResult[] BulkLog_result = Database.Insert(Log_Inserts, false);
      
      for (Database.SaveResult BLr : BulkLog_result ) {
            if (!BLr.isSuccess()) {             
                for(Database.Error err : BLr.getErrors()) {
                    System.debug('Log Errors: ');
                    System.debug('The following error has occurred.');                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
//End of Entire Statement below Related to 00485655
      
  }
   
}