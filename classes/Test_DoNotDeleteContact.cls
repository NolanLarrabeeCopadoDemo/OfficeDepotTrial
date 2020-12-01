/**************************************************************
*Name           : Test_DoNotDeleteContact 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 11th April,2012
*Purpose        : To test DoNotDeleteContact
********************************************************************/
@isTest
public with sharing class Test_DoNotDeleteContact {
  @isTest 
  // Test Contact Deletion with Task
  static void TestContactDeletionWithTask(){
   Recordtype rec =[select id , name from recordtype where sobjecttype='contact'and name='Contact(US)'];
    Account account = Test_Utils.CreateAccount();
    Contact contact = Test_Utils.CreateContact(account.Id);
    contact.Phone= '7657876543';
      contact.recordtypeid=rec.id;
    update contact;
    
    // Create task and associate it with contact
    Task task = Test_Utils.GenerateBasicTask();
    insert task;
    task.WhoId = contact.Id;
    update task;
    
    // Try to delete Contact
    try{
      delete contact;
    }
    catch(Exception e){ 
system.debug('check catch');        
        system.debug('error msg--> ' + e.getStackTraceString());        
    }
    
    // Contact should not be deleted because we have associated Task with it
    List<Contact> contactList = [Select id From Contact Where id = :contact.Id];
    //System.assertEquals(contactList.size(), 1);         
  }
  
  @isTest 
  // Test Contact Deletion with Note 
  static void TestContactDeletionWithNote(){
        Recordtype rec =[select id , name from recordtype where sobjecttype='contact'and name='Contact(US)'];
    Account account = Test_Utils.CreateAccount();
    Contact contact = Test_Utils.CreateContact(account.Id);
      contact.recordtypeid=rec.id;
    update contact;
    // Create Note and associate it with Contact
    Note note = Test_Utils.CreateNote(contact);
    
    // Try to delete Contact
    try{
        delete contact;
    }
    catch(Exception e){         
    }
    
    // Contact should not be deleted because we have associated Note with it
    List<Contact> contactList = [Select id From Contact Where id = :contact.Id];
    //System.assertEquals(contactList.size(), 1);         
  }
  
  
  @isTest
  static void TestMailingStreetUpdate(){
       Recordtype rec =[select id , name from recordtype where sobjecttype='contact'and name='Contact(US)'];
     Account account = Test_Utils.CreateAccount(); 
     Contact contact = Test_Utils.CreateContact(account.Id); 
       contact.recordtypeid=rec.id;
    update contact;
     try {
     contact.mailingstreet = '6600 N Military Trail';
     contact.mailingstreet2__c = '6600 N Military Trail';
     update contact; }
     
     catch(System.NullPointerException e){  
        Return; }
  }
}