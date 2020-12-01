public class AceCustomerResponseLoad {

    public PageReference AddAttachments() 
    {
        System.debug('List of attachments:' + lAttachment);
        lAttachment.add(Attachment );
        attachment = new Attachment();
        return null;
    }


public ID PriceChangesCustomerID {get;set;}
public ACE_Customer_Price_Changes__c custPriceOb {get;set;}
Public boolean pageAccessAllowed {get;set;}
public String responseSelection {get;set;}
public PageReference pref {get;set;}
public String notificationDate {get;set;}
public class custException extends Exception{}
public List<Attachment> lAttachment{get;set;}


public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }

  

public AceCustomerResponseLoad() 
{
  lAttachment = new List<Attachment>();
 
  
  system.debug ('Inside Constructor AceCustomerResponseLoad');
  PriceChangesCustomerID = ApexPages.currentPage().getParameters().get('pchangeid');
  custPriceOb  = [select id,Customer_Notification_Date_Approved__c,SFDC_Notification_Flag__c,Customer_Response__c from ACE_Customer_Price_Changes__c where id = :PriceChangesCustomerID];
  pref = new PageReference('/' + PriceChangesCustomerID);
  
  if ('3'.equals(custPriceob.SFDC_Notification_Flag__c))
    pageAccessAllowed = true;
    
  if (custPriceOb.Customer_Notification_Date_Approved__c != null)
     notificationDate = custPriceOb.Customer_Notification_Date_Approved__c.format();
  
}

public PageReference attachForApproval() 
{
   try{
    
    
   /* if ('Approved'.equals(responseSelection) && attachment.Body == null)
      throw new custException('Customer Approval Is Required,Please Attach The Customer Approval.');
    
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = PriceChangesCustomerID; 
    attachment.IsPrivate = true;
    
    if (attachment.body != null)
      insert attachment;  
   */ 
   
    if ('Approved'.equals(responseSelection) && lAttachment.size() < 1)
      throw new custException('Customer Approval Is Required,Please Attach The Customer Approval.');
    
    
    for(Attachment atch : lAttachment)
    {
        atch.OwnerId = UserInfo.getUserId();
        atch.ParentId = PriceChangesCustomerID; 
        atch.IsPrivate = true;
    }
    //if (attachment.body != null)
    //  insert attachment; 
   
   insert lAttachment;
       
    custPriceOb.Customer_Response__c = responseSelection;
    
    update custPriceOb;
    
    // TODO Call Approval Process
  
    return pref;
   }
  catch(custException ce) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ce.getMessage()));
    return null;
  }
  catch(Exception e) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
    return null;
  }
}

public PageReference cancel() {

  return pref;
}


 public list<SelectOption> getCustomerReponseOptions (){
 
         list<SelectOption> responses = new list<SelectOption>();
         responses.add(new SelectOption('Approved','The customer has accepted the price increases '));
         responses.add(new SelectOption('Rejected','The customer has disputed the price increases'));

         return responses;
     }

}