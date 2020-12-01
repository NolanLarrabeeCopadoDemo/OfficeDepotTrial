public class LeadStagingUtil {
    public static Task createTask(LeadStaging__c ls) {
        Task newTask = new Task();
        String subjectString = 'Duplicate Lead received: ' + ls.last_name__c;

        if (ls.First_Name__c != null) {
            subjectString += ' ,' + ls.First_Name__c;
        }
        if (ls.Company__C != null) {
            subjectString += ' ,' + ls.Company__c;
        }
        newTask.Subject = subjectString;
        newTask.Description = 'Duplicate Lead received based on email, provided information :';
        if (ls.first_name__c != null) {
            newTask.Description += 'First Name: ' + ls.first_name__c + ' ';
        }
        if (ls.last_name__c != null) {
            newTask.Description += 'Last Name: ' + ls.last_name__c + ' ';
        }

        if (ls.email__c != null) {
            newTask.Description += 'Email: ' + ls.email__c + ' ';
        }

        if (ls.company__c != null) {
            newTask.Description += 'Company: ' + ls.company__c + ' ';
        }
        if (ls.address1__c != null) {
            newTask.Description += 'Address Line 1: ' + ls.address1__c + ' ';
        }
        if (ls.address2__c != null) {
            newTask.Description += 'Address Line 2: ' + ls.address2__c + ' ';
        }
        if (ls.city__c != null) {
            newTask.Description += 'City: ' + ls.city__c + ' ';
        }
        if (ls.state__c != null) {
            newTask.Description += 'State: ' + ls.state__c + ' ';
        }
        if (ls.zip__c != null) {
            newTask.Description += 'Zip: ' + ls.zip__c + ' ';
        }
        if (ls.phone__c != null) {
            newTask.Description += 'Phone: ' + ls.phone__c + ' ';
        }
        if (ls.Product__c != null) {
            newTask.Description += 'Products provided for lead: ' + ls.Product__c + ' ';
        }
        if (ls.additional_Info__c != null) {
            newTask.Description += 'Additional Infomation: ' + ls.additional_Info__c + ' ';
        }
        if (ls.URL_Reference__c != null) {
            newTask.Description += 'URL ' + ls.URL_Reference__c + ' ';
        }
        if(ls.Marketing_Opt_In__c != null) {
            newTask.Description += 'Marketing Opt In: ' + ls.Marketing_Opt_In__c + ' '; 
        }
        if(ls.Contact_Timeframe__c != null) {
            newTask.Description += 'Contact Timeframe: ' + ls.Contact_Timeframe__c;
        }

        newTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('BizBox').getRecordTypeId();

        return newTask;
    }

}