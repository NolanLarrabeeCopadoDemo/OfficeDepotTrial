public class Pros_handler {

    public static void createaccountsetup(list<Account> newAccounts, map<id,account> oldaccounts){
     Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
       Set<Id>  Accids= New Set<Id>();
        Map<Id,Account>  mAccounts=New Map<Id,Account>();
        for(Account ac: newAccounts)
        {
            
            if(ac.Recordtypeid==Parent_RecordTypeId 
                && ac.ORACLE_PARTY_ID__c!=null 
                && ac.ORACLE_PARTY_ID__c != oldaccounts.get(ac.id).ORACLE_PARTY_ID__c)
            {
                  mAccounts.put(Ac.id,Ac);
       
            }
        }
        
        if(!mAccounts.isEmpty())
        {
            Map<Id,Account> mAccPrimarySiteid=New Map<Id,Account>();
            List<Account_Setup_Request__c> ASRlist= New List<Account_Setup_Request__c>();
            Map<Id,Contact>  mContacts= New Map<Id,Contact>();
            
            for(Contact Con:[Select Id,FirstName,LastName,Email,Phone,Role__c,Accountid FROM Contact Where Accountid=:mAccounts.Keyset() and Primary_Contact__c=true])
            {    
                    mContacts.put(Con.AccountId,Con);
            }
            
            for(Account AccSite:[SELECT Id,Related_Account__c,Oracle_Party_Site_ID__c FROM Account WHERE Primary_Site__c=true and  Related_Account__c=:mAccounts.keyset()])
            {
                mAccPrimarySiteid.put(AccSite.Related_Account__c,AccSite);
            }
            
            for(Account A:mAccounts.values())
            {
                ASRlist.add(Pros_handler.accountsetuprecord(A,mAccPrimarySiteid.get(A.id).Id,mAccPrimarySiteid.get(A.id).Oracle_Party_Site_ID__c,mContacts.get(A.Id)));
            }
            
            Insert ASRlist;
        }    
    }
    
    Public static Account_Setup_Request__c accountsetuprecord(Account ac,Id AccSiteId, String oraclePartysite,Contact cont)
    {
         Account_Setup_Request__c  ASR = New Account_Setup_Request__c();
        ASR.Account__C = ac.Id;
        ASR.Street_Address_Bill__c = ac.Address1__c;
        ASR.Street_Address_2_Bill__c = ac.Address2__c;
        ASR.State_Bill__c         = ac.State__c;
        ASR.BILL_COUNTRY__c       = ac.Country__c;
        ASR.Zip_Bill__c           = ac.Zip__c;
        ASR.City_Bill__c          = ac.City__c;
        ASR.Survey_Complete__c   = true;
        ASR.BillTo_Name__c = ac.name;
        ASR.ShipTo_Name__c = ac.name;
 
        ASR.AUTO_BACK_FAX_OR_EMAIL_ADDR__c='9999999999';
        ASR.AUTO_BACK_FAX_EMAIL__c='F';
        ASR.Back_Orders_Flag__c='Y';
        ASR.Billing_Delivery_Method_Media_type__c='PRINT';
        ASR.Ultimate_Duns_Number__c='0';       
        ASR.Loyalty_Type__c='RG';
        ASR.Display_Payment_Method__c='N';
        ASR.Display_Prices__c='N';
        ASR.Duns_Number__c='0';
        ASR.Y_N_exclude_Alternate_Sourcing__c='N';
        ASR.Y_N_exclude_Vendor_Drop_Ship__c='N';
        ASR.GP_Floor__c='0';
        ASR.INV_NUM_OF_COPIES__c=1;
        ASR.Minimum_Order_Value__c=0;
        ASR.Off_Contract_percent__c='0';
        ASR.Off_Contract__c='R';
        ASR.Off_Wholesale_percent__c='0';
        ASR.Off_Wholesale__c='L';
        ASR.Max_Order_Amount__c=1;
        ASR.PARENT_CODE__c='P';
        ASR.Add_Parent_ID__c='0';
        ASR.Invoice_Payment_Method__c='Credit Card';
        ASR.PO__c='H';
        ASR.Rename_Cost_Center__c='';
        ASR.Rename_desktop__C='';
        ASR.Rename_purchase_order__c='';
        ASR.Cost_Center__c='H';
        ASR.Desktop__c='H';
        ASR.PO__c='H';

        ASR.Rename_release__c='';
               
        ASR.PD_Detail__c='Y';
        ASR.Price_Plan__c='7200000-300';
        ASR.PROMO_FLAG_EMAIL__c='Y';
        ASR.PROMO_FLAG_FLYER__c='Y';
        ASR.PROMO_FLAG_PHONE__c='Y';
        ASR.PROSPECT_SOURCE__c='SFDC';
        ASR.Release__c='H';
        ASR.Rep_ID__c = ac.Sales_Person_ExtID__c;
        ASR.Revenue_Band__c='STANDARD';
        ASR.PD_Doc_Name__c='Standard Invoice';
        //ASR.Primary_Contact_Fax__c='0';
       // ASR.Primary_Contact_Mobile_Phone__c='0';
        ASR.PD_Incl_Backup_Inc__c='N';
        ASR.Billing_Frequency__c='Weekly';
        ASR.SHIP_COUNTRY__c='USA';
        ASR.Small_Order_Fee_Flag__c='N';
        ASR.TAX_EXCEPTION_FLAG__c='N';
        ASR.Cross_Reference_number__c='0';
        ASR.Fax_Order_Flag__c='Y';      
        ASR.Backorders_displayed_on_packing_list__c='Y';
        ASR.Display_Purchase_Orders__c='Y';
        ASR.Tax_Exempt__c='N';
        ASR.Print_invoice__c='Y';
        ASR.Rename_Packlist__c=''; 
        ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c=oraclePartysite;
        ASR.City_Ship__c=ac.City__c;
        ASR.State_Ship__c=ac.State__c;
        ASR.Zip_Ship__c=ac.Zip__c;
        ASR.SHIP_COUNTRY__c=ac.Country__c;
        ASR.Street_Address_Ship__c=ac.Address1__c;
        ASR.SFDC_SHIPTO_ID__c=AccSiteId;
        asr.ORACLE_PARTY_ID__c =ac.Oracle_Party_ID__c;
        asr.Parent_Creation__C=true;
        //asr.Account_Phone__c=Ac.Phone;
        asr.Primary_Contact_Phone__c=cont.phone;
        asr.Primary_Contact_Mobile_Phone__c=cont.phone;
        asr.Primary_Contact_First_Name__c=cont.firstname;
        asr.Primary_Contact_Last_Name__c=cont.LastName;
        asr.Primary_Contact_Email__c=cont.Email; //'test@officedepot.com';
        asr.Primary_contact_role__c='SALES';
        //cont.Role__c;
        asr.Report_Loc__c='';

        asr.OPERATION__c='E';
        Return ASR;
       
    }
    
    
    
}