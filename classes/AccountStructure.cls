/**  Copyright (c)Ã‚Â 2008, Matthew Friend, Sales Engineering, Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*  Neither the name of theÃ‚Â salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
* To adapt this to anouther Object simply search for "Change" to go to the places 
* where the sObject and query must be changed
*/
public with sharing class AccountStructure{
 
    //Declare variables
    public  String currentId;
    public  transient List<ObjectStructureMap> asm ;
    public  transient Map<String, ObjectStructureMap> masm;
    public  List<Integer> maxLevel;
    //public  Set<Account>accountSet;
    public transient Map<ID, Account> accountMap; 
    public  String Subject{get;set;}
    public  String Body{get;set;}
    public  Document document {get;set;} 
    public  List<Account>selectedAccountList{get;set;}
    public  String userEmailCc{get;set;} 
//  public  String firstFileName{get;set;}
//  public  String firstFileLink{get;set;}
//  public  String secondFileName{get;set;}
//  public  String secondFileLink{get;set;}
//  public  String thirdFileName{get;set;}
//  public  String thirdFileLink{get;set;}
    
    String selectedUser = '';  
    List<String> emailToBeSend = new List<String>();
    String addresses; 
   
    /**
    * Constructor
    */
    public AccountStructure() {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};        
    }
    
    /**
    * One argument Constructor
    */
    public AccountStructure(ApexPages.StandardController controller) {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
        document = new Document();
        selectedAccountList = new List<Account>();
  //    firstFileName = ''; firstFileLink =''; secondFileName ='';
  //    secondFileLink =''; thirdFileName=''; thirdFileLink='';
        //accountSet = new Set<Account>();      
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
    List<ObjectStructureMap> cacheObjectStructureMap=new List<ObjectStructureMap>();
    public List<ObjectStructureMap> getObjectStructure(){
        if(asm == null){
            asm = new List<ObjectStructureMap>{};
        }        
        asm.clear();
        if ( currentId == null ) {
            currentId = System.currentPageReference().getParameters().get( 'id' );
        }
        
        System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
        asm = formatObjectStructure( CurrentId );
        
        return asm;
    }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId ){
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        if(masm == null){
            masm = new Map<String, ObjectStructureMap>{};
        }
        accountMap = new Map<ID, Account>();
        masm.clear();

        //Change below
        List<Account> al            = new List<Account>{};
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
        Integer limits = 2250;
        
        //Find highest level obejct in the structure
        currentParent.add( GetTopElement( currentId ) );
        
        //Loop though all children
        while ( !endOfStructure ){

            if( level == 0 ){
                //Change below                   
                al = [ SELECT a.Tier_1_Partner__c, a.Tier_1_Partner__r.name,a.Type,Segment__c,Buying_Group__c,Account_Owner_Manager_Name__c, a.YTD_Sales_TY_IMU2__c,a.YTD_Sales_LY_IMU2__c, a.Weeks_Since_Last_Order__c,a.owner.email, a.open_opp_amt__c, a.YTD_Sales_TY__c, a.YTD_Sales_LY__c, a.YTD_Sales_Diff__c,  a.owner.name, a.Site, a.cust_id__c,a.OMX_Primary_Key__c, a.industry_OD_SIC_Rep__c, a.city__c, a.state__c, a.Address__c, a.LastActivityDate, a.Last_Order_Date__c,a.ParentId, a.OwnerId, a.Name, a.Industry, a.owner.Short_Title__c,a.Id FROM Account a WHERE a.id IN : CurrentParent ORDER BY a.Name ];
                
                limits = limits - al.size();
             
            } 
            else {
                //Change below      
               
                al = [ SELECT a.Tier_1_Partner__c, a.Tier_1_Partner__r.name,a.Type,Segment__c,Buying_Group__c,Account_Owner_Manager_Name__c, a.YTD_Sales_TY_IMU2__c,a.YTD_Sales_LY_IMU2__c,a.Weeks_Since_Last_Order__c, a.owner.email,a.owner.name, a.owner.Short_Title__c,a.YTD_Sales_TY__c, a.YTD_Sales_LY__c, a.YTD_Sales_Diff__c, a.open_opp_amt__c, a.Site,a.cust_id__c,a.OMX_Primary_Key__c, a.industry_OD_SIC_Rep__c, a.city__c, a.state__c, a.Address__c, a.LastActivityDate, a.Last_Order_Date__c,a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN : CurrentParent ORDER BY a.Name limit :limits];
                 
                limits = limits - al.size();
            }           
                 
            if( al.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account a = al[i];
                    nodeId = ( level > 0 ) ? NodeList.get( a.ParentId )+'.'+String.valueOf( i ) : String.valueOf( i ); 
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );
                    //accountSet.add(a);
                    accountMap.put(a.id, a);
                   
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
    public List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
        
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
        
        Boolean top = false;
        while ( !top ) {
            //Change below
            Account a = [ Select a.Id, a.Tier_1_Partner__r.name, a.Tier_1_Partner__c,a.YTD_Sales_TY_IMU2__c,a.YTD_Sales_LY_IMU2__c,Segment__c,Buying_Group__c,Account_Owner_Manager_Name__c,a.owner.Short_Title__c,a.Weeks_Since_Last_Order__c,a.owner.name, a.owner.email,a.cust_id__c,a.OMX_Primary_Key__c,a.YTD_Sales_TY__c, a.YTD_Sales_LY__c, a.YTD_Sales_Diff__c, a.open_opp_amt__c, a.industry_OD_SIC_Rep__c, a.city__c, a.state__c, a.Address__c, a.LastActivityDate, a.Last_Order_Date__c, a.ParentId From Account a where a.Id =: objId limit 1 ];
            
            if ( a.ParentID != null ) {
                objId = a.ParentID;
                
            }
            else {
                system.debug('in else');
                top = true;
            }
        }
       
        return objId ;
    }
    
    
    //============================================================//
    // Divide original email list into multiple of 100 users email
    //============================================================//
    public List<String> getEmailList(Integer startCounter, Integer endCounter){
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
        
    //   if(firstFileName.trim().length() > 0 ){
    //       body = body +  '<br><b>File 1 Name:</b>' + firstFileName + '&nbsp;&nbsp;&nbsp;';
    //   }
    //   if(firstFileLink.trim().length() > 0){
    //       body = body + '<b>File 1 Link:</b>'+firstFileLink+'<br>';
    //   }
    //   if(secondFileName.trim().length() > 0 ){
    //       body = body +  '<br><b>File 2 Name:</b>' + secondFileName + '&nbsp;&nbsp;&nbsp;';
    //   }
    //   if(secondFileLink.trim().length() > 0){
    //       body = body + '<b>File 2 Link:</b>'+secondFileLink+'<br>';
    //   }
    //   if(thirdFileName.trim().length() > 0 ){
    //       body = body +  '<br><b>File 3 Name:</b>' + thirdFileName + '&nbsp;&nbsp;&nbsp;';
    //   }
    //   if(thirdFileLink.trim().length() > 0){
    //       body = body + '<b>File 3 Link:</b>'+thirdFileLink+'<br>';
    //   }
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
       /* for(Task task : taskList){
            Attachment attachment = new Attachment();
            attachment.Body = body;
            attachment.Name = document.name;
            attachment.ParentId = task.id;
            attachmentList.add(attachment);
        }
        insert attachmentList; */ 
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
                     //addresses += ':' + account.Owner.Email;
                     emailToBeSend.add(account.Owner.Email);
                }          
            }
         }     
        return Page.AccountHierarchySendEmail;  
          
    }
    
    
    public PageReference BackToAccountHierarchy(){
        
        /*accountMap=new Map<ID, Account>();
        selectedAccountList = new List<Account>();
        asm = new  List<ObjectStructureMap>();
        masm = new Map<String, ObjectStructureMap>{};
        maxLevel = new List<Integer>();
        emailToBeSend = new List<String>();*/
        //return null;
        return Page.AccountHierarchyPage;  
        
    } 
    
    /******************************************List of Users Mail to be send*************************************************/
    public List<SelectOption> getUsers() {
        //set<String> allMarkets = new set<String>();
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('None','--None--'));
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
    /****************************************************************************************************************************/
    
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
        public Account account;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Account getaccount() { return account; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Account a ) { this.account = a; }

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a ){
            
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
}