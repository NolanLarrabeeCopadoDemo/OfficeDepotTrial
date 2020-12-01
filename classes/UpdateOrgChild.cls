public class UpdateOrgChild{

    
    // Default Constructor
 public UpdateOrgChild()
    {
    }
// get all child records with Org values
 public void updateChild(List<Account> accounts){
 
 Map<Id,Id> OrgMap= new Map<Id,Id> ();
 List<Opportunity> custOpp = new  List<Opportunity>();
 List<Contact> custContact= new  List<Contact>();
 List<Contract> custContract= new  List<Contract>();
 List<Case> custCases= new  List<Case>();
 List<Task> custTask= new  List<Task>();
 List<Account_Profile__c> custAccProfile= new  List<Account_Profile__c>();
 List<Note> custNotes= new  List<Note>();
 List<Note> custNotesInsert= new  List<Note>();


 //get Org Records
      for(Account rec : accounts){
         if(rec.Org__C !=null)
         OrgMap.put(rec.Id, rec.Org__C);
      }
      if(OrgMap.size()>0){
      
      //get Opportunities
      custOpp =[select Id,org__C,accountId from Opportunity where accountId in : OrgMap.keyset()];
         for(Opportunity  rec :custOpp ){
           rec.org__C= OrgMap.get(rec.AccounTId);
         }
         if(custOpp .size()>0)
         update custOpp ;
         
        //get Contacts
        custContact =[select Id,org__C,accountId from Contact where accountId in : OrgMap.keyset()];
         for(Contact rec :custContact){
           rec.org__C= OrgMap.get(rec.AccounTId);
         }
         if(custContact.size()>0)
         update custContact;
         
         
        //get Cases
        custCases =[select Id,org__C,accountId from Case where accountId in : OrgMap.keyset()];
         for(Case rec :custCases){
           rec.org__C= OrgMap.get(rec.AccounTId);
         }
         if(custCases.size()>0)
         update custCases;

         
         
        //get Contracts
        custContract =[select Id,org__C,accountId from Contract where accountId in : OrgMap.keyset()];
         for(Contract rec :custContract){
           rec.org__C= OrgMap.get(rec.AccounTId);
         }
         if(custContract.size()>0)
         update custContract;

        //get Tasks
        custTask =[select Id,org__C,whatId from Task where whatId  in : OrgMap.keyset()];
         for(Task rec :custTask ){
           rec.org__C= OrgMap.get(rec.whatId);
         }
         if(custTask .size()>0)
         update custTask ;
         
         
        //get Account Profile
        custAccProfile =[select Id,org__C,Account__c from Account_Profile__c where Account__c in : OrgMap.keyset()];
         for(Account_Profile__c rec :custAccProfile){
           rec.org__C= OrgMap.get(rec.Account__c);
         }
         if(custAccProfile.size()>0)
         update custAccProfile;

                //get Notes
        /*custNotes=[select Id,ParentId,title,body,isPrivate from Note where ParentId in : OrgMap.keyset()];
         for(Note rec :custNotes){
            Note newRec= new Note();
            newRec.body=rec.Body;
            newRec.title=rec.Title;
            newRec.isPrivate =rec.isPrivate;
            newRec.ParentId= OrgMap.get(rec.ParentId);
            custNotesInsert.add(newRec);
            
         }
           if(custNotesInsert.size()>0)
           insert custNotesInsert;
           */

      }
      
      
 }
}