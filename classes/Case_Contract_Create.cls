/**************************************************************************
*Created By :Wipro Offshore team
*Created Date : 11/05/2012
*Purpose :Create a ContractMessage record when Create contract button is clicked from the case.

Last Modified       :
Last Modified By    :
Last Modified Reason:
***************************************************************************/
//Call back to update the Record will be from ContractMessageService Apex class

global class Case_Contract_Create
{
   
   WebService static string Case_Contract_Create (String Case_opptyid,String Case_caseid)
   {    
        try
        {
            list<case> triggernewcase = new list<Case>();
            list<opportunity> triggernewopty = new list<opportunity>();
            triggernewopty = [Select id, ownerid, accountid,Product__c,Product_Subtype__c,Probability  from opportunity where id =: Case_opptyid];
            List<Sales_Person__c> salesperID=new List<Sales_Person__c>();
            set<id> set_opptyOwnerid=new set<id>(); 
            set<id> set_opptyid=new set<id>();
            set<id> set_opptyaccountid=new set<id>();
            list<opportunity> list_opportunity2bupdated = new list<opportunity>();
            list<ContractMessage__c> ocmc=new list<ContractMessage__c>();
            list<ContractMessage__c> ocmc3=new list<ContractMessage__c>();
            list<ContractMessage__c> lst_contractmsg=new list<ContractMessage__c>();  
            Map<id,Opportunity> map1_optyid =new Map<id,Opportunity>();
            string error;
            
            for(Opportunity lst_oppty: triggernewopty)
            {
               if((lst_oppty.Product__c =='MPS')||((lst_oppty.Product__c =='Ink & Toner')&&(lst_oppty.Product_Subtype__c=='Automatic Toner Replenishment (ATR)')))
               {
                   set_opptyOwnerid.add(lst_oppty.ownerid);
                   set_opptyaccountid.add(lst_oppty.accountid);
                   set_opptyid.add(lst_oppty.id);
                   map1_optyid.put(lst_oppty.id,lst_oppty); 
               }
               else
               {
                   error = ' Opportunity Product Should be MPS';
               }
            }
            Map<id,Sales_Person__c> map_salesperID =new Map<id,Sales_Person__c>();
            for (Sales_Person__c s: [select id,Name,user__c from Sales_Person__c where user__c in:set_opptyOwnerid ])
            {
                map_salesperID.put(s.user__c,s);
            }
            
            
            map<id,account> Map_oraclepartyid = new map<id,account>([select id,name,Oracle_Party_ID__c from account where id in:set_opptyaccountid]);

                for(Opportunity lst_oppty: triggernewopty)
                {

                      if((lst_oppty.Product__c=='MPS')||((lst_oppty.Product__c =='Ink & Toner')&&(lst_oppty.Product_Subtype__c=='Automatic Toner Replenishment (ATR)')))
                      {
                          ContractMessage__c ocmc1 = new ContractMessage__c();
                          ocmc1.Opportunity_Id__c = lst_oppty.id;
                          ocmc1.Contract_Type__c = 'MPS';
                          ocmc1.OraclePartyId__c =  Map_oraclepartyid.get(lst_oppty.accountid).Oracle_Party_ID__c;
                          ocmc1.SalesPersonId__c = map_salesperID.get(lst_oppty.OwnerId).Name;
                          ocmc1.Support__c = Case_caseid;
                          ocmc.add(ocmc1); 
                      
                      }
                      else
                       {
                           error = ' Opportunity Product Should be MPS';
                       }
                }
            if(ocmc.size()!=0)
            {   
                insert ocmc;
                error = 'Contract Message Created';
            }
            return (error);
        }
        catch(exception e)
        {
            string es = string.valueof(e);
            return es;
        }      
     }
}