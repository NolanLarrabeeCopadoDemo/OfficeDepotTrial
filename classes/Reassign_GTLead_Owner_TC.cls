@isTest
private class Reassign_GTLead_Owner_TC {
    
    static testMethod void myUnitTest_olddata() 
    {
    	List <lead> lds = new List<lead>();
        
    	String DEFAULT_USER = 'salesforce';
    	User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
       
        recordtype rctyp1 = [SELECT Id, Name, DeveloperName from recordtype where sobjecttype = 'Lead' and developername = 'Lead_Canada'];

        user usr1 = [SELECT id, managerid, manager__c FROM user where managerid != null and isactive=true and manager.isactive = true and profile.name='Field Sales' and manager.profile.name = 'Field Sales' LIMIT 1];
   
        lead ld=new lead ();
        ld.lastname='testlead1';
        ld.company='testcompany1';
        ld.zip__c='12345';
        ld.Status='Open';       
        ld.OwnerId = usr1.id;//UserInfo.getUserId();//'005f00000029YS6AAM';
        ld.Lead_72_Hr_Counter__c = 0;
        ld.WCW_Count__c = 120;
        ld.recordtypeid = rctyp1.id;       
        ld.Time_of_non_API_User_Modification__c = System.now()-3;
        
        lds.add(ld);

    	insert lds;    	
        
    	test.startTest();

		system.debug('before lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c + 
                     ' createddate:' + ld.CreatedDate + ' New_Date_time__c:' + ld.New_Date_time__c);                		        
        
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';                        
        
        Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner(strQuery);               
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 73;
        database.executebatch(assignBatch1, 10);
        
        system.debug('After executebatch.................');               
        system.debug('After lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c);
		  
        
        test.StopTest();
        
    }
    
    static testMethod void myUnitTest_48hrs() 
    {
    	List <lead> lds = new List<lead>();
        
    	String DEFAULT_USER = 'salesforce';
    	User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
        
		user usr1 = [SELECT id, managerid, manager__c FROM user where managerid != null and isactive=true and manager.isactive = true and profile.name='Field Sales' and manager.profile.name = 'Field Sales' LIMIT 1];
        recordtype rctyp1 = [SELECT Id, Name, DeveloperName from recordtype where sobjecttype = 'Lead' and developername = 'Lead_Canada'];
    
        
        lead ld=new lead ();
        ld.lastname='testlead1';
        ld.company='testcompany1';
        ld.zip__c='12345';
        ld.Status='Open';  
        ld.OwnerId = usr1.id;//UserInfo.getUserId();//'005f00000029YS6AAM';
        ld.Lead_72_Hr_Counter__c = 0;
        ld.WCW_Count__c = 120;
        ld.recordtypeid = rctyp1.id;        
        ld.Time_of_non_API_User_Modification__c = System.now()-3;
        
        lds.add(ld);
 
    	insert lds;    	
        
    	test.startTest();

		system.debug('before lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c + 
                     ' createddate:' + ld.CreatedDate + ' New_Date_time__c:' + ld.New_Date_time__c);                		        
        
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';                        
        
        Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner(strQuery);               
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 50;
        database.executebatch(assignBatch1, 10);
        
        system.debug('After executebatch.................');               
        system.debug('After lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c);
		  
        
        test.StopTest();
        
    }
    
    static testMethod void myUnitTest_73hrs() 
    {
    	List <lead> lds = new List<lead>();
        
    	String DEFAULT_USER = 'salesforce';
    	User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
    	user usr1 = [SELECT id, managerid, manager__c FROM user where managerid != null and isactive=true and manager.isactive = true and profile.name='Field Sales' and manager.profile.name = 'Field Sales' LIMIT 1];
        recordtype rctyp1 = [SELECT Id, Name, DeveloperName from recordtype where sobjecttype = 'Lead' and developername = 'Lead_Canada'];
        
          
        lead ld=new lead ();
        ld.lastname='testlead1';
        ld.company='testcompany1';
        ld.zip__c='12345';
        ld.Status='Open';
    
        ld.OwnerId = usr1.id;//UserInfo.getUserId();//'005f00000029YS6AAM';
        ld.Lead_72_Hr_Counter__c = 1;
        ld.WCW_Count__c = 120;
        ld.recordtypeid = rctyp1.id;         
        ld.Time_of_non_API_User_Modification__c = System.now()-3;
        
        lds.add(ld);
        
       
   
    	insert lds;    	
        
    	test.startTest();

		system.debug('before lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c + 
                     ' createddate:' + ld.CreatedDate + ' New_Date_time__c:' + ld.New_Date_time__c);                		        
        
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';                        
        
        //Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner(strQuery);
        Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner();               
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 50;
        database.executebatch(assignBatch1, 10);
        
        system.debug('After executebatch.................');               
        system.debug('After lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c);
		  
        
        test.StopTest();
        
    }
    
    static testMethod void myUnitTest_Schedulabletest() 
    {
        test.startTest();
        
    	List <lead> lds = new List<lead>();
        
    	String DEFAULT_USER = 'salesforce';
    	User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
       
        recordtype rctyp1 = [SELECT Id, Name, DeveloperName from recordtype where sobjecttype = 'Lead' and developername = 'Lead_Canada'];
        user usr1 = [SELECT id, managerid, manager__c FROM user where managerid != null and isactive=true and manager.isactive = true and profile.name='Field Sales' and manager.profile.name = 'Field Sales' LIMIT 1];
         
        lead ld=new lead ();
        ld.lastname='testlead1';
        ld.company='testcompany1';
        ld.zip__c='12345';
        ld.Status='Open';  
        ld.OwnerId = usr1.id;//UserInfo.getUserId();//'005f00000029YS6AAM';
        ld.Lead_72_Hr_Counter__c = 1;
        ld.WCW_Count__c = 120;
        ld.recordtypeid = rctyp1.id;        
        ld.Time_of_non_API_User_Modification__c = System.now()-3;
        
        lds.add(ld);
        
       
   
    	insert lds;    	
        
    	

		system.debug('before lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c + 
                     ' createddate:' + ld.CreatedDate + ' New_Date_time__c:' + ld.New_Date_time__c);                		        
        
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';                        
        
        SchedulableContext sc = null;
        Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner();               
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 50;
        assignBatch1.execute(sc);
        
        system.debug('After executebatch.................');               
        system.debug('After lead1 record type:' + ld.recordtype.DeveloperName + ' Status:' + ld.status +
                     ' Lead_72_Hr_Counter__c:' + ld.Lead_72_Hr_Counter__c + ' WCW_Count__c:' + ld.WCW_Count__c);
		  
        
        test.StopTest();
        
    }



}