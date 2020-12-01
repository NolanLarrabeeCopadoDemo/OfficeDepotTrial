/***
Description: To implement serializable implementation of the batch classes Account_Sectorchange_onsite_Batch & Account_addresschange_Batch

This single class implemnets both interfaces Batchable and Schedulable.


Created By: Ankur Pradhan
Created Date: 07-May-2012

Modifed by: Sunil Bansal
Modified Date: 21-May-2012

Modify Reason: To initiate Account Assignment batch job with some specific subject of email and not via shceduler at some specific time.
Removed earlier code of other batch job scheduling as that is not required.


**/
global class EmailServiceHandler implements Messaging.InboundEmailHandler 
{
        
        global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) 
        {
           if (email.subject== 'Start Account Assignment Job')
           {

                String strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                                    +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                                    +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                                    +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                                    +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                                    +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                                    +' from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%0\' OR Name Like \'%1\' OR Name Like \'%2\')';
                AccountAssignments_Batch assignBatch1 = new AccountAssignments_Batch(strQuery);
                if(!test.isrunningtest())
                {
                    database.executebatch(assignBatch1, 500);
                }
        
                strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                                    +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                                    +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                                    +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                                    +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                                    +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                                    +' from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%3\' OR Name Like \'%4\' OR Name Like \'%5\')';
                AccountAssignments_Batch assignBatch2 = new AccountAssignments_Batch(strQuery);
                if(!test.isrunningtest())
                {
                    database.executebatch(assignBatch2, 500);
                }
                strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                                    +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                                    +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                                    +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                                    +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                                    +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                                    +' from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%6\' OR Name Like \'%7\')';
                AccountAssignments_Batch assignBatch3 = new AccountAssignments_Batch(strQuery);
                if(!test.isrunningtest())
                {
                    database.executebatch(assignBatch3, 500);
                }
                strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                                    +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                                    +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                                    +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                                    +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                                    +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                                    +' from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%8\' OR Name Like \'%9\')';
                AccountAssignments_Batch assignBatch4 = new AccountAssignments_Batch(strQuery);
              if(!test.isrunningtest())
              {
                database.executebatch(assignBatch4, 500);
              }

           }
            
           Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
           return result;
        }
}