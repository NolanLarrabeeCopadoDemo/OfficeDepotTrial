public class ACEMyPriceChanges {

  public String SearchText { get; set; }
  public class custException extends Exception{}
  public list<ACE_Customer_View__c> skulist {get;set;}
  public list<ACE_Customer_View__c> skulist_d {get;set;}
  // start of story 00827410
  public list<ACE_Customer_View__c> skulistApproval {get;set;}
  public list<ACE_Customer_View__c> skulistNonApproval {get;set;}
  //list<ACE_Customer_View__c> skulistApproval = new list<ACE_Customer_View__c> ();
  //list<ACE_Customer_View__c> skulistNonApproval = new list<ACE_Customer_View__c> ();
  //end of story 00827410
  public ACE_Customer_Price_Changes__c ACEPriceChangeRec {get;set;}
  public boolean displaypage {get;set;}
  public boolean displayResponse {get;set;}
  public string pageKey {get;set;}
  public string emailKey {get;set;}
  public string pageContent {get;set;}
  public boolean displayApproval {get;set;}
  public boolean displayDisclaimer{get;set;}
  public boolean displayHighlighted{get;set;}
  public boolean displayHeader {get;set;}
  public boolean displayeffectiveDate {get;set;}
  public String cPageUrl {get;set;}
  public Integer List_size = 10;
  public Integer counter; 
  public Integer total_size{get;set;}
  
  public void skuDownload() {
  
  }
  
    public Boolean getDisablePrevious() {     
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size){
          system.debug('total_size>>>>>>>>'+total_size);
          return true;
      }  
      else return false;
    }
  
    public void nextPage(){
        counter = counter+List_size; 
        getSKURecords();                                     
    }
    public void prevPage(){
        counter = counter-List_size;
        getSKURecords();                               
    }
     
  public ACEMyPriceChanges() {
   try
   {
   counter = 0;
   tabAsc = true;
   getFieldName = 'Sales_Price_Change_Effective_Date_Appro__c';
   FieldName = 'Sales_Price_Change_Effective_Date_Appro__c';
   sortDirection = 'ASC'; 
   displayHeader = false;
   displayApproval = true;
   displayResponse = false;
   displayDisclaimer = false;
   displayeffectiveDate = true;
    date skudate;
    //String pageKey = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    displaypage = true;
    pageKey = ApexPages.currentPage().getParameters().get('pkey');
    emailKey = ApexPages.currentPage().getParameters().get('ekey');
    if ('ERROR'.equals(ApexPages.currentPage().getParameters().get('ErrorCode')))
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ApexPages.currentPage().getParameters().get('ErrorMsg')));
    
    //TODO: Read from custom settings
    cPageUrl = 'http://uat-officedepotpricechanges.cs7.force.com/MyPriceChanges';
    
      list<ACE_Settings__c> desettings =[SELECT Id, Name, Site_URL__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            cPageUrl = desettings[0].Site_URL__c;
    
    boolean userIsApprover = false;
    if (emailKey != null) {
        For (ace_customer_mailout__c m: [select id from ace_customer_mailout__c where email_key__c = :emailKey and contact__r.role__c includes ('Price Change Approver')])
             userIsApprover = true;
    }
    
    if (pageKey == null)
      throw new CustException ('You Are Not Authorized To View This Page'); 
    
    for (ace_customer_price_changes__c a: [Select id,hosted_catalog__c,name,Customer__r.Name,Customer__r.Cust_ID__c,Customer__r.Owner.Name,Customer__r.AccountNumber,CallMeRequest__c,Customer__r.aops_cust_id__c, Customer_Response__c,Customer_Comments__c,sfdc_notification_flag__c,Customer_Comments_Submitter__c,Record_Unlock__c,SKU_Approval_Pending__c,Exception_Date_Lock__c from ACE_Customer_Price_Changes__c where page_Key__c =:pageKey limit 1]) {
      ACEPriceChangeRec = a;
      if (a.hosted_catalog__c)
         displayeffectiveDate = false;
      if (a.SFDC_Notification_Flag__c == '3' && userIsApprover)
        displayResponse = true;
    }
    
    if (ACEPriceChangeRec == null)
      throw new CustException ('You Are Not Authorized To View This Page');
    else
        displayHeader = true;
        
    if (ACEPriceChangeRec.Customer_Response__c == 'Approved')
       displayApproval = false;

    if(ACEPriceChangeRec.Record_Unlock__c == true || ACEPriceChangeRec.SKU_Approval_Pending__c == true || ACEPriceChangeRec.Exception_Date_Lock__c == true)
        displayDisclaimer = true;    
// Added QPU__c,Alt_QPU__C,List_Price__c,Alt_List_Price__c for case #00827452
//Added SFDC_Notification_Flag__c 00827410
       skulist = [select SKU__c,Item_12_Month_Qty__c,SKU_Last_Update__c,
                         SKU_Description__c,
                         Current_Sell_Price__c,
                         Approved_Proposed_Price__c,
                         Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,
                         Status__c,Price_Changed_After_Notify__c,
                         UOM__c,
                         Old_Price__c,
                         Quantity_Per_Unit__c,
                         Item_12_Month_Sales__c,
                         Sales_Price_Change_Effective_Date_Appro__c,
                         QPU__c,
                         Alt_QPU__c,
                         List_Price__c,
                         Alt_List_Price__c,SFDC_Notification_Flag__c
                         from ACE_Customer_View__c
                         where name = :pageKey order by Sales_Price_Change_Effective_Date_Appro__c NULLS LAST limit :List_size OFFSET :counter];
                         
       skulist_d = [select SKU__c,Item_12_Month_Qty__c,SKU_Last_Update__c,
                         SKU_Description__c,
                         Current_Sell_Price__c,
                         Approved_Proposed_Price__c,
                         Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,
                         Status__c,Price_Changed_After_Notify__c,
                         UOM__c,
                         Old_Price__c,
                         Quantity_Per_Unit__c,
                         Item_12_Month_Sales__c,
                         Sales_Price_Change_Effective_Date_Appro__c,
                         QPU__c,
                         Alt_QPU__c,
                         List_Price__c,
                         Alt_List_Price__c,SFDC_Notification_Flag__c,Approval__c
                         from ACE_Customer_View__c
                         where 
                         name = :pageKey order by Sales_Price_Change_Effective_Date_Appro__c NULLS LAST];
                         
       total_size = [select count() from ACE_Customer_View__c  where name =: pageKey];   
       system.debug('<<<<<<<<<<<'+skulist );
       
       //Start of 00827410
       
         skulistApproval = new list<ACE_Customer_View__c> ();
         skulistNonApproval = new list<ACE_Customer_View__c> ();
         
         
         System.debug('&&&&&&&Total records'+skulist.size());
       for(integer i=0;i<skulist.size();i++){
         
         //Support 00826573 Blank New Price if sku swapped or new price 0 - Miles.
         if(skulist[i].Approved_Proposed_Price__c == 0.0 || skulist[i].Alt_SKU__c != null)
         {
             skulist[i].Approved_Proposed_Price__c = null;
         }

         if(skulist[i].SFDC_Notification_Flag__c=='3')
         skulistApproval.add(skulist[i]);
         else
         skulistNonApproval.add(skulist[i]);
       }
       
       
                System.debug('&&&&&&&Total Approval records'+skulistApproval.size());
                System.debug('&&&&&&&Total Non Approval records'+skulistNonApproval.size());


         //end of 00827410       
       //getSKURecords();                   
    
    }
    catch(custException ce) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
     displaypage = false;
    }
    catch(Exception e) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
     displaypage = false;
    }
  }
  
  // Sorting
   
   public void Refresh_rec() 
    {
    System.debug('&&&&&Inside Refesh');
        counter = 0;
        getSKURecords();       
    }
   
    public String fieldName = 'Sales_Price_Change_Effective_Date_Appro__c';
    public String sortDirection {get;set;}
    public String getFieldName{get;set;}
    public Boolean tabAsc{get;set;}
    
    public PageReference sortCust() 
    {
    
    
        if(getFieldName == 'SKU__c'){
            fieldName = 'SKU__c';}
        else if(getFieldName == 'Alt_SKU__c'){
            fieldName = 'Alt_SKU__c';}
        else if(getFieldName == 'SKU_Description__c'){
            fieldName = 'SKU_Description__c';} 
        else if(getFieldName == 'Alt_SKU_Description__c'){
            fieldName = 'Alt_SKU_Description__c';}        
        else if(getFieldName == 'UOM__c'){
            fieldName = 'UOM__c';}
        else if(getFieldName == 'Alt_UOM__c'){
            fieldName = 'Alt_UOM__c';}
        else if(getFieldName == 'Item_12_Month_Qty__c'){
            fieldName = 'Item_12_Month_Qty__c';}
        else if(getFieldName == 'Item_12_Month_Sales__c'){
            fieldName = 'Item_12_Month_Sales__c';}
        else if(getFieldName == 'Current_Sell_Price__c'){
            fieldName = 'Current_Sell_Price__c';}
        else if(getFieldName == 'Alt_Sell_Price__c'){
            fieldName = 'Alt_Sell_Price__c';}
        else if(getFieldName == 'Approved_Proposed_Price__c'){
            fieldName = 'Approved_Proposed_Price__c';}
        else if(getFieldName == 'Sales_Price_Change_Effective_Date_Appro__c'){
            fieldName = 'Sales_Price_Change_Effective_Date_Appro__c';}
        // Start case #00827452
        else if(getFieldName == 'QPU__c'){
            fieldName = 'QPU__c';}
        else if(getFieldName == 'Alt_QPU__c'){
            fieldName = 'Alt_QPU__c';}
        else if(getFieldName == 'List_Price__c'){
            fieldName = 'List_Price__c';}
        else if(getFieldName == 'Alt_List_Price__c'){
            fieldName = 'Alt_List_Price__c';}   
        //end case 00827452
            
        if(tabAsc){
            sortDirection = 'DESC';          
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';         
            tabAsc = true;             
        }  
        getSKURecords();  
        return null;
    }
  
  public PageReference getSKURecords()
  {
      try
      {
           
           String query = '';
           System.debug('>>>>>>>>> value of field name' + FieldName);
           // fieldName = 'Sales_Price_Change_Effective_Date_Appro__c';
           date skudate;
           if((searchText != null) && (searchText != ''))
           {  
              if(displayHighlighted){    
              String textToSearch = '' + searchText + '%';
              // Added QPU__c,Alt_QPU__C,List_Price__c,Alt_List_Price__c for case #00827452
              query = 'select SKU__c,SKU_Last_Update__c,Item_12_Month_Qty__c,SKU_Description__c,Status__c, Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,Current_Sell_Price__c,Approved_Proposed_Price__c,UOM__c,Old_Price__c,Quantity_Per_Unit__c,Item_12_Month_Sales__c, Sales_Price_Change_Effective_Date_Appro__c,Price_Changed_After_Notify__c,QPU__c,Alt_QPU__c,Alt_List_Price__c,List_Price__c,SFDC_Notification_Flag__c from ACE_Customer_View__c  where Price_Changed_After_Notify__c = true and sku__c  like \''+ textToSearch + '\' and name = \'' + pageKey  + '\' order by ' + fieldName + ' ' + sortDirection+ ' NULLS LAST limit ' +List_size+ ' OFFSET ' +counter+ '' ;
              total_size = [select count() from ACE_Customer_View__c  where sku__c  like: textToSearch and name =: pageKey and Price_Changed_After_Notify__c = true];                      
              System.debug('>>>>>>>>> query ' + query );
              }
              else{
              String textToSearch = '' + searchText + '%';
              query = 'select SKU_Last_Update__c,Item_12_Month_Qty__c,SKU__c,SKU_Description__c,Status__c, Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,Current_Sell_Price__c,Approved_Proposed_Price__c,UOM__c,Old_Price__c,Quantity_Per_Unit__c,Item_12_Month_Sales__c, Sales_Price_Change_Effective_Date_Appro__c,Price_Changed_After_Notify__c,QPU__c,Alt_QPU__c,Alt_List_Price__c,List_Price__c,SFDC_Notification_Flag__c from ACE_Customer_View__c  where sku__c  like \''+ textToSearch + '\' and name = \'' + pageKey  + '\' order by ' + fieldName + ' ' + sortDirection+ ' NULLS LAST limit ' +List_size+ ' OFFSET ' +counter+ '' ;
              total_size = [select count() from ACE_Customer_View__c  where sku__c  like: textToSearch and name =: pageKey];                      
              System.debug('>>>>>>>>> query ' + query );
              }
           }else
           {
              if(displayHighlighted){  
              query = 'select SKU_Last_Update__c,Item_12_Month_Qty__c,SKU__c,SKU_Description__c,Status__c, Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,Current_Sell_Price__c,Approved_Proposed_Price__c,UOM__c,Old_Price__c,Quantity_Per_Unit__c,Item_12_Month_Sales__c, Sales_Price_Change_Effective_Date_Appro__c,Price_Changed_After_Notify__c,QPU__c,Alt_QPU__c,Alt_List_Price__c,List_Price__c,SFDC_Notification_Flag__c from ACE_Customer_View__c  where Price_Changed_After_Notify__c = true and  name = \'' + pageKey  + '\' order by ' + fieldName + ' ' + sortDirection+ ' NULLS LAST limit ' +List_size+ ' OFFSET ' +counter+ '';             
              total_size = [select count() from ACE_Customer_View__c  where name =: pageKey and Price_Changed_After_Notify__c = true];
              System.debug('>>>>>>>>> query ' + query );  
              }
              else{
              query = 'select SKU_Last_Update__c,Item_12_Month_Qty__c,SKU__c,SKU_Description__c,Status__c, Alt_SKU__c, Alt_SKU_Description__c, Alt_UOM__c,Alt_Sell_Price__c,Current_Sell_Price__c,Approved_Proposed_Price__c,UOM__c,Old_Price__c,Quantity_Per_Unit__c,Item_12_Month_Sales__c, Sales_Price_Change_Effective_Date_Appro__c,Price_Changed_After_Notify__c,QPU__c,Alt_QPU__c,Alt_List_Price__c,List_Price__c,SFDC_Notification_Flag__c from ACE_Customer_View__c  where name = \'' + pageKey  + '\' order by ' + fieldName + ' ' + sortDirection+ ' NULLS LAST limit ' +List_size+ ' OFFSET ' +counter+ '';
              total_size = [select count() from ACE_Customer_View__c  where name =: pageKey];
              System.debug('>>>>>>>>> query ' + query );  
              }            
       
           }   
            skulist = database.query(query);    
                              System.debug('>>>>>>>>> skulist ' + skulist );
                              
                              //Start of 00827410
         skulistApproval = new list<ACE_Customer_View__c> ();
         skulistNonApproval = new list<ACE_Customer_View__c> ();

       for(integer i=0;i<skulist.size();i++){
           //Support 00826573 Blank New Price if sku swapped or new price 0 - Miles.
         if(skulist[i].Approved_Proposed_Price__c == 0.0 || skulist[i].Alt_SKU__c != null)
        	 {
             skulist[i].Approved_Proposed_Price__c = null;
             }
           
         if(skulist[i].SFDC_Notification_Flag__c=='3')
         skulistApproval.add(skulist[i]);
         else
         skulistNonApproval.add(skulist[i]);
       }
       
       System.debug('>>>>>>>>> skulistApproval' + skulistApproval.size());
       System.debug('>>>>>>>>> skulistNonApproval' + skulistNonApproval.size());


         //end of 00827410       
          
           /*  if (skulist.size() == 0) 
             {
              throw new CustException ('You Are Not Authorized To View This Page');        
             }
             else 
             {
                 list<AggregateResult> skuagg = [select min(expiration_date__c) expdt from ace_customer_view__c where name = :pageKey and expiration_date__c != null];
                 if (skuagg.size() > 0) 
                 {
                    skudate = date.valueOf(string.valueof(skuagg[0].get('expdt')));
                   
                   if (skudate < Date.today())
                     throw new custException('You Are Not Authorized to View This Page - The Page Has Expired');
                 }
             }  */
     
    }
    
    catch(custException ce) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
     displaypage = false;
    }
    catch(Exception e) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
     displaypage = false;
    }                    
         return null;                
  }
  
  public PageReference AppRec()
  {
         
         PageReference p = new PageReference (cPageUrl + '?pkey=' + pageKey + '&ekey=' + emailKey);
         p.setRedirect(true);
         try
         {
          String email = emailCheck();
          if (email == null) 
           throw new CustException('Approval Authority Does Not Exist, Please Validate Your Access');
          else
          {
              ACEPriceChangeRec.Customer_Response__c = 'Approved';
              ACEPriceChangeRec.Customer_Response_Email__c = email;
              ACEPriceChangeRec.Implementation_Status_Code__c = 'COMPL'; 
              
              for(ACE_Customer_MailOut__c MailOutRec:[select id,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c 
                                      where Customer_Core_Price_Changes__c =:ACEPriceChangeRec.id
                                      order by CreatedDate desc limit 1]){
                  MailOutRec.Reporting_Accepted_Date__c = system.now();
                  update MailOutRec;
              }
                   
              update ACEPriceChangeRec;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Response Has Been Submitted'));
              return p;
          }
         }
         catch (CustException ce) {
                PageReference perror = new PageReference (cPageUrl + '?pkey=' + pageKey + '&ekey=' + emailKey + '&ErrorCode=ERROR'+'&ErrorMsg=' + ce.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
        return perror;
         }
  }
  public PageReference RejRec()
  {
          PageReference p = new PageReference (cPageUrl + '?pkey=' + pageKey + '&ekey=' + emailKey);
           p.setRedirect(true);
      try
         {
          String email = emailCheck();
          if (email == null)
           throw new CustException('Approval Authority Does Not Exist, Please Validate Your Access');
          else
          {
              ACEPriceChangeRec.Customer_Response__c = 'Call Me';
              ACEPriceChangeRec.Customer_Response_Email__c = email;
              ACEPriceChangeRec.CallMeRequest__c = true;
              update ACEPriceChangeRec;
              
              /*Task t = new Task(whoId = ACEPriceChangeRec.id,subject=email);
              insert t;
              */
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your Response Has Been Submitted'));
              return p;
          }
         }
         catch (CustException ce) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
                return p;
         }
  }
 
  public string emailCheck() {
        list <ACE_Customer_MailOut__c> m = [select id,Email__c,Email_Key__c from ACE_Customer_MailOut__c where email_key__c = :emailKey];
        if (m.size() > 0)
          return m[0].email__c;
        else
          return null;
  }
    
  
}