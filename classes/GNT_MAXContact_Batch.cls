global class GNT_MAXContact_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery;
    //CurrencyIsoCode - Need to add when Currency is Enabled

        //Default Constructor
    global GNT_MAXContact_Batch(){}
    

    
    global Database.QueryLocator start(Database.BatchableContext BC){        
     String QUERY  = 'SELECT UniqueId__c FROM GTContact_Delta__c Limit 1';   
         return Database.getQueryLocator(QUERY);
    }
    
     
    global void execute(Database.BatchableContext BC, SObject[] scope){
    
    // get uniqueId's
    List<string> uniqueIds1= new List<string>();
    List<GTContact_Delta__c > deleteData = new   List<GTContact_Delta__c >();
    List<GTContact_Delta__c > insertData = new   List<GTContact_Delta__c >();
        AggregateResult[] groupedResults =[SELECT UniqueId__c
    FROM GTContact_Delta__c 
    WHERE Processed_Status__c= 'Process MAX' 
    GROUP BY UniqueId__c
    HAVING COUNT(Id) > 1  
    ];
        
        for (AggregateResult ar : groupedResults)  {
        
        string str =( String)ar.get('UniqueId__c');
        uniqueIds1.add(str);
          // uniqueIds.add((ID)ar.get('UniqueId__c'));
        }
        
      Integer size=uniqueIds1.size();
      system.debug('&&&&&&&&&&&&size'+size);   
        
      List<string> uniqueIds= new List<string>();
      
      if(size>100){
      for(integer i=0;i< 100;i++){
      uniqueIds.add(uniqueIds1[i]);
      }
      }
      else{
      for(integer i=0;i< size;i++){
      uniqueIds.add(uniqueIds1[i]);
      }
      }
      
        
        
      deleteData =[Select id, name, First_Name__c, Account_OMX_Primary_Key__c,Email__c,
      SITE_OMX_Primary_Key__c,UniqueId__c,Sales_Rep__c,Salutation__c,Role__c,Fax__c,
      Phone__c,Phone_Ext__c,Title__c,Language__c,Processed_Status__c from   GTContact_Delta__c 
      where UniqueId__c in :uniqueIds  ];
  
      Integer sizedata=deleteData.size();
      
      for(integer i=0;i<uniqueIds.size();i++){
             GTContact_Delta__c insertNew = new GTContact_Delta__c ();
             string site=' ';
               for(integer j=0;j<sizedata;j++){
                  if(uniqueIds[i]==deleteData [j].UniqueId__c){
                  insertNew.name =deleteData [j].name;
                  insertNew.First_Name__c=deleteData [j].First_Name__c;
                  insertNew.UniqueId__c=deleteData [j].UniqueId__c;
                  insertNew.Sales_Rep__c=deleteData [j].Sales_Rep__c;
                  insertNew.Account_OMX_Primary_Key__c=deleteData [j].Account_OMX_Primary_Key__c;
                  insertNew.Language__c=deleteData [j].Language__c;
                  insertNew.Processed_Status__c =deleteData [j].Processed_Status__c ;
                  if(deleteData [j].Email__c!=null)
                  insertNew.Email__c=deleteData [j].Email__c;
                  if(deleteData [j].Salutation__c!=null)
                  insertNew.Salutation__c=deleteData [j].Salutation__c;    
                  if(deleteData [j].Phone__c!=null)
                  insertNew.Phone__c=deleteData [j].Phone__c;    
                  if(deleteData [j].Phone_Ext__c!=null)
                  insertNew.Phone_Ext__c=deleteData [j].Phone_Ext__c;    
                  if(deleteData [j].Title__c!=null)
                  insertNew.Title__c=deleteData [j].Title__c;  
                  if(deleteData [j].Fax__c!=null)
                  insertNew.Fax__c=deleteData [j].Fax__c; 
                  if(deleteData [j].Role__c!=null)
                  insertNew.Role__c=deleteData [j].Role__c;   
                  if(deleteData [j].SITE_OMX_Primary_Key__c  !=null)    
                   site =site+deleteData [j].SITE_OMX_Primary_Key__c +','; 
                  }
               }
             insertNew.SITE_OMX_Primary_Key__c =site;
             insertData .add(insertNew);
       }      
       
      // delete the GT Contact Delta
      if(deleteData.size()>0)
      delete deleteData;


      if(insertData .size()>0)
      insert insertData ;
 
   }



    
    
     global void finish(Database.BatchableContext BC){
        
    }
     global void execute(SchedulableContext sc){ 

      GNT_MAXContact_Batch assignBatch1 = new GNT_MAXContact_Batch ();
        database.executebatch(assignBatch1);
     
     }
    }