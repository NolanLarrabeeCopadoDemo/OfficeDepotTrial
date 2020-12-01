/*
Description: To check if a lead is potential duplicate and flag that on Lead record. 
            Test coverage of this class is covered from DuplicateLeadsExtension_TC apex test class, and also may be from other classes.
Created By: Sunil Bansal
Created Date: 20-Nov-2012

Modified By:
Modified Date:
Modify Reason:

*/
public with sharing class DuplicateLeadPotential 
{

        public Lead currentLead {get;set;}
        public List<Lead> duplicateLeads = new List<Lead>();
        
        public DuplicateLeadPotential()
        {
        }
        
        private String orCondition(String orClause, String fieldName, Set<String> valueSet)
        {
            System.debug('SET VALUE === '+valueSet);
            String retValue = '';
            String fieldValue = '';
            for(String str: valueSet)
            {
                System.debug('STR VALUE BEFORE == '+str);
                str = String.escapeSingleQuotes(str);
                System.debug('STR VALUE AFTER == '+str);
                fieldValue = fieldValue + ',\''+ str +'\'';
                
            }
            
            fieldValue = fieldValue.subString(1);
            if(orClause != '') {
                    retValue = orClause + ' OR ' + '(' +fieldName + ' IN (' + fieldValue + ') AND '+fieldName + ' != NULL )' ;
                    //retValue = orClause + ' OR ' + '(' +fieldName + ' IN (' + fieldValue + '))' ;
            }
            else
                    retValue = '(' +fieldName + ' IN (' + fieldValue + ') AND '+fieldName + ' != NULL )' ;

            System.debug('RETURN FIELD VALUE === '+retValue);
            return retValue; 
        }
/*      // not used at the moment      
        private String andCondition(String andClause, String fieldName, String fieldValue)
        {
                String retValue = '';
                if(andClause != '')
                        retValue = andClause + ' AND ' + fieldName + ' = \'' + fieldValue.trim() + '\'';
                else
                        retValue = fieldName + ' = \'' + fieldValue.trim() + '\'';
                
                return retValue;
        }
*/      
        public List<Lead> getMatchingLeads(Set<String> nameSet, Set<String> companySet, Set<String> emailSet, Set<String> phoneSet, Set<String> zipSet, Set<String> stateSet)
        {
                String strQuery = 'Select Id, Name, LastName, Account__c, Status, Company, Email, Phone, Zip__c, State__c from Lead where ';
                String orClause = '';
                //String andClause = '';
                String whereClause = '';
                String whereClause1 = '';
                String whereClause2 = '';
                if(nameSet != null && nameSet.size() > 0)
                        whereClause1 =orCondition(whereClause1, 'Name', nameSet);

                if(companySet != null && companySet.size() > 0)
                        whereClause1 = orCondition(whereClause1, 'Company', companySet);
                        
                if(emailSet != null && emailSet.size() > 0)
                        whereClause1 = orCondition(whereClause1, 'Email', emailSet);

                if(phoneSet != null && phoneSet.size() > 0)
                        whereClause1 = orCondition(whereClause1, 'Phone', phoneSet);
                 
                 if(zipSet != null && zipSet.size() > 0)
                    whereClause2 = orCondition(whereClause2, 'Zip__c', zipSet);
                
                System.debug('ACCOUNT STATE SET == '+stateSet);
           
                if(stateSet != null && stateSet.size() > 0)
                    whereClause2 = orCondition(whereClause2, 'State__c', stateSet);
         
                if(whereClause1!= '')
                {
                     whereClause = whereClause + '( ' +whereClause1 +' )';
                     if(whereClause2 != '')
                        whereClause = whereClause + ' AND (' +whereClause2 +')';
                }
                else if(whereClause2 != '') 
                    whereClause = whereClause + '( ' +whereClause2 +' )';
              
                       
                if(whereClause != '')
                {
                        //whereClause = orClause;
                        strQuery = strQuery + whereClause + ' ORDER BY Id LIMIT 100';
                        System.debug('MY LEAD SOQL QUERY == '+strQuery);
                        duplicateLeads = Database.query(strQuery);
                        System.debug('>>>>DuplicateLeads>>>>> '+duplicateLeads);
                }
                return duplicateLeads;
        }
        
  
//==============================================================================//
// Get matching accounts list
//==============================================================================//
        public List<Account>  getMatchingAccounts(Set<String> companySet, Set<String> zipSet, Set<String> stateSet) 
        {   
                List<Account> listAccounts = new List<Account>();
                String strQuery = 'Select Id, Status__c, State__c, Zip__c, Name, City__c, Address1__c, AOPS_Cust_Id__c From Account where ';                
                //  **** records will be querried with OR condition only for all different sets passed, actualy AND/OR logic is applied in Trigger in loop.
                String whereClause = '';
                String whereClause1 = '';

                if(companySet != null && companySet.size() > 0)
                    whereClause = orCondition(whereClause, 'Name', companySet);
         /*              
                if(andClause != '')
                    andClause = '(' + andClause + ')';
                        
                if(whereClause != '' && andClause != '')
                    whereClause = whereClause + ' AND ' + andClause;
                else if(whereClause == '' && andClause != '')
                    whereClause = andClause;
         */
                if(zipSet != null && zipSet.size() > 0)
                    whereClause1 = orCondition(whereClause1, 'Zip__c', zipSet);
                
                System.debug('ACCOUNT STATE SET == '+stateSet);
           
                if(stateSet != null && stateSet.size() > 0)
                    whereClause1 = orCondition(whereClause1, 'State__c', stateSet);
                    
                if(whereClause1 != '')
                    whereClause1 = '('+whereClause1 + ')';
                
                if(whereClause !='' && whereClause1 !='')
                    whereClause = whereClause + ' AND ' + whereClause1 ;
                else if(whereClause == '' && whereClause1 !='')
                    whereClause = whereClause1 ;

                if(whereClause != '')
                {
                    strQuery = strQuery + whereClause + ' LIMIT 100';
                    System.debug('MY ACCOUNT SOQL QUERY == '+strQuery);
                    listAccounts = Database.query(strQuery);
                    System.debug('>>>>listAccounts>>>>> '+listAccounts);
                }
                return listAccounts;
        } 
        
//==============================================================================//
// Get matching contacts list
//==============================================================================//
        public List<contact>  getMatchingContacts(Set<String> fNameSet, Set<String> lNameSet, Set<String> emailSet, Set<String> phoneSet) 
        {
            List<Contact> listContact = new List<Contact>();
            String strQuery = 'Select Id, Name,FirstName,LastName, Account.Name, MobilePhone, MailingState, MailingCity, Email, Phone From Contact where ';
            // *** records will be querried with OR condition only for all different sets passed, actualy AND/OR logic is applied in Trigger in loop.
            String whereClause = '';
            String whereClause1 = '';
            String whereClause2 = '';

            if(fNameSet != null && fNameSet.size() > 0)
                whereClause1 = orCondition(whereClause1, 'FirstName', fNameSet);

            if(lNameSet != null && lNameSet.size() > 0)
                whereClause1 = orCondition(whereClause1, 'LastName', lNameSet);
                        
            if(emailSet != null && emailSet.size() > 0)
                whereClause2 = orCondition(whereClause2, 'Email', emailSet);

            if(phoneSet != null && phoneSet.size() > 0)
                whereClause2 = orCondition(whereClause2, 'Phone', phoneSet);
            if(whereClause1!= '')
            {
                whereClause =whereClause + '( ' +whereClause1 +' )';
                if(whereClause2!= '')
                    whereClause = whereClause + ' AND (' +whereClause2 +')';
            }
            else if(whereClause2!= '') 
                whereClause = whereClause + '( ' +whereClause2 +' )';

            if(whereClause != '')
            {
                strQuery = strQuery + whereClause + ' LIMIT 100';
                System.debug('MY CONTACT QUERY == '+strQuery);
                listContact = Database.query(strQuery);
                System.debug('>>>>>listContact>>>> '+ listContact);
            }

            return listContact;             
        } 
        

}