trigger CSA_Contact_Creation on Contact_Staging_Area__c (after insert) {

    Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
    
    Contact NC = New Contact(
            FirstName = Trigger.New[0].First_Name__c,
            LastName = Trigger.New[0].Last_Name__c,
            LeadSource = Trigger.New[0].Lead_Source__c,
            Status__c = 'Active',
            MobilePhone = Trigger.New[0].Mobile_Phone__c,
            Premium_Contact__C = true,
            Phone = Trigger.New[0].Phone__c,
            Email = Trigger.New[0].Primary_Email_Address__c,
            Title = Trigger.New[0].Title__c,
            Recordtypeid = ContactRecordTypeId,
            AccountID = Trigger.New[0].Account_ID__c
            );
   System.debug('&&&&&&&&&&&&&&&'+NC);         
    Insert NC;
    
system.debug(NC.id);

    List<Contact_Staging_Area__c > cS = [Select ID, Contact_Instance__c, Full_Name__c from Contact_Staging_Area__c Where ID = :Trigger.New[0].Id ];   
    List<Contact_Staging_Area__c > ucS = New List<Contact_Staging_Area__c >();
    
    For (Contact_Staging_Area__c fCS: cS)
        {
            fcS.Name = fcS.Full_Name__c;
            fcS.Contact_Instance__c = nC.ID;
            ucS.Add(fcS);
        }
    Update ucS;

}