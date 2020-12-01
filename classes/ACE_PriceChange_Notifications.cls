global class ACE_PriceChange_Notifications implements database.Batchable<Sobject>,Database.Stateful
{
    global String batchId = '1';
    public String qry; 
    global String OrgId;
    global String Sandbox_msg ='';
    global SET<Id> UserinChatterGroup;
    global String ChatterpostString = '';
    global String ChatterGroupName = 'Pricing Updates';
    global String SumamryPage;
    global Map<ID,ace_customer_price_changes__c> userToPrice;
    
    global ACE_PriceChange_Notifications (){
        delete [select id from ACE_Notification_PriceChanges__c];
        ACE_Settings__c aceSetting = [Select id,tab_url__c from ACE_Settings__c limit 1]; 
        system.debug('Inside Constructor');
        userToPrice = new Map<ID,ace_customer_price_changes__c>();
        SumamryPage = aceSetting.tab_url__c;
        this.OrgId = UserInfo.getOrganizationId();
        if(OrgId != '00DE0000000J4oSMAS'){
            this.Sandbox_msg = '*****TEST FROM Sandbox, Please Ignore ******';
        }
        ChatterpostString = this.Sandbox_msg + 'Price/Margin changes are Available for customer(s) please visit '+SumamryPage + 'Posted on '+String.valueOf(System.now());
        //Populating the batch Id from custome Settings       
       list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            this.batchId = desettings[0].BatchName__c;       
        this.qry =  'SELECT Id, batchId__c, Customer__r.ownerId, Customer__r.owner.email,Customer_Notification_Date_Approved__c,SFDC_Notification_Flag__c from ACE_Customer_Price_Changes__c where batchId__c =\''+batchId+'\''  ; 
        
        
        list<CollaborationGroup> lstCollaborationGroup = [SELECT Id from CollaborationGroup where Name =: ChatterGroupName];
        list<CollaborationGroupMember> GroupMembers = new list<CollaborationGroupMember>(); 
        UserinChatterGroup = new SET<Id>();
        if(lstCollaborationGroup.size()>0){
            String GroupId = lstCollaborationGroup[0].Id;
            GroupMembers = [SELECT MemberId from CollaborationGroupMember  where CollaborationGroupId  =: GroupId];
        }
        
        //Post the Feed to Group Members:
        List<FeedItem> cgmfeed = new List<FeedItem>();  
        if(GroupMembers.size()>0){
            for(CollaborationGroupMember cgm : GroupMembers){
                UserinChatterGroup.add(cgm.MemberId);
                FeedItem  fItem_G = new FeedItem();               
                //fItem.Type = 'TextPost';
                fItem_G.ParentId = cgm.MemberId;
                fItem_G.Body = ChatterpostString;
                cgmfeed.add(fItem_G);
            }
        insert cgmfeed;
                
        }

        
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {                
        return Database.getQueryLocator(qry);
    }
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {  
        List<ACE_Customer_Price_Changes__c> PCR = scope;
        system.debug('Deepak1:' + userToPrice.size());
        Set <Id>UniqueUserIDS = new Set <Id>();
        List<FeedItem> lfeed = new List<FeedItem>();    
         
        List<ACE_Notification_PriceChanges__c> doneNotification  = [SELECT UserEmail__c,batchId__c from ACE_Notification_PriceChanges__c where batchId__c = :batchId];
        map<String ,ACE_Notification_PriceChanges__c > mapdoneNotification = new map<String ,ACE_Notification_PriceChanges__c >();
        // Feed has to be posted once for a Batch
        for(ACE_Notification_PriceChanges__c p :doneNotification ) {
           mapdoneNotification.put(String.valueOf(p.UserEmail__c), p);
        }
        
        for(ACE_Customer_Price_Changes__c c: PCR){
            if(mapdoneNotification.get(c.Customer__r.owner.email)== null){
                UniqueUserIDS.add(c.Customer__r.ownerId);  
            }
        }
        Map<ID,Boolean> notifydtExists = new Map<ID,Boolean>();
        for (AggregateResult ar:[select Customer__r.ownerId owner,count(id) from ace_customer_price_changes__c where Customer_Notification_Date_Approved__c <> null and batchid__c = :batchId and customer__r.ownerid = :UniqueUserIDs group by Customer__r.ownerId]) {
        	notifydtExists.put((id)ar.get('owner'),true);
        }
        
        for (SObject s : scope) 
          {
            Ace_Customer_Price_Changes__c aPrice = (Ace_Customer_Price_Changes__c)s;
            system.debug('OwnerID ContainsKey:' + aPrice.Customer__r.ownerId + ' : ' + 'Notification DATE:' + aPrice.Customer_Notification_Date_Approved__c);
           /* if (userToPrice.containsKey(aPrice.Customer__r.ownerId) && aPrice.Customer_Notification_Date_Approved__c != null) {
                userToPrice.put(aPrice.Customer__r.ownerId,aPrice);
                system.debug('Inside if Loop');
            }
            else if (!userToPrice.containsKey(aPrice.Customer__r.ownerId)) {
              userToPrice.put(aPrice.Customer__r.ownerId,aPrice);
               system.debug('Inside Else Loop');
            }*/
            
            if (notifydtExists.containsKey(aPrice.Customer__r.ownerId)) {
            	if (aPrice.Customer_Notification_Date_Approved__c != null)
            	  userToPrice.put(aPrice.Customer__r.ownerId,aPrice);
            }
            else {
            	userToPrice.put(aPrice.Customer__r.ownerId,aPrice);
            }
            
          }

        
        
        
        list<ACE_Notification_PriceChanges__c>  listNP = new list<ACE_Notification_PriceChanges__c>();
        
        for(Id a: UniqueUserIDS){
            System.debug(UserinChatterGroup.contains(a));
            if(!UserinChatterGroup.contains(a)){//excluding the chatter group to avaoid duplicate the posting.
                FeedItem  fItem = new FeedItem();               
                //fItem.Type = 'TextPost';
                fItem.ParentId = a;
                fItem.Body = ChatterpostString;
                lfeed.add(fItem);   
            } 
            
            if (userToPrice.containsKey(a))  {
                ACE_Notification_PriceChanges__c np = new ACE_Notification_PriceChanges__c();
                np.batchId__c = batchId;
                np.UserEmail__c = userToPrice.get(a).Customer__r.owner.email;
                np.user__c = userToPrice.get(a).Customer__r.ownerid;
                np.Notification_Date__c = userToPrice.get(a).Customer_Notification_Date_Approved__c;
                listNP.add(np);
            }   
        }      
         insert lfeed;
         insert listNP;
        
        
        
    }
    global void finish(Database.BatchableContext BC)
    {
       system.debug('User List Size:' + userToPrice.size());
       System.debug('Completed Sending the Notifications for Batch Id :'+batchId) ;
    }
}