trigger ACEMailDelivery on ACE_Customer_MailOut__c (after update) {
   set<ID> priceIDs = new Set<ID>();
   list<ace_customer_price_changes__c> PriceUpd = new list<ace_customer_price_changes__c>();
   Map<ID,boolean> successMap = new Map<ID,boolean>();
   Map<ID,boolean> failIDs = new Map<ID,boolean>();
   Map<ID,Date> latestNotifyDate = new Map<ID,Date>();
   
   for (ace_customer_mailout__c m:Trigger.new) {
     if (m.bounced_flag__c <> Trigger.oldMap.get(m.id).bounced_flag__c && m.bounced_flag__c == true) {
       priceIDs.add(m.Customer_Core_Price_Changes__c);
       failIDs.put(m.ID,true);
          
     }
   }  
   
   for (AggregateResult r:[SELECT customer_core_price_changes__c,max(notification_Date__c) notifyDt from ACE_Customer_MailOut__c where customer_core_price_changes__c=:priceIDs group by customer_core_price_changes__c]) {
      latestNotifyDate.put((String)r.get('customer_core_price_changes__c'),(Date)r.get('notifyDt'));
   }
   
   
   
   for (ACE_Customer_MailOut__c r: [SELECT  Customer_Core_Price_Changes__C,ID,notification_date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c=:priceIDs and bounced_flag__c=false and notification_date__c=:latestNotifyDate.values()]) {
   
     IF (!failIDs.containsKey(r.ID) && !successMap.containsKey(r.Customer_Core_Price_Changes__c) && r.notification_date__c==latestNotifyDate.get(r.Customer_Core_Price_Changes__C))
      successMap.put(r.Customer_Core_Price_Changes__C,true);
   }
   
   for (Ace_customer_price_changes__c p:[select id, Notification_Status_Code__c,Notification_Error__c from ace_customer_price_changes__c where id = :PriceIDs]) {
   
    if (!successMap.containsKey(p.id)) {
      ace_customer_price_changes__c ap = new ace_customer_price_changes__c(ID = p.id);
      ap.Notification_Status_Code__c = 'NOTIFY-FAILED';
      ap.Notification_Error__c = 'Email Delivery Bounced on all Contacts';
      PriceUpd.add(ap);
     }
   }
   
   update PriceUpd;
 }