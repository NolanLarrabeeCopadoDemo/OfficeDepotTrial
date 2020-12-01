@isTest
private class userKeyUpdate_TC
{
    static testMethod void testuserKeyUpdate ()
    {
        Profile p4 = [select id from profile where name='System Administrator' limit 1];
        //User us1 = new User(alias = '11_usr ', email='1proxy12@proxy456.officedepot.com',OD_Employee_ID__c='113659',emailencodingkey=null, lastname='11test223',languagelocalekey='en_US',localesidkey='en_US', profileid = null,timezonesidkey=null,username='11proxy@proxy457.com');
        //insert us1;
        User us2 = new User(alias = '12_usr ', email='111proxy12@proxy457.officedepot.com',OD_Employee_ID__c='113859',emailencodingkey='UTF-8', lastname='22test223',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='211proxy@proxy457.com');
        us2.firstname='testfirst';
        us2.lastname='testlast';
        us2.street='6600 BOCA';
        us2.Alternate_Email__c ='111proxy12@proxy456.officedepot.com';
        us2.city='BOCA';
        us2.PostalCode='33496';
                         
        insert us2;
        System.debug('User@@@!!!'+us2);
     
        User us3 = new User(alias = '3_usr ', email='222proxy@proxy456.officedepot.com',OD_Employee_ID__c='998876',emailencodingkey='UTF-8', lastname='333test333',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='311proxy@proxy458.com');
        us3.firstname='first';
        us3.lastname='last';
    
        insert us3;
        System.debug('User@@@!!!'+us3);
    
        us3.managerid=us2.id;
        update us3;
     
        User us4 = new User(email='444proxy@proxy456.officedepot.com',OD_Employee_ID__c='113759',emailencodingkey='UTF-8', lastname='444test444',languagelocalekey='en_US',localesidkey='en_US', timezonesidkey='America/Los_Angeles',username='444proxy@proxy458.com');
        us4.firstname='first4';
        us4.lastname='last4';
        us4.CommunityNickname='';
        
        insert us4;
        System.debug('User@@@!!!'+us4);
    
        User us5 = new User(email='544proxy@proxy456.officedepot.com',OD_Employee_ID__c='113760',emailencodingkey='UTF-8', lastname='544test444',languagelocalekey='en_US',localesidkey='en_US', timezonesidkey='America/Los_Angeles',username='544proxy@proxy458.com');
        us5.firstname='first5';
        us5.lastname='last5';
        us5.CommunityNickname='';
        us5.title='USCOR:CWR013:CWR';
        us5.TimeZoneSidKey = '';
        us5.EmailEncodingKey = '';
        
        try{
            insert us5;
            System.debug('User@@@!!!'+us5);
        }
        catch(Exception e)
        {
            System.debug('UserError@@@!!!'+e);
        }
        
        Profile chatterP = [select id from profile where name='Chatter Free User' limit 1];     
        us3.profileid = chatterP.Id;
        update us3; 
     }
}