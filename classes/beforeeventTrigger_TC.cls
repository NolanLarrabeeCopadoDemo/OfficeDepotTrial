@isTest

private class beforeeventTrigger_TC
{
     static testMethod void oppTest()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
        system.runAs(u1){
            
            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            opp.product__c = 'K-12 Growth';
            opp.StageName='90%-Execute';
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
           // opp.Summary_Stage__c='Identify Prospect (1.0)';
            opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            opp.Product_Subtype__c='Other Equipment';
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            insert opp;
            
            
           /*FiscalYearSettings FY = new FiscalYearSettings();
            FY.name='2016';
           insert FY;
            
            Period PR = new Period();
            PR.Number=12345;
           // PR.FiscalYearSettingsId=FY.id;
            PR.Type='Week';
            PR.StartDate=system.today();
            PR.EndDate=system.today();
            insert PR;*/
            Event ev = new event();
            EV.DurationInMinutes=1440;
            ev.ActivityDateTime=DateTime.newInstanceGMT(2016,7, 5, 2, 2, 3);
            ev.Appointment_FiscalMonth__C ='07';
            ev.ownerId=u1.id;
            ev.Whatid=opp.id;
            ev.Subject='Other';
            ev.StartDateTime=DateTime.newInstanceGMT(2016,7, 5, 2, 2, 3);
            ev.EndDateTime = DateTime.newInstanceGMT(2016,7,6, 2, 2, 3);
            ev.Task_Type__c='Mail';
            ev.Call_Disposition__c='Meeting';
            insert ev;
        }
        }
     }