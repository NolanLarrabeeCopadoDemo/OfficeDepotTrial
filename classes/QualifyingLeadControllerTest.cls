/**
* @author Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date 15/1/2020
*
* 
* @description This class Test class for QualifyingLeadController class
*/
@IsTest
public with sharing class QualifyingLeadControllerTest {
     @testSetup static void setup() {
       List<User> userList = DataFactory.createUserTestRecords('Test', 1);
        //02716516 : Qualifying Lead Conversion
       Id QualifyingRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Qualifying Deal (US)').getRecordTypeId();  
       //List<Lead> TestLeads = DataFactory.createLeadTestRecords(userList[0].Id, 1, QualifyingRecordType, false);
       Account a1 = new Account(
                      Name = '12333'
                  );
                  insert a1;
        Lead l1 = new Lead(
                      FirstName ='Gen_Lead_First_Name_',
                      LastName ='Gen_Lead_Last_Name_',
                      Company = 'The Qualifying Company_',
                      Email = 'Qualifying'+'@Email.Com',
                      Phone = '1092837364',
                      RecordTypeId = QualifyingRecordType,
                      Estimated_Close_Date__c = System.today(),
                      OwnerId = UserInfo.getUserId(),
                      IsConverted = false,
                      Account__c = a1.Id);
                      insert l1;
       //INSERT TestLeads;

        Blob b = Blob.valueOf('Test Data');     
        Attachment attachment = new Attachment();
        attachment.ParentId = l1.Id; //parent id
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;        
        INSERT attachment;

        Note n = new Note();
        n.parentId=l1.Id; //parent id
        n.body='inserting note from code'; // body of the note. this should be populated from the notes field that you have shown in the screenshot
        n.title='New Note from code'; // the title of the note
        n.isPrivate=false;  // if private it will be visible only for the owner and any user with modify all permission
        INSERT n; //insert the record
    }

    @IsTest
    static void convertLeadTest(){
        List<Lead> lstLead = [Select id From Lead Limit 1];
        Test.startTest();
        Map<String,String> leadMap = QualifyingLeadController.convertQualifyingLead(lstLead[0].id);
        Test.stopTest();
        List<Lead> lstLeadVerify = [Select id, IsConverted From Lead Limit 1];
        System.assertEquals( 'Success',leadMap.get('Status'));
    }

}