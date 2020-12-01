/***************************************************************************
 Name         : CustomListViewController 
 Created By   : Lalit
 Description  : Class for CustomListView Page for S-410488(00687615)
 Created Date : May  5, 2016               
****************************************************************************/

public without sharing class CustomListViewController {
    
    //---------------------------------------------------------------------------//
   //properties, variables and constants
   //---------------------------------------------------------------------------// 
   
    public static Integer PAGESIZE = 20;//Label.JobProfileReportPageSize != null ? Integer.valueOf(Label.JobProfileReportPageSize) : 10;
    private static string DEFAULT_SORT_FIELD = 'Id';
    
    //dynamic cols related infos
    public Map<String,FieldSettingWrapper> mapColumns{get;set;}
    public List<String> fieldList {get;set;}        
    public String getFieldListSTR(){return '' + fieldList;}  
    public Map<String,FieldSettingWrapperAccount> mapColumnsAccount{get;set;}
    public List<String> fieldListAccount {get;set;}
     
    //sorting related infos 
    public string sortField{set;get;}   
    public boolean isAsc{set; get;}
    public String sortString {
        get{
        	 if (sortField != null) {
            String sortOrder = isAsc ? ' ASC ' : ' DESC ';
            return sortField + sortOrder; 
        	 } else {
        	 	return 'Order by CreatedDate';
        	 }
        }
    }    
    
    public string currentChar{get;set;}
    public String [] getCharList()
    {
        String [] l = new  String []{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','Other', 'All'};
        return l;
    }
    
    //listview related infos
    public String objectType{get;set;}
    public String objectLabel{get;set;}
    public String viewType{get;set;}
    public String objectTypeAccount{get;set;}
    public String objectLabelAccount{get;set;}
    public String viewTypeAccount{get;set;}
    
    
    public transient CustomPaginator.Paginator paginator {get;private set;}    
    public List<ObjectWrapper> DisplayList{get;set;}
    public transient CustomPaginator.Paginator paginatorAccount {get;private set;}    
    public List<ObjectWrapperAccount> DisplayListAccount{get;set;}
    
    Boolean enableSharing;    
    String filter;    
    String previousSortField;
    Integer currentPage; 
    String filterAccount;    
    String previousSortFieldAccount;
    Integer currentPageAccount;     
   
   //---------------------------------------------------------------------------//
   //Constructor and Page method
   //---------------------------------------------------------------------------// 
   
    public CustomListViewController(){
        init();
        initAccount();
    }
    
    //sort list
    public PageReference doSort(){
        isAsc = previousSortField.equals(sortField)? !isAsc : true;       
        currentChar = previousSortField.equals(sortField)? currentChar : 'All';           
        previousSortField = sortField;   
        initPaginator(); 
        return null;
    }
    public PageReference doSortAccount(){
        isAsc = previousSortFieldAccount.equals(sortField)? !isAsc : true;       
        currentChar = previousSortFieldAccount.equals(sortField)? currentChar : 'All';           
        previousSortFieldAccount = sortField;   
        initPaginatorAccount(); 
        return null;
    }
    
    public pageReference charFilter(){   
        initPaginator();
        return null;
    }
   
   //---------------------------------------------------------------------------//
   //Private helper methods
   //---------------------------------------------------------------------------// 
   //init page
   private void init(){
        viewType = apexpages.currentPage().getParameters().get('viewType');
        objectType = apexpages.currentPage().getParameters().get('objectType');
        objectLabel = apexpages.currentPage().getParameters().get('objectLabel');
        filter = apexpages.currentPage().getParameters().get('filter');
        enableSharing = apexpages.currentPage().getParameters().get('sharing') == 'true';        
        
        mapColumns = new Map<String,FieldSettingWrapper> ();
        Map<Integer,CustomListView__c> mapColumnOrders = new Map<Integer,CustomListView__c>();
        for(CustomListView__c col : CustomListView__c.getAll().values()){
            if(col.objectName__c != null && col.objectName__c.equalsIgnoreCase(objectType) && 
            ((viewType == null && col.viewType__c == null) || 
            (viewType != null && col.viewType__c != null && viewType.equalsIgnoreCase(col.viewType__c)))){
                mapColumnOrders.put(Integer.valueOf(col.ColumnOrder__c),col);
                mapColumns.put(col.FielApiName__c,new FieldSettingWrapper(col));
                if(col.referenceField__c != null && !mapColumns.containsKey(col.referenceField__c)){
                    mapColumns.put(col.referenceField__c,new FieldSettingWrapper());
                }
                if(col.IsDefaultSortField__c)
                    DEFAULT_SORT_FIELD = col.FielApiName__c;
            }
        }
        
                
        fieldList = new List<String>();     
        List<Integer> colOrders = new List<Integer>();
        colOrders.addAll(mapColumnOrders.keyset());
        colOrders.sort();
        for(Integer colOrder : colOrders){
            fieldList.add(mapColumnOrders.get(colOrder).FielApiName__c);
        }   
        
        currentChar = '';
        previousSortField = sortField = DEFAULT_SORT_FIELD;
        isAsc = true;
        initPaginator();
    }
    private void initAccount(){
        viewTypeAccount = 'AccountView';
        objectTypeAccount = 'Account';
        objectLabelAccount = 'Account';
        filterAccount = null;
        enableSharing = apexpages.currentPage().getParameters().get('sharing') == 'true';        
        
        mapColumnsAccount = new Map<String,FieldSettingWrapperAccount> ();
        Map<Integer,CustomListViewAccount__c> mapColumnOrders = new Map<Integer,CustomListViewAccount__c>();
        for(CustomListViewAccount__c col : CustomListViewAccount__c.getAll().values()){
            if(col.objectName__c != null && col.objectName__c.equalsIgnoreCase(objectTypeAccount) && 
            ((viewTypeAccount == null && col.viewType__c == null) || 
            (viewTypeAccount != null && col.viewType__c != null && viewTypeAccount.equalsIgnoreCase(col.viewType__c)))){
                mapColumnOrders.put(Integer.valueOf(col.ColumnOrder__c),col);
                mapColumnsAccount.put(col.FielApiName__c,new FieldSettingWrapperAccount(col));
                if(col.referenceField__c != null && !mapColumnsAccount.containsKey(col.referenceField__c)){
                    mapColumnsAccount.put(col.referenceField__c,new FieldSettingWrapperAccount());
                }
                if(col.IsDefaultSortField__c)
                    DEFAULT_SORT_FIELD = col.FielApiName__c;
            }
        }
        
                
        fieldListAccount = new List<String>();     
        List<Integer> colOrders = new List<Integer>();
        colOrders.addAll(mapColumnOrders.keyset());
        colOrders.sort();
        for(Integer colOrder : colOrders){
            fieldListAccount.add(mapColumnOrders.get(colOrder).FielApiName__c);
        }   
        
        currentChar = '';
        previousSortFieldAccount = sortField = DEFAULT_SORT_FIELD;
        isAsc = true;
        initPaginatorAccount();
    }
    
    //initialize paginator
    private void initPaginator(){
    	firstPage();
    }
    private void initPaginatorAccount(){
    	firstPageAccount();
    }
    
    //initialize paginator object
    private void setPagination(){
    	List<ObjectWrapper> recordsList = new List<ObjectWrapper>();
    	
    	
        for(sObject obj : enableSharing ? WithSharingUtility.databasequery(getQuery()) : database.query(getQuery())){
            recordsList.add(new ObjectWrapper(obj,mapColumns));
        }
        paginator = new CustomPaginator.Paginator(PAGESIZE, recordsList);
        currentPage = paginator.currentPage = currentPage != null ? currentPage : (paginator.totalPage > 0 ? 1 : 0);
    }
    
    private void setPaginationAccount(){
    	List<ObjectWrapperAccount> recordsList = new List<ObjectWrapperAccount>();
    	
    	
        for(sObject obj : enableSharing ? WithSharingUtility.databasequery(getQueryAccount()) : database.query(getQueryAccount())){
            recordsList.add(new ObjectWrapperAccount(obj,mapColumnsAccount));
        }
        paginatorAccount = new CustomPaginator.Paginator(PAGESIZE, recordsList);
        currentPageAccount = paginatorAccount.currentPage = currentPageAccount != null ? currentPageAccount : (paginatorAccount.totalPage > 0 ? 1 : 0);
    }
    
    private List<ObjectWrapper> setResultList(List<CustomPaginator.WrapperObject> resList){
        List<ObjectWrapper> resultList = new List<ObjectWrapper>(); 
        for(CustomPaginator.WrapperObject wrpObj : resList){
            resultList.add((ObjectWrapper)wrpObj);
        }
        return resultList;
    }
    private List<ObjectWrapperAccount> setResultListAccount(List<CustomPaginator.WrapperObject> resList){
        List<ObjectWrapperAccount> resultList = new List<ObjectWrapperAccount>(); 
        for(CustomPaginator.WrapperObject wrpObj : resList){
            resultList.add((ObjectWrapperAccount)wrpObj);
        }
        return resultList;
    }
        
    //for char filter
    private string getCharCondition()
    {
        if(currentChar == 'All' || currentChar == '') return '';
        
        Boolean isOther = currentChar == 'Other';
        String [] charLst = !isOther ? new String [] {currentChar} : new  String []{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        string soql ='';
        for(string chr : charLst){
            
            String clause = isOther ? (' (NOT(' + sortField + ' LIKE \''+ chr +'%\')) ') : (+ sortField + ' LIKE \''+ chr +'%\' ');
            if(soql=='')
                soql+= clause ;
            else
                soql+= ' AND ' + clause;
        }
        return '(' + soql +')';
    }
    
    //prepare whereclauses
    private string getWhereClause(){
        String clause = '';
        clause = getCharCondition();
        if(!Test.isRunningTest()){
        	filter = Label.Custom_View_Filter;//'Status = \'Open\' AND LeadSource = \'BSD Auto Account Setup\' AND RecordType.name = \'Lead (US)\' AND Account__r.AccountSource = \'BSD Auto Account Setup\' AND Account__r.recordType.name = \'Prospect\' AND Account__r.Rep_Call_Date__c = null AND Account__r.CreatedDate > 2016-01-01T00:00:00Z';
        }
                
        if(filter != null && filter != ''){
            clause += clause == ''? ('' + filter ) : (' AND ' + filter ) ;
        }
        clause += clause == ''? (' OwnerId = \'' + Userinfo.getUserId()+'\' ' ) : (' AND OwnerId = \'' + Userinfo.getUserId()+'\' ' ) ;
        return clause;
    }
    private string getWhereClauseAccount(){
        String clause = '';
        clause = getCharCondition();
        if(!Test.isRunningTest()){
        	filterAccount = Label.Custom_View_Filter_Account;//'Status = \'Open\' AND LeadSource = \'BSD Auto Account Setup\' AND RecordType.name = \'Lead (US)\' AND Account__r.AccountSource = \'BSD Auto Account Setup\' AND Account__r.recordType.name = \'Prospect\' AND Account__r.Rep_Call_Date__c = null AND Account__r.CreatedDate > 2016-01-01T00:00:00Z';
        }
                       
        if(filterAccount != null && filterAccount != ''){
            clause += clause == ''? ('' + filterAccount ) : (' AND ' + filterAccount ) ;
        }
        clause += clause == ''? (' OwnerId = \'' + Userinfo.getUserId()+'\' ' ) : (' AND OwnerId = \'' + Userinfo.getUserId()+'\' ' ) ; 
        return clause;
    }
    
    //prepare query
    private String getQuery(){
        String soql = 'Select ';
        
        if(mapColumns.size() > 0){
            for(String field : mapColumns.keyset()){
                soql += field + ',' ;
            }
            
            soql = soql.substring(0,soql.lastIndexOf(','));
            
        }else{
            soql += 'Id';
        }
        soql += ' From ' + objectType; 
        String whereClause = getWhereClause();
        if(whereClause != ''){
            soql += ' Where ' + whereClause;
        }  
        soql += ' order By ' + sortString;
        
        return soql;
    }  
    private String getQueryAccount(){
        String soql = 'Select ';
        
        if(mapColumnsAccount.size() > 0){
            for(String field : mapColumnsAccount.keyset()){
                soql += field + ',' ;
            }
            
            soql = soql.substring(0,soql.lastIndexOf(','));
            
        }else{
            soql += 'Id';
        }
        soql += ' From ' + objectTypeAccount; 
        String whereClause = getWhereClauseAccount();
        if(whereClause != ''){
            soql += ' Where ' + whereClause;
        }  
        soql += ' order By ' + sortString;
        System.debug('Account Query--->'+soql);
        return soql;
    }   
   
   //---------------------------------------------------------------------------//
   //Methods/Properties related to page navigation
   //---------------------------------------------------------------------------//   
   
    //move to next page
    public PageReference nextPage(){    	
        setPagination();
        DisplayList = setResultList(paginator.getNextPage());
        currentPage += 1; 
               
        return null;
    }
    public PageReference nextPageAccount(){    	
        setPaginationAccount();
        DisplayListAccount = setResultListAccount(paginatorAccount.getNextPage());
        currentPageAccount += 1; 
               
        return null;
    }
    
    //move to previous page
    public PageReference previousPage(){    	
        setPagination();
        DisplayList = setResultList(paginator.getPreviousPage());
        currentPage -= 1;
        return null;
    }
    public PageReference previousPageAccount(){    	
        setPaginationAccount();
        DisplayListAccount = setResultListAccount(paginatorAccount.getPreviousPage());
        currentPageAccount -= 1;
        return null;
    }
    
    //move to next page
    public PageReference firstPage(){    	
        setPagination();
        DisplayList = setResultList(paginator.getFirstPage());
        currentPage = paginator.currentPage;
        return null;
    }
    public PageReference firstPageAccount(){    	
        setPaginationAccount();
        DisplayListAccount = setResultListAccount(paginatorAccount.getFirstPage());
        currentPageAccount = paginatorAccount.currentPage;
        return null;
    }
    
    //move to next page
    public PageReference lastPage(){    	
        setPagination();
        DisplayList = setResultList(paginator.getLastPage());
        currentPage = paginator.currentPage;
        return null;
    }
    public PageReference lastPageAccount(){    	
        setPaginationAccount();
        DisplayListAccount = setResultListAccount(paginatorAccount.getLastPage());
        currentPageAccount = paginatorAccount.currentPage;
        return null;
    }
     
   //---------------------------------------------------------------------------//
   //Inner wrapper classes
   //---------------------------------------------------------------------------// 
   
    public class FieldSettingWrapper {
        public CustomListView__c fieldSetting;
        public String getFieldLabel(){ return fieldSetting.FieldName__c;}
        public Boolean getEnableCharFilter(){ return fieldSetting.enableCharFilter__c;}
        public Boolean getMakeLink(){ return fieldSetting.referenceField__c != null && fieldSetting.makeLink__c == true;}
        public String getReferenceField(){ return fieldSetting.referenceField__c;}
        public Boolean getMakeVisible(){ return fieldSetting.makeVisible__c;}
        public Boolean getEscapeOutput(){ return fieldSetting.Escape_Output__c;}     
        public String getSortByFieldAPI(){ return fieldSetting.SortByFieldAPI__c;}    
        
        public FieldSettingWrapper(){
            this.fieldSetting = new CustomListView__c();
        }
        
        public FieldSettingWrapper(CustomListView__c fieldSetting){
            this.fieldSetting = fieldSetting;
        }        
    }
    public class FieldSettingWrapperAccount {
        public CustomListViewAccount__c fieldSetting; 
        public String getFieldLabel(){ return fieldSetting.FieldName__c;}
        public Boolean getEnableCharFilter(){ return fieldSetting.enableCharFilter__c;}
        public Boolean getMakeLink(){ return fieldSetting.referenceField__c != null && fieldSetting.makeLink__c == true;}
        public String getReferenceField(){ return fieldSetting.referenceField__c;}
        public Boolean getMakeVisible(){ return fieldSetting.makeVisible__c;}
        public Boolean getEscapeOutput(){ return fieldSetting.Escape_Output__c;}     
        public String getSortByFieldAPI(){ return fieldSetting.SortByFieldAPI__c;}    
        
        public FieldSettingWrapperAccount(){
            this.fieldSetting = new CustomListViewAccount__c();
        }
        
        public FieldSettingWrapperAccount(CustomListViewAccount__c fieldSetting){
            this.fieldSetting = fieldSetting;
        }        
    }
    
    public class ObjectWrapper extends CustomPaginator.WrapperObject{   
    	public Map<String,FieldSettingWrapper> mapColumns {get;set;}
    	sObject obj;     
        public Map<String,Object> getfieldMap (){
        	Map<String,Object> fieldMap1 = new Map<String,Object>();
            for(String field : mapColumns.keyset()){
                FieldSettingWrapper fieldWrapper = mapColumns.get(field);
                
                Object val = getValue(obj, field);
                fieldMap1.put(field,val != null? val : '');
                if(fieldWrapper.getMakeLink()){
                    fieldMap1.put(field + '__REF' , getUrl(fieldWrapper,obj));
                }
            }
            return fieldMap1;
        }
        
        
        public objectWrapper(sObject obj,Map<String,FieldSettingWrapper> mapColumns){
        	this.obj = obj;            
        	this.mapColumns = mapColumns;
        } 
        
        private string getUrl(FieldSettingWrapper fieldWrapper, sObject obj){                       
            return getValue(obj, fieldWrapper.getReferenceField()) + '';			
        }
    }
    public class ObjectWrapperAccount extends CustomPaginator.WrapperObject{   
    	public Map<String,FieldSettingWrapperAccount> mapColumns {get;set;}
    	sObject obj;     
        public Map<String,Object> getfieldMap (){
        	Map<String,Object> fieldMap1 = new Map<String,Object>();
            for(String field : mapColumns.keyset()){
                FieldSettingWrapperAccount fieldWrapper = mapColumns.get(field);
                
                Object val = getValue(obj, field);
                fieldMap1.put(field,val != null? val : '');
                if(fieldWrapper.getMakeLink()){
                    fieldMap1.put(field + '__REF' , getUrl(fieldWrapper,obj));
                }
            }
            return fieldMap1;
        }
        
        
        public objectWrapperAccount(sObject obj,Map<String,FieldSettingWrapperAccount> mapColumns){
        	this.obj = obj;            
        	this.mapColumns = mapColumns;
        } 
        
        private string getUrl(FieldSettingWrapperAccount fieldWrapper, sObject obj){                       
            return getValue(obj, fieldWrapper.getReferenceField()) + '';			
        }
    }
    
	//-----------------------------------------------------------------------------------
   // Method to get a Value of some field of a object
   //-----------------------------------------------------------------------------------
   public static Object getValue(sObject obj,String fieldAPI){   
        while(obj != null && fieldAPI.contains('.'))
        {
            obj = obj.getSObject(fieldAPI.substring(0,fieldAPI.indexof('.')));         
            fieldAPI = fieldAPI.substring(fieldAPI.indexof('.')+1, fieldAPI.length());
        }                     
        return obj != null? obj.get(fieldAPI) : null;
  }
  
}