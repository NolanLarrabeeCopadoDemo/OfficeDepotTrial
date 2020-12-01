/*************************************************************
 * Name : TrackAccountSetupClass
 * Created By : Himanshu Sharma
 * Created Date :19-03-2020
 * Purpose : Test class for TrackAccountSetupClass class
 * JIRA: NAIT-125250
 ****************************************************************/
global without sharing class TrackAccountSetupClass
{
    @AuraEnabled
    public static String TrackAccountSetupRequest(String SFDCAccountId)
    {
        SetInfo SetInfo = new SetInfo();
        HttpRequest req = new HttpRequest();
        // Using named credential-trackAccountSetupCredential for hitting the EAI service
        req.setEndpoint('callout:trackAccountSetupCredential/trackAccountSetup');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        String body;
        HTTPResponse res;
        Http http = new Http();
        String jsonResponse = '';
        list<Account_Setup_Request__c> query = new list<Account_Setup_Request__c>();

        try
        {
            query = [Select id, Account_Setup_Request_Number__c from Account_Setup_Request__c where Account__c =:SFDCAccountId];
            body = '{' +
                       '\"SFDCRequestID\":\"' + query[0].Account_Setup_Request_Number__c + '\",' +
                       '\"SFDCAccountID\":\"\",' +
                       '\"AOPSAccountID\":\"0\"' +
                       '}';
            req.setBody(body);
            res = http.send(req);
            jsonResponse = res.getBody();
            jsonResponse = jsonResponse.replace('"set":', '"sets":');
            return jsonResponse;
        }
        Catch(Exception ex)
        {
            jsonResponse = '{"response": {"status": "Failed", "message": "' + ex.getMessage() + '"}}';
        }
        return jsonResponse;
    }

    /*-----Wrapper class to extract the information from the callout response-----*/
    public class SetInfo
    {
        public List<cls_set> sets;
        public String o_Rtn_Msg;
    }

    public class cls_set
    {
        public Integer Step_Number; //1
        public String Step_Description; //1-SFDC Request (SFD200/201/..F)
        public String Request_Id;   //000000000288667
        public String SFDC_Id;  //0011k00000UsAslAAF
        public String AOPS_Account_Id;  //04688227
        public String B_Name;   //Parent Account
        public String Message;  //Request on AS400 - Request Received and Posted
        public String Posted_Timestamp; //2019-10-15-12.27.00.352000
        public String Operation;    //E
    }

    public class Tracker
    {
        public Integer Max_Step_Number; //1
        public String Step1_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step1_Message;
        public String Step1_Status;
        public String Step1_Timestamp;
        public String Step1_icon;

        public String Step2_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step2_Message;
        public String Step2_Status;
        public String Step2_Timestamp;
        public String Step2_icon;

        public String Step3_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step3_Message;
        public String Step3_Status;
        public String Step3_Timestamp;
        public String Step3_icon;

        public String Step4_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step4_Message;
        public String Step4_Status;
        public String Step4_Timestamp;
        public String Step4_icon;

        public String Step5_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step5_Message;
        public String Step5_Status;
        public String Step5_Timestamp;
        public String Step5_icon;

        public String Step6_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step6_Message;
        public String Step6_Status;
        public String Step6_Timestamp;
        public String Step6_icon;

        public String Step7_Description; //1-SFDC Request (SFD200/201/..F)
        public String Step7_Message;
        public String Step7_Status;
        public String Step7_Timestamp;
        public String Step7_icon;

        public String AOPS_Account_Id;  //04688227
        public String Message;          //Request on AS400 - Request Received and Posted
        public String Operation;        //E
        public String status;
    }

    @AuraEnabled
    public static String getTrackAcctSetup(String SFDCAccountId)
    {
        SetInfo SetInfo = new SetInfo();
        HttpRequest req = new HttpRequest();
        Tracker tracker = new Tracker();
        Integer maxSuccessStep = 0;

        tracker.Step1_Status = 'Pending';
        tracker.Step2_Status = 'Pending';
        tracker.Step3_Status = 'Pending';
        tracker.Step4_Status = 'Pending';
        tracker.Step5_Status = 'Pending';
        tracker.Step6_Status = 'Pending';
        tracker.Step7_Status = 'Pending';

        tracker.Step1_icon = 'action:defer';
        tracker.Step2_icon = 'action:defer';
        tracker.Step3_icon = 'action:defer';
        tracker.Step4_icon = 'action:defer';
        tracker.Step5_icon = 'action:defer';
        tracker.Step6_icon = 'action:defer';
        tracker.Step7_icon = 'action:defer';

        tracker.Step1_Description = 'Request to be sent AOPS';
        tracker.Step2_Description = 'AOPS Request to be Received ';
        tracker.Step3_Description = 'Request to be added to Setup pool in AOPS';
        tracker.Step4_Description = 'Customer not created in AOPS';
        tracker.Step5_Description = 'Customer not sent to Salesforce';
        tracker.Step6_Description = 'Salesforce did not receive Customer';
        tracker.Step7_Description = 'Salesforce did not process Customer';

        tracker.Step1_Message = 'Pending Action: Request to be sent AOPS';
        tracker.Step2_Message = 'Pending Action: AOPS Request to be Received ';
        tracker.Step3_Message = 'Pending Action: Request to be added to Setup pool in AOPS';
        tracker.Step4_Message = 'Pending Action: Create Customer in AOPS';
        tracker.Step5_Message = 'Pending Action: Customer not sent to Salesforce';
        tracker.Step6_Message = 'Pending Action: Salesforce did not receive Customer';
        tracker.Step7_Message = 'Pending Action: Salesforce did not process the Customer';

        req.setEndpoint('callout:trackAccountSetupCredential/trackAccountSetup');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        String body;
        HTTPResponse res;
        Http http = new Http();
        String jsonResponse = '';
        list<Account_Setup_Request__c> query = new list<Account_Setup_Request__c>();
        List<Account_Service_Data__c> acctServiceList = new List<Account_Service_Data__c>();
        List<Account_Message__c> acctMsgList = new List<Account_Message__c>();

        try
        {
            if (SFDCAccountId != null && SFDCAccountId != '')
            {
                acctMsgList = [SELECT Id, Republish__c, OPERATION__c, LastModifiedDate FROM Account_Message__c WHERE ACCT_ID_SFDC_ACCOUNT_ID__c =:SFDCAccountId];
                query = [SELECT Id, Account_Setup_Request_Number__c FROM Account_Setup_Request__c WHERE Account__c =:SFDCAccountId];
                acctServiceList = [SELECT Id, status__C, Batch_Processed__c, AOPS_CUSTOMER_ID__c, SFDC_CUSTOMER_ID__c, LastModifiedDate, CreatedDate FROM Account_Service_Data__c WHERE SFDC_CUSTOMER_ID__c =:SFDCAccountId];
            }

            if (acctMsgList.size() > 0)
            {
                tracker.Max_Step_Number = 1;
                tracker.Step1_Description = 'Request Sent to AOPS';
                tracker.Step1_Message = 'Request Sent to AOPS is Successful';
                tracker.Step1_Status = 'Success';
                tracker.Step1_icon = 'action:approval';
                tracker.Step1_Timestamp = '' + acctMsgList[0].LastModifiedDate.format('yyyy-MM-dd hh:mm:ss');
            }
            else
            {
                tracker.Step1_Description = 'Request Sent to AOPS failed';
                tracker.Step1_Status = 'Failed';
                tracker.Step1_icon = 'action:close';
                tracker.Step1_Message = 'Request Sent to AOPS is failed. Please Contact Support.';
            }

            if (query.size() > 0)
            {
                body = '{' +
                       '\"SFDCRequestID\":\"' + query[0].Account_Setup_Request_Number__c + '\",' +
                       '\"SFDCAccountID\":\"\",' +
                       '\"AOPSAccountID\":\"0\"' +
                       '}';
            }

            req.setBody(body);
            res = http.send(req);
            jsonResponse = res.getBody();
            String jsonString2 = jsonResponse.replace('"set":', '"sets":');
            SetInfo = (SetInfo)JSON.deserialize(jsonString2, SetInfo.class);

            for (cls_set cs: SetInfo.sets)
            {
                if (cs.Step_Number == 1)
                {
                    if (cs.Posted_Timestamp.trim().length() > 2)
                    {
                        if (tracker.Max_Step_Number < 2)
                            tracker.Max_Step_Number = 2;
                        tracker.Step2_Description = 'AOPS Request Received';
                        tracker.Step2_Status = 'Success';
                        tracker.Step2_icon = 'action:approval';
                        tracker.Step2_Message = 'AOPS has the Request is Successful';
                        tracker.Step2_Timestamp = cs.Posted_Timestamp;
                    }
                }
                else if (cs.Step_Number == 2)
                {
                    if (cs.Posted_Timestamp.trim().length() > 2)
                    {
                        if (tracker.Max_Step_Number < 3)
                            tracker.Max_Step_Number = 3;

                        tracker.Step3_Description = 'Request is added to Setup pool in AOPS';
                        tracker.Step3_Status = 'Success';
                        tracker.Step3_icon = 'action:approval';
                        tracker.Step3_Timestamp = cs.Posted_Timestamp;
                        tracker.Step3_Message = cs.Message + ' : ' + cs.Step_Description;
                    }
                }
                else if (cs.Step_Number == 3)
                {
                    if (cs.Posted_Timestamp.trim().length() > 2)
                    {
                        if (tracker.Max_Step_Number < 4)
                            tracker.Max_Step_Number = 4;

                        tracker.Step4_Message = cs.Message + ' : Account# ' + cs.AOPS_Account_Id;
                        tracker.Step4_Description = 'Customer created in AOPS';
                        tracker.Step4_Status = 'Success';
                        tracker.Step4_icon = 'action:approval';
                        tracker.Step4_Timestamp = cs.Posted_Timestamp;
                    }
                }
                else if (cs.Step_Number == 4)
                {
                    if (cs.Posted_Timestamp.trim().length() > 2)
                    {
                        if (tracker.Max_Step_Number < 5)
                            tracker.Max_Step_Number = 5;

                        tracker.Step5_Message = 'Account is sent back to Salesforce : Account# ' + cs.AOPS_Account_Id;
                        tracker.Step5_Description = 'Account is sent back to Salesforce ';
                        tracker.Step5_Status = 'Success';
                        tracker.Step5_icon = 'action:approval';
                        tracker.Step5_Timestamp = cs.Posted_Timestamp;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            jsonResponse = '{"response": {"status": "Failed", "message": "' + ex.getMessage() + '"}}';
        }

        if (acctServiceList.size() > 0 && tracker.Max_Step_Number > 4)
        {
            if ( tracker.Max_Step_Number == 5 )
            {
                tracker.Max_Step_Number = 6;
                tracker.Step6_Description = 'Salesforce Ready to Process';
                tracker.Step6_Message = 'Salesforce recevied the account and is Pedning to Process';
                tracker.Step6_Status = 'Success';
                tracker.Step6_icon = 'action:approval';
                tracker.Step6_Timestamp = '' + acctServiceList[0].CreatedDate.format('yyyy-MM-dd hh:mm:ss');
            }
            if ( tracker.Max_Step_Number == 6 )
            {
                if (acctServiceList[0].Batch_Processed__c)
                {
                    tracker.Max_Step_Number = 7;
                    tracker.Step7_Description = 'Salesforce Account is all set';
                    tracker.Step7_Message = 'Salesforce Account is all set';
                    tracker.Step7_Status = 'Success';
                    tracker.Step7_icon = 'action:approval';
                    tracker.Step7_Timestamp = '' + acctServiceList[0].LastModifiedDate.format('yyyy-MM-dd hh:mm:ss');
                    if (acctServiceList[0].status__C == 'FAIL')
                    {
                        tracker.Step7_Description = 'Salesforce unable to Process';
                        tracker.Step7_Status = 'Error';
                        tracker.Step7_Message = 'Salesforce Account count not be Processed ';
                        tracker.Step7_icon = 'action:close';
                    }
                }
            }
        }
        return JSON.serialize(tracker);
    }
}