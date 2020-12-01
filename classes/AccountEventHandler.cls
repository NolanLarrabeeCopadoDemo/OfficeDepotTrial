//
// (c) Appirio Inc. 2015
//
//
// Author    Jai Gupta    May 27 2015
// Modified  Luke SLEVIN  S-347755 8.31.2015
//
// Handler class AccountEventHandler for AccountEvents trigger
//
//
public with sharing class AccountEventHandler {

    public AccountEventHandler(boolean isExecuting, integer size){

    }

    //LSLEVIN S-347755 8.31.2015 Start
    public void sendToAccountSetup(List<Account> newAccounts,Map<Id,Account> oldMap) {
        List<Account> accountsToProcessSuceess = new List<Account>();
        List<Account> accountsToProcessFailure = new List<Account>();
        List<Account_Setup_Request__c> accountSetupRequests = new List<Account_Setup_Request__c>();
        Map<Id,Contact> primaryContactMap = new Map<Id,Contact>();
        Map<Id,Account> siteAccountMap = new Map<Id,Account>();
        Map<Id,String> salesPersonMap = new Map<Id,String>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> siteIds = new Set<Id>();

        for(Account acc: newAccounts){
          //LSLEVIN Case 00143313 added AccountSource Check Below
          system.debug('Account Source check1:' + acc.AccountSource);
          if(((oldMap.get(acc.Id).DNBI_CREDIT_OUTCOME__c == null && acc.DNBI_CREDIT_OUTCOME__c != null && acc.Primary_Site__c == false) ||
          (oldMap.get(acc.Id).DNBI_MatchScore__c == null && acc.DNBI_MatchScore__c != null && acc.Primary_Site__c == false) ||
          (oldMap.get(acc.Id).DNBI_MatchScore__c == null && acc.DNBI_MatchScore__c == null && acc.Oracle_Party_ID__c != null && acc.Primary_Site__c == false)) && acc.AccountSource == 'BSD Auto Account Setup') {

            system.debug('Account Source check2:' + acc.AccountSource);

            if(acc.DNBI_CREDIT_OUTCOME__c == 'Approved' && acc.Potential_Duplicate__c == false){
                accountsToProcessSuceess.add(acc);
                accIds.add(acc.Id);
                siteIds.add(acc.Primary_Site_ID__c);
            }
            else if(acc.DNBI_CREDIT_OUTCOME__c == 'Declined' || acc.Potential_Duplicate__c == true){
              System.debug('### line 40');
              accountsToProcessFailure.add(acc);
            }
            else if(acc.DNBI_MatchScore__c == 4 || (acc.DNBI_MatchScore__c == 5 && (acc.DNBI_CREDIT_OUTCOME__c == '' || acc.DNBI_CREDIT_OUTCOME__c == null))){
              System.debug('### line 42');
              accountsToProcessFailure.add(acc);
            }
            if((acc.DNBI_MatchScore__c != null || acc.DNBI_MatchScore__c == null) && (acc.DNBI_CREDIT_OUTCOME__c == '' || acc.DNBI_CREDIT_OUTCOME__c == null)){
              System.debug('### line 45');
              accountsToProcessFailure.add(acc);
            }
          }
        }

        if(accountsToProcessSuceess.size() > 0 || accountsToProcessFailure.size() > 0){

          siteAccountMap = new Map <Id,Account>([SELECT Id, Oracle_Party_Site_ID__c FROM Account WHERE Id IN:siteIds]);

          for(Contact c: [SELECT Primary_Contact__c,Firstname,LastName,Email,Phone,
          AccountId,Title FROM Contact WHERE AccountId IN: accIds AND Primary_Contact__c = true]){
            primaryContactMap.put(c.AccountId,c);
          }

          For(Account acc: [SELECT Id,Sales_PersonID__r.Name FROM ACCOUNT WHERE Id IN: accIds]){
            salesPersonMap.put(acc.Id,acc.Sales_PersonID__r.Name);
          }

          //Querying of Pricing template fields for mapping.
          Map<String,Pricing_Template__c> ptMap = new Map<String,Pricing_Template__c>();

          for (Pricing_Template__c pt : [select id,Name,Contract_Number_10__c,
          Contract_Number_1__c,Contract_Number_2__c, Contract_Number_3__c,Contract_Number_4__c,Contract_Number_5__c,Contract_Number_6__c,
          Contract_Number_7__c,Contract_Number_8__c,Contract_Number_9__c,Priority_1__c,Priority_2__c,Priority_3__c,
          Priority_4__c,Priority_5__c,Priority_6__c,Priority_7__c,Priority_8__c,Priority_9__c,Priority_10__c,Cust_Prod_Xref__c,
          Delivery_Code__c,Exclude_Universal_Pricing__c,GP_Floor_Percernt__c,Loyalty__c,Minimum_Order_Value__c,Off_Contract_Code__c,
          Off_Contract_Percent__c,Off_Wholesale_Code__c,Off_Wholesale_Percent__c,Price_Plan_Id__c,Account_Setup_Notes_c__c, Revenue_Band__c,
          Freight_Charge__c,Parent_Id__c from Pricing_Template__c ]) {
             ptMap.put(pt.name, pt);
          }

          //Process Prospect Accounts with a Green or Yellow Credit Check
          for(Account act: accountsToProcessSuceess){
            Account_Setup_Request__c ASR = new Account_Setup_Request__c();
            ASR.Account__c = act.Id;
            ASR.Rep_ID__c = salesPersonMap.get(act.Id);
            ASR.Sales_Rep_ID_for_First_Ship_to__c = salesPersonMap.get(act.Id);

            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Phone != null){
              ASR.Account_Phone__c = primaryContactMap.get(act.Id).Phone;
            }
            ASR.ORACLE_PARTY_ID__c = act.Oracle_Party_ID__c;
            ASR.OPERATION__c = 'S';
            ASR.Survey_Complete__c = true;
            if(siteAccountMap.get(act.Primary_Site_ID__c) != null && siteAccountMap.get(act.Primary_Site_ID__c).Oracle_Party_Site_ID__c != null){
              ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = siteAccountMap.get(act.Primary_Site_ID__c).Oracle_Party_Site_ID__c;
            }
            ASR.Hedberg_Flag__c = 'E';
            ASR.Segment__c = 'Small < $40K';

            ASR.BillTo_Name__c = act.Name;
            ASR.Street_Address_Bill__c = act.Address1__c;
            ASR.Street_Address_2_Bill__c = act.Address2__c;
            ASR.City_Bill__c = act.City__c;
            ASR.State_Bill__c = act.State__c;
            ASR.Zip_Bill__c = act.Zip__c;
            ASR.BILL_COUNTRY__c = act.Country__c;
            //added by Nisha on 01/21/2016 for S-374372 [Case#00570010]                   //ASR.Account_Phone_Extension__c = act.Phone_Ext__c;
            ASR.Sales_Contact_Phone_Extension__c = act.Phone_Ext__c != null? Integer.valueOf(act.Phone_Ext__c):0;
            //end S-374372 [Case#00570010]
            ASR.ShipTo_Name__c = act.Name;
            ASR.Street_Address_Ship__c = act.Address1__c;
            ASR.Street_Address_2_Ship__c = act.Address2__c;
            ASR.City_Ship__c = act.City__c;
            ASR.State_Ship__c = act.State__c;
            ASR.Zip_Ship__c = act.Zip__c;
            ASR.SHIP_COUNTRY__c = act.Country__c;

            ASR.Account_Type__c = act.Account_Type__c;
            ASR.Request_Account_Billing__c = act.Request_Account_Billing__c;
            ASR.Primary_Contact_Phone__c = act.Phone;

            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Title != null){
              ASR.Primary_Contact_Job_Title__c = primaryContactMap.get(act.Id).Title;
            }
            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Firstname != null){
              ASR.Primary_Contact_First_Name__c = primaryContactMap.get(act.Id).Firstname;
            }
            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).LastName != null){
              ASR.Primary_Contact_Last_Name__c = primaryContactMap.get(act.Id).LastName;
            }
            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Phone != null){
              ASR.Primary_Contact_Phone__c = primaryContactMap.get(act.Id).Phone;
              ASR.Primary_Contact_Fax__c = primaryContactMap.get(act.Id).Phone;
            }
            if(primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Email != null){
              ASR.Primary_Contact_Email__c = primaryContactMap.get(act.Id).Email;
            }
            ASR.Primary_contact_role__c = 'SALES';


            ASR.Invoice_Payment_Method__c = 'Credit Card';
            ASR.Back_Orders_Flag__c = 'No';
            ASR.Special_Delivery_Requirements__c = 'NO';
            ASR.EDI_or_Punch_Out__c = 'NO';
            ASR.Does_your_Customer_have_any_ordering_pr__c = 'NO';
            ASR.Tax_Exempt__c = act.Tax_Exempt__c;
            ASR.Release__c = 'Hide';
              // Case 00688494 - Changed value of Small_Order_Fee_Flag__c from No to Yes.
            ASR.Small_Order_Fee_Flag__c = 'Yes';
            // Below mapping for fields from Pricing Template
            if(ptMap.get(act.Pricing_template_cd__c) != null){
              ASR.Core_Item_Price_List_ID_10__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_10__c;
              ASR.Core_Item_Price_List_ID_1__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_1__c;
              ASR.Core_Item_Price_List_ID_2__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_2__c;
              ASR.Core_Item_Price_List_ID_3__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_3__c;
              ASR.Core_Item_Price_List_ID_4__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_4__c;
              ASR.Core_Item_Price_List_ID_5__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_5__c;
              ASR.Core_Item_Price_List_ID_6__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_6__c;
              ASR.Core_Item_Price_List_ID_7__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_7__c;
              ASR.Core_Item_Price_List_ID_8__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_8__c;
              ASR.Core_Item_Price_List_ID_9__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_9__c;
              ASR.Core_Item_Price_List_Priority_Code_10__c = ptMap.get(act.Pricing_template_cd__c).Priority_10__c;
              ASR.Core_Item_Price_List_Priority_Code_1__c = ptMap.get(act.Pricing_template_cd__c).Priority_1__c;
              ASR.Core_Item_Price_List_Priority_Code_2__c = ptMap.get(act.Pricing_template_cd__c).Priority_2__c;
              ASR.Core_Item_Price_List_Priority_Code_3__c = ptMap.get(act.Pricing_template_cd__c).Priority_3__c;
              ASR.Core_Item_Price_List_Priority_Code_4__c = ptMap.get(act.Pricing_template_cd__c).Priority_4__c;
              ASR.Core_Item_Price_List_Priority_Code_5__c = ptMap.get(act.Pricing_template_cd__c).Priority_5__c;
              ASR.Core_Item_Price_List_Priority_Code_6__c = ptMap.get(act.Pricing_template_cd__c).Priority_6__c;
              ASR.Core_Item_Price_List_Priority_Code_7__c = ptMap.get(act.Pricing_template_cd__c).Priority_7__c;
              ASR.Core_Item_Price_List_Priority_Code_8__c = ptMap.get(act.Pricing_template_cd__c).Priority_8__c;
              ASR.Core_Item_Price_List_Priority_Code_9__c = ptMap.get(act.Pricing_template_cd__c).Priority_9__c;
              ASR.Cross_Reference_Number__c = ptMap.get(act.Pricing_template_cd__c).Cust_Prod_Xref__c;
              ASR.Exclude_Account_from_Universal_Pricing__c = ptMap.get(act.Pricing_template_cd__c).Exclude_Universal_Pricing__c;
              ASR.GP_Floor__c = ptMap.get(act.Pricing_template_cd__c).GP_Floor_Percernt__c;
              ASR.Loyalty_Type__c =ptMap.get(act.Pricing_template_cd__c).Loyalty__c;
              if (ptMap.get(act.Pricing_template_cd__c).Minimum_Order_Value__c != null){
                ASR.Minimum_Order_Value__c = Double.valueof(ptMap.get(act.Pricing_template_cd__c).Minimum_Order_Value__c);
              }
              ASR.Off_Contract_percent__c = ptMap.get(act.Pricing_template_cd__c).Off_Contract_Percent__c;
              ASR.Off_Wholesale_percent__c = ptMap.get(act.Pricing_template_cd__c).Off_Wholesale_Percent__c;
              ASR.Price_Plan__c = ptMap.get(act.Pricing_template_cd__c).Price_Plan_Id__c;
              ASR.Revenue_Band__c = ptMap.get(act.Pricing_template_cd__c).Revenue_Band__c;
              ASR.Add_Parent_ID__c = ptMap.get(act.Pricing_template_cd__c).Parent_Id__c;

            }


            ASR.Auto_Fax_Flag__c = 'F';
            ASR.Desktop__c = 'Hide';
            ASR.Cost_Center__c = 'Hide';
            ASR.PO__c = 'Hide';
            ASR.Delivery_Method__c = 'INV';
            ASR.Display_Payment_Method__c = 'No';
            ASR.Display_Prices__c = 'No';
            ASR.PROSPECT_SOURCE__c = 'SFDC';
            ASR.AUTO_BACK_FAX_EMAIL__c = 'F';
            ASR.TIER_1_ACCOUNT_CODE__c = '';
            ASR.PROMO_FAX__c = '';
            ASR.PROMO_FLAG_STUFFER__c = '';
            ASR.PD_Detail__c = 'Yes';
            ASR.PD_Incl_Backup_Inc__c = 'No';

            ASR.TriggerByPass__c = true;

            accountSetupRequests.add(ASR);

            act.Prospect_Creation_Failure__c = false;
            act.Failed_Reason__c = '';
          }

          //Create Account Setup Requests
          insert accountSetupRequests;

          //Process Prospect Accounts with a Red Credit Check
          for(Account ac: accountsToProcessFailure){
            ac.Prospect_Creation_Failure__c = true;

            if(ac.DNBI_CREDIT_OUTCOME__c == 'Declined' && ac.Potential_Duplicate__c == true){
              System.debug('### line 210');
              ac.Failed_Reason__c = 'Credit Check Declined and Potential Duplicate';
            }
            else if(ac.DNBI_CREDIT_OUTCOME__c == 'Declined' && ac.Potential_Duplicate__c == false){
              System.debug('### line 213');
              ac.Failed_Reason__c = 'Credit Check Declined';
            }
            else if(ac.DNBI_CREDIT_OUTCOME__c != 'Declined' && ac.Potential_Duplicate__c == true){
              System.debug('### line 216');
              ac.Failed_Reason__c = 'Potential Duplicate';
            }
            else if((ac.DNBI_CREDIT_OUTCOME__c == '' || ac.DNBI_CREDIT_OUTCOME__c == null) && ac.Potential_Duplicate__c == false){
              System.debug('### line 219');
              ac.Failed_Reason__c = 'DnB Check Failed';
            }
          }
        }
    }
    //LSLEVIN S-347755 8.31.2015 Stop
}