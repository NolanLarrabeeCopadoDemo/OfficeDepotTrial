@isTest
public class DMLRelationController_TC {
    public static Integer pageNumber = 1;
    public static Integer recordToDisply = 50;
    static testMethod void getDMLApprovalDataTest() {
        Recordtype rt = [SELECT Id FROM RecordType WHERE Name = 'Deployment Request'];
		list<DML__c> lstDML = new list<DML__c>();
        DML__c dmlrec = new DML__c();
        dmlrec.Status__c = 'Approved';
        //dmlrec.DECISION_MAKER_ID__c = '123456600';
        dmlrec.Effective_Start_Date__c = system.today();

        lstDML.add(dmlrec);

        DML__c dmlrec1 = new DML__c();
        dmlrec1.Status__c = 'Approved';
        //dmlrec1.DECISION_MAKER_ID__c = '123446799';
        dmlrec1.Effective_Start_Date__c=system.today();
        lstDML.add(dmlrec1);
		insert lstDML;
        
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.Related_DML__c = dmlrec.id;
        insert prospectAccount;
        
        Account prospectAccount1 = Test_Utils.CreateAccount('Prospect');
        prospectAccount1.Related_DML__c = dmlrec1.id;
        insert prospectAccount1;

        Org__c org = new Org__c();
        org.Business_Name__c = 'Test org';
        org.DUNS_Number__c = '123123456';
        org.Address_1__c = 'Melino Park';
        org.City__c = 'Bocca';
        org.State__c  ='FL';
        org.Zip__c = '12345';
        insert org;

        DML_Relation__c dmlr = new DML_Relation__c();
        dmlr.Org__c = org.Id;
        //dmlr.CUSTOMERID__c = '123456422';
        dmlr.Account__c = prospectAccount.id;
        dmlr.DML__c = dmlrec.Id;
        //dmlr.DECISIONMAKERID__c = '013834953';
        dmlr.Effective_End_Date__c = system.today();
        dmlr.Effective_Start_Date__c = system.today();
        insert dmlr;
        list<Case> lstCase = new list<Case>();
        Case newCase = new Case();
        newCase.accountId = prospectAccount.id;
        newCase.Support_Type__c = 'New DML Exception';
        newCase.Support_Sub_Type__c = dmlrec.Reason_for_Creation__c;
        newCase.subject = prospectAccount.Name;
        newCase.RecordTypeId = rt.Id;
        newCase.Description = 'Account Name :' + ' ' + prospectAccount.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + dmlrec.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + 'https://officedepot--oduat.cs78.my.salesforce.com/' + dmlrec.id;
        lstCase.add(newCase);

        Case newCase1 = new Case();
        newCase1.accountId = prospectAccount1.id;
        newCase1.Support_Type__c = 'New DML Exception';
        newCase1.Support_Sub_Type__c = dmlrec1.Reason_for_Creation__c;
        newCase1.subject = prospectAccount1.Name;
        newCase1.RecordTypeId = rt.Id;
        newCase1.Description = 'Account Name :' + ' ' + prospectAccount1.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + dmlrec1.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + 'https://officedepot--oduat.cs78.my.salesforce.com/' + dmlrec1.id;
        lstCase.add(newCase1);
        
        insert lstCase;

        DMLRelationController.CasePagerWrapper objWrapper =  new DMLRelationController.CasePagerWrapper();
        objWrapper = DMLRelationController.getDMLApprovalData(pageNumber, recordToDisply);
        System.debug('objWrapper=>'+objWrapper);
        String caseid = '["' + newCase.Id + '"]';
        String caseid1 = '["' + newCase1.Id + '"]';
        system.debug('caseid' + caseid);
        string notes = 'Rejected';
        DMLRelationController.CasePagerWrapper objWrapper2 =  new DMLRelationController.CasePagerWrapper();
        DMLRelationController.CasePagerWrapper objWrapper3 =  new DMLRelationController.CasePagerWrapper();
        objWrapper2 = DMLRelationController.processDMLApproval(caseid1, pageNumber, recordToDisply);
        System.debug('objWrapper2=>'+objWrapper2);
        //objWrapper3 = DMLRelationController.processDMLRejection(caseid, notes, pageNumber, recordToDisply);
        System.debug('objWrapper3=>'+objWrapper3);
        

        
        System.AssertEquals(true, objWrapper.total == 0);
        
    }
    static testMethod void processDMLRejectionTest() {
        Recordtype rt = [SELECT Id FROM RecordType WHERE Name = 'Deployment Request'];
		list<DML__c> lstDML = new list<DML__c>();
        DML__c dmlrec = new DML__c();
        dmlrec.Status__c = 'Approved';
        dmlrec.DECISION_MAKER_ID__c = '111456600';
        dmlrec.Effective_End_Date__c = system.today();

        lstDML.add(dmlrec);

        DML__c dmlrec1 = new DML__c();
        dmlrec1.Status__c = 'Approved';
        dmlrec1.DECISION_MAKER_ID__c = '111446799';
        dmlrec1.Effective_Start_Date__c=system.today();
        lstDML.add(dmlrec1);
        
        insert lstDML;

        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.Related_DML__c = dmlrec.id;
        insert prospectAccount;
        
        Account prospectAccount1 = Test_Utils.CreateAccount('Prospect');
        prospectAccount1.Related_DML__c = dmlrec1.id;
        insert prospectAccount1;
        

        Org__c org = new Org__c();
        org.Business_Name__c = 'Test org';
        org.DUNS_Number__c = '111123456';
        org.Address_1__c = 'Melino Park';
        org.City__c = 'Bocca';
        org.State__c  ='FL';
        org.Zip__c = '12345';
        insert org;

        DML_Relation__c dmlr = new DML_Relation__c();
        dmlr.Org__c = org.Id;
        dmlr.CUSTOMERID__c = '123456111';
        dmlr.Account__c = prospectAccount.id;
        dmlr.DML__c = dmlrec.Id;
        //dmlr.DECISIONMAKERID__c = '013834953';
        dmlr.Effective_End_Date__c = system.today();
        dmlr.Effective_Start_Date__c = system.today();
        insert dmlr;
        
        Case newCase1 = new Case();
        newCase1.accountId = prospectAccount1.id;
        newCase1.Support_Type__c = 'New DML Exception';
        newCase1.Support_Sub_Type__c = dmlrec1.Reason_for_Creation__c;
        newCase1.subject = prospectAccount1.Name;
        newCase1.RecordTypeId = rt.Id;
        newCase1.Description = 'Account Name :' + ' ' + prospectAccount1.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + dmlrec1.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + 'https://officedepot--oduat.cs78.my.salesforce.com/' + dmlrec1.id;
        insert newCase1;
      
        String caseid1 = '["' + newCase1.Id + '"]';                
        //system.debug('caseid' + caseid);                        
        DMLRelationController.CasePagerWrapper objWrapper3 =  new DMLRelationController.CasePagerWrapper();
        string notes = 'Rejected';
        Test.startTest();
        try{
        objWrapper3 = DMLRelationController.processDMLRejection(caseid1, notes, pageNumber, recordToDisply);
        }catch(Exception e){
        
        }
        Test.StopTest();
        System.debug('objWrapper3=>'+objWrapper3);
        
        
    }
     static testMethod void processDMLRelationDataTest() {
         list<DML__c> lstDML = new list<DML__c>();
       DML__c dmlrec = new DML__c();
        dmlrec.Status__c = 'Approved';
        dmlrec.DECISION_MAKER_ID__c = '123556600';
        dmlrec.Effective_End_Date__c = system.today();

        lstDML.add(dmlrec);

        DML__c dmlrec1 = new DML__c();
        dmlrec1.Status__c = 'Approved';
        dmlrec1.DECISION_MAKER_ID__c = '123556799';
        dmlrec1.Effective_Start_Date__c=system.today();
         lstDML.add(dmlrec1);
        insert lstDML;

        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.Related_DML__c = dmlrec.id;
        insert prospectAccount;
        
        Account prospectAccount1 = Test_Utils.CreateAccount('Prospect');
        prospectAccount1.Related_DML__c = dmlrec1.id;
        insert prospectAccount1;

        Org__c org = new Org__c();
        org.Business_Name__c = 'Test org';
        org.DUNS_Number__c = '123553456';
        org.Address_1__c = 'Melino Park';
        org.City__c = 'Bocca';
        org.State__c  ='FL';
        org.Zip__c = '12345';
        insert org;

        DML_Relation__c dmlr = new DML_Relation__c();
        dmlr.Org__c = org.Id;
        dmlr.CUSTOMERID__c = '123456422';
        dmlr.Account__c = prospectAccount.id;
        dmlr.DML__c = dmlrec.Id;
        //dmlr.DECISIONMAKERID__c = '013834953';
        dmlr.Effective_End_Date__c = system.today();
        dmlr.Effective_Start_Date__c = system.today();
        insert dmlr;
        
        String newDMLId = '' + dmlrec1.id;
        String input = '["' + dmlr.Id + '"]';
        String dataVal = String.valueOf(Date.today());
        Map <String, List<Object>> mapData = new Map <String, List<Object>>();
        system.debug('input=>'+input);
        system.debug('newDMLId=>'+newDMLId);
        system.debug('dataVal=>'+dataVal);
        mapData = DMLRelationController.processDMLRelationData(input, newDMLId,dataVal);
        System.debug('mapData=>'+mapData);
     }
    static testMethod void getDMLRelationDataTest() {
       
        DML__c dmlrec = new DML__c();
        //dmlrec.Status__c = 'Draft';
        dmlrec.DECISION_MAKER_ID__c = '123456755';
        dmlrec.DECISION_MAKER_NM__c = 'DML name';
        dmlrec.Effective_Start_Date__c=system.today();
        insert dmlrec;


        Org__c org = new Org__c();
        org.Business_Name__c = 'Test org';
        org.DUNS_Number__c = '123423477';
        org.Address_1__c = 'Melino Park';
        org.City__c = 'Bocca';
        org.State__c  ='FL';
        org.Zip__c = '12345';
        insert org;

        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.Related_DML__c = dmlrec.id;
        prospectAccount.Org__c = org.id;
        insert prospectAccount;


        DML_Relation__c dmlr = new DML_Relation__c();
        dmlr.Org__c = org.Id;
        dmlr.CUSTOMERID__c = '123456666';
        dmlr.Account__c = prospectAccount.id;
        dmlr.DML__c = dmlrec.Id;
        //dmlr.DECISIONMAKERID__c = '013834950'; 
        dmlr.Effective_End_Date__c = system.today();
        dmlr.Effective_Start_Date__c = system.today();
        insert dmlr;

        List<String> CustId = new List<String>{'123456678','123456676'};
        List<String> ParentId = new List<String> {'1234'};
        List<String> DMLId = new List<String>();
        DMLId.add(dmlrec.Name);
        String DMLName='test';
        List<String> RepId = new List<String>{'123456678','123456676'};
        List<String> GPId = new List<String>{'123456678','123456676'};
        List<String> DunsId = new List<String>{'123456678','123456676'};
        
        DMLRelationController.DMLRelatedData objData = DMLRelationController.getDMLRelationData(CustId, ParentId, DMLId, DMLName,RepId, GPId, DunsId,1,50);     
        System.debug('objData=>'+objData);
        System.AssertEquals(true, objData.countDml == 0);
        
    }
    
