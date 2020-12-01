public class LeadClose

{        
        //public Lead currentLead {get;set;}
        //public String strName {get;set;}
        //public String strLastName {get;set;}
        public String strCompany {get;set;}
        public String strAdd1{get;set;}
        public String strAdd2{get;set;}
        public String strZip {get;set;}
        public String strState {get;set;}
        public String strLeadSource {get;set;}
        //public Boolean matchingLeadsFound {get; set;}
        public List<Lead> lstDuplicateLeads = new List<Lead>();
     

         //==============================================================================//
        // Get matching lead list
       //==============================================================================//
        
        public void searchLeads(List<Lead> leads)
        {
         Id LeadId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (US)').getRecordTypeId();
         System.debug('&&&&&&&&&&&&&Insidemethod'+leads);
         string status='Open';
         string status1 = 'Contacted';
        
          for( Lead leadrec: Leads){
          
          
          System.debug('&&&&&&&&&&&&&Inside');
          
            String strQuery = 'Select Id, Name,recordtype.name, LastName,Address1__c,Address2__c,LeadSource, Account__c, Account__r.Id, Account__r.Name, Status, Company, EMail, Phone, Zip__c, City__c, State__c, OwnerId from Lead where recordtypeid=:LeadId and (status =:status or status =:status1) and createddate=last_n_days:30 and ';
            String orClause = '';
            String andClause = '';
            String whereClause = '';
               
              strCompany=leadrec.Company;
              strState=leadrec.State__c;
              strLeadSource= leadrec.LeadSource;
              strAdd1=leadrec.address1__c;
              strAdd2=leadrec.address2__c;
              strZip=leadrec.zip__c;
              strLeadSource=leadrec.leadsource;
            
            if(strCompany != null && strCompany.trim() != '')
               {  
                orClause = orCondition(orClause, 'Company', strCompany);           
               }            
                
            if( strAdd1 != null && strAdd1.trim() != '')
            {                   
                   orClause = orCondition(orClause, 'Address1__C', strAdd1); 
            }
            
            
            if( strAdd2 != null && strAdd2.trim() != '')
            {
                orClause = orCondition(orClause, 'Address2__C', strAdd2); 
                   
            }
                                  
            if(strZip != null && strZip.trim() != ''){
               orClause = orCondition(orClause, 'Zip__c', strZip); 
             }   

            if(strState != null && strState.trim() != ''){
              orClause = orCondition(orClause, 'State__c ', strState); 
            }
            
             
            if(orClause != '')
            {
          
                strQuery = strQuery + orClause + ' order by createddate asc LIMIT 100';
                
               System.debug('MY LEAD WHERE CLAUSE == '+strQuery);
               lstDuplicateLeads = Database.query(strQuery);
               System.debug('MY Lead LIST SIZE == '+lstDuplicateLeads.size());
               System.debug('MY Query == '+strQuery);
                
                if(lstDuplicateLeads.size() > 0 ){
                
                String testLead;
              
                   testlead= '<a href="https://officedepot--uat.cs7.my.salesforce.com/'+lstDuplicateLeads[0].Id+'">'+lstDuplicateLeads[0].Company+'</a>';
              
                
                System.debug('&&&&&leadhere6'+lstDuplicateLeads);
                    //Closing logic as per case#...., duplicate leads should not be closed.
                    
                    //leadrec.status='Closed';
                     leadrec.sub_status__c = 'Lead Duplicate';
                     //leadrec.Closed_Date__c = system.today();
                     //leadrec.Close_Reason__c = 'Current Customer';
                     leadrec.ownerId=lstDuplicateLeads[0].OwnerId;
                     leadrec.Lead_Duplicates__c=testlead;
                     System.debug('&&&&&leadhere7'+lstDuplicateLeads);
                 }    
            }
            
 } 



}


        private String orCondition(String orClause, String fieldName, String fieldValue)
        {
                String retValue = '';
                if(orClause != '')
                    retValue = orClause + ' AND ' + fieldName + ' = \'' + String.escapeSingleQuotes(fieldValue.trim()) + '\'';
                else
                    retValue = fieldName + ' = \'' + String.escapeSingleQuotes(fieldValue.trim()) + '\'';
                return retValue;
        }

    


}