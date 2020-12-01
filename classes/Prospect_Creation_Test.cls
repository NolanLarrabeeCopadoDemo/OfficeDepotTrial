@isTest
private class Prospect_Creation_Test  {
  static testMethod void Test_Info(){
      profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      
      //LSLEVIN 2.10.16 S-376887 Updated below lines employee id to include OD
      user usr1 = new User(Alias = 'Standar', Email='standarduser@officedepot.com', OD_Employee_ID__c = 'xxOD111111',                           
                        EmailEncodingKey='UTF-8', LastName='Dataloader', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                        ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standardusr@officedepot.com');
      insert usr1;
      system.runas(usr1){
        Prospect_Staging_Area__c tNA = New Prospect_Staging_Area__c(
            Name = 'Test 27',
            Address_1__c = '2700 SW 27th st',
            Address_2__c = 'Suite 27',
            City__c = 'Jupiter',
            State__c = 'Fl',
            Zip__c = '33469',
            Source__c = 'DNB Healthcare',
            Duns_Enrichment__c = '270000270',
            Phone__c = '2702702700',
            WCW__c = 27,
            Auto_Assign__c = true,
            Type__c = 'GPO 27',
            Parent_Company_Name__c = 'My Company Name, 27',
            GPO__c = 'GPO 1st',
            GPO_Relationship__c = 'Pricing Group #1',
            Number_of_Beds__c = 27,
            ACO__c = 'ACO 27'
            );
      
    Insert tNA;
      
        Prospect_Staging_Area__c tNA2 = New Prospect_Staging_Area__c(
            Name = 'Test 27 1',
            Address_1__c = '2701 SW 27th st',
            Address_2__c = 'Suite 27',
            City__c = 'Jupiter',
            State__c = 'Fl',
            Zip__c = '33469',
            Source__c = 'Dnb Acquisition',
            Duns_Enrichment__c = '270000271',
            Phone__c = '2702702700',
            WCW__c = 527,
            Auto_Assign__c = false,
            Owner_Employee_ID__c = '111111',
            User_Owner__c = usr1.id,
            Type__c = 'GPO 27 1',
            Parent_Company_Name__c = 'My Company Name, 27 1',
            GPO__c = 'GPO 2nd',
            GPO_Relationship__c = 'Pricing Group #2',
            Number_of_Beds__c = 27,
            ACO__c = 'ACO 27 1'
            );
      
    Insert tNA2;   
        Contact_Staging_Area__c tCA = New Contact_Staging_Area__c(
            Name = 'Test 27',
            Phone__c = '2702702700',
            DUNS_Enrichment__c = '270000270',
            First_Name__c = 'Test Contact',
            Last_Name__c = '27',
            Lead_Source__c = 'Test Class 27',
            Middle_Name__c = 'None',
            Mobile_Phone__c = '2702702700',
            MRC_Code__c = 'A27A',
            Primary_Email_Address__c = '273@gmail.com',
            Title__c = 'Associate',
            Type__c = 'Stage Test' 
            );
    Insert tCA; 
           
    List<Prospect_Staging_Area__c> pS = [Select ID, Account_Profile_Instance__c, Prospect_Instance__c from Prospect_Staging_Area__c Where ID = :tNA.Id ];   
    
    For (Prospect_Staging_Area__c fPS: pS)
        {
            System.Debug(fps.id);
            System.Debug(fps.Account_Profile_Instance__c);
            System.Debug(fps.Prospect_Instance__c);
        }
            
    List<Contact_Staging_Area__c> cS = [Select ID, Name, Contact_Instance__c, Staging_Area_Prospect__c, Account_ID__c from Contact_Staging_Area__c Where ID = :tCA.Id ];   
    
    For (Contact_Staging_Area__c fcS: cS)
        {
            System.Debug(fcs.id);
            System.Debug(fcs.Contact_Instance__c);
            System.Debug(fcs.Staging_Area_Prospect__c);
            System.Debug(fcs.Account_ID__c);
            System.Debug(fcs.Name);
        }            
      
  } 
  }
}