    static testMethod void processDMLRelationDataSalesRepTest() {
  		list<DML__c> lstDML = new list<DML__c>();
        DML__c dmlrec = new DML__c();
        //dmlrec.Status__c = 'Draft';
        dmlrec.DECISION_MAKER_ID__c = '123456733';
        dmlrec.DECISION_MAKER_NM__c = 'DML name';
        dmlrec.Effective_Start_Date__c=system.today();
        lstDML.add(dmlrec);
        
        DML__c dmlrec2 = new DML__c();
        //dmlrec.Status__c = 'Draft';
        dmlrec2.DECISION_MAKER_ID__c = '123456722';
        dmlrec2.DECISION_MAKER_NM__c = 'new DML name';
        dmlrec2.Effective_Start_Date__c=system.today();
        lstDML.add(dmlrec2);
        insert lstDML;
        
        DML_Relation__c dmlr = new DML_Relation__c();
       // dmlr.Org__c = org.Id;
        dmlr.CUSTOMERID__c = '123456633';
        //dmlr.Account__c = prospectAccount.id;
        dmlr.DML__c = dmlrec.Id;
        //dmlr.DECISIONMAKERID__c = '013834952';
        dmlr.Effective_End_Date__c = system.today()+10;
        dmlr.Effective_Start_Date__c = system.today();
        insert dmlr;
        
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        Sales_Person__c salesPerson=new Sales_Person__c();
        salesPerson.user__c=oUser.id;
        insert salesPerson;
        
        String InputData = '["' + dmlr.Id + '"]';
        string newDMLId= salesPerson.id;
        String Segment='Major $500K-$1M';
        String newDMLIdVal=salesPerson.id;
        String ProposedDate='2018-10-10';
        List < DML_Relation__c > lstDMLR = DMLRelationController.processDMLRelationDataSalesRep(InputData, newDMLId, Segment, newDMLIdVal, ProposedDate,'','');
        System.debug('lstDMLR=>'+lstDMLR);
        newDMLId=dmlrec2.id; 
        String DateVal='2018-10-10';
        
        
        
        Map <String, List < Object >> mapObj = DMLRelationController.processDMLRelationDate(InputData, newDMLId, DateVal);
        String status = DMLRelationController.processDMLData(newDMLId);
        System.debug('status=>'+status);
        List < DML_Relation_History__c > lstDRH = DMLRelationController.getDMLRelationHistory(dmlr.Id);
        System.debug('lstDRH=>'+lstDRH);
        System.AssertEquals(true, lstDMLR.size()>0);
        System.AssertEquals('SUCCESS', status);
        //System.AssertEquals(true, lstDRH.size()>0);
        
    }
     
}