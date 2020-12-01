/*************************************************************
*Name : AssignmentProspectController
*Created By : Sandesh Ganjare
*Created Date :30-03-2020
*Purpose : Controller for Prospect reassigment LWC.
*JIRA: NAIT-124929
****************************************************************/
public with sharing class AssignmentProspectController {
   
    public static String TotalSearchRows {get;set;}
    public static list<ReassignOut> searchResult {get;set;}
    public class custException extends Exception {}
    public static String errorReportLink {get;set;}
    public list<String> AcctRecordTypes {get;set;}
    public static String AccountRecType {get;set;}
    public static boolean isAdmin {get;set;}
    //Added for S-429664
    public static String recentReassignment {get;set;}  // Check this
    public static Integer totalRows {get;set;}
    public static List<ReassignOut> roWrapperList{get; set;} //used on vf page
    public static ReassignDataWrapper rofinalWrapperList;
    public static PaginationUtility con {get; set;}
    public static Integer selectedPageNumber {get; set;}
    //End S-429664

    //
    public static String zipCodes {get;set;}
    private static List<String> zipCodeLst;
    //END S-414429 (OD 00687413) [Hemant 6/1/2016] - Update Zip Filter

    public static final Map<String,List<Integer>> WCWRangeMap = new Map<String,List<Integer>> {
        '1-19' => new List<Integer> {1, 19},
        '20-49' => new List<Integer> {20, 49},
        '50-99' => new List<Integer> {50, 99},
        '100-149' => new List<Integer> {100, 149},
        '150-199' => new List<Integer> {150, 199},
        '200-249' => new List<Integer> {200, 249},
        '250-500' => new List<Integer> {250, 500},
        '500+' => new List<Integer> {501,501}
    };
    public AssignmentProspectController() {   
    }
    
    public class ReassignOut {    
      @AuraEnabled
       public Account act {get;set;}
      /*@AuraEnabled
       public boolean sbox {get;set;}
      @AuraEnabled 
       public String newOwner {get;set;}
      @AuraEnabled
       public String qStatus {get;set;}
      @AuraEnabled
       public String qStatusMsg {get;set;}
      @AuraEnabled
       public String qAppReJDt {get;set;}*/
      @AuraEnabled
       public boolean selectDisabled {get;set;}
    }

    public class ReassignData{
        public Id id;
    }

    public class ReassignDataWrapper{
        @AuraEnabled
        public string message{get;set;}
        @AuraEnabled
        public List<ReassignOut> reassigndata{get;set;}
        @AuraEnabled
        public integer totalSearchRows{get;set;  }
    }

    @AuraEnabled
    public static ReassignDataWrapper ReassignAll(String customerName, String customerNumber, String odEmpID,String zipCodes,
    String salesRepName,String industry,String WCWRangeValue,String state, String salesPersonId, String proposedPersonId, 
    String newsalesPersonlId,integer offset){
        Map<ID,Reassignment_Queue__c> pendingReassignmentMap = new Map<ID,Reassignment_Queue__c>();
             list<ID> AccountIDs = new List<ID>();

        //Modified for S-429664
        //rofinalWrapperList.clear();
        rofinalWrapperList = Search(customerName,customerNumber, odEmpID, zipCodes,salesRepName, 
                                    industry, WCWRangeValue, state, salesPersonId,proposedPersonId, -1);
        
        
        system.debug('@@@@@@@@@@@@@rofinalWrapperList' + rofinalWrapperList);
        List<ReassignData> lstReassignData = new List<ReassignData>();
        for (ReassignOut r:rofinalWrapperList.reassigndata) {
        //End S-429664
            //r.sbox=true;
            //Account a = new Account(Id=r.id);
            ReassignData rd = new ReassignData();
            rd.id = r.act.ID;    
            AccountIDs.add(r.act.ID);
            lstReassignData.add(rd);
        }
        system.debug('@@@@@@@@@@@@@lstReassignData' + lstReassignData);
        for(Reassignment_Queue__c q:[select id,account__c from reassignment_queue__c where account__c=:accountIDs and status__c = 'Pending Approval'])
          pendingReassignmentMap.put(q.Account__c,q);

        //Modified for S-429664
        for (ReassignOut r:rofinalWrapperList.reassigndata) {
        //End S-429664
          if (pendingReassignmentMap.containsKey(r.act.ID)){
            ReassignData rd = new ReassignData();
            rd.id = r.act.ID;             
            for (Integer i = lstReassignData.size() - 1; i >= 0 ; --i) {
                if ( lstReassignData[i].id == r.act.get('id')) {
                    lstReassignData.remove(i); 
                }
            }
          }
            
        }
        system.debug('@@@@@@@@@@@@@lstReassignData' + lstReassignData);
        String ReassignDatastr  = JSON.serialize(lstReassignData);
        system.debug('@@@@@@@@@@@@@lstReassignData' + lstReassignData);
        ReassignDataWrapper data = Reassign( customerName,  customerNumber,  odEmpID, zipCodes,
         salesRepName, industry, WCWRangeValue, state,  salesPersonId, proposedPersonId, 
         newsalesPersonlId,  ReassignDatastr, offset);

         system.debug('@@@@@@@@@@@@@data' + data);
        return data;
    }
    
    @AuraEnabled
    public static ReassignDataWrapper Reassign(String customerName, String customerNumber, String odEmpID,String zipCodes,
                                               String salesRepName,String industry,String WCWRangeValue,String state, String salesPersonId, String proposedPersonId, 
                                               String newsalesPersonlId, String ReassignData,integer offset) {
       ReassignDataWrapper  rdw = new ReassignDataWrapper();
       ReassignDataWrapper searchData = new ReassignDataWrapper();
       try{    
        //List<ReassignOut> reassigndataNEW = new List<ReassignOut>();
        system.debug('@@@@@@@@@@@@@newsalesPersonlId' + newsalesPersonlId);
        system.debug('@@@@@@@@@@@@@ReassignData' + ReassignData);
        List<ReassignData> lstReassignData =  (List<ReassignData>)JSON.deserialize(ReassignData, List<ReassignData>.class);
        system.debug('@@@@@@@@@@@@@lstReassignData' + lstReassignData);

        list<Account> acUpd = new list<Account>();
        ReassignUtils ru = new ReassignUtils();
        ID toUserID;
        list<user> userHier = ru.getUserHier();
        system.debug('@@@@@@@@@@@@@userHier' + userHier);
        if (newsalesPersonlId != null && newsalesPersonlId !='') {
            List<User> sp = [select id from User where id=:newsalesPersonlId and isactive=true];
            if (sp.size()==0) {
                system.debug('SalesPerson Not Active');
                rdw.message='SalesPerson Not Active';
                //rdw.reassigndata = reassigndataNEW;
                //return rdw;
            }
            else
                toUserID=sp[0].ID;
        }
        boolean ReassignAllowed=false;
        if (toUserID != null) {
            for(user u:userHier) {
                system.debug('Hier Loop:' + u.ID +':'+toUserID);
                if (toUserID == u.ID) {
                    reassignAllowed=true;
                    break;
                }
            }
        }
        isAdmin = false;
        for (groupMember g:[SELECT Id, UserOrGroupId from groupMember where group.name='ReAssignment Admin' and UserOrGroupId=:userInfo.getUserId()]){
            isAdmin = true;
            break;
        }
        
        system.debug('reassignAllowed:' + reassignAllowed +' isAdmin:'+isAdmin);
        system.debug('User Hierarchy:'+userHier);
        if (reassignAllowed == false && isAdmin == false) {
            system.debug('Reassign Not Allowed');
            rdw.message = ReassignUtils.REASSIGN_NOT_ALLOWED;
            //rdw.reassigndata = reassigndataNEW;
            //return rdw;
            //throw new custException ();
        }

        list<ReassignUtils.ReassignData> reassignReq = new list<ReassignUtils.ReassignData>();
        list<ReassignUtils.ReassignData> reassignRes = new list<ReassignUtils.ReassignData>();
        //Modified below line for S-429664
        if(!lstReassignData.isEmpty()){
            for (ReassignData r:lstReassignData) {
                Account a = new Account(Id=r.id);                    
                acUpd.add(a);
            }
        }       
        system.debug('Reassignment:'+acUpd);
        if(!acupd.isEmpty()){
            for (Account a: acupd) {
                ReassignUtils.ReassignData rd = new ReassignUtils.ReassignData();
                rd.AccountID = a.ID;
                rd.toUserID = toUserID;
                reassignReq.add(rd);
            }
        }
       
        system.debug('reassignReq:'+reassignReq);
        ReassignRes = ru.ReassignAccounts(ReassignReq);
        system.debug('ReassignRes:'+ReassignRes);
        Boolean oneOrMoreErrors = false;
        if(!ReassignRes.isEmpty()){
            for (ReassignUtils.ReassignData r:ReassignRes) {
                if (r.status_code=='E') {
                    oneOrMoreErrors = true;
                    break;
                }
            }
        }

         searchData = Search( customerName,customerNumber, odEmpID, zipCodes,salesRepName, industry, WCWRangeValue, state, salesPersonId,proposedPersonId, offset);
        //search();
        if (oneOrMoreErrors){
            system.debug('Errors');           
            rdw.message='Processed with Errors, Please <a href='+errorReportLink+' target="_blank">Click Here</a> to view failures';
            rdw.reassigndata = searchData.reassigndata;
            rdw.totalSearchRows = searchData.totalSearchRows;
            return rdw;
        }else if(rdw.message !=''){
            system.debug('No Errors');
            rdw.message='Successfully Processed';
            rdw.reassigndata = searchData.reassigndata;
            rdw.totalSearchRows = searchData.totalSearchRows;
            return rdw;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully Processed'));
        }else{
            rdw.reassigndata = searchData.reassigndata;
            rdw.totalSearchRows = searchData.totalSearchRows;
            return rdw;
        }
        //system.debug('Accounts to update:' + ReassignRes);
        }
        catch(Exception e) {
            rdw.message= 'Unexpected Exception:' + e;
            rdw.reassigndata = null;
            rdw.totalSearchRows = searchData.totalSearchRows;
            return rdw;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static ReassignDataWrapper Search(String customerName, String customerNumber, String odEmpID,String zipCodes,
        String salesRepName,String industry,String WCWRangeValue,String state, String salesPersonId, String proposedPersonId, integer offset) {
            
        searchResult = new list<Reassignout>(); 
       
        list<account> aSearch = new list<account>();        
        ReassignUtils ru = new ReassignUtils();
        errorReportLink = ru.ReassignMetadata.Error_Report_link__c;
        list<String> AcctRecordTypes = new list<String>();
        if (ru.ReassignMetadata.Reassignment_types__c != null)
         AcctRecordTypes = ru.ReassignMetadata.Reassignment_types__c.split(',');

        AccountRecType = '\'';
        for (integer i=0;i<AcctRecordTypes.size();i++) {
            if (i==0)
                AccountRecType = AccountRecType + AcctRecordTypes[i];
            else
                AccountRecType = AccountRecType + '\',\'' + AcctRecordTypes[i];
        }
        AccountRecType = AccountRecType + '\'';
        
        //system.debug('iNUDSTRY:'+industry);
        //system.debug('@@customerName'+customerName);
        if (customerName != null)
            customerName = customerName.replace('\'','\\\'');

              //Modified for S-429664
            //String searchSOQL1 = 'select id,name,Account_Number__c ,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account ';
            String searchSOQL1 = 'select id,name,Account_Number__c ,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.approver__r.Name,assignment_status__r.New_Owner__c,assignment_status__r.New_Owner__r.Name,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account ';
            String countSOQL = 'select count() from account ';
            String searchSOQL = ' where recordType.name in ('+AccountRecType+')';
        //End S-429664


        if (customerName != null && customerName != '')
            searchSOQL = searchSOQL + ' and name like \''+customerName.trim()+'%\''; // S-414429 (OD 00687413) [Hemant 6/6/2016] - Add trim() function
        //START S-414429 (OD 00687413) [Hemant 5/31/2016] - Update Zip Filter
        //if (zip != null && zip != '')
            //searchSOQL = searchSOQL + ' and ZIP__C like \'' +zip+'%\'';
        if (String.isNotBlank(zipCodes)){
            zipCodeLst = new List<String>();
            for(String zipCode : zipCodes.split(',')){
                //System.debug('============='+zipCode);
                //System.debug('====1111========='+zipCode.trim());
                if(String.isNotBlank(zipCode)){
                zipCodeLst.add(zipCode.trim() + '%');
                }
            }
            searchSOQL = searchSOQL + ' and ZIP__C like: zipCodeLst ';
        }
        //END S-414429 (OD 00687413) [Hemant 5/31/2016] - Update Zip Filter
        if (odEmpId != null && odEmpId != '')
            searchSOQL = searchSOQL + ' and owner.od_employee_id__c=\''+odEmpId.trim()+'\''; // S-414429 (OD 00687413) [Hemant 6/6/2016] - Add trim() function
        if (industry != null && industry != '')
            searchSOQL = searchSOQL + 'and Industry_OD_SIC_Rep__c =\''+Industry+'\'';
        if (salesPersonId != null && salesPersonId != '')
           searchSOQL = searchSOQL + ' and ownerid =\''+salesPersonId+'\'';

        //Added for S-429664
        //if (proposedPersonId != null && proposedPersonId !='')
           //searchSOQL = searchSOQL + ' and ownerid !=\''+proposedPersonId+'\'';
        //End S-429664

        if (proposedPersonId != null && proposedPersonId != '')
            searchSOQL = searchSOQL + ' and assignment_status__r.New_Owner__c=\''+proposedPersonId+'\' and assignment_status__r.Status__c in (\'Pending Approval\',\'Approved\',\'Auto Approved\')';
        //START S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
        //if (AccountToHoldInput.Org_WCW_Count_DB__c != null){
            //searchSOQL = searchSOQL + ' and Org_WCW_Count_Rep__c='+AccountToHoldInput.Org_WCW_Count_DB__c;
        if (String.isNotBlank(WCWRangeValue) && WCWRangeValue != '' && WCWRangeMap.containsKey(WCWRangeValue)){
              List<Integer> range = WCWRangeMap.get(WCWRangeValue);
              searchSOQL = searchSOQL + ' and Org_WCW_Count_Rep__c >= '+ range[0];
              if(range[0] != range[1]){
                searchSOQL += ' and Org_WCW_Count_Rep__c <= ' + range[1];
              }
        }
        //Added for S-425902
        /*else{
             if(WCWRangeValue != 'none')
             searchSOQL += ' and Org_WCW_Count_Rep__c = null';
        }*/// End S-425902

        //END S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
        if (customerNumber != null && customerNumber != '')
               searchSOQL = searchSOQL + ' and Account_Number__c=\''+customerNumber.trim()+'\''; // S-414429 (OD 00687413) [Hemant 6/6/2016] - Add trim() function

      ///  searchSOQL = searchSOQL + ' order by name asc';

      //added for the story #S-418599 (00687415) #START

      if(SalesRepName != null && SalesRepName != '') {
        searchSOQL = searchSOQL + ' and Sales_PersonID__r.name like \''+SalesRepName.trim()+'%\'';
      }

      //added for the story #S-418599 (00687415) #END

      // added for the story #S-418604 (00715861) #START

      if(state != null && state != '' ) {
        searchSOQL = searchSOQL + ' and State__c = \''+state.trim()+'\'';
      }

      // added for the story #S-418604 (00715861) #END

        //Modified for S-429664
        countSOQL = countSOQL + searchSOQL;
        if(Offset == -1){
            searchSOQL = searchSOQL1 + searchSOQL + ' LIMIT 1000';
        }else{
            searchSOQL = searchSOQL1 + searchSOQL + ' LIMIT 100 OFFSET '+  Offset; //limit :v_pagesize OFFSET :v_Offset
        }
        
        System.debug('Generated SOQL:' + searchSOQL);
        totalRows = (Integer)Database.countQuery(countSOQL);
        aSearch = (list<Account>)Database.query(searchSOQL);
        //End S-429664

        TotalSearchRows = string.valueof(aSearch.size());
        list<ReassignOut> searchResp = new list<ReassignOut>();
        integer dispSize=0;
        if (aSearch.size() > 1000)
        dispSize = 1000; //End S-429664
        else
        dispSize = aSearch.size();

        system.debug('Result Count:' + aSearch.size());
        list<ID> acctids = new list<ID>();
        for (integer i=0;i<dispSize;i++) {
          acctids.add(aSearch[i].id);
        }

        Map<ID,Reassignment_Queue__c> pendingReassignmentMap = new Map<ID,Reassignment_Queue__c>();
        for(Reassignment_Queue__c q:[select id,account__c from reassignment_queue__c where account__c=:acctids and status__c = 'Pending Approval'])
         pendingReassignmentMap.put(q.Account__c,q);

        for (integer i=0;i<dispSize;i++) {
            ReassignOut ro = new ReassignOut();
            ro.act = aSearch[i];

            if (ro.act.assignment_status__r.Status__c != 'Pending Approval' && ro.act.assignment_status__c != null) {
               ro.act.assignment_status__r.Status__c = null;
               ro.act.assignment_status__r.Approver__c = null;
               ro.act.assignment_status__r.New_Owner__c = null;
            }
            //ro.sbox = false;
            if (pendingReassignmentMap.containsKey(aSearch[i].id))
              ro.selectDisabled = true;
            else
              ro.selectDisabled = false;
            //if(!ro.selectDisabled)  
            searchResult.add(ro);
        }
        system.debug('pendingReassignmentMap:' + pendingReassignmentMap); 
        //system.debug('SelectAll Status:' + disableSelectAll);
        system.debug('Result:' + searchResult[0].act.Assignment_Status__r.New_Owner__c);
        ReassignDataWrapper rdw = new ReassignDataWrapper();
        rdw.reassigndata = searchResult;
        rdw.message = '';
        rdw.totalSearchRows = totalRows;    
        return rdw;
    }
}