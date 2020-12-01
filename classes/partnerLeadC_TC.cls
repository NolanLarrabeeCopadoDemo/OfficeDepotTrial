@isTest
public class partnerLeadC_TC {
    
   static testMethod void partnerLeadcTest() {
      //partnerLeadC p = new partnerLeadC();
     partnerLeadC.initLead('123456','test');
     lead so = new lead();
      partnerLeadC.getPicklistValues(so, 'state__c');
      partnerLeadC.saveLead(so);
       
      partnerLeadC.googleCred();
      partnerLeadC.facebookCred();
      partnerLeadC.linkedinCred();
      //Added by Aravind
      id RecordtypeId;
      for(recordtype r: [select id from recordtype where name = 'Potential Partner Events'])
      {
          event e = new event(subject = 'sample', location ='sample', StartDateTime = datetime.now(), enddatetime=datetime.now(), Profile_Name__c='sample', recordtypeid = r.id);
          insert e;
      }
      partnerLeadC.getEvents();
       //Addtion ends
       
   } 
    
    
}