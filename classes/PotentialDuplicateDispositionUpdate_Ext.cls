public with sharing class PotentialDuplicateDispositionUpdate_Ext
{
    public Boolean disableInput {get; set;}
    public Boolean DispostionKeep {get; set;}
    public integer unselectedCheckboxCount{get;set;}
    public integer accountCheckboxCount{get;set;}
    public String callfunc{get;set;}
    private Integer wrapperDeleteCount = 0;
    private Integer nonAccountTotalCount =0;
    private integer nonAccountDeleteCount= 0;
    public integer cannotdelete{get;set;}
    private Integer accWrapperInactiveCount = 0;
    private Integer accountTotalCount =0;
    private integer accountInactiveCount= 0;
    private integer accountInactivetempCount= 0;    //Added By George, case#00146693
    private integer NonaccountInactivetempCount= 0;    //Added By George, case#00146693
    public integer counter{get;set;} //keeps track of the offset
    public integer list_size{get;set;} //sets the page size or number of rows
    public integer total_size{get;set;}
    public string sortingField{get;set;}
    public boolean currentUserCheck{get;set;}
    public string recordTypeValue{get;set;}
    public string dispostionWarning{get;set;}
    public string recordNameValue{get;set;}
    public string lastModifiedvalue{get;set;}
    private list<id> recIds = new list<id>();
    public String sortDir { get; set; }
    private boolean accountRecSelected = false;
    public string appliedFilter{get;set;}
    transient list<DMND_Duplicate__c> currentUserRec = new list<DMND_Duplicate__c>();
    public integer recCount = 0;
    public boolean searchEntered = true;
    public string dupid;
    public void disableCloseDateInput(){
        disableInput = true;
    }
    public PageReference enableCloseDateInput(){
        System.debug('>>>>>enableCloseDateInput>>>>>>');
        disableInput = true;
        potentialdup.Disposition__c=null;
        potentialdup.Dispostion_Reason__c=null;
        potentialdup.Other_Disposition_Reason__c=null;
        potentialDuplicate.clear();
        for(WrapperClass w :wrapperlist)
        {
            if(w.checked == true)
            {
                if(w.wrapDupPot.Object_Type__c=='Customer'||w.wrapDupPot.Object_Type__c=='Prospect'||w.wrapDupPot.Object_Type__c=='Site'){
                    accountRecSelected = true;
                }
                disableInput = false;
                potentialDuplicate.add(w.wrapDupPot);
            }
            
        }
        if(accountRecSelected){
            DispositionPicVal= new List<SelectOption>();
            DispositionPicVal.add(new SelectOption('','--None--'));
            DispositionPicVal.add(new SelectOption('Inactive','Inactive'));
            DispositionPicVal.add(new SelectOption('Keep','Keep'));
        }else{
            DispositionPicVal= new List<SelectOption>();
            DispositionPicVal.add(new SelectOption('','--None--'));
            DispositionPicVal.add(new SelectOption('Delete','Delete'));
            DispositionPicVal.add(new SelectOption('Merge','Merge'));
            DispositionPicVal.add(new SelectOption('Keep','Keep'));
        }
        accountRecSelected = false;
        return null;
    }
    public List<SelectOption> DispositionPicVal{get;set;}
    //List<WrapperClass> wrapperlist{get;set;}
    public List<WrapperClass> wrapperlist= new List<WrapperClass>();
    public list<wrapperclass> getwrapperlist()
    {
        return wrapperlist;
    }
    public list<wrapperclass> setwrapperlist()
    {
        return wrapperlist;
    }
    public DMND_Duplicate__c potentialdup{get;set;}
    public List<DMND_Duplicate__c> listpotentialDup{get;set;}
    transient List<DMND_Duplicate__c> listpotentialDup1{get;set;}
    public List<DMND_Duplicate__c> potentialDuplicate= new List<DMND_Duplicate__c>();
    public Map<Id,String> MapOwneridandDup= new Map<Id,String>();
    List<Id> baseownerid= new List<Id>();
    public String CurrentUsername{get;set;}
    public list<String> warnName =new list<String>();
    public PotentialDuplicateDispositionUpdate_Ext(ApexPages.StandardController controller)
    {
        //selectatleastone=true;
        dupid = ApexPages.currentPage().getParameters().get('id');
        callfunc = null;
        disableInput = true;
        String WarningMessage ;
        currentUserCheck = false;
        sortDir = 'ASC';
        counter = 0;
        list_size = 50;
        total_size = 0;
        String CurrentUserId=(userinfo.getuserid()).substring(0,15);
        listpotentialDup = new List<DMND_Duplicate__c>();
        CurrentUsername=[Select name from user where id=:userinfo.getuserid()].name;
        potentialdup = [Select id,Name ,lastmodifiedby.name,CurrentUser__c,Customer_Id__c,Address_1__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Name,Potential_Duplicate_Warning__r.Description__c,Account__r.Name,Contact__r.Name,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_ID__c,Related_Object_Name__c,Related_Object_OwnerName__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c,Potential_Duplicate_Warning__r.Warning_Key__c from DMND_Duplicate__c where id=:ApexPages.currentPage().getParameters().get('id')];
        sortingField = 'Potential_Duplicate_Warning__r.Name';
        dispostionWarning = potentialdup.Potential_Duplicate_Warning__r.Name;        
        potentialdup.Disposition__c=null;
        potentialdup.Dispostion_Reason__c=null;
        potentialdup.Other_Disposition_Reason__c=null;
        DispositionPicVal= new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription3 = DMND_Duplicate__c.Disposition__c.getDescribe();
        DispositionPicVal.add(new SelectOption('','--None--'));
        for (Schema.Picklistentry picklistEntry3:statusFieldDescription3.getPicklistValues()){
            DispositionPicVal.add(new SelectOption(picklistEntry3.getValue(),picklistEntry3.getLabel()));
        }
        
        if (dupid == null || dupid == '') 
          currentUserRec = [Select id,Potential_Duplicate_Warning__r.Name,DMND_Duplicate__c.Disposition__c ,DMND_Duplicate__c.Account__c ,Address_1__c,Customer_Id__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Description__c,Related_Object_OwnerName__c from DMND_Duplicate__c limit 1000]; //where Related_Object_OwnerName__c =:CurrentUsername
        else
          currentUserRec = [Select id,Potential_Duplicate_Warning__r.Name,DMND_Duplicate__c.Disposition__c ,DMND_Duplicate__c.Account__c ,Address_1__c,Customer_Id__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Description__c,Related_Object_OwnerName__c from DMND_Duplicate__c where id = :dupid];  //and Related_Object_OwnerName__c =:CurrentUsername         
        
        for(DMND_Duplicate__c DMNDVal :currentUserRec ){
            warnName.add(DMNDVal.Potential_Duplicate_Warning__r.Name);
        }
        system.debug('warnName**'+warnName);
        if(potentialdup.Disposition__c == 'keep')
            DispostionKeep = true; 
        WarningMessage = potentialdup.Potential_Duplicate_Warning__r.Name;
        listpotentialDup1= [Select id,Name ,lastmodifiedby.name,CurrentUser__c,Customer_Id__c,Address_1__c,Account__r.Address2__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Description__c,Potential_Duplicate_Warning__r.Warning_Key__c,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_Name__c,Related_Object_OwnerName__c,Potential_Duplicate_Warning__r.Name,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Potential_Duplicate_Warning__r.Name IN:warnName order by Potential_Duplicate_Warning__r.Warning_Key__c,CurrentUser__c limit :list_size offset :counter]; //Potential_Duplicate_Warning__r.Name=:WarningMessage and Related_Object_OwnerID__c=:CurrentUserId and Disposition__c=:null
        total_size = listpotentialDup1.size();//[Select count() from DMND_Duplicate__c];
        system.debug('total_size**'+total_size);
        for(DMND_Duplicate__c currentUserRec:currentUserRec){
            //listpotentialDup.add(currentUserRec);
            /*if(currentUserRec.Account__c==null){
                nonAccountTotalCount++;
                if(currentUserRec.Disposition__c=='Delete'){
                    nonAccountDeleteCount++;
                }
            }*/
            //Commented By George, case#00146693
           /*
            if(currentUserRec.Account__c!=null){
                accountTotalCount++;
                System.debug('-*-*-* Counting*-*-:'+accountTotalCount);
                if(currentUserRec.Disposition__c=='Inactive'){
                    accountInactiveCount++;
                }
            }*/
        }
        system.debug('nonAccountTotalCount**'+nonAccountTotalCount);
         //Added By George, case#00146693
        for(DMND_Duplicate__c currentUserRec:listpotentialDup1){
            listpotentialDup.add(currentUserRec);
            if(currentUserRec.Account__c!=null)
            {
                accountTotalCount++;
            }
            if(currentUserRec.Disposition__c=='Inactive' && currentUserRec.Account__c!=null)
            {
                accountInactiveCount++;
            }
            if(currentUserRec.Account__c==null)
            {
                nonAccountTotalCount++;
                if(currentUserRec.Disposition__c=='Delete'){
                    nonAccountDeleteCount++;
                }
            }
        }    
        System.debug('-------INACTIVE COUNT-----'+accountInactiveCount);
        System.debug('++++++nonAccountDeleteCount:'+nonAccountDeleteCount+'------nonAccountTotalCount:'+nonAccountTotalCount);
        //END:- Added By George, case#00146693
        
        /*integer recLimit = 25 - listpotentialDup1.size();
        listpotentialDup1= [Select id,lastmodifiedby.name,Account__r.Name,Related_Object_Name__c,Related_Object_OwnerName__c,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_ID__c,Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Related_Object_OwnerID__c!=:CurrentUserId order by Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_OwnerID__c,Object_Type__c limit :recLimit offset :counter]; // and Related_Object_OwnerID__c=:CurrentUserId and Disposition__c=:null
        for(DMND_Duplicate__c otherUserRec:listpotentialDup1){
            listpotentialDup.add(otherUserRec);
        }*/
        for(DMND_Duplicate__c dup_alias1:listpotentialDup)
        {
            baseownerid.add(dup_alias1.Related_Object_OwnerID__c);
            //recIds.add(dup_alias1.id);
        }
        for(User user_alias:[Select id,name from user where id in:baseownerid])
        {
            MapOwneridandDup.put(user_alias.id,user_alias.name);
        }
        for(DMND_Duplicate__c dup_alias:listpotentialDup)
        {
            String OwnerName=MapOwneridandDup.get(dup_alias.Related_Object_OwnerID__c);
            if(OwnerName!=null)
            {
                WrapperClass w= new WrapperClass(false,dup_alias.Related_Object_Name__c,OwnerName,dup_alias);
                wrapperlist.add(w);
            }
        }
        searchrec();
    }
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        pagination();
        return null;
    }
    public PageReference Previous() { //user clicked previous button
        list_size = 50;
        counter -= list_size;
        pagination();
        return null;
    }
    public PageReference Next() { //user clicked next button
        counter += list_size;
        pagination();
        return null;
    }
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        pagination();
        return null;
    }
    public Boolean getDisablePrevious() {
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    public void searchrec(){
        list_size =50;
        if(searchEntered){
            counter = 0;
            searchEntered = false;
        }
        pagination();
    }
    public void pagination(){
        listpotentialDup.clear();
        wrapperlist.clear();
        String CurVar= 'A';
        /*nonAccountTotalCount = 0;
        nonAccountDeleteCount = 0;
        accountTotalCount = 0;
        accountInactiveCount = 0;*/
        callfunc = null;
        sortingField= ApexPages.currentPage().getParameters().get('sortingField');
        boolean appFilter = false;
        if(sortingField==null){
            sortingField = 'Potential_Duplicate_Warning__r.Name,CurrentUser__c';
        }
        
        transient list<DMND_Duplicate__c> offsetRec = new list<DMND_Duplicate__c> ();
        string soqlid = 'Select id from DMND_Duplicate__c where id!=null';//Potential_Duplicate_Warning__r.Name IN:warnName
        if(currentUserCheck){
            soqlid+=' and CurrentUser__c=:CurVar';
            appFilter = true;
        }
        if(recordTypeValue!=null){
            soqlid+=' and Object_Type__c LIKE \'%'+recordTypeValue+'%\'';
            appFilter = true;
        }
        if(String.isNotBlank(dispostionWarning)){
            soqlid+=' and Potential_Duplicate_Warning__r.Name LIKE \'%'+dispostionWarning+'%\'';
            appFilter = true;
        }
        if(String.isNotBlank(recordNameValue)){
            soqlid+=' and Related_Object_Name__c LIKE \'%'+recordNameValue+'%\'';
            appFilter = true;
        }
        soqlid+=' order by Potential_Duplicate_Warning__r.Name,CurrentUser__c limit 10000';
        string soqlidsize = soqlid;
        if(!appFilter){
            list_size = 50;
            searchEntered = true;
        }
        //recCount = database.query(soqlidsize).size();
         
        //soqlid+=' limit :list_size offset :counter';
        offsetRec= database.query(soqlid);
        recCount = offsetRec.size();
        if(recCount<50){
            counter = 0;
        }
       
        if(appFilter){
            total_size = recCount;            
        }else{
            total_size = recCount ;//[Select count() from DMND_Duplicate__c];
            list_size = 50;
        }
        if((list_size+counter)>total_size){            
                list_size = total_size-counter;
                system.debug('list_size***'+list_size);
         }
        appFilter = false;
        //if(counter!=0){
            recIds.clear();
            for(DMND_Duplicate__c Dm : offsetRec){
                recIds.add(Dm.Id);
            }
        //}
        //string soql = 'Select id,lastmodifiedby.name,Potential_Duplicate_Warning__r.Warning_Key__c,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Potential_Duplicate_Warning__r.Name,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c limit '+list_size;
        //soql+=' offset '+counter;
        //soql+=;
        string soql = 'Select id,Name ,lastmodifiedby.name,Customer_Id__c,Address_1__c,Account__r.Address2__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Description__c,CurrentUser__c,Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_Name__c,Related_Object_OwnerName__c,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Potential_Duplicate_Warning__r.Name,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c WHERE Id IN :recIds ';//
        if(currentUserCheck){
            soql+=' and CurrentUser__c=:CurVar';
        }
        soql+=' ORDER BY '+sortingField+' '+sortDir ;
        soql+=' limit :list_size offset :counter';
        system.debug('soql1**'+soql);
        listpotentialDup1= database.query(soql);//[Select id,lastmodifiedby.name,Potential_Duplicate_Warning__r.Warning_Key__c,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Potential_Duplicate_Warning__r.Name,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c order by Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_OwnerID__c,Object_Type__c limit :list_size offset :counter]; //Potential_Duplicate_Warning__r.Name=:WarningMessage and Related_Object_OwnerID__c=:CurrentUserId and Disposition__c=:null
        //total_size = listpotentialDup1.size();
        system.debug('soql **'+soql);
        for(DMND_Duplicate__c currentUserRec:listpotentialDup1){
            listpotentialDup.add(currentUserRec);
            /*if(currentUserRec.Account__c==null){
                nonAccountTotalCount++;
                if(currentUserRec.Disposition__c=='Delete'){
                    nonAccountDeleteCount++;
                }
            }
            if(currentUserRec.Account__c!=null){
                accountTotalCount++;
                if(currentUserRec.Disposition__c=='Inactive'){
                    accountInactiveCount++;
                }
            }*/
        }
        /*integer recLimit = 100 - listpotentialDup1.size();
        listpotentialDup1= [Select id,lastmodifiedby.name,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_ID__c,Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Related_Object_OwnerID__c!=:CurrentUserId order by Potential_Duplicate_Warning__r.Warning_Key__c,Related_Object_OwnerID__c,Object_Type__c limit :recLimit]; // and Related_Object_OwnerID__c=:CurrentUserId and Disposition__c=:null
        for(DMND_Duplicate__c otherUserRec:listpotentialDup1){
            listpotentialDup.add(otherUserRec);
        }*/
        for(DMND_Duplicate__c dup_alias1:listpotentialDup)
        {
            baseownerid.add(dup_alias1.Related_Object_OwnerID__c);
        }
        for(User user_alias:[Select id,name from user where id in:baseownerid])
        {
            MapOwneridandDup.put(user_alias.id,user_alias.name);
        }
        for(DMND_Duplicate__c dup_alias:listpotentialDup)
        {
            String OwnerName=MapOwneridandDup.get(dup_alias.Related_Object_OwnerID__c);
            if(OwnerName!=null)
            {
                WrapperClass w= new WrapperClass(false,dup_alias.Related_Object_Name__c,OwnerName,dup_alias);
                wrapperlist.add(w);
            }
        }
        //appFilter = 'false';
    }
    public void populatelist()
    {
        callfunc = null;
        wrapperDeleteCount = 0;
        accWrapperInactiveCount = 0;
        system.debug('The value dynamic is -->'+potentialdup.Other_Disposition_Reason__c);
        potentialDuplicate.clear();
        unselectedCheckboxCount = 1;
        accountCheckboxCount = 1;
        //string currentDisposition = potentialdup.Disposition__c;
        if(potentialdup.Disposition__c!='keep'){
            system.debug('please check'+potentialdup.Dispostion_Reason__c);
             system.debug('please check123'+potentialdup.Other_Disposition_Reason__c);
            potentialdup.Dispostion_Reason__c=null;
            potentialdup.Other_Disposition_Reason__c=null;
            system.debug('please check after'+potentialdup.Dispostion_Reason__c);
             system.debug('please check123 after'+potentialdup.Other_Disposition_Reason__c);
        }
        if(potentialdup.Dispostion_Reason__c!='Other'){
            potentialdup.Other_Disposition_Reason__c=null;
        }
        accountInactiveCount=0;
        for(DMND_Duplicate__c currentUserRec:[Select id,Name ,lastmodifiedby.name,CurrentUser__c,Customer_Id__c,Address_1__c,Account__r.Address2__c,City__c,State__c,Zip__c,Year_Sales_LY__c,YTD_Sales_TY__c,Potential_Duplicate_Warning__r.Description__c,Potential_Duplicate_Warning__r.Warning_Key__c,Account__r.Name,Contact__r.Name,Contact__r.id,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_Name__c,Related_Object_OwnerName__c,Potential_Duplicate_Warning__r.Name,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Potential_Duplicate_Warning__r.Name IN:warnName order by Potential_Duplicate_Warning__r.Warning_Key__c,CurrentUser__c limit :list_size offset :counter])
        {
            if(currentUserRec.Disposition__c=='Inactive' && currentUserRec.Account__c!=null)
            {
                accountInactiveCount++;
            }
        }
        System.debug('--------INACTIVE COUNT FROM POPULATE--'+accountInactiveCount);
        for(WrapperClass wrap:wrapperlist)
        {
            if(wrap.checked==true && wrap.BaseOwnerName==CurrentUsername && wrap.wrapDupPot.Account__c==null && wrap.wrapDupPot.Disposition__c!='Delete'){
                wrapperDeleteCount++;
                system.debug('1wrapperDeleteCount + nonAccountDeleteCount = nonAccountTotalCount'+wrapperDeleteCount+' + '+nonAccountDeleteCount+' = '+nonAccountTotalCount);
                if((wrapperDeleteCount+nonAccountDeleteCount)==nonAccountTotalCount)
                    unselectedCheckboxCount = 0;
                else
                {
                    unselectedCheckboxCount = 1;
                    if(NonaccountInactivetempCount==0)
                    {
                        //nonAccountDeleteCount=nonAccountDeleteCount+wrapperDeleteCount;
                        NonaccountInactivetempCount=wrapperDeleteCount;
                    }
                }
            }
            System.debug('--->>>DEBUG---->>>>'+wrap.checked+'-'+wrap.BaseOwnerName+'='+CurrentUsername+'-'+wrap.wrapDupPot.Account__c+'-'+ wrap.wrapDupPot.Disposition__c);
            if(wrap.checked==true && wrap.BaseOwnerName==CurrentUsername && wrap.wrapDupPot.Account__c!=null && wrap.wrapDupPot.Disposition__c!='Inactive'){
                accWrapperInactiveCount++;
                system.debug('accWrapperInactiveCount +accountInactiveCount'+accWrapperInactiveCount+' + '+accountInactiveCount+' = '+accountTotalCount);
                if((accWrapperInactiveCount +accountInactiveCount)==accountTotalCount)
                    accountCheckboxCount= 0;
                else
                {
                    accountCheckboxCount= 1;
                }
            }
            potentialDuplicate.add(wrap.wrapDupPot);
        }
        /*
        if(accountCheckboxCount==1)
        {
            //accountInactiveCount=accountInactiveCount+accWrapperInactiveCount;
            accountInactivetempCount=accWrapperInactiveCount;
        }
        */
        System.debug('*************'+accountInactivetempCount);
        /*if(accWrapperInactiveCount==accountTotalCount && potentialdup.Disposition__c=='keep')
        {
            accWrapperInactiveCount=0;
        }*/
    }
    public PageReference saveRecord()
    {
       
        if(potentialdup.Disposition__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select Desposition value.'));
            return null;
        }
        if(potentialdup.Disposition__c == 'Keep' && potentialdup.Dispostion_Reason__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select Desposition Reason value.'));
            return null;
        }
        if(potentialdup.Dispostion_Reason__c=='Other' && potentialdup.Other_Disposition_Reason__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter Other Desposition Reason value.'));
            return null;
        }
        populatelist();
        
        if(unselectedCheckboxCount==0 && potentialdup.Disposition__c == 'Delete'){
            system.debug('2wrapperDeleteCount + nonAccountDeleteCount = nonAccountTotalCount'+wrapperDeleteCount+' + '+nonAccountDeleteCount+' = '+nonAccountTotalCount);
            string alertMsgDelete = 'Sorry, you cannot disposition all records as Delete for this customer.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Sorry,All the records cannot be mark as Delete!'));
            callfunc='<script> alert(\''+alertMsgDelete+'\'); </script>';
            return null;
        }
        if(accountCheckboxCount==0 && potentialdup.Disposition__c == 'Inactive'){
            system.debug('2wrapperDeleteCount + nonAccountDeleteCount = nonAccountTotalCount'+wrapperDeleteCount+' + '+nonAccountDeleteCount+' = '+nonAccountTotalCount);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Sorry,All the records cannot be mark as Inactive!'));
            string alertMsgInactive = 'Sorry, you cannot disposition all records as Inactive for this customer.';
            callfunc='<script> alert(\''+alertMsgInactive +'\'); </script>';
            return null;
        }
        
        system.debug('The value dynamic is -->'+potentialdup.Other_Disposition_Reason__c);
        potentialDuplicate.clear();
        //unselectedCheckboxCount = 0;
        string currentDisposition = potentialdup.Disposition__c;
        if(potentialdup.Disposition__c!='keep'){
            potentialdup.Dispostion_Reason__c=null;
        }
        if(potentialdup.Dispostion_Reason__c!='Other'){
            potentialdup.Other_Disposition_Reason__c=null;
        }
        for(WrapperClass wrap:wrapperlist)
        {
            if(wrap.checked==true && wrap.BaseOwnerName==CurrentUsername)
            {
                system.debug('wrap.wrapDupPot.Disposition__c**'+wrap.wrapDupPot.Disposition__c);
                system.debug('The value dynamic is1 -->'+potentialdup.Other_Disposition_Reason__c);
                if(currentDisposition !='Inactive'){
                    wrap.wrapDupPot.Disposition__c=potentialdup.Disposition__c;
                    wrap.wrapDupPot.Dispostion_Reason__c=potentialdup.Dispostion_Reason__c;
                    system.debug('The value dynamic is2 -->'+potentialdup.Other_Disposition_Reason__c);
                    wrap.wrapDupPot.Other_Disposition_Reason__c=potentialdup.Other_Disposition_Reason__c;
                    potentialDuplicate.add(wrap.wrapDupPot);
                }else{
                    if(wrap.wrapDupPot.Object_Type__c=='Customer'||wrap.wrapDupPot.Object_Type__c=='Prospect'||wrap.wrapDupPot.Object_Type__c=='Site'){
                        wrap.wrapDupPot.Disposition__c=potentialdup.Disposition__c;
                        wrap.wrapDupPot.Dispostion_Reason__c=potentialdup.Dispostion_Reason__c;
                        wrap.wrapDupPot.Other_Disposition_Reason__c=potentialdup.Other_Disposition_Reason__c;
                        potentialDuplicate.add(wrap.wrapDupPot);
                    }else{
                        wrap.checked=false;
                        wrap.wrapDupPot.Disposition__c=null;
                        wrap.wrapDupPot.Dispostion_Reason__c=null;
                        wrap.wrapDupPot.Other_Disposition_Reason__c = null;
                    }
                }
            }else{
                wrap.wrapDupPot.Disposition__c=null;
                wrap.wrapDupPot.Dispostion_Reason__c=null;
                wrap.wrapDupPot.Other_Disposition_Reason__c = null;
            }
        }
        try{
            if(potentialDuplicate.size()==0)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Select atleast one record.'));
                return null;
            }
            else
            {
                update potentialDuplicate;
                //return new PageReference('/'+potentialdup.id);//potentialdup.Related_Object_ID__c
                searchrec();
                potentialdup.Disposition__c=null;
                potentialdup.Dispostion_Reason__c=null;
                potentialdup.Other_Disposition_Reason__c=null;
                disableInput=true;
                /*accountInactiveCount = accountInactiveCount+accountInactivetempCount;
                accountInactivetempCount=0;
                */
                nonAccountDeleteCount = nonAccountDeleteCount+NonaccountInactivetempCount;
                NonaccountInactivetempCount=0;
                
                return null;
            }
            }catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
    }
    public PageReference cancelRecord(){
        return new PageReference('/'+ potentialdup.Related_Object_ID__c);
    }
    public class WrapperClass
    {
        public boolean checked{get;set;}
        public String ContactName{get;set;}
        public String BaseOwnerName{get;set;}
        public DMND_Duplicate__c wrapDupPot{get;set;}
        public wrapperclass(boolean b,String s,String n,DMND_Duplicate__c alias)
        {
            checked=b;
            ContactName=s;
            BaseOwnerName=n;
            wrapDupPot=alias;
        }
    }
}