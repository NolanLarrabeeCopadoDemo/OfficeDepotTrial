Public class ContractPricingTermsClass {
  @AuraEnabled
    public static Map < String, List < String >> startInit(Id RecordId){
        system.debug('in apex---');
        string deptvalues ='';
        List<string> departVal= new List<string>();
        set<string> departmentVal= new set<string>();
        Map < String, List < String >> depPiklistMap = new Map < String, List < String >> ();
        List < String > CompletedepartmentList = new List < String > ();
        List<String> departmentList = new List<String>();
        List<Merch_Dept_Group__c> DepartmentsMapping = new List<Merch_Dept_Group__c>();
        set<string> departmentNameset  = new set<string>();
        
        string s = [select id,Departments__c from Contract_Pricing_Terms__c where id=:RecordId].Departments__c; 
        if(string.isNotEmpty(s)){
            departmentList.addall(s.split(';'));
        }
        system.debug('in apex--departmentList-'+departmentList);
        departmentList.sort();
        depPiklistMap.put('onloadDepList', departmentList);
        // strating disable
        Contract_Pricing_Terms__c CPT =  [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,Contract__c,Departments__c 
                                          from Contract_Pricing_Terms__c 
                                          Where id =: RecordId];
        list<Contract_Pricing_Terms__c> duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,
                                                        Contract__c,Departments__c from Contract_Pricing_Terms__c where 
                                                        Relevant_Customer_Level__c=:CPT.Relevant_Customer_Level__c 
                                                        and Private_Brand__c=:CPT.Private_Brand__c 
                                                        and Contract__c =:CPT.Contract__c /* and Active__c=true */
                                                        and (NOT id =:CPT.id)];
        for(Contract_Pricing_Terms__c pricingTerm : duplicateRec){
            deptvalues+=pricingTerm.Departments__c+';';
        }
        
        if(deptvalues!=null){// && CPT.Active__c
            
            departVal = deptvalues.split(';');
            system.debug('departVal **'+departVal );
            for(string dep1 : departVal){
                departmentVal.add(dep1);
            }
        }
        system.debug('departmentVal**'+departmentVal);
        //ending disable
        
        string s2 =[select id,Department_Groups__c from Contract_Pricing_Terms__c where id=:RecordId].Department_Groups__c;
        List<string> depGroups = new List<string>();
        if(string.isNotEmpty(s2)){
            depGroups = s2.split(';');
        }
        //if(depGroups.contains('Select All')){
        DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true]; 
        /* }
else{
DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true and Dept_Group_Name__c IN :depGroups]; 
}*/
        for(Merch_Dept_Group__c deptName : DepartmentsMapping){
            departmentNameset.add(deptName.Department__c);
        }     
        for( string deplist : departmentNameset){
            if(!departmentVal.contains(deplist))
                CompletedepartmentList.add(deplist);
        }
        CompletedepartmentList.sort();
        system.debug('in apex--CompletedepartmentList-'+CompletedepartmentList);
        depPiklistMap.put('CompDepList', CompletedepartmentList);
        return depPiklistMap;
        
    }
    
    
    
    @AuraEnabled
    public static List<string> deparments1(string dep,id RecordId){
        string deptvalues ='';
        List<string> departVal= new List<string>();
        set<string> departmentVal= new set<string>();
        system.debug('in apex--2-');
        List<string> part = new List<string>();
        part = dep.split(';');
        system.debug('in apex--2-'+part);
        List<Merch_Dept_Group__c> DepartmentsMapping = new List<Merch_Dept_Group__c>();
        set<string> departmentNameset  = new set<string>();
        List<String> departmentList = new List<String>();
        // strating disable
        Contract_Pricing_Terms__c CPT =  [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,Contract__c,Departments__c 
                                          from Contract_Pricing_Terms__c 
                                          Where id =: RecordId];
        list<Contract_Pricing_Terms__c> duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,
                                                        Contract__c,Departments__c from Contract_Pricing_Terms__c where 
                                                        Relevant_Customer_Level__c=:CPT.Relevant_Customer_Level__c 
                                                        and Private_Brand__c=:CPT.Private_Brand__c 
                                                        and Contract__c =:CPT.Contract__c /* and Active__c=true */
                                                        and (NOT id =:CPT.id)];
        for(Contract_Pricing_Terms__c pricingTerm : duplicateRec){
            deptvalues+=pricingTerm.Departments__c+';';
        }
        if(deptvalues!=null /* && CPT.Active__c */){//
            departVal = deptvalues.split(';');
            system.debug('departVal **'+departVal );
            for(string dep1 : departVal){
                departmentVal.add(dep1);
            }
        }
        system.debug('departmentVal**'+departmentVal);
        //ending disable
        if(part.contains('Select All')){
            DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true]; 
        }
        else{
            DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true and Dept_Group_Name__c IN :part]; 
        }
        for(Merch_Dept_Group__c deptName : DepartmentsMapping){
            departmentNameset.add(deptName.Department__c);
        }     
        for( string deplist : departmentNameset){
            if(!departmentVal.contains(deplist))
                departmentList.add(deplist);
        }
        departmentList.sort();
        system.debug('in apex--departmentList-'+departmentList);
        
        
        return departmentList;
        
    }
    
    @AuraEnabled
    public static Map < String, List < String >> deparments(string dep,id RecordId,string CustLevel,boolean PrivateBand,id Parentid){
        string deptvalues ='';
        Map < String, List < String >> depPiklistMap = new Map < String, List < String >> ();
        List<string> departVal= new List<string>();
        set<string> departmentVal= new set<string>();
        system.debug('in apex--2-');
        system.debug('in apex--RecordId-'+RecordId);
        List<string> part = new List<string>();
        if(string.isNotEmpty(dep))
            part = dep.split(';');
        system.debug('in apex--2-'+part);
        List<Merch_Dept_Group__c> DepartmentsMapping = new List<Merch_Dept_Group__c>();
        List<Merch_Dept_Group__c> CmpDepartmentsMapping = new List<Merch_Dept_Group__c>();
        set<string> departmentNameset  = new set<string>();
        set<string> departmentNameset2  = new set<string>();
        List<String> departmentList = new List<String>();
        List < String > CompletedepartmentList = new List < String > ();
		List < String > CmpdepartmentList = new List < String > ();
        list<Contract_Pricing_Terms__c> duplicateRec = new list<Contract_Pricing_Terms__c>();
        // strating disable
       /* Contract_Pricing_Terms__c CPT =  [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,Contract__c,Departments__c 
                                          from Contract_Pricing_Terms__c 
                                          Where id =: RecordId];*/
        if(string.isNotEmpty(RecordId)){
            system.debug('==in if---147===');
        duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,
                                                        Contract__c,Departments__c from Contract_Pricing_Terms__c where 
                                                        Relevant_Customer_Level__c=:CustLevel 
                                                        and  Private_Brand__c=:PrivateBand 
                                                        and Contract__c =:Parentid /* and Active__c=true */
                                                        and (NOT id =:RecordId)];
        }
        else{
           duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,
                                                        Contract__c,Departments__c from Contract_Pricing_Terms__c where 
                                                     Relevant_Customer_Level__c=:CustLevel 
                                                        and   Private_Brand__c=:PrivateBand 
                                                        and Contract__c =:Parentid /* and Active__c=true */
                                                        ];
        }
        system.debug('duplicateRec **'+duplicateRec);
        for(Contract_Pricing_Terms__c pricingTerm : duplicateRec){
            deptvalues+=pricingTerm.Departments__c+';';
        }
        system.debug('deptvalues **'+deptvalues);
        if(deptvalues!=null)/*&& CPT.Active__c)*/{//
            departVal = deptvalues.split(';');
            system.debug('departVal **'+departVal );
            for(string dep1 : departVal){
                departmentVal.add(dep1);
            }
        }
        system.debug('departmentVal**'+departmentVal);
        //ending disable
        if(part.contains('Select All')){
            DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true]; 
        }
        else{
            DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true and Dept_Group_Name__c IN :part]; 
        }
        system.debug('DepartmentsMapping'+DepartmentsMapping);
        for(Merch_Dept_Group__c deptName : DepartmentsMapping){
            departmentNameset.add(deptName.Department__c);
        }     
        system.debug('departmentNameset'+departmentNameset);
        for( string deplist : departmentNameset){
            if(!departmentVal.contains(deplist))
                departmentList.add(deplist);
        }
        departmentList.sort();
        system.debug('in apex--departmentList-'+departmentList);
        CmpDepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true]; 
        for(Merch_Dept_Group__c deptName2 : CmpDepartmentsMapping){
            departmentNameset2.add(deptName2.Department__c);
        }
		system.debug('departmentNameset2'+departmentNameset2);
		for( string deplist : departmentNameset2){
            if(!departmentVal.contains(deplist))
                CompletedepartmentList.add(deplist);
        }
		CompletedepartmentList.sort();
        depPiklistMap.put('availableOptions', CompletedepartmentList);
        depPiklistMap.put('SelectedValues', departmentList);
        system.debug('availableOptions **'+CompletedepartmentList );
        system.debug('SelectedValues **'+departmentList );
        return depPiklistMap;
        
    }
    
    
    @AuraEnabled
    Public Static  Map<String, Object>  upsert_CPT(Contract_Pricing_Terms__c CPT)
    { 
        Map<String, Object> MyMap = new Map<String, Object>();
           try{
             Upsert CPT;
        }   catch(Exception e){
                MyMap.put('Status', e.getMessage());
                MyMap.put('StatusCode', -1);
                system.debug('ee****'+e.getStackTraceString());
                system.debug('ee**'+e.getMessage());
            }
            system.debug('ee**'+MyMap);
            return MyMap;
       
    }
    
    @AuraEnabled
    public static List < String > startInit_New(){
        List<String> departmentList = new List<String>();
        set<string> departmentNameset  = new set<string>();
        List<Merch_Dept_Group__c> DepartmentsMapping = [select Department__c from Merch_Dept_Group__c where Active__c=true];
        for(Merch_Dept_Group__c deptName : DepartmentsMapping){
            departmentNameset.add(deptName.Department__c);
        }     
        for( string deplist : departmentNameset){
            
                departmentList.add(deplist);
        }
        departmentList.sort();
        return departmentList;
    }
    
    @AuraEnabled
    public static List<string> custDepartment(Id RecordId){
        system.debug('======level======'+RecordId);
        string deptvalues ='';
        List<string> departVal= new List<string>();
        set<string> departmentVal= new set<string>();
        List<String> departmentList = new List<String>();
        //if(String.isNotBlank(RecordId)){
        Contract_Pricing_Terms__c CPT =  [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,Contract__c,Departments__c 
                                          from Contract_Pricing_Terms__c 
                                          Where id =: RecordId];
        
        list<Contract_Pricing_Terms__c> duplicateRec = [select id,Relevant_Customer_Level__c,Private_Brand__c,Active__c,
                                                        Contract__c,Departments__c from Contract_Pricing_Terms__c where 
                                                       Relevant_Customer_Level__c=:CPT.Relevant_Customer_Level__c 
                                                        and Private_Brand__c=:CPT.Private_Brand__c 
                                                        and Contract__c =:CPT.Contract__c /* and Active__c=true */
                                                        and (NOT id =:CPT.id)];
        for(Contract_Pricing_Terms__c pricingTerm : duplicateRec){
            deptvalues+=pricingTerm.Departments__c+';';
        }
        if(deptvalues!=null /* && CPT.Active__c*/){//
            departVal = deptvalues.split(';');
            system.debug('departVal **'+departVal );
            for(string dep : departVal){
                departmentVal.add(dep);
            }
            
        }
        return departmentList;
        
    }
    
}