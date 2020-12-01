public class EmailTemplateNotes {
public String body {get; set;}
 public String quoteids {get; set;} 
 
 public EmailTemplateNotes() {
   
}
    
    public String getEmailTemplateNote() {
        try{
        this.body = [Select Comment__c from QxQuote_Note__c Where QxQuote__c =:quoteids order by createddate desc limit 1].Comment__c; 
        }
        catch(Exception e){
            
        }
        return this.body;
    }
}