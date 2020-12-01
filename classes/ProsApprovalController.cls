/**
* @class name: ProsApprovalController
* @author :  Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date : 10/9/2020
* @description : This class is responsible for PROS quote approval related stuffs.
* @JIRA NAIT-128079 (02870008) : Automate Approval Process
*/
public without sharing class ProsApprovalController {
    
    
    /*******************************************************************************************************
* @author Sandesh Ganjare 15 Oct 2020
* @description Create Support type case (NAIT-150833)
* @param userId=> record id,comments=>Comments put by approver, file=>File content, fileName=> Name of attachment
*/        
    @AuraEnabled(cacheable=true)
    public static Boolean approvalStatus(String caseId, String userId){
        System.debug('caseId=>'+caseId);
        System.debug('userId=>'+userId);
        Boolean status = false;
        try{                                                       
            //Getting Work Item Id
            List<ProcessInstanceWorkitem> pItemList = [Select Id,ActorId,OriginalActorId from ProcessInstanceWorkitem 
                                                       where ProcessInstance.TargetObjectId =:caseId AND OriginalActorId =: userId];
            System.debug('pItemList=>'+pItemList);
            if(pItemList.isEmpty()){
                status = true;
            }
            return status;
        }catch(exception e){
            return status;
        }
    }
    
    /*******************************************************************************************************
* @author Sandesh Ganjare 08 Oct 2020
* @description Create Support type case (NAIT-150833)
* @param userId=> record id,comments=>Comments put by approver, file=>File content, fileName=> Name of attachment
*/        
    @AuraEnabled
    public static Boolean approveReject(String caseId, String userId, String comments,String action, String file, String fileName){
        System.debug('caseId=>'+caseId);
        System.debug('userId=>'+userId);
        System.debug('comments=>'+comments);
        System.debug('action=>'+action);
        try{
            //Find Quote from case id and attach this file to that Quote
            List<Case> cList = [SELECT Id, Pros_Quote_ID__c FROM Case WHERE Id =: caseId Limit 1];
            
            if(!cList.isEmpty() && file != null && file != ''){
                String base62File = EncodingUtil.urlDecode(file, 'UTF-8');     
                ContentVersion contentVersionRec = new ContentVersion(); 
                contentVersionRec.Title = fileName;  
                contentVersionRec.PathOnClient = '/' + fileName;  
                contentVersionRec.FirstPublishLocationId = cList[0].Pros_Quote_ID__c;  
                contentVersionRec.VersionData = EncodingUtil.base64Decode(base62File);  
                contentVersionRec.IsMajorVersion = true;  
                INSERT contentVersionRec;
            }
            
            
            // Approve the submitted request
            // First, get the ID of the newly created item
            //Class used for Approving Record
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(comments);
            
            //Approve or Reject Record
            req.setAction(action); //Approve/Reject
            
            req.setNextApproverIds(new Id[] {userId});
            
            //Getting Work Item Id
            ProcessInstanceWorkitem pItem = [Select Id,ActorId,OriginalActorId from ProcessInstanceWorkitem 
                                             where ProcessInstance.TargetObjectId =:caseId];
            
            req.setWorkitemId(pItem.Id);
            // Submit the request for approval
            Approval.ProcessResult result = Approval.process(req);
            
            return true;
        }catch(exception e){
            return false;
        }
    }
    
    
    // Approval Users.
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
* Given a Quote's SFDC ID, returns the internal Users who should approve that Quote.
* Who should approve a particular quote is decided based on a rules table.
*/
    @AuraEnabled
    public static List<User> getApprovalUsers(String quoteId, String Type, String IssueTerm) {
        try {
            CameleonCPQ__QxQuote__c q = [SELECT Id, OwnerId, CameleonCPQ__AccountId__r.OwnerId, Type__c,Issue_Term__c FROM CameleonCPQ__QxQuote__c WHERE Id =: quoteId];
            q.Type__c = Type;
            q.Issue_Term__c = IssueTerm;
            update q;
            List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id, Name, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c,Text_Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                       FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c = 'PROS' AND Active__c = true];
            Map<String, User> possibleApprovalUsers = getPossibleApprovalUsers(q);
            List<String> approvalTitles = ApprovalRuleEngineController.getApprovalTitles((sObject) q, rules);
            System.debug('approvalTitles=>'+approvalTitles);
            //List<String> orderedApprovalTitles = getOrderedUserApprovalTitles(approvalTitles, metadata);
            List<User> approvalUsers = getActualApprovalUsers(possibleApprovalUsers, approvalTitles);
            System.debug('approvalUsers=>'+approvalUsers);
            return approvalUsers;
        } catch(Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the approval users.');
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getIssueTerms(String Types){
        System.debug('Types=>'+Types);
        List<String> parts = Types.split(';');
        List<String> IssueTerms = new List<String>(); 
        List<PROS_Issue_Term__mdt> IssueTermsList = [SELECT Type__c,Issue_Term__c FROM PROS_Issue_Term__mdt WHERE Type__c IN :parts]; //
        if(!IssueTermsList.isEmpty()){
            for(Integer i=0;i<IssueTermsList.size();i++){
                IssueTerms.add(IssueTermsList[i].Issue_Term__c);
            }
            System.debug('IssueTerms=>'+IssueTerms);
        }
        return IssueTerms;
    }
    
    /**
* Helper for getApprovalUsers.
* Given a quote, returns the possible approvers from the Quote Owner's
* management hierarchy and the Quote Account Owner's management hierarchy.
* The result is organized in a Map - Key: Position, Value: User, where the position
* corresponds to the Approver__c field on the Endless_Aisle_Internal_Approval_Rule__c object.
* Note: If more Queues are added as options in the Rules table, they should also be added here.
*/
    private static Map<String, User> getPossibleApprovalUsers(CameleonCPQ__QxQuote__c q) {
        //User quoteOwner = [SELECT Id, Manager_ID__c, Director_ID__c, Senior_Director_ID__c, VP_ID__c, SVP_ID__c FROM User WHERE Id =: q.OwnerId];
        User accOwner = [SELECT Id, Manager_ID__c, Director_ID__c, Senior_Director_ID__c, VP_ID__c, SVP_ID__c FROM User WHERE Id =: q.CameleonCPQ__AccountId__r.OwnerId];
        
        Map<String, User> possibleApprovalUsers = new Map<String, User>();
        //possibleApprovalUsers = getMapWithQuoteOwnerHierarchyAdded(possibleApprovalUsers, quoteOwner);
        possibleApprovalUsers = ApprovalRuleEngineController.getMapWithAccOwnerHierarchyAdded(possibleApprovalUsers, accOwner);
        
        return possibleApprovalUsers;
    }
    private static List<User> getActualApprovalUsers(Map<String, User> possibleApprovalUsers, List<String> approvalTitles) {
        List<User> actualApprovalUsers = new List<User>();
        for(String title : approvalTitles) {
            if(!possibleApprovalUsers.containsKey(title)) { continue; }
            if(listIncludesUser(actualApprovalUsers, possibleApprovalUsers.get(title))) { continue; }
            
            actualApprovalUsers.add(possibleApprovalUsers.get(title));
        }
        return actualApprovalUsers;
    }
    
    /**
* Helper for getActualApprovalUsers.
* Given a List of Users and a single User, determines if the User is in the List.
*/
@TestVisible
    private static boolean listIncludesUser(List<User> usrs, User usr) {
        for(User listUser : usrs) {
            if(listUser.Id == usr.Id) {
                return true;
            }
        }
        return false;
    }
    
    
    @AuraEnabled
    Public static void CreateSCOECaseFORApproval(Id qouteId,String IssueType, String IssueTerm, String approverIds){
        try{
            System.debug('approverIds=>'+approverIds);
            List<String> UserIds = (List<String>) JSON.deserialize(approverIds, List<String>.class);
            Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();
            CameleonCPQ__QxQuote__c q = [SELECT Id, Name, Quote_Number__c, CameleonCPQ__AccountId__c, CameleonCPQ__AccountId__r.Name FROM CameleonCPQ__QxQuote__c WHERE Id =: qouteId LIMIT 1];      
            //Support Owner --> Legal/Business Callouts
            List<Group> gpList =  [SELECT Id FROM Group WHERE Type = 'Queue' AND NAME = 'Legal/Business Callouts' LIMIT 1];              
            System.debug('UserIds=>'+UserIds);      
            List<User> activeUsers = [SELECT Id, Name, Job_Code_Level__c, Email FROM User WHERE Id IN :UserIds LIMIT 10];
            //List<String> UserDesignations = new List<String>{'','Manager','Director','Senior Director','VP', 'SVP', 'CEO','President'}; 
            System.debug('activeUsers=>'+activeUsers);
            String Approvers_Str ='';
            List<Id> Approvers = new List<Id>(); 
            List<Id> Users = new List<Id>();
            List<Id> Manager_Users = new List<Id>();
            List<Id> Director_Users = new List<Id>();
            List<Id> SrDirector_Users = new List<Id>();
            List<Id> VPUsers = new List<Id>();
            List<Id> SVPUsers = new List<Id>();  
            if(!activeUsers.isEmpty()){
                for(Integer i=0;i<activeUsers.size();i++){
                    Approvers_Str = Approvers_Str + '\n' + activeUsers[i].Name ;
                    if(activeUsers[i].Job_Code_Level__c == null || activeUsers[i].Job_Code_Level__c == ''){
                        Users.add(activeUsers[i].Id);
                    }else if(activeUsers[i].Job_Code_Level__c == 'Manager'){  Manager_Users.add(activeUsers[i].Id);
                    }else if(activeUsers[i].Job_Code_Level__c == 'Director'){ Director_Users.add(activeUsers[i].Id);
                    }else if(activeUsers[i].Job_Code_Level__c == 'Senior Director'){ SrDirector_Users.add(activeUsers[i].Id);
                    }else if(activeUsers[i].Job_Code_Level__c == 'VP'){ VPUsers.add(activeUsers[i].Id);
                    }else if(activeUsers[i].Job_Code_Level__c == 'SVP'){ SVPUsers.add(activeUsers[i].Id);
                    }
                }
            }
            
            System.debug('Users=>'+Users);
            System.debug('Manager_Users=>'+Manager_Users);
            System.debug('Director_Users=>'+Director_Users);
            System.debug('SrDirector_Users=>'+SrDirector_Users);
            System.debug('VPUsers=>'+VPUsers);
            System.debug('SVPUsers=>'+SVPUsers);
            if(!Users.isEmpty()){
                Approvers.addAll(Users);
            }
            if(!Manager_Users.isEmpty()){  Approvers.addAll(Manager_Users);
            }
            if(!Director_Users.isEmpty()){ Approvers.addAll(Director_Users);
            }
            if(!SrDirector_Users.isEmpty()){ Approvers.addAll(SrDirector_Users);
            }
            if(!VPUsers.isEmpty()){ Approvers.addAll(VPUsers);
            }
            if(!SVPUsers.isEmpty()){ Approvers.addAll(SVPUsers);
            }
            System.debug('Approvers=>'+Approvers);


            Case c = new case();
            c.RecordTypeId = ScoeRT;
            c.SCOE_Issue_Type__c = 'Legal/Business Callout'; 
            //c.SCOE_Support_Type__c = IssueType;
            c.New_Request__c = 'IssueType:'+IssueType +'\n Issue Term:'+IssueTerm+'\n Account Name:' + q.Name + '-'+ q.Quote_Number__c +'\n Approvers:'+Approvers_Str;
            c.AccountId = q.CameleonCPQ__AccountId__c;
            
            //Support Requester --> Current user
            c.Support_Requester__c= UserInfo.getUserId();
            c.Approval_Submitter_Email__c = UserInfo.getUserEmail();
            
            c.Subject=  q.CameleonCPQ__AccountId__r.Name + ' - Legal/Business Callout - ' + IssueType;    
            
            c.Priority = '3-Medium'; 
            c.Description =    'n/a';
            
            c.ownerId = gpList[0].id; //Queue Id
            c.Pros_Quote_ID__c = q.id;
            c.Current_Approver__c = (!Approvers.isEmpty() && Approvers.size()>0) ? String.valueOf(Approvers[0]) :null;
            c.AM_Approver1__c = (!Approvers.isEmpty() && Approvers.size()>0) ? Approvers[0] :null;
            c.AM_Approver2__c = (!Approvers.isEmpty() && Approvers.size()>1) ? Approvers[1] :null;
            c.AM_Approver3__c = (!Approvers.isEmpty() && Approvers.size()>2)? Approvers[2] :null;
            c.AM_Approver4__c = (!Approvers.isEmpty() && Approvers.size()>3) ? Approvers[3] :null;
            //Creating a SCOE case
            System.debug('c=>'+c);

            INSERT c;     
            
            //Sending ros quote for approval
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setObjectId(c.Id);
            approvalRequest.setProcessDefinitionNameOrId('PROS_Approval_Process');
            Approval.ProcessResult result = Approval.process(approvalRequest);
            if(!result.isSuccess()) {
                throw new AuraHandledException('Approval process failed to submit.');           
            }
        }catch(exception e){
            throw new AuraHandledException('Something went wrong contact System Admin.'); 
        }
        
    }
    
}