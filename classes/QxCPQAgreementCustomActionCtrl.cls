global with sharing  class QxCPQAgreementCustomActionCtrl {
    public PROS_Agreement__c a { get; set; }
    public String ERROR_MSG { get; set; }   
    
    private final static String NO_MSG = ''; 
    private final static String MSG_ERROR_DATES = 'Start Date cannot be in the past must be prior to End Date';
    private final static String MSG_ERROR_ACTIVE = 'Cannot publish a non-active agreement';
    public QxCPQAgreementCustomActionCtrl(ApexPages.StandardController stdController){
        Id agreementId = ((PROS_Agreement__c)stdController.getRecord()).Id;
        this.a = [SELECT Id, Name, Start_Date__c,End_Date__c,Active__c,Quote__c FROM PROS_Agreement__c WHERE Id =: agreementId][0];      
        this.ERROR_MSG = NO_MSG;
        
        if (this.a.Start_Date__c == null){
            this.a.Start_Date__c = Date.today();
        }
        
        if (this.a.End_Date__c == null){
            this.a.End_Date__c = Date.today().addYears(1);
        }
    }
    
    public QxCPQAgreementCustomActionCtrl(){
        
    }
    
     public PageReference publishAction(){
         PageReference returnPage = null;
         //Validate Agreement Start & End Date
         if(this.a.Active__c){
             if(this.a.Start_Date__c != null && this.a.End_Date__c != null && this.a.Start_Date__c >= Date.today() && this.a.Start_Date__c < this.a.End_Date__c ){
                 Id masterQuoteId = this.a.Quote__c;
                 List<CameleonCPQ__QxQuote__c> quotes =[SELECT id,Name,Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE id =: masterQuoteId];
                 if(quotes.size()>0){
                     quotes[0].PROSAgreement__Quote_Type__c = 'Initial';
                     quotes[0].PROSAgreement__AgreementStatus__c = 'PendingPublish';
                     quotes[0].PROSAgreement__StartDate__c =  DateTime.newInstance(this.a.Start_Date__c.year() ,this.a.Start_Date__c.month() ,this.a.Start_Date__c.day(),0,0,0).format('yyyy-MM-dd') ;
                     quotes[0].PROSAgreement__EndDate__c = DateTime.newInstance(this.a.End_Date__c.year() ,this.a.End_Date__c.month() ,this.a.End_Date__c.day(),0,0,0).format('yyyy-MM-dd'); 
                     quotes[0].Core_Id__c='CL-2000239-000';
                     
                     update this.a;
                     update quotes[0];
                 }
                 returnPage = backtoQuote();
             }else{
                 this.ERROR_MSG = MSG_ERROR_DATES;
             }   
         }else{
             this.ERROR_MSG = MSG_ERROR_ACTIVE;
         }

         return returnPage;
     }
    
    public pageReference backtoQuote(){
        PageReference pageRef = new PageReference('/'+this.a.id  + '?core.apexpages.devmode.url=1' ); 
        pageRef.setRedirect(true); 
        return pageRef; 
    }
}