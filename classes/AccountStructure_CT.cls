/**  Copyright (c)Ã‚Â 2008, Matthew Friend, Sales Engineering, 

Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without 

modification, are permitted provided that the following conditions 

are met:
*  Redistributions of source code must retain the above copyright 

notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright 

notice, this list of conditions and the following disclaimer in the 

documentation and/or other materials provided with the distribution.
*  Neither the name of theÃ‚Â salesforce.com nor the names of its 

contributors may be used to endorse or promote products derived from 

this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 

CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 

MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS 

BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 

LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 

CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 

OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
* To adapt this to anouther Object simply search for "Change" to go 

to the places 
* where the sObject and query must be changed
*/
public with sharing class AccountStructure_CT{
    
    //Declare variables
    public List<WrapErrors> allErrors{get;set;}
    public  String currentId;
    public Boolean ExclusionList{get;set;}
    public Boolean launcherror{get;set;}
    public  transient List<ObjectStructureMap> asm ;
    public  transient Map<String, ObjectStructureMap> masm;
    public  List<Integer> maxLevel;
    public transient Map<ID, Account> accountMap; 
    public  String Subject{get;set;}
    public  String Body{get;set;}
    public  Document document {get;set;} 
    public  List<Account>selectedAccountList{get;set;}
    public  String userEmailCc{get;set;} 
    String selectedUser = '';  
    List<String> emailToBeSend = new List<String>();
    String addresses; 
    Map<id,Customer_Transition__c> mapCTrec = new 

Map<id,Customer_Transition__c>();
    public string error;
   
   
    /**
    * Constructor
    */
    public AccountStructure_CT() {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
        
        if(System.currentPageReference().getParameters().get( 'EL' ) 

== 'Y'){
            ExclusionList = true;
        } else{
            ExclusionList = false;
        }
        
        this.allErrors = new List<WrapErrors>();
    }
    public AccountStructure_CT(string MOD5){
        
    }
    /**
    * One argument Constructor
    */
    public AccountStructure_CT(ApexPages.StandardController 

controller) {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
        document = new Document();
        selectedAccountList = new List<Account>();
        if(System.currentPageReference().getParameters().get( 'EL' ) 

== 'Y'){
            ExclusionList = true;
        } else{
            ExclusionList = false;
        }  
        this.allErrors = new List<WrapErrors>();
    }
    
    /**
    * Allow page to set the current ID
    */
    public void setcurrentId( String cid ){
        currentId = cid;
    }

    /**
    * Return ObjectStructureMap to page
    * @return asm
    */
    //List<ObjectStructureMap> cacheObjectStructureMap=new List<ObjectStructureMap>();
    public List<ObjectStructureMap> getObjectStructure(){
        if(asm == null){
            asm = new List<ObjectStructureMap>{};
        }        
        asm.clear();
        if ( currentId == null ) {
            currentId = System.currentPageReference().getParameters().get( 'id' );
        }
        
        //System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
        
        asm = formatObjectStructure( CurrentId );
        
        return asm;
    }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId ){
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>

{};
        if(masm == null){
            masm = new Map<String, ObjectStructureMap>{};
        }
        accountMap = new Map<ID, Account>();
        masm.clear();

        //Change below
        List<Account> al            = new List<Account>{};
        List<Customer_Transition__c> cl   = new 

        List<Customer_Transition__c>{}; 
        List<Customer_Transition__c> temp   = new List<Customer_Transition__c>{};      
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;        
        
        Integer Counter = 0;
      
       Integer limits = 1000;
        
        //Find highest level obejct in the structure
        currentParent.add( GetTopElement( currentId ) );
        
        //Loop though all children
        while ( !endOfStructure ){

            if( level == 0 ){
                //Change below                   
                cl = [ SELECT Ready_for_Mod1__c,Customer_Go_Live_Target_Date__c,Written_Agreement_Custom_Core_Request__c,Final_Split_Decision__c,account__r.omx_primary_key__C,account__r.Status__c,account__r.Sales_PersonID__c,account__r.Sales_PersonID__r.name,account__r.owner.IsActive,AOPS_Flag__c,
                    Transition_Status__c,customer_transition_type__C, 
                    account__r.Type,account__r.Segment__c,account__r.Buying_Group__c,account__r.Account_Owner_Manager_Name__c, 
                    account__r.YTD_Sales_TY_IMU2__c,account__r.YTD_Sales_LY_IMU2__c, account__r.Weeks_Since_Last_Order__c,account__r.owner.email, 
                    account__r.open_opp_amt__c, account__r.YTD_Sales_TY__c, 
                    account__r.YTD_Sales_LY__c, account__r.YTD_Sales_Diff__c,  
                    account__r.owner.name, account__r.Site, 
                    account__r.cust_id__c,account__r.recordtype.name, 
                    account__r.industry_OD_SIC_Rep__c, account__r.city__c, 
                    account__r.state__c, account__r.Address__c, 
                    account__r.LastActivityDate, 
                    account__r.Last_Order_Date__c,account__r.ParentId, 
                    account__r.OwnerId, account__r.Name, account__r.Industry, 
                    account__r.owner.Short_Title__c,account__r.Id,status__c,Parent_Transition_ID__c,Account_Splitting_Required_frmla__c FROM 
                    Customer_Transition__c WHERE account__r.id IN : CurrentParent ORDER 
                    BY account__r.Name ];                                   
                    limits = limits - cl.size();               
            } 
            else {
                temp    = new List<Customer_Transition__c>();
                //Change below -- Fetch Child (This is eliminate the child record which are in Launched Status) -- Raji
                if(ExclusionList){
                    cl = [ SELECT 
                            Ready_for_Mod1__c,account__r.omx_primary_key__C,Written_Agreement_Custom_Core_Request__c,Customer_Go_Live_Target_Date__c,Final_Split_Decision__c,account__r.Status__c,account__r.Sales_PersonID__c,
                            account__r.Sales_PersonID__r.name,account__r.owner.IsActive,AOPS_Flag__c,Transition_Status__c,account__r.Type,account__r.Segment__c,account__r.Buying_Group__c,account__r.Account_Owner_Manager_Name__c, 
                            account__r.YTD_Sales_TY_IMU2__c,account__r.YTD_Sales_LY_IMU2__c,account__r.Weeks_Since_Last_Order__c, 
                            account__r.owner.email,account__r.owner.name, 
                            account__r.owner.Short_Title__c,account__r.YTD_Sales_TY__c, 
                            account__r.YTD_Sales_LY__c, account__r.YTD_Sales_Diff__c, 
                            account__r.open_opp_amt__c, account__r.Site,account__r.cust_id__c, 
                            account__r.recordtype.name,account__r.industry_OD_SIC_Rep__c, 
                            account__r.city__c, account__r.state__c, account__r.Address__c, 
                            account__r.LastActivityDate, 
                            account__r.Last_Order_Date__c,account__r.ParentId, 
                            account__r.OwnerId, account__r.Name, account__r.Industry, 
                            account__r.Id,status__c,Account_Splitting_Required_frmla__c FROM 
                            Customer_Transition__c c WHERE c.account__r.ParentID IN : 
                            CurrentParent and (Customer_Transition_Type__c != 'Child' or 
                            (c.Customer_Transition_Type__c = 'Child' and c.Ready_for_Mod1__c!= 
                            true)) ORDER BY account__r.Name limit :limits];
                                            }else{
                   cl = [ SELECT 
                            Ready_for_Mod1__c,account__r.omx_primary_key__C,Customer_Go_Live_Target_Date__c,Written_Agreement_Custom_Core_Request__c,Final_Split_Decision__c,account__r.Status__c,account__r.Sales_PersonID__c,
                            account__r.Sales_PersonID__r.name,account__r.owner.IsActive,AOPS_Flag__c,Transition_Status__c,
                            Customer_Transition_Type__c,account__r.Type,account__r.Segment__c,account__r.Buying_Group__c,account__r.Account_Owner_Manager_Name__c, 
                            account__r.YTD_Sales_TY_IMU2__c,account__r.YTD_Sales_LY_IMU2__c,account__r.Weeks_Since_Last_Order__c, 
                            account__r.owner.email,account__r.owner.name, 
                            account__r.owner.Short_Title__c,account__r.YTD_Sales_TY__c,
                            account__r.YTD_Sales_LY__c, account__r.YTD_Sales_Diff__c, 
                            account__r.open_opp_amt__c, 
                            account__r.Site,account__r.cust_id__c,account__r.recordtype.name, 
                            account__r.industry_OD_SIC_Rep__c, account__r.city__c, 
                            account__r.state__c, account__r.Address__c, 
                            account__r.LastActivityDate, 
                            account__r.Last_Order_Date__c,account__r.ParentId, 
                            account__r.OwnerId, account__r.Name, account__r.Industry, 
                            account__r.Id,status__c,Account_Splitting_Required_frmla__c FROM 
                            Customer_Transition__c c WHERE c.account__r.ParentID IN : 
                            CurrentParent ORDER BY account__r.Name limit :limits];
                                           }
                
                limits = limits - cl.size();
                
            }           
                 
            if( cl.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < cl.size(); i++ ){
                    //Change below
                    Customer_Transition__c a = cl[i];
                    nodeId = ( level > 0 ) ? NodeList.get( a.account__r.ParentId )+'.'+String.valueOf( i ) : String.valueOf( i ); 
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.account__r.id );
                    nodeList.put( a.account__r.id,nodeId );
                    nodeSortList.add( nodeId );
                    accountMap.put(a.account__r.id, a.account__r);
                   
                }               
                maxLevel.add( level );                
                level++;
            }                        
        }
        
        //Account structure must now be formatted
        NodeSortList.sort();
        for( Integer i = 0; i < NodeSortList.size(); i++ ){
            List<String> pnl = new List<String> {};
            List<String> cnl = new List<String> {};
            List<String> nnl = new List<String> {};
            
            if ( i > 0 ){
                String pn   = NodeSortList[i-1];
                pnl         = pn.split( '\\.', -1 );
            }

            String cn   = NodeSortList[i];
            cnl         = cn.split( '\\.', -1 );

            if( i < NodeSortList.size()-1 ){
                String nn = NodeSortList[i+1];
                nnl = nn.split( '\\.', -1 );
            }
            
            ObjectStructureMap tasm = masm.get( cn );
            if ( cnl.size() < nnl.size() ){
                //Parent
                tasm.nodeType = ( isLastNode( cnl ) ) ? 'parent_end' : 'parent';
            }
            else if( cnl.size() > nnl.size() ){
                tasm.nodeType   = 'child_end';
                tasm.closeFlag  = setcloseFlag( cnl, nnl, tasm.nodeType );
            }
            else{
                tasm.nodeType = 'child';
            }
            
            tasm.levelFlag = setlevelFlag( cnl, tasm.nodeType ); 
            
            //Change below
            if ( tasm.account.id == currentId ) {
                tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        asm[0].nodeType             = 'start';
        asm[asm.size()-1].nodeType  = 'end';        
        return asm;
        //Filer 
        //cacheObjectStructureMap
    }
    public string IdTreeNodeForAction{get;set;}
    public string NodeStatus{get;set;}
    public void updateTree(){
        ObjectStructureMap updateL = masm.get(IdTreeNodeForAction);
        updateL.isShow=false;
    }
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    public List<Boolean> setlevelFlag( List<String> nodeElements, 

String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size() - 1; i++ ){
            cn = Integer.valueOf( nodeElements[i] );
            cn++;
            searchNode  = workNode + String.valueOf( cn );
            workNode    = workNode + nodeElements[i] + '.';
            if ( masm.containsKey( searchNode ) ){
                flagList.add( true );
            }
            else {
                flagList.add( false );
            }
        }
        
        return flagList;
    }
    
    /**
    * Determin if the element is a closing element
    * @return flagList
    */
    public List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = nnl.size(); i < cnl.size(); i++ ){
            flagList.add( true );
        }
        
        return flagList;
    }
    
    /**
    * Determin if Element is the bottom node  
    * @return Boolean
    */
    public Boolean isLastNode( List<String> nodeElements ){
        
        String searchNode   = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size(); i++ ){
            if ( i == nodeElements.size()-1 ){
                cn = Integer.valueOf( nodeElements[i] );
                cn++;
                searchNode = searchNode + String.valueOf( cn );
            }
            else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if ( masm.containsKey( searchNode ) ){
            return false;
        }
        else{
            return true;
        }
    }
    
    /**
    * Find the tom most element in Heirarchy  
    * @return objId 
    */
    public String GetTopElement( String objId ){
    
        if(ExclusionList){
            return objId ; // This is to start the Tree from the Current Account
        }
    
        
        Boolean top = false;
        while ( !top ) {
            //Change below
            Customer_Transition__C a = [ Select Ready_for_Mod1__c,Written_Agreement_Custom_Core_Request__c,account__r.omx_primary_key__C,Customer_Go_Live_Target_Date__c,
            Final_Split_Decision__c,account__r.Status__c,status__c,account__r.Id, account__r.YTD_Sales_TY_IMU2__c,account__r.YTD_Sales_LY_IMU2__c,
            account__r.Segment__c,account__r.Buying_Group__c,account__r.Account_Owner_Manager_Name__c,account__r.owner.Short_Title__c,
            account__r.Weeks_Since_Last_Order__c,account__r.owner.name, account__r.owner.email,account__r.cust_id__c,account__r.recordtype.name,
            account__r.YTD_Sales_TY__c, account__r.YTD_Sales_LY__c, account__r.YTD_Sales_Diff__c, account__r.open_opp_amt__c, 
            account__r.industry_OD_SIC_Rep__c, account__r.city__c, account__r.state__c, account__r.Address__c, account__r.LastActivityDate, 
            account__r.Last_Order_Date__c, account__r.ParentId,Account_Splitting_Required_frmla__c,Written_Agreement_Customer_No__c 
            From Customer_Transition__c where account__r.id =: objId limit 1 ];

            if ( a.account__r.ParentID != null ) {
                objId = a.account__r.ParentID;
               
            }
            else {
                top = true;              
            }
        }
        
        return objId ;
    }
    
    
    //============================================================//
    // Divide original email list into multiple of 100 users email
    //============================================================//
    public List<String> getEmailList(Integer startCounter, Integer 

endCounter){
        List<String> emailList = new List<String>();
        if(emailToBeSend.size() >= endCounter){         
            for(Integer i = startCounter; i<endCounter; i++){
                emailList.add(emailToBeSend[i]);            
            }
        }
        else{           
            for(Integer i = startCounter; i<emailToBeSend.size(); i++){
                emailList.add(emailToBeSend[i]);            
            }
        }
        return emailList;
    }
    
    //============================================================//
    //Create body
    //============================================================//
    public String createNewBody(){        
        body = body + '<br>' ;
        return body;        

    }
    
    
    
    //============================================================//
    //Prepare and send email
    //============================================================// 
    public PageReference sendEmail(){
        
        try{
        
            // Define the attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(document.name);
            efa.setContentType(document.contenttype);
            efa.setBody(document.body);
                
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            email.setSubject( subject );
            String modifiedBody = createNewBody();        
            email.setHtmlBody( modifiedBody );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});   
        
            
            
            if (userEmailCc.Contains(';'))
                {
                    string[] EmailsCC = userEmailCc.Split(';');
                    
                                   
                    email.setCcAddresses(EmailsCC);
                }
                else
                {
                    
                       email.setCcAddresses(new String[]{userEmailCc});
                    
                }
      
            Integer startCounter = 0; 
            Integer endCounter = 100;       
            
            // Breakdown list to multiple of 100
            if(emailToBeSend.size() > 100){
                Integer counter = emailToBeSend.size()/100;           

  
                for(Integer i = 0; i <= counter; i++){                

  
                    List<String> emailAddressList = getEmailList(startCounter, endCounter);                 
                    startCounter = endCounter;
                    endCounter = endCounter + 100;
                    email.setToAddresses(emailAddressList);           

     
                    Messaging.SendEmailResult [] sendEmailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    return Page.AccountHierarchyEmailConfirmation;    

                 
                }
            }
            else{                
                email.setToAddresses(emailToBeSend);
             
                Messaging.SendEmailResult [] sendEmailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                return Page.AccountHierarchyEmailConfirmation;        

         
            }
            body = modifiedbody;
            CreateActivity();
       
        }
        catch(Exception e){         
            return null;
        }       
        return Page.AccountHierarchyEmailConfirmation;
    }
    
    //============================================================//
    //Create activity for those accounts whome we sent email
    //============================================================//
    public void CreateActivity(){
        List <Task> taskList = new List<Task>();
        List <Attachment> attachmentList = new List<Attachment>();
        for(Account account : selectedAccountList) {
            Task task = new Task(ActivityDate = System.today(),Subject = subject,Description=body, status='Completed', whatId=account.Id);
            taskList.add(task);
        }
        insert taskList;
    }
    
    //============================================================//
    //Get selected account to send email
    //============================================================// 
    public PageReference selectedAccounts(){ 
        selectedAccountList = new List<Account>();  
        Account account;
        for(Id accountId : accountMap.keySet()){
            account = accountMap.get(accountId);
            
            if(ApexPages.currentPage().getParameters().get(account.id) == '1') {
                selectedAccountList.add(account);
                if(account.Owner.Email != null){
                     emailToBeSend.add(account.Owner.Email);
                }          
            }
         }     
        return Page.AccountHierarchySendEmail;  
          
    }
    
    //===========================================================//
    //Get the list of Records that need to be Launched//
    //===========================================================//
    public PageReference LaunchSelected(){
        Boolean errorbypasscheck = false;
        selectedAccountList = new List<Account>();
        Account account;
        Set<Id> AccId = new Set<Id>();
        list<Customer_Transition__c> lct = new list<Customer_Transition__c>();
        
        for(Id accountId : accountMap.keySet()){
               if(ApexPages.currentPage().getParameters().get(accountId) == '1') 
                AccId.add(accountId);
                system.debug('param@@@'+ApexPages.currentPage().getParameters().get(accountId));
         }
         
         //get the Parents  to the above accounts - so that we launch them as well when child's are launched
            for(Account parentAccount : [select id, parentId from account where id =:AccId]){
                if(parentAccount.parentId != null){
                    AccId.add(parentAccount.parentId);
                }
            }
            system.debug('AccId@@@'+AccId);
         // We don't want to Launch or send the GP to AOPS

         for(Customer_Transition__c c:[select Id,Written_Agreement_Customer_No__c,Customer_Go_Live_Target_Date__c,
         Parent_Transition_ID__r.status__c,Account__r.OMX_Mainframe_Account_Level__c,Account__r.Split_Record__c,
         Related_WRF_Case__c,Written_Agreement_ID__c,Written_Agreement_ID__r.status__c,Parent_Transition_ID__c,
         Parent_Transition_ID__r.Account__r.ownerid,Account__c,Ready_for_Mod1__c,status__C,account__r.Sales_PersonID__c,
         Transition_Status__c ,Final_Split_Decision__c,AOPS_Flag__c, 
         Account__r.OwnerId,Account__r.name,account__r.Status__c,Account__r.omx_primary_key__c,Account__r.Segment__c,
         account__r.owner.IsActive,account__r.Sales_PersonID__r.name,Account_Splitting_Required_frmla__c ,
         Override_Administrative_close__c,Administrative_close__c,
         Customer_Loss__c,Override_Loss_of_Customer__c,Customer_Transition_Type2__c,Written_Agreement__c,Local_Core__c,Written_Agreement_Custom_Core_Request__c
         from Customer_Transition__c where Account__c = :AccId  and  
         (Customer_Transition_Type__c!='Grandparent' and (not name like '%Customer Transition Great Grandparent of%'))]){
            mapCTrec.put(c.id,c);
         }
         //Declaring the Error Page redirection boolean to false to refresh the same page
         launcherror=false;
         List<Id> inactiveownerId= new List<Id>();
         List<User> inactiveowner= new List<User>();
         allErrors.clear();
        //Launching all selected Customer Transition Records from the hierarchy
         for(Customer_Transition__c ct : [select Written_Agreement_Customer_No__c,Customer_Go_Live_Target_Date__c,
         Override_Administrative_close__c,Administrative_close__c, Parent_Transition_ID__r.name,Id,Parent_Transition_ID__r.status__c,
         Customer_Loss__c,Override_Loss_of_Customer__c,
         Parent_Transition_ID__r.Ready_for_Mod1__c,Account__r.OMX_Mainframe_Account_Level__c,Account__r.Split_Record__c,
         Parent_Transition_ID__r.AOPS_Assigned_AOPS_Account_ID__c,Related_WRF_Case__c,Written_Agreement_ID__c,
         Written_Agreement_ID__r.status__c,Parent_Transition_ID__r.Customer_Transition_Type__c,Parent_Transition_ID__c,
         Parent_Transition_ID__r.omx_primary_key__c,Parent_Transition_ID__r.Account__r.ownerid,Account__c,Ready_for_Mod1__c,
         status__C,account__r.Sales_PersonID__c,
         Transition_Status__c ,Final_Split_Decision__c,AOPS_Flag__c, 
         Account__r.OwnerId,Account__r.name,account__r.Status__c,Account__r.omx_primary_key__c,Account__r.Segment__c,
         account__r.owner.IsActive,account__r.Sales_PersonID__r.name,Account_Splitting_Required_frmla__c,Customer_Transition_Type2__c,Written_Agreement__c,Local_Core__c,Written_Agreement_Custom_Core_Request__c
         from Customer_Transition__c 
         where Account__c = :AccId and  
         (Customer_Transition_Type__c!='Grandparent' and (not name like '%Customer Transition Great Grandparent of%'))]){
         error=ct.Account__r.omx_primary_key__c+'@@:@@'+ct.Account__r.name+'@@:@@';
            //If the record is launched in prior then do not do anything
           if( ct.Ready_for_Mod1__c==true){
           
           }    
            //If the Current record is not launched in prior then checking of the record is valid to launch 
           else{
             String ownerId=ct.Account__r.OwnerId;
             ownerId=ownerId.substring(0,15);

            system.debug('entering loop');
            //Checking if the record is not a valid one
             system.debug('ID>>>>'+ct.id+'Status>>>>'+ct.status__c);
           if(( (ct.Final_Split_Decision__c =='Yes'  || ct.Account__r.Split_Record__c == true ) && ct.Ready_for_Mod1__c == false  ) 
             || ((ct.Final_Split_Decision__c=='' || ct.Final_Split_Decision__c==null) &&   ct.Account_Splitting_Required_frmla__c=='Yes')
             || ct.account__r.status__c!='Active'  || ct.account__r.Sales_PersonID__c==null || 
              ct.account__r.Sales_PersonID__r.name=='Awaiting SalesID'   
             || ct.account__r.Sales_PersonID__r.name=='D7873'  || 
             ct.account__r.owner.IsActive !=true || 
             (ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account' && 
             ct.Transition_Status__c !='Active') ||  
             (ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account' && 
             ct.AOPS_Flag__c!='Y') ||  ct.Account__r.Segment__c==null 
             ||  ct.Account__r.Segment__c=='Other' || 
            ownerId==System.Label.salesforce   ||  
            ownerId==System.Label.SalesforceDataloaderNorth ||
            (ct.Written_Agreement_Customer_No__c != null && ct.Customer_Go_Live_Target_Date__c == null)||
            ( ct.Status__c !='On Deck'  && 
            ct.status__c != 'ODP Agreement in Development' && ct.status__c != 'OMX Extension in Development' &&
                                 ct.status__c != 'ODP Agreement Complete' )||
            (ct.status__c == 'Administrative Close' && ct.Administrative_close__c == true && ct.Override_Administrative_close__c == false)                   
               ||                  
            (ct.status__c == 'Loss of Customer' && ct.Customer_Loss__c== true && ct.Override_Loss_of_Customer__c== false) || 
            //Added for Case# 00674130
            ((ct.Customer_Transition_Type2__c == 'Standalone' || ct.Customer_Transition_Type2__c == 'Child') && ct.Written_Agreement__c == true && ct.Local_Core__c == true && (ct.Written_Agreement_Custom_Core_Request__c == '' || ct.Written_Agreement_Custom_Core_Request__c == null) )
                     
                                 //&&
            
           //  (!(ct.status__c == 'Administrative Close' && ct.Administrative_close__c == true && ct.Override_Administrative_close__c == true))
             //&&
         //  ( !(ct.status__c == 'Loss of Customer' && ct.Customer_Loss__c== true && ct.Override_Loss_of_Customer__c== true))
           )           
                {
                            system.debug('@@@@@@@@@Customer_Transition_Type2__c '+ ct.Customer_Transition_Type2__c );
                            system.debug('@@@@@@@@@Written_Agreement__c  '+ ct.Written_Agreement__c);
                            system.debug('@@@@@@@@@Local_Core__c  '+ ct.Local_Core__c);
                            system.debug('@@@@@@@@@Written_Agreement_Custom_Core_Request__c '+ ct.Written_Agreement_Custom_Core_Request__c);
                System.debug('&&&&&&&&&&&& Entering loop 1'+ct);
                   //Checking if the status is not 'On Deck' but has either of the ODP/OMX status to launch
                               if((ct.Final_Split_Decision__c !='Yes' && ct.Account__r.Split_Record__c != true)
                               &&
                               ((ct.Final_Split_Decision__c!='' && ct.Final_Split_Decision__c!=null && ct.Account_Splitting_Required_frmla__c=='Yes')
                                ||((ct.Final_Split_Decision__c=='' || ct.Final_Split_Decision__c==null) && ct.Account_Splitting_Required_frmla__c!='Yes'))
                               && ct.account__r.status__c=='Active' && ct.account__r.Sales_PersonID__c!=null && 
                               ct.account__r.Sales_PersonID__r.name!='Awaiting SalesID'  && 
                               ct.account__r.Sales_PersonID__r.name!='D7873' 
                               && ct.account__r.owner.IsActive ==true && 
                               ((ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account' && 
                               ct.Transition_Status__c =='Active')||
                               (ct.Account__r.OMX_Mainframe_Account_Level__c == 'National' )) &&   
                               ((ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account' && 
                               ct.AOPS_Flag__c=='Y')||(ct.Account__r.OMX_Mainframe_Account_Level__c == 'National' )) &&  
                                 ct.Account__r.Segment__c!=null &&  
                                 ct.Account__r.Segment__c!='Other'   
                                 && ownerId!=System.Label.salesforce  &&  ownerId!=System.Label.SalesforceDataloaderNorth 
                               && ((ct.Written_Agreement_Customer_No__c != null && ct.Customer_Go_Live_Target_Date__c != null)||
                               (ct.Written_Agreement_Customer_No__c == null)) && 
                               //Added for Case# 00674130
                               ((ct.Customer_Transition_Type2__c != 'Standalone' || ct.Customer_Transition_Type2__c != 'Child') && ct.Written_Agreement__c != true && ct.Local_Core__c != true && (ct.Written_Agreement_Custom_Core_Request__c != '' || ct.Written_Agreement_Custom_Core_Request__c != null) )
                                 && (ct.status__c == 'ODP Agreement in Development' || ct.status__c == 'OMX Extension in Development' || 
                                 ct.status__c == 'ODP Agreement Complete'  ||  ct.status__c == 'On Deck'  || 
                                 (ct.status__c == 'Administrative Close' && ct.Administrative_close__c == true && ct.Override_Administrative_close__c == true)||
                                 (ct.status__c == 'Loss of Customer' && ct.Customer_Loss__c== true && ct.Override_Loss_of_Customer__c== true)

                                 )){
                                    //Launching the record if status is either ODP or OMX
                                    system.debug('###Launching the record if status is either ODP or OMX');
                                    ct.Ready_for_Mod1__c = true;
                                    lct.add(ct);
                                }
                            //If the Status is neither On Deck nor OMX/ODP then throw error for the record
                            else{
                            system.debug('@@@@@@@@@Customer_Transition_Type2__c in if '+ ct.Customer_Transition_Type2__c );
                            system.debug('@@@@@@@@@Written_Agreement__c  in if '+ ct.Written_Agreement__c);
                            system.debug('@@@@@@@@@Local_Core__c  in if '+ ct.Local_Core__c);
                            system.debug('@@@@@@@@@Written_Agreement_Custom_Core_Request__c  in if '+ ct.Written_Agreement_Custom_Core_Request__c);
                                String errorMsg = Errorcheck(ct,ownerid);
                                system.debug('###If the Status is neither On Deck nor OMX/ODP then throw error for the record');
                                if(errorMsg.length() >3)
                                error = error + errorMsg.substring(0,errorMsg.length()-3);
                                
                                System.debug('&&&&&&&&&&&&&&&errorinloop'+error );
                                launcherror=true; 
                                allErrors.add(new WrapErrors(error));
                            }
                }
                //If the current record does not have any errors then checking if its Parent Transition is valid
               else{
                    //checking the validations for the Parent Transition record which aren't launched in prior and aren't Grandparent record
                    system.debug('Inside loop for Parent ID>>>>'+ct.id+'Status>>>>'+ct.status__c+' First else');
                    if(ct.Parent_Transition_ID__c!=null  && ct.Parent_Transition_ID__r.Customer_Transition_Type__c!='Grandparent' && (!ct.Parent_Transition_ID__r.name.contains('Customer Transition Great Grandparent of'))&& (ct.Parent_Transition_ID__r.Ready_for_Mod1__c != true)){ 
                        string childerror=ct.Account__r.omx_primary_key__c+'@@:@@'+ct.Account__r.name+'@@:@@';
                        string parenterror='';
                       if(mapCTrec.get(ct.Parent_Transition_ID__c)!=null)
                        {
                        system.debug('ID>>>>'+ct.id+'Status>>>>'+ct.status__c+' Parent Error check');
                        String prntErrorMsg = Errorcheck(mapCTrec.get(ct.Parent_Transition_ID__c),string.valueof(ct.Parent_Transition_ID__r.Account__r.ownerid).substring(0,15));
                        if(prntErrorMsg.length() >3)
                        parenterror = prntErrorMsg.substring(0,prntErrorMsg.length()-3);
                        }
                        //Displaying the Parent Record error message for the Child record
                        if(parenterror!=''){
                        launcherror=true;   
                            childerror=childerror+'The Record cannot be launched as Parent: '+ct.Parent_Transition_ID__r.omx_primary_key__c+' cannot be launched due to the error Reasons' ;
                            allErrors.add(new WrapErrors(childerror));
                        }
                        else
                        {
                        //Launching the selected Customer Transition records if they are Valid and the Parent Transition record is also valid
                        system.debug('@@@@In else and launching the CT');
                        ct.Ready_for_Mod1__c = true;
                        lct.add(ct);
                        }
                    }
                    else{
                    //Launching the selected Parent Customer Transition records if they are Valid
                    system.debug('@@@@In else and launching the CT 1111');

                        ct.Ready_for_Mod1__c = true;
                        lct.add(ct);
                    }         
                }
              } 
         }
         //Successfully launching the valid Customer Transition Records
         if(lct.size()>0){
         system.debug('@@@@@@@@@lct' + lct);
         update lct;
         
         PageReference pageRef1 =  new PageReference('javascript:window.close();');
            //Redirecting to the Error Page
             if(  launcherror==true) {
             PageReference pageRef2 =  new PageReference('/apex/Account_Hierarchy_Page_CTerror?id='+currentId);
             pageRef2.setRedirect(false);
             return pageRef2;
             }
             //Refreshing the same page
            else if(launcherror==false){
             PageReference pageRef2 =  new PageReference('/apex/Account_Hierarchy_Page_CT?id='+currentId);
             pageRef2.setRedirect(false);
             return pageRef2;
            }        
        return pageRef1;
        }
         else{
          //Redirecting to the Error Page
          if(  launcherror==true) {
             PageReference pageRef2 =  new PageReference('/apex/Account_Hierarchy_Page_CTerror?id='+currentId);
             pageRef2.setRedirect(false);
             return pageRef2;
             }
            else
            return null;
        }
    }
    // This Method prepares and returns the Error Message for the Failure Records that are selected
    public string Errorcheck(customer_Transition__c ct,string ownerId){
        String errMsg ='';
        if( ( (ct.Final_Split_Decision__c =='Yes'  || ct.Account__r.Split_Record__c == true ) && ct.Ready_for_Mod1__c == false  ) || ((ct.Final_Split_Decision__c ==''  || 
        ct.Final_Split_Decision__c ==null ) &&   ct.Account_Splitting_Required_frmla__c=='Yes')       || ct.account__r.status__c!='Active' || 
        ct.account__r.Sales_PersonID__c==null || ct.account__r.Sales_PersonID__r.name=='Awaiting SalesID' || ct.account__r.Sales_PersonID__r.name=='D7873'   
        || ct.account__r.owner.IsActive !=true || ct.Transition_Status__c !='Active' ||  ct.AOPS_Flag__c!='Y' ||  
        ct.Account__r.Segment__c==null ||  ct.Account__r.Segment__c=='Other' 
        ||  ownerId==System.Label.SalesforceDataloaderNorth 
        || ownerId==System.Label.salesforce   
        || (ct.Written_Agreement_Customer_No__c != null && ct.Customer_Go_Live_Target_Date__c == null)
        || ((ct.Status__c !='On Deck') && 
        (ct.status__c != 'ODP Agreement in Development' && ct.status__c != 'OMX Extension in Development' && ct.status__c != 'ODP Agreement Complete' ) 
        )
        || (ct.status__c == 'Administrative Close' && ct.Administrative_close__c == true && ct.Override_Administrative_close__c == false)||
        (ct.status__c == 'Loss of Customer' && ct.Customer_Loss__c== true && ct.Override_Loss_of_Customer__c== false)
        //Added for Case# 00674130
        || ((ct.Customer_Transition_Type2__c == 'Standalone' || ct.Customer_Transition_Type2__c == 'Child') && ct.Written_Agreement__c == true && ct.Local_Core__c == true && (ct.Written_Agreement_Custom_Core_Request__c == '' || ct.Written_Agreement_Custom_Core_Request__c == null) )
        ) 
        {        
        system.debug('###//Setting the Error Page redirection boolean to true');
        //Setting the Error Page redirection boolean to true
       // launcherror=true;       

            if(((ct.Status__c !='On Deck') && (ct.status__c != 'ODP Agreement in Development' && ct.status__c != 'OMX Extension in Development' && ct.status__c != 'ODP Agreement Complete'))
             &&(! (ct.status__c == 'Administrative Close' && ct.Administrative_close__c == true && ct.Override_Administrative_close__c == true) ) &&
            (! (ct.status__c == 'Loss of Customer' && ct.Customer_Loss__c== true && ct.Override_Loss_of_Customer__c== true))

             ){
             launcherror=true;   
            errMsg=errMsg+'Not in Valid status for Launching' + ' , ' ;}
            if(ct.account__r.Sales_PersonID__c==null)
            errMsg=errMsg+'Sales Person ID is \'NULL\'' + ' , ' ;
            if(ct.account__r.Sales_PersonID__r.name=='Awaiting SalesID')
            errMsg=errMsg+'Sales Person ID is \'Awaiting SalesID\'' + ' , ' ;
            if(ct.account__r.Sales_PersonID__r.name=='D7873')
            errMsg=errMsg+'Sales Person ID is \'belonging to DataLoader\'' + ' , ' ;
            if(ct.account__r.status__c !='Active')
            errMsg=errMsg+'Account is not Active' + ' , ' ;
            if(ct.account__r.owner.IsActive !=true)
            errMsg=errMsg+'Account Owner is not Active' + ' , ' ;
            if((ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account')&&(ct.Transition_Status__c !='Active'))
            errMsg=errMsg+'Transition Status is not Active' + ' , ' ;
            if( (ct.Final_Split_Decision__c ==''  || ct.Final_Split_Decision__c ==null ) && ct.Account_Splitting_Required_frmla__c=='Yes'  )
            errMsg=errMsg+'Final Split Decision is \'Blank\''+' , ' ;
            if( (ct.Final_Split_Decision__c =='Yes'  || ct.Account__r.Split_Record__c == true ) && ct.Ready_for_Mod1__c == false  )
            errMsg=errMsg+'Split Record can be Launched only through split process'+' , ' ;
            if((ct.Account__r.OMX_Mainframe_Account_Level__c == 'Main Account')&&(ct.AOPS_Flag__c!='Y'))
            errMsg=errMsg+'AOPS Flag is not \'Y\'' + ' , ' ;
            if(ct.Account__r.Segment__c==null)
            errMsg=errMsg+'Segment is \'NULL\'' + ' , ' ;
            if(ct.Account__r.Segment__c=='Other')
            errMsg=errMsg+'Segment is \'Other\'' + ' , ' ;
           //// if(ownerId==System.Label.DataLoader)
           //// errMsg=errMsg+'Owner is \'DataLoader\'' + ' , ' ;
            if(ownerId==System.Label.salesforce)
            errMsg=errMsg+'Owner is \'Salesforce\'' + ' , ' ;
            if(ownerId==System.Label.SalesforceDataloaderNorth)
            errMsg=errMsg+'Owner is \'Salesforce DataLoader North\'' + ' , ' ;
            if(ct.Written_Agreement_Customer_No__c != null && ct.Customer_Go_Live_Target_Date__c == null)
            errMsg=errMsg+'Customer Go Live Target Date is mandatory' + ' , ' ;
            //Added for Case# 00674130
            if((ct.Customer_Transition_Type2__c == 'Standalone' || ct.Customer_Transition_Type2__c == 'Child') && ct.Written_Agreement__c == true && ct.Local_Core__c == true && (ct.Written_Agreement_Custom_Core_Request__c == '' || ct.Written_Agreement_Custom_Core_Request__c == null) )
            errMsg=errMsg+'Written Agreement Custom Core Request is required' + ' , ' ;
        }
        system.debug('errMsg@@@@'+errMsg);
        // To Prepare the Error Message for Invalid Customer Transition records and returning the same
        return errMsg;
    }
    
    public PageReference BackToAccountHierarchy(){
                return Page.AccountHierarchyPage;  
        
    } 
    
    /******************************************List of Users Mail to 

be send*************************************************/
    public List<SelectOption> getUsers() {
        List<SelectOption> options = new List<SelectOption>();
        Set <String> setOfEmail = new Set<String>();
        for(Account account : selectedAccountList) {
            setOfEmail.add(account.Owner.Email);
        }       
        for(String emailIds : setOfEmail) {
            options.add(new SelectOption(emailIds,emailIds));
        }       
        return options;
    }
    public String getSelectedUsers() {
        return selectedUser;
    }
        
    public void setSelectedUsers(String selectedUser) {        
        this.selectedUser = selectedUser;
    }
    
    

    
    

/********************************************************************

********************************************************/
    
    /**
    * Wrapper class
    */
    public with sharing class ObjectStructureMap{

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        public boolean isShow{get;set;}
        
        /**
        * @Change this to your sObject
        */
        public Customer_Transition__c account;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Customer_Transition__c getaccount() { return account; 

}
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add

(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add

(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = 

cn; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Customer_Transition__c a ) { 

this.account = a; }

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap( String nodeId, Boolean[] 

levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, 

Boolean currentNode, Customer_Transition__c a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;
            this.isShow = true;
            //Change this to your sObject  
            this.account = a;
        }
    }
    
    /**
    * Wrapper class for errors
    */
        public with sharing class WrapErrors{

        public String accName{get;set;}
        public String omxPrimaryKey{get;set;}
        public String reason{get;set;}
        
        public String getomxPrimaryKey() { return omxPrimaryKey; }
        public String getaccName() { return accName; }
        public String getreason() { return reason; }
        
        public WrapErrors(string eachError)
        {
        
        
        System.debug('&&&&&&&&&&&&&&&&&eachError'+eachError);
            if(eachError != NULL && eachError != '')
            {
            List<String> cols=eachError.split('@@:@@');
            if(cols.size()>0 && cols[0]!=NULL )
            omxPrimaryKey=cols[0];
            if(cols.size()>1 && cols[1]!=NULL)
            accName=cols[1];
            if(cols.size()>2 && cols[2]!=NULL)
            reason=cols[2];
            }
        }
    }
}