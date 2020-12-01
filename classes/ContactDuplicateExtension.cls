public class ContactDuplicateExtension {
    public List<ContactWrapper> duplicateList {get; set;}
    
    public ContactDuplicateExtension(ApexPages.StandardController controller) {
        Id currentContactId = ApexPages.currentPage().getParameters().get('id');
        Contact currentContact = [SELECT Duplicate_Of__c FROM Contact WHERE Id = :currentContactId];
        List<Contact> duplicates = new List<Contact>();
        
        if (currentContact.Duplicate_Of__c != null) {
            duplicates = [SELECT Id, Name, Phone, Email, Master_Duplicate__c
                          FROM Contact
                          WHERE Duplicate_Of__c = :currentContact.Duplicate_Of__c
                          AND Id != :currentContact.Id
                          ORDER BY Master_Duplicate__c DESC];
                          
            // Get activity counts for duplicate contacts
            List<Id> dupContactIds = new List<Id>();
            
            for (Contact c : duplicates) {
               dupContactIds.add(c.id); 
            }
    
            // agf.ADM_DeletedTaskScheduledJob
            List<AggregateResult> taskCount = [SELECT WhoId, COUNT(Id) TaskCount FROM Task WHERE WhoId IN :dupContactIds GROUP BY WhoId];
            Map<String, Integer> taskCountMap = new Map<String, Integer>();
            
            for (AggregateResult ar : taskCount) {
                taskCountMap.put((String) ar.get('WhoId'), (Integer) ar.get('TaskCount'));
            }
            
            // Events
            List<AggregateResult> eventCount = [SELECT WhoId, COUNT(Id) EventCount FROM Event WHERE WhoId IN :dupContactIds GROUP BY WhoId];
            Map<String, Integer> eventCountMap = new Map<String, Integer>();
            
            for (AggregateResult ar : eventCount){
                eventCountMap.put((String) ar.get('WhoId'), (Integer) ar.get('EventCount'));
            } 
            
            // Add activities for Contacts and create wrapper
            duplicateList = new List<ContactWrapper>();
            
            for (Contact c : duplicates) {
                ContactWrapper aw = new ContactWrapper();
                aw.contactId = c.Id;
                aw.name = c.Name;
                aw.phone = c.Phone;
                aw.email = c.Email;
                aw.masterDuplicate = c.Master_Duplicate__c;
                
                integer tasks = 0;
                integer events = 0;
                
                if (taskCountMap.get(c.Id) != null) {
                    tasks = taskCountMap.get(c.Id);
                }
                
                if (eventCountMap.get(c.Id) != null) {
                    events = eventCountMap.get(c.Id);
                }
                
                aw.activities = tasks + events;
                duplicateList.add(aw);
            }
        }
    }
    
    public class ContactWrapper {
        
        public Id contactId {get;set;}
        public String name {get;set;}
        public String phone {get;set;}
        public String email {get;set;}
        public String masterDuplicate {get;set;}
        public Integer activities {get;set;}
    } 
}