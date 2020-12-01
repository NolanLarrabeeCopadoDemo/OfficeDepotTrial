public class WRFtaskCreation {
    
   public static ID caseid {get;set;}
   Public list<WRF_Task__c> TaskToSavelst{get;set;}
   Date myDate = system.today();  
   public list<WRF_Task__c> taskcreatelist = new list<WRF_Task__c>();
   public list<WRF_Task__c> tskListRepDispCRFPRec = new list<WRF_Task__c>();
   public list<WRF_Task__c> createCustomCoreRequestList = new list<WRF_Task__c>();
   public list<WRF_Task__c> createHostedWrfList = new list<WRF_Task__c>();
   public list<WRF_Task__c> createLeaderWrfList = new list<WRF_Task__c>();

// start of 00658900 
    public void createCustomCoreRequest (List<case> cases)    
    {
        for(Case cs : Cases){
            
            // Creating WRF Task for Rebates
            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = 'Rebates',
            Assignment_Group__c = 'Rebates',
            Due_Date__c = myDate.addDays(14),
            Priority__c = 'Normal',
            Status__c = 'Not Started',
            Notification_Group__c = 'raji.mathew@officedepot.com',
            WRF_Stage__c = 'Not Started');
            createCustomCoreRequestList .add(wrf);
            
            
            // Creating WRF Task for Pricing
            WRF_Task__c wrf1 = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = '',
            Assignment_Group__c = 'OD N Pricing/Bids/Remediation',
            Assigned_To__c = label.Rich_Mumford ,
            Notification_Group__c = 'raji.mathew@officedepot.com',
            Due_Date__c = myDate.addDays(14),
            Priority__c = 'Normal',
            Status__c = 'Not Started',
            WRF_Stage__c = 'Not Started');
            createCustomCoreRequestList.add(wrf1);
            
            
            // Creating WRF Task for legal
            WRF_Task__c wrf3 = new WRF_Task__c();
            wrf3.WRF__c = cs.id;
            wrf3.Disposition_Code__c = 'Legal';
            wrf3.Assignment_Group__c = 'Legal';
            wrf3.Notification_Group__c = 'raji.mathew@officedepot.com';
            wrf3.Due_Date__c = myDate.addDays(14);
            wrf3.Priority__c = 'Normal';
            wrf3.Status__c = 'Not Started';
            wrf3.WRF_Stage__c = 'Not Started';
            createCustomCoreRequestList.add(wrf3);
            
        }
        if( createCustomCoreRequestList.size() > 0){
            insert createCustomCoreRequestList;  
        }
    }
        
    //Case-00658900 - End


    //Case-00511627 - Start      
    
    public void taskRepDispCRFPRec(List<case> cases)    
    {
        for(Case cs : Cases){
            
            // Creating WRF Task for Rebates
            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = 'Rebates',
            Assignment_Group__c = 'Rebates',
            Due_Date__c = myDate.addDays(14),
            Priority__c = 'Normal',
            Status__c = 'Not Started',
            Notification_Group__c = 'raji.mathew@officedepot.com',
            WRF_Stage__c = 'Not Started');
            tskListRepDispCRFPRec.add(wrf);
            
            
            // Creating WRF Task for Pricing
            WRF_Task__c wrf1 = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = '',
            Assignment_Group__c = 'OD N Pricing/Bids/Remediation',
            Assigned_To__c = label.Rich_Mumford ,
            Notification_Group__c = 'raji.mathew@officedepot.com',
            Due_Date__c = myDate.addDays(14),
            Priority__c = 'Normal',
            Status__c = 'Not Started',
            WRF_Stage__c = 'Not Started');
            tskListRepDispCRFPRec.add(wrf1);
            
            // Creating WRF Task for Implementation Group
            WRF_Task__c wrf2 = new WRF_Task__c();
            wrf2.WRF__c = cs.id;
            wrf2.Disposition_Code__c = 'Implementation';
            wrf2.Assignment_Group__c = 'Implementation';
            wrf2.Notification_Group__c = 'raji.mathew@officedepot.com';
            wrf2.Due_Date__c = myDate.addDays(14);
            wrf2.Priority__c = 'Normal';
            wrf2.Status__c = 'Not Started';
            wrf2.WRF_Stage__c = 'Not Started';
            tskListRepDispCRFPRec.add(wrf2);
            
            // Creating WRF Task for legal
            WRF_Task__c wrf3 = new WRF_Task__c();
            wrf3.WRF__c = cs.id;
            wrf3.Disposition_Code__c = 'Legal';
            wrf3.Assignment_Group__c = 'Legal';
            wrf3.Notification_Group__c = 'raji.mathew@officedepot.com';
            wrf3.Due_Date__c = myDate.addDays(14);
            wrf3.Priority__c = 'Normal';
            wrf3.Status__c = 'Not Started';
            wrf3.WRF_Stage__c = 'Not Started';
            tskListRepDispCRFPRec.add(wrf3);
            
        }
        if( tskListRepDispCRFPRec.size() > 0){
            insert tskListRepDispCRFPRec;  
        }
    }
    
    
    
    //Case-00498003 - End
    public void taskaggdisp(List<case> cases)    
    {
        for(Case cs : Cases){
            
            // Creating WRF Task for Rebates
            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
                                            Disposition_Code__c = 'Rebates',
                                            Assignment_Group__c = 'Rebates',
                                            Assigned_To__c = label.Colleen_Shivley,
                                            Due_Date__c = myDate.addDays(14),
                                            Priority__c = 'Normal',
                                            Status__c = 'Not Started',
                                            //Notification_Group__c = 'raji.mathew@officedepot.com',
                                            Notification_Group__c = 'HQrebates.team@officedepot.com',
                                            WRF_Stage__c = 'Not Started');
            taskcreatelist.add(wrf);
            
            // Creating WRF Task for Pricing
            WRF_Task__c wrf1 = new WRF_Task__c(WRF__c = cs.id,
                                            Disposition_Code__c = 'OD N Remediation',
                                            Assignment_Group__c = 'OD N Pricing/Bids/Remediation',
                                            //Assigned_To__c = label.Rich_Mumford ,
                                            //Notification_Group__c = 'raji.mathew@officedepot.com',
                                            Due_Date__c = myDate.addDays(14),
                                            Priority__c = 'Normal',
                                            Status__c = 'Not Started',
                                            WRF_Stage__c = 'Not Started');
            taskcreatelist.add(wrf1);
            
            // Creating WRF Task for Development
            WRF_Task__c wrf2 = new WRF_Task__c(WRF__c = cs.id,
                                            Disposition_Code__c = 'Development',
                                            Assignment_Group__c = 'Contract Development',
                                            Assigned_To__c = label.Andrew_Wiley,
                                            //Notification_Group__c = 'raji.mathew@officedepot.com',
                                            Notification_Group__c = 'condev@officedepot.com',
                                            Due_Date__c = myDate.addDays(14),
                                            Priority__c = 'Normal',
                                            Status__c = 'Not Started',
                                            WRF_Stage__c = 'Not Started');
            taskcreatelist.add(wrf2);
        }
        if (taskcreatelist.size() > 0) {
            insert taskcreatelist;  
        }
    }
    
    public void WrfCreation (List<case> cases)    
    {  
    System.debug('&&&&&&&&&&&&entered here'+cases);
       for (Case cs : Cases) {
       TaskToSavelst = new list<WRF_Task__c>();
        
        //Changing the assigned to as per ticket 00611053 
        
        // Creating WRF Task for Implementation Group
  /*      WRF_Task__c wrf = new WRF_Task__c();
        wrf.WRF__c = cs.id;
        wrf.Disposition_Code__c = 'Implementation';
        wrf.Assignment_Group__c = 'Implementation';
                //wrf.Assigned_To__c = label.Laura_Hammer;
        wrf.Assigned_To__c = label.John_Rogers;
        wrf.Notification_Group__c = 'istrans@officedepot.com ';
        wrf.Due_Date__c = myDate.addDays(14);
        wrf.Priority__c = 'Normal';
        wrf.Status__c = 'Not Started';
        wrf.WRF_Stage__c = 'Not Started';
        TaskToSavelst.add(wrf);
  */      
        // Creating WRF Task for Contract Development Group
        WRF_Task__c wrf2 = new WRF_Task__c();
        wrf2.WRF__c= cs.id;
        wrf2.Disposition_Code__c = 'Development';
        wrf2.Assignment_Group__c = 'Contract Development';
        wrf2.Assigned_To__c = label.Andrew_Wiley;
        wrf2.Notification_Group__c = 'condev@officedepot.com';
        wrf2.Due_Date__c = myDate.addDays(14);
        wrf2.Priority__c = 'Normal';
        wrf2.Status__c = 'Not Started';
        wrf2.WRF_Stage__c = 'Not Started';
        TaskToSavelst.add(wrf2);
        
        // Creating WRF Task for Lifecycle/Remediation Group
        WRF_Task__c wrf3 = new WRF_Task__c();
        wrf3.WRF__c = cs.id;
        wrf3.Disposition_Code__c = 'Transition';
        ///wrf3.Assignment_Group__c = 'Lifecycle/Remediation';
        
        // commenting below line 00788642 
       /////// wrf3.Assigned_To__c = label.Rich_Mumford;
        wrf3.Notification_Group__c = 'customertransitionrequests@officedepot.com ';
        //- Updated Due to Validation Rule "Disposition_Code_and_Assignment_Group"
        wrf3.Assignment_Group__c = 'Transition Team';
        wrf3.Due_Date__c = myDate.addDays(14);
        wrf3.Priority__c = 'Normal';
        wrf3.Status__c = 'Not Started';
        wrf3.WRF_Stage__c = 'Not Started';
        TaskToSavelst.add(wrf3);
        
        
                // Creating WRF Task for Lifecycle/Remediation Group
  /*      WRF_Task__c wrf4 = new WRF_Task__c();
        wrf4.WRF__c = cs.id;
        wrf4.Disposition_Code__c = 'Rebates';
        ///wrf3.Assignment_Group__c = 'Lifecycle/Remediation';
        wrf4.Assigned_To__c = label.Colleen_Shivley;
        wrf4.Notification_Group__c = 'HQrebates.team@officedepot.com';
        wrf4.Assignment_Group__c = 'Rebates';
        wrf4.Due_Date__c = myDate.addDays(14);
        wrf4.Priority__c = 'Normal';
        wrf4.Status__c = 'Not Started';
        wrf4.WRF_Stage__c = 'Not Started';
        TaskToSavelst.add(wrf4);
    */
        
        
        if( TaskToSavelst.size() > 0)
        {
            insert TaskToSavelst;  
        } 
      }   
   }
   
   
   // Story - 00978146 Start
   public void hostedWrfCreation (List<case> cases) {
       
       for (Case cs : Cases) {
           
           
            WRF_Task__c hwrf = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = 'Hosted Catalog',
            Assignment_Group__c = 'BSD Pricing',
            Due_Date__c = myDate,
            Priority__c = 'Normal',
            Status__c = 'Not Started');
            createHostedWrfList.add(hwrf);
            insert createHostedWrfList;
               
       }
   } 
   // Story - 00978146 End
   
   //Story - NAIT-109874 Start
   
    public void leaderWrfCreation (List<case> cases) {
       
       for (Case cs : Cases) {
           
           
            WRF_Task__c lwrf = new WRF_Task__c(WRF__c = cs.id,
            Disposition_Code__c = 'Leader/Follower SKU Change',
            Assignment_Group__c = 'BSD Pricing',
            Due_Date__c = myDate,
            Priority__c = 'Normal',
            Status__c = 'Not Started');
            createLeaderWrfList.add(lwrf);
            insert createLeaderWrfList;
               
       }
   } 
   //Story - NAIT-109874 End
   
   
   // creation of task only for Pricing NORTH team and Implementation team 
      /* public void WrfCreationWithFilter (List<case> cases)    
    {  
        list<WRF_Task__c> TaskToSavelstFilter;
        System.debug('&&&&&&&&&&&&entered here'+cases);
       for (Case cs : Cases) {
       TaskToSavelstFilter = new list<WRF_Task__c>();
        
        //Changing the assigned to as per ticket 00611053 
        
        // Creating WRF Task for Implementation Group
        WRF_Task__c wrf = new WRF_Task__c();
        wrf.WRF__c = cs.id;
        wrf.Disposition_Code__c = 'Implementation';
        wrf.Assignment_Group__c = 'Implementation';
        //wrf.Assigned_To__c = label.Laura_Hammer;
        wrf.Assigned_To__c = label.John_Rogers;
        wrf.Notification_Group__c = 'istrans@officedepot.com ';
        wrf.Due_Date__c = myDate.addDays(14);
        wrf.Priority__c = 'Normal';
        wrf.Status__c = 'Not Started';
        wrf.WRF_Stage__c = 'Not Started';
        TaskToSavelstFilter.add(wrf);
        
       //Creating WRF Task for Pricing NORTH Group
        WRF_Task__c wrf1= new WRF_Task__c();
        wrf1.WRF__c = cs.id;
        wrf1.Disposition_Code__c = 'OD N Remediation';
        wrf1.Assignment_Group__c = 'OD N Pricing/Bids/Remediation';
        //wrf1.Assigned_To__c = label.Laura_Hammer;
        wrf1.Assigned_To__c = label.John_Rogers;
        wrf1.Notification_Group__c = 'istrans@officedepot.com ';
        wrf1.Due_Date__c = myDate.addDays(14);
        wrf1.Priority__c = 'Normal';
        wrf1.Status__c = 'Not Started';
        wrf1.WRF_Stage__c = 'Not Started';
        TaskToSavelstFilter.add(wrf1);
       }
        if( TaskToSavelstFilter.size() > 0)
        {
            system.debug('listsize'+TaskToSavelstFilter.size());
            insert TaskToSavelstFilter;  
        } 
         
   }*/
   
}