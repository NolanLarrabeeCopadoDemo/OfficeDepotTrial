// This trigger is to manage teh values of user when created or Updated from People soft Feed
trigger userKeyUpdate on User (before insert, before update) 
{
        List<User> errorRecords = new List<User>(); // Records with CWR in Title
        profile p =[select id from profile where name='partner community user custom'];// querying profile id of partner community profile.
        for (User user :Trigger.New) 
        {
                if (Trigger.isInsert)
                        {
                            // Set the default keys if blank
                            if (user.TimeZoneSidKey == null || user.TimeZoneSidKey == '')
                            {
                                user.TimeZoneSidKey = 'America/New_York';
                            }   
                            if (user.EmailEncodingKey== null || user.EmailEncodingKey== '')
                            {   
                                user.EmailEncodingKey='ISO-8859-1';
                            }
                            
                            // Prevernt user creation from PeopleSoft of contractors or store managers
                            String currentUser = UserInfo.getUserName() ;
                            //Updated by Shubham for the Case 00149839
                            if (currentUser.contains('dataloader') && user.Title != null && (user.Title.contains('CWR') || user.Title.contains('Store') 
                                || user.Title.contains('Liaison'))) {
                                errorRecords.add(user);
                            }
                        }
                
                if (Trigger.isInsert || Trigger.isUpdate)
                {             
                    // bypassing partner community profile.
                    if (user.profileid != p.id) {
                    	if(user.Alternate_Email__c != '' && user.Alternate_Email__c != null && user.email != user.Alternate_Email__c ) {
                           user.email = user.Alternate_Email__c ;
                      	}
                    }
                    //Assign to Chatter user if no profile Id is retrieved
                    if (user.profileid == null  )
                    {
	                    user.profileid = label.Profile_Id_Chatter_Free_User;
                    }
                    System.debug('&&&&&&&&&&&&&&&&profe'+user.profileid);
                     //System.debug('&&&&&&&&&&&&&&&&new profile'+trigger.NewMap.get(user.id).profileId); - Commented by Najma since the test classes were failing due to this
                    
                    if (user.profileid == null  )
                    {
	                    user.profileid = label.Profile_Id_Chatter_Free_User;
                    }
                
                    if(Trigger.isUpdate) {               
                        String oldprofile=trigger.oldMap.get(user.id).profileId;
                        
                        oldprofile=oldprofile.substring(0,15);
                        
                       System.debug('&&&&&&&&&&&&&&&&oldprofile'+oldprofile);

                        String newprofile=user.profileid;
                        newprofile=newprofile.substring(0,15);
                        
                         System.debug('&&&&&&&&&&&&&&&&newprofile'+newprofile);
                        
                        
                        if(  (oldprofile==label.Profile_ID_Chatter_Only_User  || oldprofile==label.Profile_ID_Ideation_Suport)  && newprofile == label.Profile_Id_Chatter_Free_User )                 
                            user.profileId=oldprofile;
                        
                        // Deactivate cwr with chatter free license
                        if (user.profileId != null) {
                            string profId = user.profileId;
                            
                            if (user.Title != null) {
                              //Updated by Shubham for the Case 00149839
                              if ((user.Title.contains('CWR') || user.Title.contains('Store') || user.Title.contains('Liaison')) && profId.substring(0,15) == label.Profile_Id_Chatter_Free_User) 
                               {
                                user.IsActive = false;
                               }
                            }
                        }
                        
                        
                        System.debug('before loop'+trigger.oldMap.get(user.id).profileId);
                        // If going from standard to chatter license
                        if (newprofile == label.Profile_Id_Chatter_Free_User  &&  trigger.oldMap.get(user.id).profileId!=user.profileId ) {                       
                                       System.debug('Inside loop');
                                    
                                        user.OD_employee_id__c = 'xx' + user.OD_employee_id__c;
                                        user.FederationIdentifier = 'xx' + user.FederationIdentifier;
                                        user.Username = 'xx' + user.Username;
                                        user.Email = 'xx' + user.Email;
                                        user.isActive = false;
                                        user.profileId = trigger.oldMap.get(user.id).profileId;                                                                                                      
                        }
                            
 
                     }         
                                   
                    if(user.FirstName!='' && user.lastname!='' && user.FirstName!=null && user.lastname!=null)
                    {
                      if(user.alias== null  || user.alias==''){
                    
                        string alia1 = user.FirstName.substring(0,1);
                        integer len = user.lastname.length();
                        
                        if(len>=5)
                        {
                            alia1 = alia1 + user.lastname.substring(0,4);
                        }else
                        {
                            alia1 = alia1 + user.lastname.substring(0,len);
                        }
                                               user.Alias = alia1;
                                               
                     }                          
                        
                        if(user.CommunityNickname==null || user.CommunityNickname==''){
                            user.CommunityNickname = user.lastname+'.'+user.FirstName+'.od'+user.OD_Employee_Id__c;
                        }
                    }
                }
                system.debug('Deepak:' + user.profileid);
        }
        // Records with CWR in Title
        if (!(errorRecords.isEmpty()))
        {
            for (User eachErrorUser : errorRecords) {
                eachErrorUser.addError('Contractor cannot be created');
            }
        }
        
        

}