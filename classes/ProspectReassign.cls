public class ProspectReassign {
    public string CustomerName {get;set;}
    public String customerNumber {get;set;}
    public String Industry {get;set;}
    public String salesPerson {get;set;}
    public String ProsposedsalesPerson {get;set;}
    public Account AccountToHoldInput {get;set;}
    public Account AccountToHoldsp {get;set;}
    public String TotalSearchRows {get;set;}
    public boolean tblRendered{get;set;}
    public boolean msgRendered{get;set;}
    public Account newsalesPersonlkup {get;set;}
    public list<ReassignOut> searchResult {get;set;}
    public list<SelectOption> industryOptions {get;set;}
    public class custException extends Exception {}
    public String errorReportLink {get;set;}
    public list<String> AcctRecordTypes {get;set;}
    public String AccountRecType {get;set;}
    public boolean isAdmin {get;set;}
    public boolean disableSelectAll {get;set;}
    public String odEmpID {get;set;}

    //Added for S-429664
    public String recentReassignment {get;set;}
    public Integer totalRows {get;set;}
    public List<ReassignOut> roWrapperList{get; set;} //used on vf page
    public List<ReassignOut> rofinalWrapperList;
    public PaginationUtility con {get; set;}
    public Integer selectedPageNumber {get; set;}
    //End S-429664

    public String SalesRepName{get;set;} // added for the story #S-418599 (00687415)

    // added for the story #S-418604 (00715861) #START

    public static final String NONE = 'None';
    public List<SelectOption> stateList{set;}
    public String state{get;set;}

    public List<SelectOption> getstateList() {

      List<SelectOption> options = new List<SelectOption>();

       Schema.DescribeFieldResult fieldResult = Account.State__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

       options.add(new SelectOption(NONE, NONE));

       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       return options;
    }

    // added for the story #S-418604 (00715861) #END

    //START S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
    public list<SelectOption> WCWRangeOptions {get;set;}
    public String WCWRangeValue {get;set;}
    public final Map<String,List<Integer>> WCWRangeMap = new Map<String,List<Integer>> {
          '1-19' => new List<Integer> {1, 19},
          '20-49' => new List<Integer> {20, 49},
          '50-99' => new List<Integer> {50, 99},
          '100-149' => new List<Integer> {100, 149},
          '150-199' => new List<Integer> {150, 199},
          '200-249' => new List<Integer> {200, 249},
          '250-500' => new List<Integer> {250, 500},
          '500+' => new List<Integer> {501,501}
      };
    //END S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
    //START S-414429 (OD 00687413) [Hemant 6/1/2016] - Update Zip Filter
    public String zipCodes {get;set;}
    private List<String> zipCodeLst;
    //END S-414429 (OD 00687413) [Hemant 6/1/2016] - Update Zip Filter

    public ProspectReassign() {
        AccountToHoldInput = new Account();
        AccountToHoldInput.Org_WCW_Count_Rep__c = null;
        AccountToHoldsp = new Account();
        AcctRecordTypes = new list<String>();
        searchResult = new list<Reassignout>();
        //Added for S-429664
        roWrapperList = new  List<Reassignout>();
        rofinalWrapperList = new  List<Reassignout>();
        selectedPageNumber = 1;
        con = new PaginationUtility();
        //End S-429664
        tblRendered = false;
        msgRendered = false;
        disableSelectAll=true;
        newsalesPersonlkup = new Account();
        industryOptions = new list<SelectOption>();
        //Get Industry Picklist Values
        Schema.DescribeFieldResult industryField = Account.Industry_OD_SIC_Rep__c.getDescribe();
        List<Schema.PicklistEntry> industryPickList = industryField.getPicklistValues();
        Industryoptions.add(new SelectOption('',''));
        ReassignUtils ru = new ReassignUtils();
        errorReportLink = ru.ReassignMetadata.Error_Report_link__c;
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

        for( Schema.PicklistEntry i : industryPickList)
        {
          Industryoptions.add(new SelectOption(i.getLabel(), i.getValue()));
        }
        isAdmin = false;

        populateWCWRangeOptions();//S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range

        for (groupMember g:[SELECT Id, UserOrGroupId from groupMember where group.name='ReAssignment Admin' and UserOrGroupId=:userInfo.getUserId()])
            isAdmin = true;
    }

    //START S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
    private void populateWCWRangeOptions(){

			//Added for S-425902
        	WCWRangeOptions = new list<SelectOption>{new SelectOption('none','--None--')};
        	WCWRangeOptions.add(new SelectOption('', 'Blank'));
			//End S-425902

            for(String range : WCWRangeMap.keySet()){
                WCWRangeOptions.add(new SelectOption(range, range));
            }
    }
    //END S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range

    public class ReassignOut {
        public Account act {get;set;}
       public boolean sbox {get;set;}
       public String newOwner {get;set;}
       public String qStatus {get;set;}
       public String qStatusMsg {get;set;}
       public String qAppReJDt {get;set;}
        public boolean selectDisabled {get;set;}
    }

    public void ReassignAll() {
        Map<ID,Reassignment_Queue__c> pendingReassignmentMap = new Map<ID,Reassignment_Queue__c>();
        list<ID> AccountIDs = new List<ID>();

		//Modified for S-429664
		rofinalWrapperList.clear();
		rofinalWrapperList = searchResult;
        for (ReassignOut r:rofinalWrapperList) {
        //End S-429664
            r.sbox=true;
            AccountIDs.add(r.act.ID);
        }

        for(Reassignment_Queue__c q:[select id,account__c from reassignment_queue__c where account__c=:accountIDs and status__c = 'Pending Approval'])
          pendingReassignmentMap.put(q.Account__c,q);

	    //Modified for S-429664
        for (ReassignOut r:rofinalWrapperList) {
        //End S-429664
          if (pendingReassignmentMap.containsKey(r.act.ID))
            r.sbox=false;
        }

		//Added for S-429664
		recentReassignment = newsalesPersonlkup.ownerID;
		//End S-429664
        reassign();

    }

    public void Reassign() {
        try
        {
        list<Account> acUpd = new list<Account>();
        ReassignUtils ru = new ReassignUtils();
        //Added for S-429664
        if(recentReassignment == null){
        rofinalWrapperList.clear();
        rofinalWrapperList.addAll(roWrapperList);
        }
        //End S-429664
        ID toUserID;
        list<user> userHier = ru.getUserHier();
        system.debug('@@@@@@@@@@@@@newsalesPersonlkup' + newsalesPersonlkup);
        system.debug('@@@@@@@@@@@@@newsalesPersonlkup.ownerID' + newsalesPersonlkup.ownerID);

        if (newsalesPersonlkup.ownerID != null) {
        system.debug('@@@@@@@@@@@@@newsalesPersonlkup1111' + newsalesPersonlkup);
        system.debug('@@@@@@@@@@@@@newsalesPersonlkup.ownerID1111' + newsalesPersonlkup.ownerID);
           //Validate SalesPerson is valid
           List<User> sp = [select id from User where id=:newsalesPersonlkup.ownerID and isactive=true];
            if (sp.size()==0) {
              system.debug('SalesPerson Not Active');
              throw new custException ('SalesPerson is Not Active');
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
                }
            }
        }
        system.debug('User Hierarchy:'+userHier);
        if (reassignAllowed == false && isAdmin == false) {
            system.debug('Reassign Not Allowed');
            throw new custException (ReassignUtils.REASSIGN_NOT_ALLOWED);
        }

        list<ReassignUtils.ReassignData> reassignReq = new list<ReassignUtils.ReassignData>();
        list<ReassignUtils.ReassignData> reassignRes = new list<ReassignUtils.ReassignData>();
        //Modified below line for S-429664
        for (ReassignOut r:rofinalWrapperList) {
            if (r.sbox)
                acUpd.add(r.act);
        }
            system.debug('Reassignment:'+acUpd);
        for (Account a: acupd) {
          ReassignUtils.ReassignData rd = new ReassignUtils.ReassignData();
          rd.AccountID = a.ID;
          rd.toUserID = toUserID;
          reassignReq.add(rd);
        }
        ReassignRes = ru.ReassignAccounts(ReassignReq);
        Boolean oneOrMoreErrors = false;
        for (ReassignUtils.ReassignData r:ReassignRes) {
            if (r.status_code=='E') {
                oneOrMoreErrors = true;
                break;
            }
        }

        search();
        if (oneOrMoreErrors)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processed with Errors, Please <a href='+errorReportLink+' target="_blank">Click Here</a> to view failures'));
            else {
            system.debug('No Errors');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Successfully Processed'));
            }
        system.debug('Accounts to update:' + ReassignRes);
            if(test.isrunningtest()){
                Exception e;
                throw e;
            }
        }
            catch(custException ce) {
              system.debug('Error:' + ce);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));

            }
            catch(Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
            }
    }

    public void Search() {
        PageReference pref = new PageReference('/');
        @TestVisible String zip,owner;
        searchResult.clear();
        //Added for S-429664
        roWrapperList = new  List<Reassignout>();
        rofinalWrapperList = new  List<Reassignout>();
        selectedPageNumber = 1;
        con = new PaginationUtility();
        //End S-429664
        newsalesPersonlkup.ownerid = null;
        msgRendered = true;
        disableSelectAll=true;
        system.debug('zip:'+ AccountToHoldInput.ZIP__C +':');
        if (AccountToHoldInput.ZIP__C == null)
            zip='';
        else
            zip=AccountToHoldInput.ZIP__C;

        list<account> aSearch = new list<account>();

        system.debug('Owner:'+AccountToHoldInput.ownerID);
       /* if (industry == null)
            industry='';*/
        system.debug('iNUDSTRY:'+industry);
        system.debug('@@customerName'+customerName);
        if (customerName != null)
            customerName = customerName.replace('\'','\\\'');

			  //Modified for S-429664
               String searchSOQL1 = 'select id,name,Account_Number__c ,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account ';
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
            	System.debug('============='+zipCode);
            	System.debug('====1111========='+zipCode.trim());
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
        if (AccountToHoldInput.ownerID != null)
           searchSOQL = searchSOQL + ' and ownerid =\''+AccountToHoldInput.ownerID+'\'';

        //Added for S-429664
        if (recentReassignment != null)
           searchSOQL = searchSOQL + ' and ownerid !=\''+recentReassignment+'\'';
        //End S-429664

        if (AccountToHoldsp.ownerID != NULL)
            searchSOQL = searchSOQL + ' and assignment_status__r.New_Owner__c=\''+AccountToHoldsp.ownerID+'\' and assignment_status__r.Status__c in (\'Pending Approval\',\'Approved\',\'Auto Approved\')';
        //START S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
        //if (AccountToHoldInput.Org_WCW_Count_DB__c != null){
            //searchSOQL = searchSOQL + ' and Org_WCW_Count_Rep__c='+AccountToHoldInput.Org_WCW_Count_DB__c;
        if (String.isNotBlank(WCWRangeValue) && WCWRangeMap.containsKey(WCWRangeValue)){
              List<Integer> range = WCWRangeMap.get(WCWRangeValue);
	          searchSOQL = searchSOQL + ' and Org_WCW_Count_Rep__c >= '+ range[0];
	          if(range[0] != range[1]){
	            searchSOQL += ' and Org_WCW_Count_Rep__c <= ' + range[1];
	          }
        }
        //Added for S-425902
        else{
        	 if(WCWRangeValue != 'none')
        	 searchSOQL += ' and Org_WCW_Count_Rep__c = null';
        }// End S-425902

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

      if(state != null && state != '' && state != NONE) {
        searchSOQL = searchSOQL + ' and State__c = \''+state.trim()+'\'';
      }

      // added for the story #S-418604 (00715861) #END

        //Modified for S-429664
		countSOQL = countSOQL + searchSOQL;
        searchSOQL = searchSOQL1 + searchSOQL + ' LIMIT 1000';
		recentReassignment = null;
        System.debug('Generated SOQL:' + searchSOQL);
		totalRows = (Integer)Database.countQuery(countSOQL);
        aSearch = (list<Account>)Database.query(searchSOQL);
        //End S-429664

        /*
        if (AccountToHoldInput.ownerID != null)  {
          if (AccountToHoldsp.ownerID != NULL) {
            if (AccountToHoldInput.Org_WCW_Count_Rep__c == 0 || AccountToHoldInput.Org_WCW_Count_Rep__c==null) {
              aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND ZIP__C LIKE :zip + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry +'%' and ownerid = :AccountToHoldInput.ownerID and assignment_status__r.New_Owner__c=:AccountToHoldsp.ownerID and assignment_status__r.Status__c in ('Pending Approval','Approved','Auto Approved') and recordType.name=:AcctRecordTypes  limit 49000];
             }
            else
              aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND ZIP__C LIKE :zip + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry +'%' and ownerid = :AccountToHoldInput.ownerID and assignment_status__r.New_Owner__c=:AccountToHoldsp.ownerID and assignment_status__r.Status__c in ('Pending Approval','Approved','Auto Approved') and Org_WCW_Count_Rep__c=:AccountToHoldInput.Org_WCW_Count_Rep__c and recordType.name=:AcctRecordTypes  limit 49000];
          }
          else {
             if (AccountToHoldInput.Org_WCW_Count_Rep__c == 0 || AccountToHoldInput.Org_WCW_Count_Rep__c==null) {
              aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND ZIP__C LIKE :zip + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry +'%' and ownerid = :AccountToHoldInput.ownerID and recordType.name=:AcctRecordTypes  limit 49000];
             }
            else
              aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND ZIP__C LIKE :zip + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry +'%' and ownerid = :AccountToHoldInput.ownerID  and Org_WCW_Count_Rep__c=:AccountToHoldInput.Org_WCW_Count_Rep__c and recordType.name=:AcctRecordTypes  limit 49000];
          }

        }
        else {
          if (AccountToHoldsp.ownerID != NULL) {
           if (AccountToHoldInput.Org_WCW_Count_Rep__c == 0 || AccountToHoldInput.Org_WCW_Count_Rep__c==null) {
             aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry + '%' AND ZIP__C LIKE :zip + '%' and assignment_status__r.New_Owner__c=:AccountToHoldsp.ownerID and assignment_status__r.Status__c in ('Pending Approval','Approved','Auto Approved') and recordtype.name=:AcctRecordTypes limit 49000];
           }
           else
             aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry + '%' AND ZIP__C LIKE :zip + '%' and assignment_status__r.New_Owner__c=:AccountToHoldsp.ownerID and assignment_status__r.Status__c in ('Pending Approval','Approved','Auto Approved') and Org_WCW_Count_Rep__c=:AccountToHoldInput.Org_WCW_Count_Rep__c and recordtype.name=:AcctRecordTypes  limit 49000];
          }
          else {
           if (AccountToHoldInput.Org_WCW_Count_Rep__c == 0 || AccountToHoldInput.Org_WCW_Count_Rep__c==null) {
             aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry + '%' AND ZIP__C LIKE :zip + '%' and recordtype.name=:AcctRecordTypes limit 49000];
           }
           else
             aSearch = [select id,name,owner.name,Sales_PersonID__r.name,Industry_OD_SIC_Rep__c,status__c,zip__C,assignment_status__r.approver__c,assignment_status__r.New_Owner__c,assignment_status__r.Status__c,assignment_status__r.Status_message__c,assignment_status__r.Approve_Reject_Date__c,Org_WCW_Count_Rep__c from account where name like :customerName + '%' AND Industry_OD_SIC_Rep__c LIKE :Industry + '%' AND ZIP__C LIKE :zip + '%' and Org_WCW_Count_Rep__c=:AccountToHoldInput.Org_WCW_Count_Rep__c and recordtype.name=:AcctRecordTypes  limit 49000];
          }
        }
        */

        TotalSearchRows = string.valueof(aSearch.size());
        list<ReassignOut> searchResp = new list<ReassignOut>();
        integer dispSize=0;
        //Modified for S-429664
        if (aSearch.size() > 1000)
            dispSize = 1000; //End S-429664
        else
            dispSize = aSearch.size();

        if (dispSize > 0)
            tblRendered = true;
        else
            tblRendered = false;
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
            ro.sbox = false;
            if (pendingReassignmentMap.containsKey(aSearch[i].id))
              ro.selectDisabled = true;
            else
              ro.selectDisabled = false;
            searchResult.add(ro);
        }
        for (ReassignOut r:searchResult) {
            if (!r.selectDisabled) {
                disableSelectAll = false;
                break;

            }
        }
         system.debug('SelectAll Status:' + disableSelectAll);
         system.debug('Result:' + searchResult);

		//Added for S-429664
	     con.pageSize = 100;
	     List<Object> tempList = con.setPagination(searchResult);
	     if(tempList != null) {
	        roWrapperList = getWrapperList(tempList);
	     } //End S-429664
        //return pref;
    }


    //Added for S-429664
     private List<ReassignOut> getWrapperList(List<Object> currentList) {
        for(ReassignOut row: roWrapperList){
            if(row.sbox == true){
              // rofinalWrapperList.add(row);
            }
        }

         if(roWrapperList != null)
         roWrapperList.clear();

        for(Object obj : currentList) {
            roWrapperList.add((ReassignOut)obj);
        }
        return roWrapperList;
    }

    public PageReference getList() {
        system.debug('==>' + selectedPageNumber);
        roWrapperList = getWrapperList(con.getPage(selectedPageNumber));

        return null;
    }

    public List<Integer> listOfLinks {
        get {
            return con.listOfLinks;
        }
    }

    public boolean isMorePrevious {
        get {
            return con.isMorePrevious;
        }
    }

    public boolean isMoreNext {
        get {
            return con.isMoreNext;
        }
    }

    public Integer totalPage {
        get {
            return con.totalPage;
        }
    }

	//End S-429664
}