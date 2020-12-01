/***
Description: Test class for 'GM_GPAccounts_Controler' apex controller
Created By: Subhrajyoti Chakraborty
Created Date: 27-Aug-2012

Modified By:
Modified Date:

Modify Reason:
**/

@isTest
public class GM_GPAccounts_Controler_TC
{
    //public String YTD_Sales_Diff;
    public static testMethod void GM_GPAccounts_Controler_TC() 
    {
    
        
         Set<String> setregion= new Set<String>();
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         //Profile p5 = [SELECT Id FROM profile WHERE name='System Administrator 2'];
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.officedepot.com',Region__c='West');
         insert u1;
         User u2 = new User();
         //LSLEVIN 2.10.16 S-376887 updated below lines employee id to include OD
         u2.alias = 'test1234'; u2.email='proxy1@proxy4567.officedepot.com';u2.emailencodingkey='UTF-8'; u2.lastname='test1234';u2.languagelocalekey='en_US';u2.localesidkey='en_US'; u2.OD_Employee_ID__c= 'xxyyOD222222';u2.profileid = p4.Id;u2.timezonesidkey='America/Los_Angeles';u2.username='proxy1@proxy4567.officedepot.com';u2.managerid=u1.id;
         insert u2;
         system.runas(u2)
         {
             
             Account acc= new Account();
             acc.name='Test_account';
             acc.GP_Id__c='12345678';
             acc.Last_Order_Date__c=System.today();            
             insert acc;
              
             AccountTeamMember atm= new AccountTeamMember();
             atm.userid=u1.id;
             atm.accountid=acc.id;
             insert atm;
             
             AccountTeamMember atm1= new AccountTeamMember();
             atm1.userid=u2.id;
             atm1.accountid=acc.id;
             insert atm1;
             
             //ApexPages.StandardController controller1=new ApexPages.StandardController(acc); 
             GM_GPAccounts_Controler report= new GM_GPAccounts_Controler();
             report.selectedRegion = 'West';
             //report.YTD_Sales_Diff='-123';
             report.getu_region();
             report.setu_region(setregion);
             //report.ReportData1();
             report.ReportData();
         }
        
      
     
        
       
        
        
    }

}