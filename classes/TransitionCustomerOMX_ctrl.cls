public class TransitionCustomerOMX_ctrl {

    public List<Customer_Transition_Dtls__c> TransitionAccounts{get;set;}
    public String ErrorMessageTypeValue { get; set; }
    public String ErrorMessageLevelValue { get; set; }
    public String accountName {get; set;}
    public static String sortingField {get; set;}
    public String custAccountName{get; set;}
    public String CustAccountOMX{get; set;}
    public static String sortDir {get; set;}
    public string recordTypeValue{get;set;}
    public ID transRecID {get;set;}
    public List<SelectOption> ErrorMessageLevelOptions{get;set;}
    public List<SelectOption> ErrorMessageTypeOptions{get;set;}
    public List<Customer_Transition__c> lCustTransRec;
    public List<Customer_Transition_Dtls__c> lCustTransDtlRec;
    public List<Customer_Transition__c> lCustTransAccRec = new List<Customer_Transition__c>();
    public List<Account> lCustAccRec = new List<Account>();
    public Customer_Transition__c custTrans{get;set;}
    Public Integer size{get;set;}
    Public Integer noOfRecords{get; set;}
    
    public TransitionCustomerOMX_ctrl(){
        
        //sortDir = 'ASC';  
        //sortingField = 'name';  
        TransitionAccounts= new List<Customer_Transition_Dtls__c>();
        custTrans = new Customer_Transition__c();
        transRecID = ApexPages.currentPage().getParameters().get('id');
        lCustTransRec = new List<Customer_Transition__c>();
        lCustTransDtlRec = new list<Customer_Transition_Dtls__c>();
        if (transRecID != null) {
          
          lCustTransDtlRec = [Select id,name,Account_ID__c,PO_Number__c,Customer_Transition_ID__r.OMX_Primary_Key__c,Customer_Transition_ID__r.Account__r.name,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c,RecordType.Name  from Customer_Transition_Dtls__c where  id =:transRecID];

          if(lCustTransDtlRec == NULL || lCustTransDtlRec.size() == 0)
          {
          lCustTransRec= [Select id, name,Account__c,Account__r.name,OMX_Primary_Key__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition__c where id =:transRecID];
          }
          if((lCustTransDtlRec == NULL || lCustTransDtlRec.size() == 0) && (lCustTransRec == NULL || lCustTransRec.size() == 0))
          {
          lCustAccRec = [Select id, name,OMX_Primary_Key__c from Account where id =:transRecID];
          }
        }
       
        if(lCustTransRec.size() >0){
            //pageLoad = 'Header';
            custTrans.Account__c = lCustTransRec[0].Account__c;
            CustAccountOMX = lCustTransRec[0].OMX_Primary_Key__c;
            }
        else 
        if(lCustTransDtlRec.size() >0){
            //pageLoad = 'Detail';
            custTrans.Account__c = lCustTransDtlRec[0].Customer_Transition_ID__r.account__c;
            CustAccountOMX = lCustTransDtlRec[0].Customer_Transition_ID__r.OMX_Primary_Key__c;
        }
        else if(lCustAccRec.size() >0){
            custTrans.Account__c = lCustAccRec[0].id;
            CustAccountOMX = lCustAccRec[0].OMX_Primary_Key__c;            
        }
        
        // List of Exception Levels
        ErrorMessageLevelOptions= new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Customer_Transition__c.Error_Message_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        ErrorMessageLevelOptions.add(new SelectOption('--None--', '--None--'));
        for(Schema.PicklistEntry f : ple)
              ErrorMessageLevelOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        
        // List of Exception Type
        ErrorMessageTypeOptions= new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult1 =  Customer_Transition__c.Error_Message_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        ErrorMessageTypeOptions.add(new SelectOption('--None--', '--None--'));
        for(Schema.PicklistEntry f : ple1)
              ErrorMessageTypeOptions.add(new SelectOption(f.getLabel(), f.getValue())); 
                  
             
    }
    
    public ApexPages.StandardSetController setCon {
        get{
            String DetailSQL_noExecute = null;
            
            
            if(setCon == null){
                size = 50;
             string DetailSOQL = 'select id,name,recordtypeid,Cost_Center_ID__c,PO_ID__c,PO_Number__c,OMX_Primary_Key__c,Account_ID__c,Customer_Transition_ID__r.OMX_Primary_Key__c,Customer_Transition_ID__r.Account__r.name,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c,RecordType.Name  from Customer_Transition_Dtls__c where Error_Code__c = \'Error\'';   // id=:transRecID and             
             DetailSQL_noExecute = DetailSOQL;
             setCon = new ApexPages.StandardSetController(Database.getQueryLocator(DetailSQL_noExecute + ' limit 50'));
             if(custTrans.Account__c != null)
                 DetailSOQL += ' and Customer_Transition_ID__r.account__r.id =\'' + custTrans.Account__c +'\'';                
             system.debug('<<<<<>>>>>'+CustAccountOMX+'>>>>custTrans.Account__r.OMX_Primary_Key__c>>'+custTrans.Account__r.OMX_Primary_Key__c);
             if(CustAccountOMX != null)
                 DetailSOQL += ' and Customer_Transition_ID__r.OMX_Primary_Key__c LIKE \'%'+CustAccountOMX+'%\'';                
             if(ErrorMessageLevelValue != '--None--' && ErrorMessageLevelValue != '' && ErrorMessageLevelValue != null)
                 DetailSOQL += ' and Error_Message_Level__c=:ErrorMessageLevelValue ';                
             if(ErrorMessageTypeValue != '--None--' && ErrorMessageTypeValue != '' && ErrorMessageTypeValue != null)
                 DetailSOQL += ' and Error_Message_Type__c=:ErrorMessageTypeValue'; 
             if(sortingField!='' && sortingField!= null)
                 DetailSOQL += ' order by ' +sortingField +' '+ sortDir;
             
                if (DetailSQL_noExecute != DetailSOQL) {  
                  system.debug('deepak:'+   DetailSOQL);     
                 setCon = new ApexPages.StandardSetController(Database.getQueryLocator(DetailSOQL));
                  
                }
                setCon.setPageSize(size);
                 
                 noOfRecords = setCon.getResultSize();
            }
            
            return setCon;
            
        }set;
    }

    Public List<Customer_Transition_Dtls__c> getTransitionDtls(){
        
        List<Customer_Transition_Dtls__c> DtlList = new List<Customer_Transition_Dtls__c>();
        
        for(Customer_Transition_Dtls__c dtl : (List<Customer_Transition_Dtls__c>)setCon.getRecords())
        DtlList.add(dtl);
        
        return DtlList;
    }
    
    public PageReference Search(){
        setCon = null;
         
        getTransitionDtls();
        return null;
    }
    
    public PageReference populateOMX(){
      if(custTrans.Account__c!=null){
       
        lCustTransAccRec = [Select id,name,account__c,OMX_Primary_Key__c from Customer_Transition__c where account__r.id =: custTrans.Account__c];
       if(lCustTransAccRec[0].OMX_Primary_Key__c!='' && lCustTransAccRec[0].OMX_Primary_Key__c!= null)
        CustAccountOMX = lCustTransAccRec[0].OMX_Primary_Key__c;
       else
        CustAccountOMX = null;
      return null;
      }
      else
      return null;
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return setcon.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return setcon.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return setcon.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         setcon.first();
     }

     // returns the last page of records
     public void last() {
         setcon.last();
     }

     // returns the previous page of records
     public void previous() {
         setcon.previous();
     }

     // returns the next page of records
     public void next() {
         system.debug('setcon>>>>>>'+setcon);
         setcon.next();
         system.debug('next setcon>>>>>>'+setcon);
    }
}