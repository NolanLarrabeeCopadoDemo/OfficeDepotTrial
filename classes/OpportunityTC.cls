@isTest

public class OpportunityTC
{
    public integer owned{get;set;}
    public integer teamed{get;set;}
    public integer total{get;set;}
    public String stageName {get; set;}
    
     static testMethod void oppTest()
    { 
        Account acc = new Account();
        acc.name='test';
        insert acc;
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1;
        
        Stage_to_Summary_Stage__c sum= new Stage_to_Summary_Stage__c( Stage__c='Identify Prospect (1.1)',Summary_Stage_Name__c ='Test');
        insert sum;
        
                Stage_to_Summary_Stage__c sum1= new Stage_to_Summary_Stage__c( Stage__c='Identify Prospect (1.1)',Summary_Stage_Name__c ='Test1');
        insert sum1;

       
        Opportunity opp = new opportunity();
        opp.accountid=  acc.id;
        opp.Name='Testopp';
        opp.product__c = 'K-12 Growth';
        opp.StageName='90%-Execute';
        opp.CloseDate=System.today();
        opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
        opp.Watson_Door_Opener__c=true;
        opp.amount=123.45;
        opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
        opp.Product_Subtype__c='Other Equipment';
        opp.ownerId=u1.id;          
        opp.Watson_Notes__C='My text';
        insert opp;
        
        opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.1)';
        update opp;
        
        }
        }