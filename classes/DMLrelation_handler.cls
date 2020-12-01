public class DMLrelation_handler {
    public static void AssociateAccountid(list<DML_Relation__c> DMLrelationlist )
    {
        List<string> custids = new List<string>();
        List<string> DeciMids = new List<string>();
        List<Id> AccIds =new List<Id>();
        List<Id> DMLIds = new List<Id>();
        
        for(DML_Relation__c D:DMLrelationlist)
        {
            if(D.CUSTOMERID__c != null && D.Account__c == null)
            {
                custids.add(D.CUSTOMERID__c);
            }
            
            if(D.CUSTOMERID__c == null && D.Account__c != null)
            {
                AccIds.add(D.Account__c);
            }
            if(D.CUSTOMERID__c != null && D.Account__c != null){
            AccIds.add(D.Account__c);
            }
            
            if(D.DECISIONMAKERID__c != null && D.DML__c == null)
            {
                DeciMids.add(D.DECISIONMAKERID__c);
            }
            
            if(D.DECISIONMAKERID__c == null && D.DML__c != null)
            {
                DMLIds.add(D.DML__c);
                
            } 
            if(D.DECISIONMAKERID__c != null && D.DML__c != null)
            {
                DMLIds.add(D.DML__c);
                
            } 

        }
        
        map<string,account> Maccounts = new map<string,account>();
        map<Id,account> MaccountsId = new map<Id,account>();
        map<Id,account> OrgMap= new map<Id,Account>();

        
        for(Account Acc:[select id,Org__c,AOPS_Cust_Id__c from account where AOPS_Cust_Id__c=:custids or id =:AccIds])
        {
            if(Acc.AOPS_Cust_Id__c !=null){
            Maccounts.put(Acc.AOPS_Cust_Id__c,Acc);            
            MaccountsId.put(Acc.id,Acc);
            }
            OrgMap.put(Acc.id,Acc);
        }
        
        
        map<string,DML__c > MDML = new map<string,DML__c >();
        map<Id,DML__c > MDMLId = new map<Id,DML__c >();


        for(DML__c Acc1:[select id,DECISION_MAKER_ID__c from DML__c where DECISION_MAKER_ID__c=:DeciMids or
         Id  in :DMLIds])
        {
            if(Acc1.DECISION_MAKER_ID__c !=null){
            MDML.put(Acc1.DECISION_MAKER_ID__c ,Acc1);            
            MDMLId.put(Acc1.id,Acc1);
            }
        }
        
        
        for(DML_Relation__c D:DMLrelationlist)
        {
            if(D.CUSTOMERID__c != null & D.Account__c == null)
            {
                if (Maccounts.containskey(D.CUSTOMERID__c)){
                D.Account__c = Maccounts.get(D.CUSTOMERID__c).id;  
                D.Org__C=Maccounts.get(D.CUSTOMERID__c).org__C;

                }    
             }
            
           if (MaccountsId.containskey(D.Account__c))
           D.CUSTOMERID__c=MaccountsId.get(D.Account__c).AOPS_Cust_Id__c;
            
            
            if(OrgMap.containskey(D.Account__c))
            D.Org__C=OrgMap.get(D.Account__c).org__C;
            
            
            
            if(D.DECISIONMAKERID__c != null && D.DML__c == null)
            {
                if (MDML.containskey(D.DECISIONMAKERID__c )){
                D.DML__C= MDML.get(D.DECISIONMAKERID__c ).id;  
                }    
            }
            
              if (MDMLId.containskey(D.DML__c ))
              D.DECISIONMAKERID__c =MDMLId.get(D.DML__c ).DECISION_MAKER_ID__c ;
                           
        
        }
    }
    
   
     
   
   
    
 public static void EffectiveEnddate(list<DML_Relation__c> DMLrelationlist )
    {
        map<String,DML_Relation__c> DMLREC = New map<String,DML_Relation__c>();
        List <String> CustID = new List <String>();
        List <Id> accId= new List <Id>();
    
        for(DML_Relation__c Dr : DMLrelationlist){
            if(Dr.CUSTOMERID__c!=null)
            CustID.add(Dr.CUSTOMERID__c);
            if(Dr.Account__C !=null)
            accId.add(Dr.Account__C);
        }
        
        Date dt=System.today();
        
        for(DML_Relation__c DRec : [Select id,Effective_End_Date__c,CUSTOMERID__c,account__C from DML_Relation__c where
         (CUSTOMERID__c = : CustID  or account__C =:accId ) and 
         (Effective_End_Date__c= null or Effective_End_Date__c>=  :dt) ]){
            
                  if(  DRec.CUSTOMERID__c!=null){
                  if(!DMLREC.Containskey(DRec.CUSTOMERID__c))
                    DMLRec.put(DRec.CUSTOMERID__c,DRec );
                    }
                    
                  if(DRec.account__C !=null){
                   if(!DMLREC.Containskey(DRec.account__C ))
                    DMLRec.put(DRec.account__C,DRec );
                   }
                       
        }
       
            if(!DMLRec.isempty()){
                
            
            for(DML_Relation__c Dr : DMLrelationlist){
                       if(DMLRec.containskey(Dr.CUSTOMERID__c)  || DMLRec.containskey(Dr.Account__c))
                        Dr.adderror('Already active exist with this customer');
                }
            }
       }

    //Code to remove related DML field on Account in case of Prospect    
    public static void RemoveRelatedDML(List<DML_Relation__c> DMLRelationlist )
    {
    List<Id> acctId= new List<Id> ();
    List<Account>  accupdate= new     List<Account>();
    List<Account> acc= new List<Account>();
    for(DML_Relation__c d:DMLRelationlist)
        {
            if(d.Account__c!=null)
            {
               acctId.add(d.Account__c);
            }
        }
    
          try{
            accupdate= [select id,Related_DML__c from account where 
             id in :acctId and  Related_DML__c!=null ];
                 for(Account rec :    accupdate){
                   rec.Related_DML__c=null;
                 }
               if(accupdate.size()>0)
               update accupdate;
     
            }
       catch(Exception e){}
    
    
            
        
             }    
    
    public static void DMLRHistoryPopulate(Map < Id, DML_Relation__c > NewMap, Map<Id,DML_Relation__c> oldMap )
    {
          List<DML_Relation_History__c> DMLHistoryInsertList= new List<DML_Relation_History__c>();
         List<DML_Relation__c> DMLRelationlist= new List<DML_Relation__c>();          
         for (String DrecStr: NewMap.keyset()) 
        {            
            if(NewMap.get(DrecStr).ProcessNew_Request__c == true)
            {                
            DML_Relation__c Drec = new DML_Relation__c();
            Drec.Id = NewMap.get(DrecStr).Id;
            Drec.DML__c=NewMap.get(DrecStr).New_DML__c;
            Drec.Effective_Start_Date__c=NewMap.get(DrecStr).New_start_Date__c;
            Drec.ProcessNew_Request__c=false;
            Drec.New_DML__c=null;
            Drec.New_start_Date__c=null;
           //DMLRelationlist.add(Drec);
            DML_Relation_History__c DHistoryRec = new DML_Relation_History__c();
            DHistoryRec.Account__c= oldMap.get(Drec.id).Account__C;
            DHistoryRec.CUSTOMERID__c=oldMap.get(Drec.id).CUSTOMERID__c;
            DHistoryRec.DML__c=oldMap.get(Drec.id).DML__c;
            DHistoryRec.DML_Relation_Modified_By__c=oldMap.get(Drec.id).Requested_By__c;
            DHistoryRec.DML_Relationship__c=oldMap.get(Drec.id).Id;
            DHistoryRec.Effective_End_Date__c=oldMap.get(Drec.id).Effective_End_Date__c;
            DHistoryRec.Effective_Start_Date__c=oldMap.get(Drec.id).Effective_Start_Date__c; 
            DMLHistoryInsertList.add(DHistoryRec);
            Drec.Effective_End_Date__c=null;
            DMLRelationlist.add(Drec);
        }
        }
          if(DMLRelationlist.size()>0)
           update DMLRelationlist;
           if(DMLHistoryInsertList.size()>0)
           insert DMLHistoryInsertList;    
    }  
}