global class UserLoginData_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select id, Name, UserName, Profile.Name, LastLoginDate, Second_Last_Login_Date__c, isActive, Training_Date__c, Week_1_Login__c, Week_2_Login__c, Week_3_Login__c, Week_4_Login__c FROM User where isActive = true and LastLoginDate != null';
    

    /* Default Constructor*/
    global UserLoginData_Batch()
    {
    	this.strQuery = DEFAULT_QUERY;
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global UserLoginData_Batch(String query)
    {
        System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    	
        List<User> lstUsers = scope;
        System.debug('SIZE LIST USERS == '+lstUsers.size());
        //Set<String> setEmpIds = new Set<String>(); // this set to store OD employee Id to select user records
        //Set<String> setRoleRelatedIds = new Set<String>(); // set of Role related ids

        //try
        //{
        	Date dt01012006 = Date.newInstance(2006, 1,1);
        	List<Login_History_2__c> lstLoginHistory = new List<Login_History_2__c>();
            // loop on the batch scope        
            for(User objUser: lstUsers)
            {
            	System.debug('USER NAME == ' +objUser.Name);
            	// if user has logged in after the previous login ( as per batch job)
            	if(objUser.Second_Last_Login_Date__c != objUser.LastLoginDate.date())
            	{
            		if(objUser.Training_Date__c != null)
            		{
		            	Integer trainingWeek = Math.MOD(Integer.valueOf(Math.FLOOR((dt01012006.daysBetween(objUser.Training_Date__c))/7)),52)+1;
		            	Integer loginWeek = Math.MOD(Integer.valueOf(Math.FLOOR((dt01012006.daysBetween(objUser.LastLoginDate.date()))/7)),52)+1;// 
		            	Integer weekDifference =  loginWeek - trainingWeek;
		            	if(weekDifference == 1)
		            		objUser.Week_1_Login__c = 'Yes';
		            	if(weekDifference == 2)
		            		objUser.Week_2_Login__c = 'Yes';
		            	if(weekDifference == 3)
		            		objUser.Week_3_Login__c = 'Yes';
		            	if(weekDifference == 4)
		            		objUser.Week_4_Login__c = 'Yes';
						System.debug('USER NAME == ' +objUser.Name+ 'Trainng date = '+ objUser.Training_Date__c + '  and week = ' +String.valueOf(trainingWeek));
            		}
					objUser.Second_Last_Login_Date__c = objUser.LastLoginDate.date(); // if both are not same
	
					Login_History_2__c logHistory = new Login_History_2__c();
					logHistory.User_Name__c = objUser.UserName; 
					logHistory.User__c = objUser.Id;
					logHistory.Login_Date__c = objUser.LastLoginDate.date();
					logHistory.Last_Login_Date__c = objUser.LastLoginDate;
					
					lstLoginHistory.add(logHistory);
            	}
            }

            insert lstLoginHistory;
            update lstUsers;
/*        }
        catch(Exception ex)
        {
            System.debug('WHY ERROR CAME here = '+ex.getMessage());
            Util.LOG('UserLoginData_Batch.execute', -1, ex.getMessage());
        }
*/
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // not required
    }
    
  

    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        UserLoginData_Batch loginBatch = new UserLoginData_Batch();
        database.executebatch(loginBatch, 500);
    } 


}