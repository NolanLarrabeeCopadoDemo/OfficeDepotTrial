Public Class QxCPQQuoteTrigger_CustApprovalHandler
{
    Public  void BeforeUpdate(List<CameleonCPQ__QxQuote__c> NewRecs,Map<Id,CameleonCPQ__QxQuote__c> OldRecs)
    {
        Set<Id> ids = new Set<Id>();
        for(CameleonCPQ__QxQuote__c  Q:NewRecs)
        {
            if(Q.Customer_Approval_Status__c!=OldRecs.get(Q.id).Customer_Approval_Status__c)
            {
                if(Q.Customer_Approval_Status__c!='Submitted'){
                    Q.Customer_Approval_1st_reminder__c = false;
                    Q.Customer_Approval_2nd_reminder__c = false;
                    // Q.Send_for_Customer_Approval__c     = false;  // commented as part of Bug: NAIT-82351/ Support number : 02238366
                    if(Q.Customer_Approval_Status__c=='Approved' && Q.Customer_Response__c!='Auto Approved' ){
                        Q.Customer_approval_is_received__c='Approved';      //Reverted Changes as part of SR-02481388
                        //Q.Customer_approval_is_received__c=true;      
                    }
                    /*if(Q.Customer_Response__c=='Auto Approved'){
Q.Customer_approval_is_received__c='Auto Approved';}*/
                    else if(Q.Customer_Approval_Status__c=='Rejected'){
                        Q.Customer_approval_is_received__c='Rejected';
                    }
                    Q.Customer_Approval_Received_Date__c=System.today();
                    ids.add(Q.Sales_Rep__c);
                }
            }
        }  
        if(ids.size()>0){
            List<User> U=[SELECT Id,IsActive,ManagerId FROM User Where id in :ids and IsActive=FALSE];
            if(!U.isEmpty()){
                for(User salesUs : U){
                    //Q.CustomerApproverRepMail__c= salesUs.IsActive?salesUs.Id:salesUs.ManagerId;
                    for(CameleonCPQ__QxQuote__c  Q1:NewRecs){
                        if(Q1.Sales_Rep__c == salesUs.Id ){
                            Q1.CustomerApproverRepMail__c= salesUs.IsActive?salesUs.Id:salesUs.ManagerId;
                        }
                    }
                }
            }
        }
    }
    
    Public  void AfterUpdate(List<CameleonCPQ__QxQuote__c> NewRecs,Map<Id,CameleonCPQ__QxQuote__c> OldRecs)
    {
        system.debug('@@@@NewRecs----'+NewRecs);
        system.debug('@@@@NewRecs----'+NewRecs[0].Owner.Name);
        //system.debug('@@@@NewRecs----'+NewRecs[0].Sales_Rep__c.FirstName);
        //system.debug('@@@@NewRecs----'+NewRecs[0].PROS_QuotesFZep__c.LastName);
        //system.debug('@@@@NewRecs----'+NewRecs[0].PROS_QuotesFZep__c.Email);
        List<Customer_Approval_Notification_History__c> InsertCPNH=New List<Customer_Approval_Notification_History__c>();
       // List<Orion_Customer_MailOut__c> InsertACE = New List<Orion_Customer_MailOut__c>();
        Set<Id> salesRepIDs = New Set<Id>();
        Map<Id, User> salesRepsIdAndSalesRepRecordMap; 
        for(CameleonCPQ__QxQuote__c quoteRecord:NewRecs){
            if(quoteRecord.Sales_Rep__c != null){
                salesRepIDs.add(quoteRecord.Sales_Rep__c);    
            }
        }
        if(!salesRepIDs.isEmpty()){
            List<User> salesRepUsers = [Select id,Name,  FirstName, LastName, Email, Phone From User Where ID IN :salesRepIDs];   
            salesRepsIdAndSalesRepRecordMap = New Map<Id, User> (salesRepUsers);
        }
        for(CameleonCPQ__QxQuote__c Q:NewRecs)
        {
            if((Q.Customer_Approval_1st_reminder__c!=OldRecs.get(Q.id).Customer_Approval_1st_reminder__c && Q.Customer_Approval_1st_reminder__c==true )
               ||
               (Q.Customer_Approval_2nd_reminder__c!=OldRecs.get(Q.id).Customer_Approval_2nd_reminder__c && Q.Customer_Approval_2nd_reminder__c==true))
            {
                InsertCPNH.add(getCPNH(Q));
            }  
            /*
            //01867589 start
            if((Q.Customer_Approval_Status__c =='Submitted') &&(Q.Customer_Approval_Status__c !=OldRecs.get(Q.id).Customer_Approval_Status__c))
            {
                system.debug('@@@@Q.CameleonCPQ__PrimaryContactId__c----'+Q.CameleonCPQ__PrimaryContactId__c);
                    system.debug('@@@@Q.Sales_Rep__r.name----'+Q.Sales_Rep__r.name);
                system.debug('@@@@Q.Sales_Rep__r.name----'+Q.Sales_Rep__r.Firstname);
                system.debug('@@@@Q.Sales_Rep__r.name----'+Q.Sales_Rep__r.Lastname);
                Orion_Customer_MailOut__c Ace_Mailout = new Orion_Customer_MailOut__c();
                Ace_Mailout.Email_Template_Code__c='11';
                Ace_Mailout.PROS_Quote__c = Q.Id;
                if(salesRepsIdAndSalesRepRecordMap.ContainsKey(Q.Sales_Rep__c) ){
                    Ace_Mailout.Rep_Name__c = salesRepsIdAndSalesRepRecordMap.get(Q.Sales_Rep__c).name;
                    Ace_Mailout.Rep_First_name__c = salesRepsIdAndSalesRepRecordMap.get(Q.Sales_Rep__c).firstname;
                    Ace_Mailout.Rep_Last_Name__c = salesRepsIdAndSalesRepRecordMap.get(Q.Sales_Rep__c).lastname;
                    Ace_Mailout.Rep_Email__c = salesRepsIdAndSalesRepRecordMap.get(Q.Sales_Rep__c).email;
                    Ace_Mailout.Rep_Phone__c = salesRepsIdAndSalesRepRecordMap.get(Q.Sales_Rep__c).phone;    
                }
                //Ace_Mailout.Pricing_Analyst_Name__c = Q.Pricing_Analyst__c.name; \
                system.debug('@@@@Email----'+Q.owner);
                system.debug('@@@@Email----'+Q.ownerID);
                //Ace_Mailout.Email__c = Q.owner.Email;Customer_Approval_Status__c
                Ace_Mailout.Customer_Approval_Status__c = Q.Customer_Approval_Status__c;
                Ace_Mailout.Email__c = Q.Customer_email__c;
                Ace_Mailout.Customer__c=Q.CameleonCPQ__AccountId__c;
                //Field Mapping added by Ramakant
                //Code starts here
                Ace_Mailout.Contact__c = Q.CameleonCPQ__PrimaryContactId__c;
                //Code ends here
                // Generate Email Key - starts
                Blob blobKey = crypto.generateAesKey(128);
                Ace_Mailout.email_key__c = EncodingUtil.convertToHex(blobKey);
                // Generate Page Key - Ends  
                //Ace_Mailout.URL__c = aceSetting.Site_URL__c + '?pkey='+ ace.Page_Key__c+'&ekey='+Ace_Mailout.email_key__c;
                
                InsertACE.add(Ace_Mailout);
            }//01867589 End
            */
        }
        
        if(InsertCPNH.size()>0)    
            Insert InsertCPNH;
     /*   //01867589 Start
        if(InsertACE.size()>0)    
            Insert InsertACE;
        //01867589 End
        */
    }
    
    Public  Customer_Approval_Notification_History__c  getCPNH(CameleonCPQ__QxQuote__c CQ)
    {
        Customer_Approval_Notification_History__c  CPNH=New Customer_Approval_Notification_History__c();
        CPNH.Customer_Email__c=CQ.Customer_email__c;
        CPNH.Date_send__c=System.Today();
        CPNH.Quote__c=CQ.id;
        
        if(CQ.Customer_Approval_1st_reminder__c==true&&CQ.Customer_Approval_2nd_reminder__c==false)
            CPNH.Customer_Approval_1st_reminder__c=true;
        
        if(CQ.Customer_Approval_2nd_reminder__c==true)
            CPNH.Customer_Approval_2nd_reminder__c=true;
        
        Return CPNH;
    }
    
}