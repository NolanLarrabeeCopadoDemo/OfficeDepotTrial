public class Contract_Pricing_Terms_Extension {
    public Contract_Pricing_Terms__c ContractPricing{get;set;}
    public Contract_Pricing_Terms__c ContractPricingclone;
    ApexPages.StandardController sControllervalue; 
    public  List<Merch_Dept_Group__c> DepartmentsMapping{get;set;}
    public list<WrapperClass> wrapperlist{get;set;}
    public map<string,boolean> selectedDept = new map<string,boolean>();
    private set<string> departmentNameset = new set<string>();
    private list<string> departmentName = new list<string>();
    private List<RowWrapper> rows;
    private string clone;
    private string lastselectedvaule;
    public list<string> part = new list<string>();
    public Boolean changethename{get;set;}
    public Boolean deletepermission{get;set;}
    private String queryString;  
    
    public List<SelectOption> statusOptions18 {get;set;}
    
    public Contract_Pricing_Terms_Extension(ApexPages.StandardController stdController){
        sControllervalue = stdController;
        this.ContractPricing = (Contract_Pricing_Terms__c)stdController.getRecord();
        system.debug('!!!!!!'+ContractPricing.Active__c);
        deletepermission=false;
        String recordid=ApexPages.currentPage().getParameters().get('id');
        /*String Saveandnew=ApexPages.currentPage().getParameters().get('save_new');
if(Saveandnew=='1')
{
ContractPricing.Contract__c=
}*/
        Schema.DescribeSObjectResult pricingtermpermission = Contract_Pricing_Terms__c.SObjectType.getDescribe();
        if(pricingtermpermission.isDeletable())
        {
            system.debug('permission true');
            deletepermission=true;
        }
        if(recordid==null)
        {
            ContractPricing.Active__c=true;
        }
        system.debug('@@@@@@@@'+ContractPricing.Active__c);
        
        wrapperlist= new list<WrapperClass>();
        DepartmentsMapping= new List<Merch_Dept_Group__c>();        
        DepartmentsMapping= [select id,Name,Department__c,Dept_Group_Name__c,Active__c from Merch_Dept_Group__c where Active__c=true];
        for(Merch_Dept_Group__c deptName : DepartmentsMapping){
            departmentNameset.add(deptName.Department__c);
        }     
        for( string deplist : departmentNameset){
            departmentName.add(deplist);
        }
        departmentName.sort();
        if(ContractPricing.id!=null){
            string s = [select id,Departments__c from Contract_Pricing_Terms__c where id=:ContractPricing.id].Departments__c; 
            if(s!=null){
                part = s.split(';');
                system.debug('part **'+part); 
            }
            
        }
        for(RowWrapper rowList : getRowWrappers()){            
            for(WrapperClass warpp:rowList.values){
                for(string merchVal:part ){
                    if(warpp.departmentName == merchVal){
                        warpp.checked = true;
                    }    
                }
            }
        }   
        /*for (string dept:departmentName){
WrapperClass w= new WrapperClass(false,dept);
system.debug('wrapperlist**'+wrapperlist);
wrapperlist.add(w);  
}*/ 
        if(clone==null){
            clone = ApexPages.currentPage().getParameters().get('clone');
            if(clone=='1'){
                ContractPricing.Name = null;
                ContractPricing.Department_Groups__c = null;
                ContractPricing.Departments__c = null;
                for(RowWrapper rowList : getRowWrappers()){            
                    for(WrapperClass warpp:rowList.values){
                        warpp.checked = false;
                    }
                }
            }
        }    
        //if(ApexPages.currentPage().getParameters().get('retURL')!=null){
        disableDepartment();
        //}
        //List<string> pageUrl = ApexPages.currentPage().getUrl().split('\\?');  
        //queryString = pageUrl[1];  
        
        
        statusOptions18 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription18 = Contract_Pricing_Terms__c.Notification_process_for_disco_items__c.getDescribe();
        for (Schema.Picklistentry picklistEntry18:statusFieldDescription18.getPicklistValues()){
            
            statusOptions18.add(new SelectOption(picklistEntry18.getValue(),picklistEntry18.getLabel()));
            /*if ((picklistEntry18.defaultValue)&&(ContractPricing.Notification_process_for_disco_items__c==null)){
                ContractPricing.Notification_process_for_disco_items__c = picklistEntry18.getValue();
            }*///02436223
        }
        
        Schema.DescribeFieldResult  How_frequently_must_we_pass_decreases= Contract_Pricing_Terms__c.How_frequently_must_we_pass_decreases__c.getDescribe();
        for (Schema.Picklistentry picklistEntry19:How_frequently_must_we_pass_decreases.getPicklistValues()){
            
            if ((picklistEntry19.defaultValue)&&(ContractPricing.How_frequently_must_we_pass_decreases__c==null)){
                ContractPricing.How_frequently_must_we_pass_decreases__c = picklistEntry19.getValue();
            }
        }
        
        
    }
    
    
    public void PopulateCheckBox(){
        system.debug('PopulateCheckBox');
        string s = ContractPricing.Department_Groups__c;
        
        system.debug('s**'+s);
        if(s!=null){
            if(s!=null && s.contains('Select All')){
                ContractPricing.Department_Groups__c= 'Select All';
            }
        }
        /*if(s!=null && s.contains('Select All')){
ContractPricing.Department_Groups__c= 'Select All';
}else if(s!=null && s.contains('Deselect All')){
ContractPricing.Department_Groups__c= 'Deselect All';
}*/
        
        for(RowWrapper rowList : getRowWrappers()){            
            for(WrapperClass warpp:rowList.values){
                warpp.checked = false;
            }
        }
        if(s!=null && s.contains('Select All')){
            for(RowWrapper rowList : getRowWrappers()){            
                for(WrapperClass warpp:rowList.values){
                    if(warpp.disable == false){
                        warpp.checked = true;
                    }
                }
            }
        }
        if(s!=null){     
            system.debug('s**'+s);       
            List<string> part = new List<string>();
            part = s.split(';');
            list<Merch_Dept_Group__c> deptValue = [select Department__c from Merch_Dept_Group__c where Dept_Group_Name__c IN :part];
            for(Merch_Dept_Group__c merchVal:deptValue ){
                system.debug('merchVal**'+merchVal);
                for(RowWrapper rowList : getRowWrappers()){            
                    for(WrapperClass warpp:rowList.values){                        
                        if(warpp.departmentName == merchVal.Department__c && warpp.disable == false){
                            system.debug('True**');
                            warpp.checked = true;
                        }  
                    }
                } 
            }
        }
        
        
        
    }
    public List<RowWrapper> getRowWrappers()
    {
        system.debug('getRowWrappers**');
        if (null==rows){
            rows=new List<RowWrapper>();     
            for (Integer idx=0; idx<(departmentName.size()/4)+1; idx++){
                rows.add(new RowWrapper());
            }
            Integer count = 0;
            for (string depName: departmentName){              
                if (null!=depName){
                    rows[count/4].addValue(false,depName,false); 
                    count++;
                }
            }
        }
        system.debug('rows**'+rows);
        return rows;
    }
    public void disableDepartment(){
        string deptvalues ='';
        system.debug('disableDepartment');
        if(clone=='1'){
            ContractPricing.id = null;
        }
        list<Contract_Pricing_Terms__c> duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,Contract__c,Departments__c from Contract_Pricing_Terms__c where Relevant_Customer_Level__c=:ContractPricing.Relevant_Customer_Level__c and Private_Brand__c=:ContractPricing.Private_Brand__c and Contract__c =:ContractPricing.Contract__c and Active__c=true and (NOT id =:ContractPricing.id)];
        system.debug('duplicateRec **'+duplicateRec+'---'+ContractPricing.Active__c);
        for(Contract_Pricing_Terms__c pricingTerm : duplicateRec){
            deptvalues+=pricingTerm.Departments__c+';';
        }
        for(RowWrapper rowList : getRowWrappers()){            
            for(WrapperClass warpp:rowList.values){ 
                warpp.disable = false;
            }  
        }
        
        List<string> departVal= new List<string>();
        set<string> departmentVal= new set<string>();
        if(deptvalues!=null  && ContractPricing.Active__c){//
            departVal = deptvalues.split(';');
            system.debug('departVal **'+departVal );
            for(string dep : departVal){
                departmentVal.add(dep);
            }
            system.debug('departmentVal**'+departmentVal);
            for(string merchVal:departmentVal){
                system.debug('merchVal**'+merchVal);
                for(RowWrapper rowList : getRowWrappers()){            
                    for(WrapperClass warpp:rowList.values){                        
                        if(warpp.departmentName == merchVal){
                            system.debug('True**');
                            warpp.checked = false;
                            warpp.disable = true;
                        }  
                    }
                } 
            }
        }
        //PopulateCheckBox();
    }
    public void Populatevalue(){   
        system.debug('Populatevalue **');
        string deptValue='';
        for(RowWrapper rowList : getRowWrappers()){            
            for(WrapperClass warpp:rowList.values){
                if(warpp.checked == true && warpp.disable == false){
                    system.debug('chekIF');
                    deptValue+=warpp.departmentName+';';
                }
            }
        }        
        system.debug('deptValue**'+deptValue);
        ContractPricing.Departments__c = deptValue;        
    }    
    public PageReference saveAndNew() {   
        system.debug('saveAndNew@');
        try { 
            PageReference pr;  
            Populatevalue();
            system.debug('ContractPricing.Departments__c**'+ContractPricing.Departments__c);
            /*if(ContractPricing.Relevant_Customer_Level__c == '' || ContractPricing.Relevant_Customer_Level__c == null){
//ContractPricing.Relevant_Customer_Level__c.adderror('You must Enter a Value');
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Relevant customer level(s) for this pricing terms group:You must enter a value'));
return null;        
}
if(ContractPricing.Required_Timing_Of_CC_Updates__c == '' || ContractPricing.Required_Timing_Of_CC_Updates__c == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Does the contract specify a specific month(s) that pricing for custom core SKUs must be updated?:You must enter a value'));
return null;        
}
if(ContractPricing.Vendor_Letter_Required_For_CC_Increase__c == '' || ContractPricing.Vendor_Letter_Required_For_CC_Increase__c == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Are manufacturer/vendor letters required to permit price increases?:You must enter a value'));
return null;        
}
if(ContractPricing.Comm_Req_CC_Price_Chg__c == '' || ContractPricing.Comm_Req_CC_Price_Chg__c == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'What type of customer communication is required to permit pricing changes on the custom core?:You must enter a value'));
return null;        
}
if((ContractPricing.Comm_Req_CC_Price_Chg__c=='Notification and customer approval'||ContractPricing.Comm_Req_CC_Price_Chg__c=='Notification only') && ContractPricing.CC_Prc_Chg_Notice_Reqd_days__c == null){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'How much notice must be provided before pricing changes can be made? (in days):You must enter a value'));
return null;        
}
/*if((ContractPricing.Is_there_language_stating_thatapplicable__c== '' || ContractPricing.Is_there_language_stating_thatapplicable__c == null)&&(ContractPricing.CC_Price_Incr_Capped__c=='Yes')){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Is there language stating that the applicable cap should be the lesser of two values?:You must enter a value'));
return null;        
}
if((ContractPricing.CC_Price_Incr_Cap_Pegd_To__c=='Consumer Price Index (CPI)' && ContractPricing.CC_Price_Incr_Capped__c=='Yes' ) && (ContractPricing.What_level_is_the_Consumer_Price_Index__c == '' || ContractPricing.What_level_is_the_Consumer_Price_Index__c == null)){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'What level is the Consumer Price Index applied?:You must enter a value'));
return null;        
}
if((ContractPricing.CC_Price_Incr_Cap_Pegd_To__c=='Consumer Price Index (CPI)' && ContractPricing.CC_Price_Incr_Capped__c=='Yes' ) && (ContractPricing.Which_Producer_Price_Index_structure__c == '' || ContractPricing.Which_Producer_Price_Index_structure__c == null)){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Which Producer Price Index structure is applied?:You must enter a value'));
return null;        
}*/
            
            /*if((ContractPricing.CC_Price_Incr_Cap_Pegd_To__c=='Consumer Price Index (CPI)' && ContractPricing.CC_Price_Incr_Capped__c=='Yes' ) && (ContractPricing.CPI_Price_Incr_Pegd_To__c == '' || ContractPricing.CPI_Price_Incr_Pegd_To__c == null)){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Which Consumer Price Index are price increases pegged to?:You must enter a value'));
return null;        
}*/
            if(ContractPricing.Departments__c=='' || ContractPricing.Departments__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select at least one Department.'));
                return null;
            }
            SObject saveNew = sControllervalue.getRecord();
            upsert saveNew;
            /*Schema.DescribeSObjectResult describeResult = sControllervalue.getRecord().getSObjectType().getDescribe();
system.debug('@@@@@@@'+describeResult);
pr = new PageReference('/' + field.getKeyPrefix() + '/e');
pr.setRedirect(true);
return pr;*/
            string s;
            if(UserInfo.getOrganizationId() == '00DE0000000J4oSMAS'){          
                s = '/' + ('' + saveNew.get('Id')).subString(0, 3) + '/e?CF00NE0000001v8i2='+ContractPricing.Contract__c+'&CF00NE0000001v8i2_lkid='+ContractPricing.Contract__c+'&scontrolCaching=1&retURL=/apex/SpringCMContract2%3Fid='+ContractPricing.Contract__c+'%26sfdc.override%3D1&sfdc.override=1';
            }else{
                //s = '/' + ('' + saveNew.get('Id')).subString(0, 3) + '/e?CF00NM0000000z2Lr='+ContractPricing.Contract__c+'&CF00NM0000000z2Lr_lkid='+ContractPricing.Contract__c+'&scontrolCaching=1&retURL=/apex/SpringCMContract2%3Fid='+ContractPricing.Contract__c+'%26sfdc.override%3D1&sfdc.override=1';
                s = '/' + ('' + saveNew.get('Id')).subString(0, 3) + '/e?CF00NE0000001v8i2='+ContractPricing.Contract__c+'&CF00NE0000001v8i2_lkid='+ContractPricing.Contract__c+'&scontrolCaching=1&retURL=/apex/SpringCMContract2%3Fid='+ContractPricing.Contract__c+'%26sfdc.override%3D1&sfdc.override=1';                                
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));
            return new Pagereference(s);  
        } catch(Exception e) {   
            ApexPages.addMessages(e);   
            return null;   
        }   
    } 
    public PageReference backToContract() {   
        
        PageReference pr;             
        string s = '/apex/springcmContract2?id='+ContractPricing.Contract__c;           
        return new Pagereference(s);  
        
    } 
    public PageReference Deleterecord()
    {
        delete ContractPricing;
        system.debug('Custom Delete');
        PageReference pr1;
        string s1 = '/apex/springcmContract2?id='+ContractPricing.Contract__c;
        system.debug('pagereference'+s1);
        return new PageReference(s1);
        
    }
    public void conditionaldisplay(){
        system.debug('hihih'+ContractPricing.CC_Price_Incr_Cap_Pegd_To__c);
        system.debug('pickist val-->' +ContractPricing.CC_Price_Incr_Capped__c);
        system.debug('==========Is_there_language_stating_thatapplicable__c======'+ContractPricing.Is_there_language_stating_thatapplicable__c);
        
        if(ContractPricing.Comm_Req_CC_Price_Chg__c!='Notification and customer approval'||ContractPricing.Comm_Req_CC_Price_Chg__c!='Notification only'){
            ContractPricing.CC_Prc_Chg_Notice_Reqd_days__c = null;
        }  
        
        if(ContractPricing.CC_Price_Incr_Capped__c!='Yes'){
            ContractPricing.Price_cap_language__c=null; 
        }  
        
        if(ContractPricing.CC_Price_Incr_Capped__c=='Yes'){
            if(ContractPricing.Is_there_language_stating_thatapplicable__c==null)
                ContractPricing.Is_there_language_stating_thatapplicable__c='Needs validation';
        }
        
        
        
        if(ContractPricing.CC_Price_Incr_Capped__c!='Yes'){
            ContractPricing.Is_there_language_stating_thatapplicable__c=null;
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd_To__c!='Other'){
            ContractPricing.Other_cap_basis__c= null;
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd2To__c!='Other'){
            ContractPricing.Second_cap_basis__c= null;
        }
        
        if(ContractPricing.Is_there_language_stating_thatapplicable__c!='Yes'){
            if(ContractPricing.Is_there_language_stating_thatapplicable__c!='Contract silent'){
                ContractPricing.CC_Price_Incr_Cap_Pegd_To__c = null;
            }
            ContractPricing.CC_Price_Incr_Cap_Pegd2To__c = null;
            ContractPricing.CPI_Price_Incr_Pegd_To__c  = null;
            ContractPricing.CPI_Price_Incr_Pegd2To__c  = null;
            ContractPricing.What_level_is_the_Consumer_Price_Index__c = null;
            ContractPricing.What_level_is_the_Consumer_Price_Index2__c = null;
            ContractPricing.Which_Consumer_Price_Index_region__c = null; 
            ContractPricing.Which_Consumer_Price_Index_region2__c = null;    
            ContractPricing.Which_Consumer_Price_Index_local_area__c = null; 
            ContractPricing.Which_Consumer_Price_Index_local_area2__c = null;
            ContractPricing.Which_Producer_Price_Index_structure__c  = null;
            ContractPricing.Which_Producer_Price_Index_structure2__c = null;
            ContractPricing.Detail_of_PPI_index_structure_indicated__c = null; 
            ContractPricing.Detail_of_PPI_index_structure_indicated2__c = null;
            ContractPricing.Price_Incr_Cap_Amt__c = null;
            ContractPricing.Price_Incr_Cap_Type_Unit__c = null;
            ContractPricing.Price_Increase_Cap_Amount_2__c = null;
            ContractPricing.Price_Increase_Cap_2_Type_Units__c = null;
        }
        
        if(ContractPricing.CC_Price_Incr_Cap_Pegd_To__c!='Static Amount'){
            
            
            ContractPricing.Price_Incr_Cap_Amt__c = null;
            ContractPricing.Price_Incr_Cap_Type_Unit__c = null;
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd2To__c!='Static Amount'){
            ContractPricing.Price_Increase_Cap_Amount_2__c = null;
            ContractPricing.Price_Increase_Cap_2_Type_Units__c = null;
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd_To__c != 'Consumer Price Index (CPI)'){
            ContractPricing.CPI_Price_Incr_Pegd_To__c  = null;
            ContractPricing.What_level_is_the_Consumer_Price_Index__c = null;            
            ContractPricing.Which_Consumer_Price_Index_region__c = null;                
            ContractPricing.Which_Consumer_Price_Index_local_area__c = null;                         
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd_To__c != 'Producer Price Index (PPI)'){
            ContractPricing.Which_Producer_Price_Index_structure__c  = null;
            ContractPricing.Detail_of_PPI_index_structure_indicated__c = null; 
        }
        if(ContractPricing.What_level_is_the_Consumer_Price_Index__c!= 'Region'){
            ContractPricing.Which_Consumer_Price_Index_region__c = null;  
        }
        if(ContractPricing.What_level_is_the_Consumer_Price_Index__c!= 'Local Area'){
            ContractPricing.Which_Consumer_Price_Index_local_area__c = null; 
        }
        if(ContractPricing.CC_Price_Incr_Cap_Pegd2To__c != 'Consumer Price Index (CPI)'){
            ContractPricing.CPI_Price_Incr_Pegd2To__c  = null;
            ContractPricing.What_level_is_the_Consumer_Price_Index2__c = null;
            ContractPricing.Which_Consumer_Price_Index_region2__c = null; 
            ContractPricing.Which_Consumer_Price_Index_local_area2__c = null;
        }   
        if(ContractPricing.CC_Price_Incr_Cap_Pegd2To__c != 'Producer Price Index (PPI)'){
            ContractPricing.Which_Producer_Price_Index_structure2__c = null;
            ContractPricing.Detail_of_PPI_index_structure_indicated2__c = null;            
        }   
        if(ContractPricing.What_level_is_the_Consumer_Price_Index2__c!= 'Region'){
            ContractPricing.Which_Consumer_Price_Index_region2__c = null;  
        }
        if(ContractPricing.What_level_is_the_Consumer_Price_Index2__c!= 'Local Area'){
            ContractPricing.Which_Consumer_Price_Index_local_area2__c = null; 
        }    
        if(ContractPricing.How_frequently_can_we_pass_increases__c!= 'Calendar'){
            ContractPricing.Calendar_period__c = null;
            ContractPricing.Other_calendar_period__c = null;
            ContractPricing.Date_1__c = null;
            ContractPricing.Date_2__c = null;
            ContractPricing.Date_3__c = null;
            ContractPricing.Date_4__c = null;
        }   
        if(ContractPricing.How_frequently_can_we_pass_increases__c!= 'Numeric'){
            ContractPricing.In_days__c = null; 
        }  
        if(ContractPricing.Calendar_period__c!= 'Other'){
            ContractPricing.Other_calendar_period__c = null; 
        }
        if(ContractPricing.Calendar_period__c!= 'Specific date'){
            ContractPricing.Date_1__c = null;
            ContractPricing.Date_2__c = null;
            ContractPricing.Date_3__c = null;
            ContractPricing.Date_4__c = null;
        }
    }
    public PageReference saveRecord(){
        Populatevalue();
        system.debug('ContractPricing.Departments__c**'+ContractPricing.Departments__c);
        if(ContractPricing.Departments__c=='' || ContractPricing.Departments__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select at least one Department.'));
            return null;
        }
        
        /*if(ContractPricing.Is_there_language_stating_thatapplicable__c==null)
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Is there language stating that the applicable cap should be the lesser of two values?'));
return null;
}*/
        
        /*list<Contract_Pricing_Terms__c> duplicateRec = [select id,Relevant_Customer_Level__c,Departments__c from Contract_Pricing_Terms__c where Relevant_Customer_Level__c=:ContractPricing.Relevant_Customer_Level__c and Departments__c=:ContractPricing.Departments__c and Contract__c =:ContractPricing.Contract__c and (NOT id =:ContractPricing.id)];
system.debug('duplicateRec **'+duplicateRec );
if(duplicateRec.size()>0){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Sorry, Princing term already exits with the same Department and Relevant Customer Level.'));
return null;
}
*/
        try{    
            if(clone!=null && clone=='1'){
                Contract_Pricing_Terms__c conPricing = ContractPricing.clone(false, true);
                insert conPricing; 
            }else{
                upsert ContractPricing; 
            }           
        }catch(exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
        return new PageReference('/apex/springcmContract2?id='+ ContractPricing.Contract__c);
    }
    public class RowWrapper
    {
        public List<WrapperClass> values {get; set;}
        public RowWrapper(){
            values=new List<WrapperClass>();
        }        
        public void addValue(boolean b ,String value,boolean d){
            values.add(new WrapperClass(b,value,d));            
        }
        
    }
    public class WrapperClass
    {
        public boolean checked{get;set;}
        public boolean disable{get;set;}
        public String departmentName{get;set;}
        public wrapperclass(boolean b,String s,boolean d)
        {
            checked=b;
            departmentName=s;
            disable = d;
        }
        
    }
    
}