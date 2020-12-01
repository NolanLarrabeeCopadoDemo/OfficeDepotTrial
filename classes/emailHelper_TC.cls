@isTest

private class emailHelper_TC
{    
    static testMethod void  emailHelper_TC(){
        ID tempId;
        
        List<EmailTemplate> temp = new List<EmailTemplate>();
        temp =  [Select Id, Name, IsActive, Folder.Name From EmailTemplate Where IsActive = true limit 1];
        
        for(EmailTemplate e: temp){
           tempId = e.id;
        }
        
        Contact con = new Contact();
        //con.Id= '12345678';
        con.Email= 'test1@gmail.com';
        con.Override_Duplicate_Check__c = true;
        con.LastName = 'Test2';
        con.FirstName = 'Test1';
        insert con;
        
        Account Acc = new Account(
            name = 'Test Account'
        );
        insert acc;
        
        
        
        //system.debug(+con);
        emailHelper.sendEmail(con.id,acc.id,con.Email,tempId,con.Email);
    }
}