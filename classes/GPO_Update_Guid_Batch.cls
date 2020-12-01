/***
Description: This Batch is to Update Guids for newscred in community.
Created By: prasad Devar    
Created Date: 24-Apr-15
*/
Global class GPO_Update_Guid_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery;
    public String accountid;
  
    private String DEFAULT_QUERY  = 'SELECT Id, Account__c, Activated__c,LastModifiedDate from GPO_Group__c limit 2';
    /* Default Constructor*/
    global GPO_Update_Guid_Batch ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
   
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      System.debug('&&&&&&&&&&&&&&&&&&&&&&Inside strQuery '+strQuery );
    
        return Database.getQueryLocator(strQuery);
    }
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
     //String serviceEndpoint= 'http://awsnwssqpcmb01.elasticbeanstalk.com/newsservice/v1/categories/';
      GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default');    
      String serviceEndpoint= commSetup.Article_URL__c;
    String mainGuid = commSetup.Article_Guid__c;
              Map<String,String> mpval= new Map<String,String>();
   
    string dt ='';
    // Get the XML document from the external server
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(serviceEndpoint+mainGuid+'/articles/');
    JSONParser parser;
        
    if (!Test.isRunningTest()) {
    	req.setMethod('GET');
    	HttpResponse res = http.send(req);
        System.debug( 'res' + res.getBody());
  		parser = JSON.createParser(res.getBody());
    }	
    else {
    	parser = JSON.createParser('{"num_found": 22,"collection_item_set": [{"content": {"image_set": [{"guid": "dd38685f66d0717f173c4964d3aaceb3",'
			+ '"urls": {"large": "http://images4.newscred.com/Zz1kZDM4Njg1ZjY2ZDA3MTdmMTczYzQ5NjRkM2FhY2ViMw=="}}],"description": "<p>In todays fast-paced world",'
			+ '"title": "6 Ways To Beat Workplace Distractions","created_at": "2015-01-13 20:05:10","modified_at": "2015-01-13 20:54:22",'
			+ '"published_at": "2015-01-13 10:40:00","guid": "47118998fd1f4387c9eaf96297dcc032"}}]}');
    }
    
    String xx= '';
    String title='';
    String guid ='';
    String link ='';
    System.debug(' done exec ');
while (parser.nextToken() != null) 
 {
   if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
     {
        String fieldName = parser.getText();
        
        if(parser.getText()== 'content' )
        {
                  parser.nextToken();
                  
                  system.debug(parser.getText()+'   content');
                       
                    
                       if(parser.getCurrentToken() == JSONToken.START_OBJECT)
                        {
                        system.debug(parser.getText()+'  inside while content');

                            while(parser.nextToken() != null)
                                {
            
                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
                                       {
                                        if(parser.getText()== 'image_set' )
                                        {
                                        system.debug(parser.getText()+'   image_set');
                                           parser.nextToken();
                                            system.debug(parser.getText()+'   image_set val');
                                             while(parser.getCurrentToken() != JSONToken.END_OBJECT)
                                             {
                                              parser.nextToken();
                                             
                                             }
                                             
                                             
                                             
                                          
                                            }
                                              if(parser.getText()== 'guid' )
                                            { 
                                              parser.nextToken();
                                              guid= parser.getText();
                                              system.debug(guid+'   guid');
                                              mpval.put(guid,dt);
                                             }
                                            if(parser.getText()== 'modified_at')   
                                            { 
                                              parser.nextToken();
                                              dt= parser.getText();
                                              system.debug(dt+'   modified_at');
                                             }       
                                         }

                                  
                                }
                                
                              
                                        }  
       
                         } 
                   }
        
        }
        
        List<GPO_GUID__c> cgnew = new List<GPO_GUID__c>();
      
          List<GPO_GUID__c> cgupdt = [select id, Guid__c,Modified_Date__c from  GPO_GUID__c where Guid__c=:mpval.keySet()];
     for (String id : mpval.keySet())
    {
      Datetime myDate = Datetime.valueOf( mpval.get(id));

      Boolean insertflag =true;
     for(GPO_GUID__c a: cgupdt ){
     if (a.Guid__c==  id )
        {
         insertflag = false;
         a.Modified_Date__c = myDate ;
         }
     }
    if(insertflag )
    {
    System.debug(id + ' val ' + mpval.get(id));
    GPO_GUID__c c = new GPO_GUID__c ();
    c.Guid__c= id ;
    c.Modified_Date__c = myDate;
    cgnew.add(c);
    }
    }
  insert cgnew;
  update cgupdt ;
  
  
  
  List<GPO_Group_Detail__c> updtgd =  [SELECT Id,  Value1__c, Value2__c from GPO_Group_Detail__c where GPO_Group__r.name like :commsetup.Default_Group_Name__c and type__c ='NEWSCRED' and isDeleted = false order by value2__c];
Integer i=1;
for (GPO_GUID__c  gpguid :  [select id, Guid__c,Modified_Date__c from  GPO_GUID__c  order by  Modified_Date__c desc])
{
    if(i>6)
    {
        break;
    }
    else
    {
     for(GPO_Group_Detail__c a: updtgd ){
     if (integer.valueof(a.Value2__c) ==  i)
        {
         a.Value1__c= gpguid.Guid__c;
         }
     }
    }
    i++;
}
  
 update updtgd;
  }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    
                        

    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
       
        GPO_Update_Guid_Batch linkBatch = new GPO_Update_Guid_Batch ();
  
        database.executebatch(linkBatch , 5);
        
    } 
  
}