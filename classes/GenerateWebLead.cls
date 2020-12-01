public class GenerateWebLead{
    private final Lead Lead{get;set;}
    String WCBcount;
    Boolean flag=false;
    
    public GenerateWebLead(ApexPages.StandardController stdController) {
        this.Lead = (Lead)stdController.getRecord();
        lead.product__C='';
        lead.Lead_Source__c='Store Lead';
    }

    public Lead getLead(){
        return Lead;
    }

    public String getWCBcount(){
        return WCBcount;
    }

    public void setWCBcount(String WCBcount){
        this.WCBcount=WCBcount;
    }


    public Pagereference Save(){
        if(lead.email==null && lead.phone==null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please enter email or phone .');
            ApexPages.addMessage(myMsg);
            return null;
        }

        else{
            List<string> wcb= new List<string>();
            String workerCount;
            if(WCBcount.contains('-')){
                wcb=WCBcount.split('-');
                workerCount=wcb[0];
            }
            if(WCBcount.contains('+')){
                wcb=WCBcount.split('\\+');
                // wcb=WCBcount.split('+');
                workerCount=wcb[0];
            }
            if(workerCount!='' && workerCount!=null)
                lead.WCW_Count__c=integer.valueof(workerCount);
            lead.LeadSource=lead.lead_source__C;
            if(lead.LeadSource=='Store Lead'   && lead.Chamber_of_Commerce_Member__c=='Yes'){
                lead.Assigned__c=false;
                lead.ownerid=System.Label.Salesforce_User;
            }
            //Modified By Vipul for Story #S-445693(00802435 - BP Enhancement - Digital Lead Form) on October 26, 2016
            //START
            if(lead.LeadSource == 'Business Pro' ){
                Store__c store = [Select OwnerId,Owner.Profile.Name ,Owner.IsActive ,Id From Store__c Where Id=:lead.Store__c ];
                Id BusinessProId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Business Pro)').getRecordTypeId();
                lead.recordtypeid=BusinessProId;
                if(store.Owner.IsActive==true && store.Owner.Profile.Name =='Business Pro Rep'){
                    lead.ownerid= store.OwnerId;
                    flag = true;
                }
                else{
                    lead.ownerid=System.Label.Business_Pro_Default_Owner;
                    flag = true;
                }
            }
            //END - Vipul
            // Start Case 01265588
            if(lead.LeadSource == 'FOS') {
                Id BusinessProId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Business Pro)').getRecordTypeId();
                lead.recordtypeid=BusinessProId;
                lead.ownerid = [Select id From User Where Name =: System.Label.FOS_Lead_Owner limit 1].Id;
                flag = true;
            }
            // End Case 01265588
            try{
                insert lead;
                //Modified By Vipul for Story #S-445693(00802435 - BP Enhancement - Digital Lead Form) on October 26, 2016
                if(flag){
                    Lead newLead = [Select Id, Owner.Id,Owner.Email, Owner.IsActive, Owner.Name from Lead Where id=:lead.id];
                    if(newLead.Owner.IsActive==true){
                        EmailTemplate setEmailTemp = [Select Id, Name from EmailTemplate Where Name='Lead Assignment Template'];
                        List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> toAddresses = new List<String>();
                        toAddresses.add(newLead.owner.email);
                        mail.setToAddresses(toAddresses);
                        mail.setTemplateId(setEmailTemp.Id);
                        mail.setTargetObjectId(newLead.Id);
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.saveAsActivity = false;
                        mails.add(mail);
                        if(mails.size()>0)
                            Messaging.sendEmail(mails);
                    }
                }//END -Vipul
            }
            catch(Exception ex){
                ApexPages.addMessages(ex);
                return null;
            }

          //  PageReference pageRef = new PageReference('http://officedepot-officemax.force.com/GenerateWebLead/ThankYouPage');
            PageReference pageRef = new PageReference(System.Label.webLeadThankYouUrl);
            return pageRef ;
        }
    }
}