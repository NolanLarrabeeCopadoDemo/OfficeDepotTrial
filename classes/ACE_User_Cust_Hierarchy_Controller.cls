public class ACE_User_Cust_Hierarchy_Controller
{
    public List<User> lUser{get;set;}
    public List<User> lUserList{get;set;}
    public Map<ID,List<User>> map_ID_luser {get;set;}
    public String QtrData {get;set;}
    
    public ACE_User_Cust_Hierarchy_Controller()
    {
        
        // New Code added by Deepak - starts
        list<ID> tmplist = new list<ID> ();
        lUserList = new list<user> ();
        User lusr = [select id from user where id = :userInfo.getUserId()];
        lUserList.add(lusr);
        tmplist.add(UserInfo.getUserid());
        system.debug('Call to code UserList');
        While (!tmplist.isEmpty()) 
        {
             list<user> ulist = [SELECT ID from user where manager.id = :tmplist];
             system.debug('Hier Query Executed');
             tmplist.clear();
             For (User u : ulist) {
                tmplist.add(u.id);
                lUserList.add(u);
             }
        } 
        // New Code added by Deeepak - ends
    
    }
    
    
           
        public Set<ID> CustomerPriceChangeRecs(Set<ID> ownerlist,String Filtertype,String qtr)
        {
           map <ID,boolean> ownerMap = new Map<ID,boolean> ();
           ID loggedinUser = userInfo.getUserID();
           if (FilterType == null)
              FilterType = 'Owned by me';
           Set<ID> records_to_collect = new Set<ID>();
           system.debug('Inside Price Change Query' + ownerList);
             Set<ID> gplist = new Set<ID> ();
            Set<ID> parentlist = new Set<ID>();
            // List<ACE_Customer_Price_Changes__c> lACE_Cust_Records = [select id, customer__r.parent.parent.id  from ACE_Customer_Price_Changes__c where (customer__r.parent.parent.ownerid in :ownerlist)];
            // System.debug('Value of GpList>>>>>>>>>' + gplist);
            
            Set<ID> ownerlistwithLoggedinUser = new Set<ID>();
            for (ID u:ownerlist) {
              ownerlistwithLoggedinUser.add(u);
              ownerMap.put(u,true);
            }
            if (FilterType == 'Owned by others' || FilterType == 'Owned by my team') {
                ownerlistwithLoggedinUser.add(loggedinUser);
            }
            
            //Collect Direct GPs
            
            
            
            For(ACE_Customer_Price_Changes__c ap: [select customer__r.parent.parent.id from ACE_Customer_Price_Changes__c where customer__r.parent.parent.ownerid in :ownerlistwithLoggedinUser and name = :qtr])
            {
                gplist.add(ap.customer__r.parent.parent.id);
            }
            System.debug('Value of GpList>>>>>>>>>' + gplist.size());
            
            //Collect Direct Parents
            
            For (ACE_Customer_Price_Changes__c ap: [select customer__r.parent.id from ACE_Customer_Price_Changes__c where customer__r.parent.ownerid in :ownerlistwithLoggedinUser and name=:qtr])
            {
                parentlist.add(ap.customer__r.parent.id);
            }
            System.debug('Value of parentlist>>>>>>>>>' + parentlist.size());
            
            
            FOR(ace_customer_price_changes__c ap: [select id from ace_customer_price_changes__c where customer__r.ownerid in :ownerlist and name=:qtr])
            {
               records_to_collect.add(ap.id);
            } 
             
            
            System.debug('Value of records_to_collect1>>>>>>>>>' + records_to_collect.size());    
            system.debug('Collection Record with Quarter:' +records_to_collect);   
            
            FOR (ace_customer_price_changes__c ap: [select id,customer__r.id,customer__r.ownerid from ace_customer_price_changes__c where customer__r.parent.parent.id in :gplist and name=:qtr]) 
            {
               if ((FilterType == 'Owned by my team' && ownerMap.containskey(ap.customer__r.ownerid)) || (FilterType == 'Owned by me' && loggedinUser == ap.customer__r.ownerid) || (FilterType == 'Owned by others' && loggedinUser != ap.customer__r.ownerid) || FilterType == 'All')
                 records_to_collect.add(ap.id);
               parentlist.add(ap.customer__r.id);
            }
            System.debug('Value of records_to_collect2>>>>>>>>>' + records_to_collect.size());
            system.debug('Plist :: ' + parentlist);
            decimal countertest = 0;
            system.debug('filter Type:' + FilterType);
            FOR (ace_customer_price_changes__c ap: [select id,customer__r.ownerid from ace_customer_price_changes__c where customer__r.parent.id in :parentlist and name=:qtr]) {
                //system.debug('@@@@' + loggedinUser);
                //system.debug('^^^^^' + ap.customer__r.ownerid);
               if ((FilterType == 'Owned by my team' && ownerMap.containskey(ap.customer__r.ownerid)) || (FilterType == 'Owned by me' && loggedinUser == ap.customer__r.ownerid) || (FilterType == 'Owned by others' && loggedinUser != ap.customer__r.ownerid) || FilterType == 'All') {
                records_to_collect.add(ap.id);
                countertest++;
               }
            }
           
            System.debug('Value of records_to_collect3>>>>>>>>>' + records_to_collect.size());
            System.debug('TTTTTTT:' + countertest);
           
        return records_to_collect;
    }
    
    
    
    
    
    
    
}