public class Accountassignmnet_primaryclass{

   public static List<AccountAssignments__c> ATs = new List<AccountAssignments__c>();
   public static Map<id,Account> MapCust = new Map<id,Account>();
   public static Map<string,id> MapSite = new Map<string,id>();
   public static set<string> Accids = new set<string>();
   public static set<id> pAccids = new set<id>();

    public static List<AccountAssignments__c> cloneupsert(List<AccountAssignments__c> ATA)
    {    
        for(AccountAssignments__c AT: ATA){
            string s= AT.Entity_Id__c;
            s=s.remove('-');
            Accids.add(s);
        }

        //to create a map of site Record and its customer
        for(Account a:[select id,OMX_Primary_Key__c,Related_Account__c,Related_Account__r.recordtype.name,Related_Account__r.omx_primary_key__c,Related_Account__r.Oracle_Party_ID__c 
                        from account where OMX_primary_key__c in: Accids]){
            pAccids.add(a.Related_Account__c);
            MapSite.put(a.OMX_primary_key__c,a.Related_Account__c);
        }
        //to create a map of Customer Record and its fields        
        for(Account a:[select id,recordtype.name,omx_primary_key__c,Oracle_Party_ID__c from account where id in: pAccids]){
            MapCust.put(a.id,a);
        }

        for(AccountAssignments__c AT: ATA){
          if(MapCust.get(MapSite.get(AT.Entity_Id__c.remove('-')))!=null){
            if(MapCust.get(MapSite.get(AT.Entity_Id__c.remove('-'))).recordtype.name=='Customer (OfficeMax)'){
            AccountAssignments__c ATclone = AT.clone(false, false, false, false);
            ATclone.AccountType__c = 'A';
            ATclone.Entity_Id__c = MapCust.get(MapSite.get(AT.Entity_Id__c.remove('-'))).omx_primary_key__c;
            ATclone.AccountId__c = MapCust.get(MapSite.get(AT.Entity_Id__c.remove('-'))).Oracle_Party_ID__c;
            ATclone.Ex_Id__c = 'A-'+MapCust.get(MapSite.get(AT.Entity_Id__c.remove('-'))).Oracle_Party_ID__c;
            ATclone.Account__c=null;
            ATs.add(ATclone);
            }
          }
        }
        return ATs;
    }                      

}