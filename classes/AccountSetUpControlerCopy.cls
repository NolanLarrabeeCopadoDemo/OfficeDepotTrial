public class AccountSetUpControlerCopy {
    //public static Opportunity lopp = new Opportunity();
    //Validate Account
    @
    AuraEnabled
        public static String getDataValidate(String OppId) {
            Opportunity lopp = [SELECT id, AccountId, account.id, account.pricing_template_cd__c, stagename from opportunity where id = : OppId];
            //  Account relavantAccount = new Account();
            Account relavantAccount = [SELECT RecordType.Name, DNBI_CREDIT_OUTCOME__c, Name, Est_Spend__c, Org_WCW_Count_Rep__c,
                                       Sic, ownerid, Sales_PersonID__r.name, Owner.name, Duns_Number__c, Ultimate_Duns_Number__c, Phone, Phone_Ext__c, setup_url1__c,
                                       Related_Account__c, Oracle_Party_ID__c, Industry_OD_SIC_Rep__c, Segment__c, Sector__c, Pricing_template_cd__c,
                                       Related_Pricing_Template_Account__r.Cust_Id__c, Payment_Term__c, Related_Parent_Account__c FROM Account WHERE
                                       id = : lopp.AccountId
                                      ];
            
            List < Contact > lstContact = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, role__c
                                           FROM Contact WHERE AccountId = : relavantAccount.Id AND primary_contact__c = true
                                          ];
            
            System.debug('&&&&&&&&&&relavantAccount Est_Spend__c ' + relavantAccount.Est_Spend__c);
            String errorMessage = '';
            if ('Custom - Self Service'.equals(lopp.account.Pricing_template_cd__c)) {
                AggregateResult qaccepted_total = [SELECT count(id) tot_accepted from quote where
                                                   OpportunityId = : OppId and status = 'Accepted by Customer'
                                                  ];
                
                if (decimal.valueof(string.valueof(qaccepted_total.get('tot_accepted'))) < 1) {
                    errorMessage = 'Opportunity should have atleast One Accepted Quote';
                }
            }
            if (errorMessage == null || errorMessage == '') {
                System.debug('&&&&&&&&&&here1');
                if (opportunity.AccountId == null) {
                    errorMessage = 'Opportunity is not associated with an Account';
                } else if (relavantAccount == null) {
                    errorMessage = 'Site Account doesnot have a related Account';
                } else if (relavantAccount.RecordType.Name == 'Customer')
                    errorMessage = 'Account setup cannot be done as Opportunity is already tied to a customer';
                else if (relavantAccount.RecordType.Name == 'Account Setup Requested')
                    errorMessage = 'Account setup cannot be done as Opportunity is already tied to an Account that is currently being setup';
                else if (lstContact.size() == 0) {
                    errorMessage = 'You must have a primary contact selected before continuing.  If you have added a contact please remember to flag it as primary by selecting the "primary contact" checkbox';
                } else if (lstContact.size() > 1) {
                    errorMessage = 'You currently have 2 or more contacts flagged as primary - you must select only one of these as the primary in order to request a customer setup';
                } else
                    errorMessage = '';
            }
            if (errorMessage == null || errorMessage == '') {
                System.debug('&&&&&&&&&&here2');
                if (lopp.stagename != 'Close' && lopp.stagename != 'Verbal Win') {
                    errorMessage = 'Verbal Win" or "Close" to request Customer setup';
                } else if (relavantAccount.Oracle_Party_ID__c == null) {
                    errorMessage = 'This prospect is not yet ready for Customer Setup. If you just created this Prospect please wait a few minutes for replication before requesting Customer Setup. If its been over 30min since creation and you are receiving this error - please put in a Support Ticket with the subject: Request customer setup is not functioning';
                } else if (relavantAccount.Industry_OD_SIC_Rep__c == null) {
                    errorMessage = 'Please complete the Industry field on the account page before submitting for customer setup';
                } else if (relavantAccount.Sector__c == null) {
                    errorMessage = 'Please complete the Sector field on the account page before submitting for customer setup';
                } else if (relavantAccount.Segment__c == null) {
                    errorMessage = 'Please complete the Segment field on the account page before submitting for customer setup';
                } else if (relavantAccount.Est_Spend__c == null) {
                    System.debug('&&&&&&&&&&here3');
                    errorMessage = 'Please complete the Account Potential field on the account page before submitting for customer setup';
                } else if (relavantAccount.Pricing_template_cd__c == null) {
                    errorMessage = 'Please complete the Pricing Template field on the account page before submitting for customer setup';
                } else
                    errorMessage = '';
            }
            list < sales_person__C > spids = [select name, ExtIDSalesPerson__c from sales_person__C where user__C = : relavantAccount.ownerid and User_Status__c = 'Active'
                                              and Primary__c = true
                                             ];
            if (spids.size() > 0) 
            {
                
                if (spids[0].ExtIDSalesPerson__c == 'TEMPID' || spids[0].ExtIDSalesPerson__c == 'Awaiting SalesID') {
                    errorMessage = 'You do not have valid SalesRep ID. Please contact your Manager ';
                }
            } 
            else {
                errorMessage = 'Currently, you are missing a sales Rep Id, please Contact your manager. If you have just been assigned a new ID, please wait 24 hours for the changes to take place.';
            }
            System.debug('&&&&&&&&&&errorMessage' + errorMessage);
            return errorMessage;
        }
    // Insert Survey Responses        
    @
    AuraEnabled
        public static void SubmitProspect(string updatedRecords) {
            System.debug('&&&&&&' + updatedRecords);
            Account_Setup_Request__c accRec = (Account_Setup_Request__c) JSON.deserialize(updatedRecords, Account_Setup_Request__c.class);
            Id AccountId = accrec.Account__c;
            Account relavantAccount = new Account();
            relavantAccount = [SELECT id, org__c ,recordtypeid FROM Account WHERE
                               id = : AccountId
                              ];
            
            Recordtype rt = [SELECT Id FROM RecordType WHERE Name = 'Account setup Requested'];
            Id submissionId;
            if (accRec != null && accRec.IsAccountSetUpSubmitted__c == false) {
                accRec.IsAccountSetUpSubmitted__c = true;
                relavantAccount.RecordTypeId = rt.id;
                system.debug('record' + accRec);
                String dmlid = accRec.DML__c;
                if(accRec.DML__c!= null && accRec.DML__c!='')
                {  
                    DML__c dmlRelatedList = new DML__c();
                     dmlRelatedList =  [select id,DECISION_MAKER_NM__c,Status__c  from DML__c where DECISION_MAKER_NM__c  =:dmlid limit 1  ];
                    if(dmlRelatedList.Status__c!='Draft' || dmlRelatedList.Status__c!='Rejected' )
                    {
                        DML_Relation__c dmlrelationrec = new DML_Relation__c(org__c=relavantAccount.org__c,account__C=relavantAccount.id,dml__c=dmlRelatedList.id);
                        insert dmlrelationrec;
                        system.debug('dmlrelationrec'+dmlrelationrec);
                        
                    }
               relavantAccount.Related_DML__C = dmlRelatedList.id;
              update relavantAccount;
                    
                }
                Account_Setup_Request__c NewRec = [Select Id from Account_Setup_Request__c where Account__C = : accRec.Account__c];
                accRec.id = NewRec.id;
                //  insert accRec;
                
                update accRec;
                update relavantAccount;
                
            }
        }@
    AuraEnabled
        public static void SubmitProspectOnClose(string updatedRecords) {
            System.debug('&&&&&&' + updatedRecords);
            Account_Setup_Request__c accRec = (Account_Setup_Request__c) JSON.deserialize(updatedRecords, Account_Setup_Request__c.class);
            if (accRec != null && accRec.IsAccountSetUp__c == false) {
                //accRec.isaccountsetup__c = true;
                insert accRec;
                system.debug('id the great');
            } else {
                Account_Setup_Request__c NewRec = [Select Id from Account_Setup_Request__c where Account__C = : accRec.Account__c];
                accRec.id = NewRec.id;
                update accRec;
            }
        }
    //AutoPopulateProspectDetails
    @
    AuraEnabled
        public static Account_Setup_Request__c getAccountData(String OppId) {
            Id AccountId;
            Account relavantAccount = new Account();
            Contact primaryContact = new Contact();
            Account siteAccount = new Account();
            Account_Setup_Request__c newRec = new Account_Setup_Request__c();
            if (OppId != null) {
                AccountId = [Select AccountId from Opportunity where Id = : OppId].AccountId;
                system.debug('Accountd' + AccountId);
                // currentAcc=[Select Name, Phone,Address1__c,Address2__c,City__c,State__c,Country__c,zip__c,Pricing_template_cd__c
                //from Account where Id=:AccountId];
                relavantAccount = [SELECT RecordType.Name, DNBI_CREDIT_OUTCOME__c, Name, Est_Spend__c, Org_WCW_Count_Rep__c,
                                   Sic, ownerid, Sales_PersonID__r.name, Owner.name, Duns_Number__c, Ultimate_Duns_Number__c, Phone, Phone_Ext__c, setup_url1__c,
                                   Related_Account__c, Oracle_Party_ID__c, Industry_OD_SIC_Rep__c, Segment__c, Sector__c, Pricing_template_cd__c,
                                   Related_Pricing_Template_Account__r.Cust_Id__c, Payment_Term__c, Related_Parent_Account__c
                                   FROM Account WHERE id = : AccountId
                                  ];
                
                list < Account_Setup_Request__c > lstAccounts = [SELECT id, BillTo_Name__c, Account_Phone__c, Street_Address_Bill__c, Street_Address_2_Bill__c, City_Bill__c, State_Bill__c,
                                                                 Zip_Bill__c, BILL_COUNTRY__c, Street_Address_Ship__c, Street_Address_2_Ship__c, City_Ship__c, State_Ship__c, Zip_Ship__c, ShipTo_Name__c,
                                                                 SHIP_COUNTRY__c, Primary_Contact_First_Name__c, Primary_Contact_Last_Name__c, Primary_Contact_Phone__c, Primary_Contact_Fax__c,
                                                                 Primary_Contact_Email__c, Does_your_Customer_have_any_ordering_pr__c, Special_Delivery_Requirements__c,Off_Contract_percent__c,
                                                                 EDI_or_Punch_Out__c, Billing_Delivery_Method_Media_type__c, AP_Contact_Salutation__c, AP_Contact_First_Name__c,
                                                                 AP_Contact_Last_Name__c, AP_Contact_Email__c, AP_Contact_Phone__c, AP_Contact_Fax__c, eBilling_Contact_Salutation__c, eBilling_Contact_First_Name__c,
                                                                 eBilling_Contact_Last_Name__c, eBilling_Contact_Phone__c, eBilling_Contact_Email__c, Monthly_eStatement_Email__c, eBilling_Contact_Salutation2__c,
                                                                 eBilling_Contact_First_Name2__c, eBilling_Contact_Last_Name2__c, eBilling_Contact_Phone2__c, eBilling_Contact_Email2__c, eBilling_Contact_Fax2__c,
                                                                 PD_Incl_Backup_Inc__c, Monthly_eStatements__c, Early_Pay_Discount_Needed__c, PD_multiple_bill_to_locations__c, Billing_Frequency__c,
                                                                 Employer_TIN__c, Is_IRS_W9_Required_for_AP__c, Tax_Exempt__c, Tax_Exempt_States__c, Why_are_you_tax_exempt__c, Goverment_Branch__c,
                                                                 Rep_Comments__c, Account__c, ACCOUNT_ID__c, Account__r.name, IsAccountSetUpSubmitted__c, IsAccountSetUp__c,
                                                                 PO__c, Desktop__c, Rename_Cost_Center__c, Rename_Release__c, Cost_Center__c, Release__c, Rename_Purchase_Order__c,
                                                                 Rename_Desktop__c, Minimum_Order_Value__c, Budgets_CC_PO__c, Print_Invoice__c, Display_Purchase_Orders__c,
                                                                 Display_Payment_Method__c, Display_Prices__c, Backorders_displayed_on_packing_list__c, Rename_Packlist__c, Show_Net_30_Question__c,
                                                                 Account__r.Est_Spend__c, Account__r.Payment_Term__c, Show_Net_20__c,
                                                                 PD_Doc_Name__c,DML__c,Segment__c
                                                                 FROM Account_Setup_Request__c where Account__c = : AccountId limit 1
                                                                ];
                
                List < RecordType > lstRecordType = [SELECT Id FROM RecordType WHERE Name = 'Site']; //use schema here
                List < Account > lstAccount = [SELECT id, Name, Oracle_Party_Site_ID__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Country__c FROM Account
                                               WHERE RecordTypeId = : lstRecordType[0].Id AND primary_site__c = true AND Related_Account__c = : accountId
                                              ];
                
               // system.debug('hello &&&&&&:' + lstAccount);
                if (lstAccount.size() == 1) {
                    siteAccount = lstAccount[0];
                }
                List < Contact > lstContact = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, role__c, MobilePhone
                                               FROM Contact WHERE AccountId = : AccountId AND primary_contact__c = true
                                              ];
                
                if (lstContact.size() == 1) {
                    primaryContact = lstContact[0];
                }
                Pricing_Template__c pricingTemp = new Pricing_Template__c();
                List < Pricing_Template__c > lstTemplate = [SELECT Id, Name, Parent_Id__c, Off_Contract_Code__c, Off_Contract_Percent__c,
                                                            Off_Wholesale_Code__c, Off_Wholesale_percent__c, GP_Floor_Percernt__c, Price_Plan_Id__c, Exclude_Universal_Pricing__c,
                                                            Loyalty__c, Minimum_Order_Value__c, Delivery_Code__c, Contract_Number_1__c, Priority_1__c, Contract_Number_2__c, Priority_2__c,
                                                            Contract_Number_3__c, Priority_3__c, Contract_Number_4__c, Priority_4__c, Contract_Number_5__c, Priority_5__c,
                                                            Contract_Number_6__c, Priority_6__c, Contract_Number_7__c, Priority_7__c, Contract_Number_8__c, Priority_8__c,
                                                            Contract_Number_9__c, Priority_9__c, Contract_Number_10__c, Priority_10__c, Revenue_Band__c, Freight_Charge__c, Cust_Prod_Xref__c,
                                                            Acct_Auto_Setup__c, Account_Setup_Notes_c__c from Pricing_Template__c where Template__c = : relavantAccount.Pricing_template_cd__c
                                                           ];
                 system.debug('hello &&&&&&:' + lstTemplate);
                
                Contact Newebilling = new Contact();
                List < Contact > Ebilling = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, Role__c FROM Contact WHERE AccountId = : AccountId
                                             AND role__c includes('eBilling') ORDER BY lastmodifieddate DESC Limit 1
                                            ];
                
                if (Ebilling.size() == 0) {} else {
                    Newebilling = Ebilling[0];
                }
                Contact NewPayable = new Contact();
                List < Contact > AccountsPayable = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, Role__c FROM Contact WHERE AccountId = : AccountId
                                                    AND role__c includes('Accounts Payable') ORDER BY lastmodifieddate DESC Limit 1
                                                   ];
                
                if (AccountsPayable.size() == 0) {} else {
                    NewPayable = AccountsPayable[0];
                }
                String errorMessage = '';
               if (errorMessage == null || errorMessage == '') {
                    system.debug('errorMessage null &&&&&&:');
                    if (lstTemplate.size() == 0) {
                        errorMessage = 'You must have a Pricing Template selected before continuing.';
                    }
                    if (lstTemplate.size() > 1) {
                        errorMessage = 'You currently have 2 or more contract Templates for the select value. Please contact your System Administartor.';
                    }
                    if (lstTemplate.size() == 1) {
                        pricingTemp = lstTemplate[0];
                           system.debug('pricingTemp &&&&&&:' + pricingTemp);
                    }
                    if (lstAccount.size() == 0) {
                        errorMessage = ' You must have a primary contact selected before continuing.  If you have added a contact please remember to flag it as primary by selecting the "primary contact" checkbox';
                    }
                    if (lstAccount.size() > 1) {
                        errorMessage = 'You currently have 2 or more sites flagged as primary - you must select only one of these as the primary in order to request a customer setup';
                    }
                    if (lstRecordType.size() == 0) {
                        errorMessage = 'Record Type "Site" not found for Account object';
                    }
                }
                
                
                //set contact details
                if (lstAccounts.size() == 1) {
                    system.debug('fix'+lstAccounts);
                    newRec.Id = lstAccounts[0].Id;
                    newRec.IsAccountSetUpSubmitted__c = lstAccounts[0].IsAccountSetUpSubmitted__c;
                    newRec.Account__c = lstAccounts[0].Account__c;
                    newRec.BillTo_Name__c = lstAccounts[0].account__r.name;
                    newRec.Primary_Contact_Email__c = lstAccounts[0].Primary_Contact_Email__c;
                    newRec.Primary_Contact_Fax__c = lstAccounts[0].Primary_Contact_Fax__c;
                    newRec.Primary_Contact_First_Name__c = lstAccounts[0].Primary_Contact_First_Name__c;
                    newRec.Primary_Contact_Last_Name__c = lstAccounts[0].Primary_Contact_Last_Name__c;
                    newRec.Primary_Contact_Phone__c = lstAccounts[0].Primary_Contact_Phone__c;
                    newRec.Account_Phone__c = lstAccounts[0].Account_Phone__c;
                    newRec.Street_Address_Bill__c = lstAccounts[0].Street_Address_Bill__c;
                    newRec.Street_Address_2_Bill__c = lstAccounts[0].Street_Address_2_Bill__c;
                    newRec.State_Bill__c = lstAccounts[0].State_Bill__c;
                    newRec.Zip_Bill__c = lstAccounts[0].Zip_Bill__c;
                    newRec.City_Bill__c = lstAccounts[0].City_Bill__c;
                    newRec.BILL_COUNTRY__c = lstAccounts[0].BILL_COUNTRY__c;
                    newRec.ShipTo_Name__c = lstAccounts[0].ShipTo_Name__c;
                    newRec.Street_Address_Ship__c = lstAccounts[0].Street_Address_Ship__c;
                    newRec.Street_Address_2_Ship__c = lstAccounts[0].Street_Address_2_Ship__c;
                    newRec.State_Ship__c = lstAccounts[0].State_Ship__c;
                    newRec.Zip_Ship__c = lstAccounts[0].Zip_Ship__c;
                    newRec.City_Ship__c = lstAccounts[0].City_Ship__c;
                    newRec.SHIP_COUNTRY__c = lstAccounts[0].SHIP_COUNTRY__c;
                    newRec.Does_your_Customer_have_any_ordering_pr__c = lstAccounts[0].Does_your_Customer_have_any_ordering_pr__c;
                    // system.debug('rohini' + lstAccounts[0].Does_your_Customer_have_any_ordering_pr__c);
                    newRec.Special_Delivery_Requirements__c = lstAccounts[0].Special_Delivery_Requirements__c;
                    newRec.EDI_or_Punch_Out__c = lstAccounts[0].EDI_or_Punch_Out__c;
                    newRec.Billing_Delivery_Method_Media_type__c = lstAccounts[0].Billing_Delivery_Method_Media_type__c;
                    newRec.AP_Contact_Salutation__c = lstAccounts[0].AP_Contact_Salutation__c;
                    newRec.AP_Contact_First_Name__c = lstAccounts[0].AP_Contact_First_Name__c;
                    newRec.AP_Contact_Last_Name__c = lstAccounts[0].AP_Contact_Last_Name__c;
                    newREc.AP_Contact_Email__c = lstAccounts[0].AP_Contact_Email__c;
                    newRec.AP_Contact_Phone__c = lstAccounts[0].AP_Contact_Phone__c;
                    newRec.AP_Contact_Fax__c = lstAccounts[0].AP_Contact_Fax__c;
                    newRec.eBilling_Contact_Salutation__c = lstAccounts[0].eBilling_Contact_Salutation__c;
                    newRec.eBilling_Contact_First_Name__c = lstAccounts[0].eBilling_Contact_First_Name__c;
                    newRec.eBilling_Contact_Last_Name__c = lstAccounts[0].eBilling_Contact_Last_Name__c;
                    newRec.eBilling_Contact_Phone__c = lstAccounts[0].eBilling_Contact_Phone__c;
                    newRec.eBilling_Contact_Email__c = lstAccounts[0].eBilling_Contact_Email__c;
                    newRec.Monthly_eStatement_Email__c = lstAccounts[0].Monthly_eStatement_Email__c;
                    newRec.eBilling_Contact_Salutation2__c = lstAccounts[0].eBilling_Contact_Salutation2__c;
                    newRec.eBilling_Contact_First_Name2__c = lstAccounts[0].eBilling_Contact_First_Name2__c;
                    newRec.eBilling_Contact_Last_Name2__c = lstAccounts[0].eBilling_Contact_Last_Name2__c;
                    newRec.eBilling_Contact_Phone2__c = lstAccounts[0].eBilling_Contact_Phone2__c;
                    newRec.eBilling_Contact_Email2__c = lstAccounts[0].eBilling_Contact_Email2__c;
                    newRec.eBilling_Contact_Fax2__c = lstAccounts[0].eBilling_Contact_Fax2__c;
                    newRec.PD_Incl_Backup_Inc__c = lstAccounts[0].PD_Incl_Backup_Inc__c;
                    newRec.Monthly_eStatements__c = lstAccounts[0].Monthly_eStatements__c;
                    newRec.Early_Pay_Discount_Needed__c = lstAccounts[0].Early_Pay_Discount_Needed__c;
                    newRec.PD_multiple_bill_to_locations__c = lstAccounts[0].PD_multiple_bill_to_locations__c;
                    newRec.Billing_Frequency__c = lstAccounts[0].Billing_Frequency__c;
                    newRec.Employer_TIN__c = lstAccounts[0].Employer_TIN__c;
                    newRec.Is_IRS_W9_Required_for_AP__c = lstAccounts[0].Is_IRS_W9_Required_for_AP__c;
                    newRec.Tax_Exempt__c = lstAccounts[0].Tax_Exempt__c;
                    newRec.Tax_Exempt_States__c = lstAccounts[0].Tax_Exempt_States__c;
                    newRec.Why_are_you_tax_exempt__c = lstAccounts[0].Why_are_you_tax_exempt__c;
                    newRec.Goverment_Branch__c = lstAccounts[0].Goverment_Branch__c;
                    newRec.Rep_Comments__c = lstAccounts[0].Rep_Comments__c;
                    newRec.IsAccountSetUp__c = lstAccounts[0].IsAccountSetUp__c;
                    newRec.Desktop__c = lstAccounts[0].Desktop__c;
                    newRec.PO__c = lstAccounts[0].PO__c;
                    newRec.Rename_Cost_Center__c = lstAccounts[0].Rename_Cost_Center__c;
                    newRec.Rename_Desktop__c = lstAccounts[0].Rename_Desktop__c;
                    newRec.Rename_Packlist__c = lstAccounts[0].Rename_Packlist__c;
                    newRec.Rename_Purchase_Order__c = lstAccounts[0].Rename_Purchase_Order__c;
                    newRec.Rename_Release__c = lstAccounts[0].Rename_Release__c;
                    newRec.Cost_Center__c = lstAccounts[0].Cost_Center__c;
                    newRec.Release__c = lstAccounts[0].Release__c;
                    newRec.Segment__c = lstAccounts[0].Segment__c;
                    newRec.Minimum_Order_Value__c = lstAccounts[0].Minimum_Order_Value__c;
                    newRec.Budgets_CC_PO__c = lstAccounts[0].Budgets_CC_PO__c;
                    newRec.Print_Invoice__c = lstAccounts[0].Print_Invoice__c;
                    newRec.Display_Purchase_Orders__c = lstAccounts[0].Display_Purchase_Orders__c;
                    newRec.Display_Payment_Method__c = lstAccounts[0].Display_Payment_Method__c;
                    newRec.Backorders_displayed_on_packing_list__c = lstAccounts[0].Backorders_displayed_on_packing_list__c;
                    newRec.Display_Prices__c = lstAccounts[0].Display_Prices__c;
                    newRec.PD_Doc_Name__c = lstAccounts[0].PD_Doc_Name__c;
                    newRec.DML__c=lstAccounts[0].DML__c;
                    //  newRec.Account__r.Est_Spend__c=lstAccounts[0].Account__r.Est_Spend__c;
                    //  newRec.Account__r.Payment_Term__c=lstAccounts[0].Account__r.Payment_Term__c;
                    system.debug('loop check' + lstAccounts[0].Account__r.Est_Spend__c);
                    system.debug('loop check' + lstAccounts[0].Account__r.Payment_Term__c);
                    Decimal Amount = lstAccounts[0].Account__r.Est_Spend__c;
                    system.debug('loop check' + Amount);
                    
                    if (Amount > 250000 && lstAccounts[0].Account__r.Payment_Term__c == 'Account Billing') {
                        newRec.Show_Net_30_Question__c = true;
                        newRec.Show_Net_20__c = true;
                        system.debug('loop check');
                    } else if (lstAccounts[0].Account__r.Payment_Term__c == 'Credit Card') {
                        newRec.Show_Net_20__c = false;
                        newRec.Show_Net_30_Question__c = false;
                    } else {
                        newRec.Show_Net_30_Question__c = false;
                        newRec.Show_Net_20__c = true;
                    }
                    
                    //newRec.Show_Net_30_Question__c=false;
                }
                if (lstAccounts.size() == 0) {
                    if (primaryContact != null) {
                        newRec.Primary_Contact_Email__c = primaryContact.Email;
                        newRec.Primary_Contact_Fax__c = primaryContact.Fax;
                        newRec.Primary_Contact_First_Name__c = primaryContact.FirstName;
                        newRec.Primary_Contact_Job_Title__c = primaryContact.Title;
                        newRec.Primary_Contact_Last_Name__c = primaryContact.LastName;
                        newRec.Primary_Contact_Mobile_Phone__c = primaryContact.MobilePhone;
                        newRec.Primary_Contact_Phone__c = primaryContact.Phone;
                        //newRec.Primary_contact_role__c = primaryContact.Role__c;
                        newRec.Primary_Contact_Salutation__c = primaryContact.Salutation;
                        
                    }
                    
                    if (pricingTemp != null) {
                        newRec.Add_Parent_ID__c = pricingTemp.Parent_Id__c;
                        newRec.Off_Contract__c =pricingTemp.Off_Contract_Code__c;
                            //pricingTemp.Off_Contract_Code__c;
                        newRec.Off_Contract_Percent__c = pricingTemp.Off_Contract_Percent__c;
                        newRec.Off_Wholesale__c = pricingTemp.Off_Wholesale_Code__c;
                        newRec.Off_Wholesale_percent__c = pricingTemp.Off_Wholesale_percent__c;
                        /*if(pricingTemp.GP_Floor_Percernt__c!=null)
newRec.Enter_GP_Floor_Percent__c = decimal.valueOf(pricingTemp.GP_Floor_Percernt__c);*/
                        newRec.GP_Floor__c = pricingTemp.GP_Floor_Percernt__c;
                        newRec.Price_Plan__c = pricingTemp.Price_Plan_Id__c;
                        newRec.Exclude_Account_from_Universal_Pricing__c = pricingTemp.Exclude_Universal_Pricing__c;
                        newRec.Loyalty_Type__c = pricingTemp.Loyalty__c;
                        if (pricingTemp.Minimum_Order_Value__c != null)
                            newRec.Minimum_Order_Value__c = decimal.valueOf(pricingTemp.Minimum_Order_Value__c);
                        newRec.Deliver_Charge_Code__c = pricingTemp.Delivery_Code__c;
                        newRec.Core_Item_Price_List_Priority_Code_1__c = pricingTemp.Priority_1__c;
                        newRec.Core_Item_Price_List_Priority_Code_2__c = pricingTemp.Priority_2__c;
                        newRec.Core_Item_Price_List_Priority_Code_3__c = pricingTemp.Priority_3__c;
                        newRec.Core_Item_Price_List_Priority_Code_4__c = pricingTemp.Priority_4__c;
                        newRec.Core_Item_Price_List_Priority_Code_5__c = pricingTemp.Priority_5__c;
                        newRec.Core_Item_Price_List_Priority_Code_6__c = pricingTemp.Priority_6__c;
                        newRec.Core_Item_Price_List_Priority_Code_7__c = pricingTemp.Priority_7__c;
                        newRec.Core_Item_Price_List_Priority_Code_8__c = pricingTemp.Priority_8__c;
                        newRec.Core_Item_Price_List_Priority_Code_9__c = pricingTemp.Priority_9__c;
                        newRec.Core_Item_Price_List_Priority_Code_10__c = pricingTemp.Priority_10__c;
                        newRec.Revenue_Band__c = pricingTemp.Revenue_Band__c;
                        newRec.Core_Item_Price_List_ID_1__c = pricingTemp.Contract_Number_1__c;
                        newRec.Core_Item_Price_List_ID_2__c = pricingTemp.Contract_Number_2__c;
                        newRec.Core_Item_Price_List_ID_3__c = pricingTemp.Contract_Number_3__c;
                        newRec.Core_Item_Price_List_ID_4__c = pricingTemp.Contract_Number_4__c;
                        newRec.Core_Item_Price_List_ID_5__c = pricingTemp.Contract_Number_5__c;
                        newRec.Core_Item_Price_List_ID_6__c = pricingTemp.Contract_Number_6__c;
                        newRec.Core_Item_Price_List_ID_7__c = pricingTemp.Contract_Number_7__c;
                        newRec.Core_Item_Price_List_ID_8__c = pricingTemp.Contract_Number_8__c;
                        newRec.Core_Item_Price_List_ID_9__c = pricingTemp.Contract_Number_9__c;
                        newRec.Core_Item_Price_List_ID_10__c = pricingTemp.Contract_Number_10__c;
                        newRec.Off_Contract_percent__c=pricingTemp.Off_Contract_Percent__c;
                        newRec.OPERATION__c = pricingTemp.Acct_Auto_Setup__c;
                        newRec.Cross_Reference_Number__c = pricingTemp.Cust_Prod_Xref__c;
                        newRec.Small_Order_Fee_Flag__c = pricingTemp.Freight_Charge__c;
                        newRec.Rep_Comments__c = pricingTemp.Account_Setup_Notes_c__c;
                        
                    }
                /*    if (Newebilling != null) {
                        newRec.eBilling_Contact_Salutation__c = Newebilling.Salutation;
                        newRec.eBilling_Contact_First_Name__c = Newebilling.FirstName;
                        newRec.eBilling_Contact_Last_Name__c = Newebilling.LastName;
                        newRec.eBilling_Contact_Job_Title__c = Newebilling.Title;
                        newRec.eBilling_Contact_Phone__c = Newebilling.Phone;
                        newRec.eBilling_Contact_Fax__c = Newebilling.Fax;
                        newRec.eBilling_Contact_Email__c = Newebilling.Email;
                    }*/
                    if (relavantAccount != null) {
                        
                        newRec.Account__c = relavantAccount.ID;
                        //newRec.ACCOUNT_ID__c=relavantAccount.id; //need to check this 
                        newRec.BillTo_Name__c = relavantAccount.Name;
                        newRec.Account_Owner__c = relavantAccount.OwnerId;
                        newRec.Account_Phone__c = relavantAccount.Phone;
                        newRec.Segment__c = relavantAccount.Segment__c;
                        newRec.Duns_Number__c = relavantAccount.Duns_Number__c;
                        newRec.Ultimate_Duns_Number__c = relavantAccount.Ultimate_Duns_Number__c;
                        //  newRec.Related_Account__c=relavantAccount.Related_Parent_Account__c;
                        newRec.Invoice_Payment_Method__c = relavantAccount.Payment_Term__c;
                        newRec.Est_Spend__c = relavantAccount.Est_Spend__c;
                        newRec.ORACLE_PARTY_ID__c = relavantAccount.Oracle_Party_ID__c;
                        if (relavantAccount.Org_WCW_Count_Rep__c != null)
                            newRec.Number_of_WCW_employees__c = string.valueof(relavantAccount.Org_WCW_Count_Rep__c);
                        newRec.Rep_ID__c = relavantAccount.Sales_PersonID__r.name;
                        // system.debug(' (relavantAccount.Est_Spend__c &&&&&' +  relavantAccount.Est_Spend__c);
                        //  if(relavantAccount.Est_Spend__c>250000&&relavantAccount.Payment_Term__c=='Account Billing')
                        // newRec.Show_Net_30_Question__c=true;
                        //  system.debug(' Show_Net_30_Question__c &&&&&' +  newRec.Show_Net_30_Question__c);
                        
                        if (relavantAccount.Est_Spend__c > 250000 && relavantAccount.Payment_Term__c == 'Account Billing') {
                            newRec.Show_Net_30_Question__c = true;
                            newRec.Show_Net_20__c = true;
                            system.debug('loop check');
                        } else if (relavantAccount.Payment_Term__c == 'Credit Card') {
                            newRec.Show_Net_20__c = false;
                            newRec.Show_Net_30_Question__c = false;
                        } else {
                            newRec.Show_Net_30_Question__c = false;
                            newRec.Show_Net_20__c = true;
                        }
                        
                    }
                    if (siteAccount != null) {
                        system.debug('siteAccount &&&&&' + siteAccount);
                        //Bill to DEtails
                        newRec.Street_Address_Bill__c = siteAccount.Address1__c;
                        newRec.Street_Address_2_Bill__c = siteAccount.Address2__c;
                        newRec.State_Bill__c = siteAccount.State__c;
                        newRec.Zip_Bill__c = siteAccount.zip__c;
                        newRec.City_Bill__c = siteAccount.City__c;
                        newRec.BILL_COUNTRY__c = siteAccount.Country__c;
                        // Ship to DEtails
                        newRec.ShipTo_Name__c = siteAccount.Name;
                        newRec.Street_Address_Ship__c = siteAccount.Address1__c;
                        newRec.Street_Address_2_Ship__c = siteAccount.Address2__c;
                        newRec.State_Ship__c = siteAccount.State__c;
                        newRec.Zip_Ship__c = siteAccount.Zip__c;
                        newRec.City_Ship__c = siteAccount.City__c;
                        newRec.SHIP_COUNTRY__c = siteAccount.Country__c;
                        newRec.SHIPTO_ORACLE_PARTY_SITE_ID__c = siteAccount.Oracle_Party_Site_ID__c;
                    }
                /*    if (NewPayable != null) {
                        newRec.AP_Contact_Salutation__c = NewPayable.Salutation;
                        newRec.AP_Contact_First_Name__c = NewPayable.FirstName;
                        newRec.AP_Contact_Last_Name__c = NewPayable.LastName;
                        newRec.AP_Contact_Job_Title__c = NewPayable.Title;
                        newRec.AP_Contact_Phone__c = NewPayable.Phone;
                        newRec.AP_Contact_Fax__c = NewPayable.Fax;
                        newRec.AP_Contact_Email__c = NewPayable.Email;
                        newRec.AP_Contact_Role__c = NewPayable.Role__c;
                        newRec.IsAccountSetUp__c = false;
                    }*/
                }
                system.debug('newrec' + newRec);
            }
            return newRec;
        }@
    AuraEnabled
        public static map < string, boolean > getStatesMap(List < String > allStates, String selectedStates) {
            // allStates=    (List<String>)JSON.deserialize(allStates, List<String>.class);
            system.debug('allStates'+allStates);
              system.debug('selectedStates'+selectedStates);
            map < string, boolean > map_states = new map < string, boolean > ();
            for (String str: allStates) {
                map_states.put(str, false);
            }
            if (selectedStates != null) {
                selectedStates = (string) JSON.deserialize(selectedStates, String.class);
                system.debug('allStates==>' + allStates);
                system.debug('selectedStates==>' + selectedStates);
                
                for (String str1: selectedStates.split(',')) {
                    map_states.put(str1, true);
                }
            }
            return map_states;
        }
        
        
        
        
         //getDML Data
    @ AuraEnabled
        public static Map<Id,String> getDMLData(String OppId) {
            system.debug('test check'+oppID);
        Map<Id,String> dmlList= new Map<Id,String>();
        List<DML_Relation__c> dmlRelatedList = new List<DML_Relation__c> ();
        Id orgId=[select account.org__C from Opportunity where Id=:OppId].account.org__C;
         Id ParentOrg = [select account.Parent.org__C from Opportunity where Id=:OppId].account.Parent.org__C;
        if(orgId  !=null){
         dmlRelatedList =  [select Decision_Maker_Name__c,DML__c  from DML_Relation__c where Org__c  =:orgId  OR Org__c =:ParentOrg];
            for(DML_Relation__c rec      :dmlRelatedList ){
                if(!dmlList.containskey( rec.DML__c  ))
                 dmlList.put(rec.DML__c,rec.Decision_Maker_Name__c);
            }
        }
        return dmlList;
        }
        
    //Create DML Data
    @AuraEnabled
        public static String CreateDMLOption(String OppId, String DMLRec) {
             system.debug('OppId'+OppId);
           //   DML__c newRec= new DML__c();
        Id accId=[select AccountId from Opportunity where Id=:OppId].AccountId ;
             system.debug('DMLRec'+DMLRec);
                DML__c Drec = (DML__c) JSON.deserialize(DMLRec, DML__c.class);
           // Id AccountId = accrec.Account__c;
            Account relavantAccount = new Account();
            
             if (Drec != null ) {
                //accRec.isaccountsetup__c = true;
                 Drec.Status__c='Draft';
                insert Drec;
                system.debug('id the great');
                List<Account> acclist = [Select id,name from Account where id=:accid];
                  Account acc=  new Account();
              acc.Id=accId;
              acc.Related_DML__C = Drec.Id;
           update acc;
               Case newCase= new Case();
               newCase.accountId=accId;
                 newCase.Support_Type__c='New DML Exception';
                 newCase.Support_Sub_Type__c=Drec.Reason_for_Creation__c;
               newCase.subject= acclist[0].Name;
               newCase.Description='Account Name :'+' '+acclist[0].Name+'\n'+'Request Type: New DML Exception'+'\n'+'Reason For DML Creation:'+' '+Drec.Reason_for_Creation__c +'\n'+ 'Please check the DML by clicking this link:'+'  '+'https://officedepot--oduat.cs78.my.salesforce.com/'+Drec.id;
               insert newCase;
                 
            }
         /*   system.debug('accid'+accId);
            if(DMLName  !=null &&  DMLName!=''){
                   system.debug('DMLName'+DMLName);
          
                   newRec.Status__c='Draft';
                   newRec.DECISION_MAKER_NM__c=DMLName;
                   insert newRec;
                   system.debug('DMLnewRec'+newRec);
              Account acc=  new Account();
              acc.Id=accId;
              acc.Related_DML__C = newRec.Id;
           update acc;
               Case newCase= new Case();
               newCase.accountId=accId;
               newCase.subject= 'Review DML related to Account';
               insert newCase;
            
            }*/
            return Drec.DECISION_MAKER_NM__c ;
        }

        
        
}