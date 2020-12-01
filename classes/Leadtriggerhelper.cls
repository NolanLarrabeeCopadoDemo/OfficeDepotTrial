public with sharing class Leadtriggerhelper {
 
public static void Leadbundle (list<Lead> leds,  map<id, Lead> oldlead ) 
{

}

public static void LinkBizBoxSales(list<Lead> leds ) 
{

Set<ID> resp = new Set<ID>();
resp.add(Label.Lead_BizBox_RT);

 RecordType getLeadRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Lead'
                and developername = 'Lead_BizBox'
                limit 1
        ];
         ID LeadBizBox = getLeadRTs.id;
         
        boolean proceed = false;
 for(Lead led:leds ){  
 if  (  resp.contains(led.RecordTypeId))
 {
 proceed  = true;
 }
 
 }
      if(proceed  )
      {
    Map<String,BizBox_Sales__c> emailmap = new Map<String,BizBox_Sales__c>();
    list <BizBox_Sales__c> updtsls = new list <BizBox_Sales__c>();
    for(BizBox_Sales__c   MySales :[SELECT Id,email__C FROM BizBox_Sales__c WHERE Potential_Lead__c ='' and Account__c = '' and email__C  != ''])
    {
    
    emailmap.put(MySales.email__C.touppercase() ,MySales);
    }
     if (!emailmap.isEmpty()  ) {
  for(Lead led:leds ){  
  
   if(!String.isBlank(led.email)){
    if(null != emailmap.get(led.email.touppercase()) && Util.bizBoxRTIdsByObject('Lead').contains(led.RecordTypeId)) 
         {
         BizBox_Sales__c bsl  =  new BizBox_Sales__c ();
         bsl  =emailmap.get(led.email.touppercase());
         bsl.Potential_Lead__c  =led.id;
        updtsls.add(bsl);
             
         }   
      }      
    }
  }
        
  
  if(!updtsls.isEmpty())
    {
        update updtsls;
    }
  
}
}

}