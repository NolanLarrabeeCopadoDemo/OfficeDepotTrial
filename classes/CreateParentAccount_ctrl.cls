public class CreateParentAccount_ctrl {
Public Account Acc{set;get;}
Public Contact cont{set;get;}
static Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
 Id SiteId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();

static Id Contact_RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();

    public CreateParentAccount_ctrl(ApexPages.StandardController controller) {
            Acc=New Account();
            cont=New Contact();
            
    }
    
    
    Public Pagereference submit()
    {
/* When Submit need to check that user has a record in sales person table where active is true and primary is true,
   If Assigned Specify Owner field is blank then check the logged in user has a record in sales person table where active is true and primary is true*/
        
        String Query='SELECT  id,Name,ExtIDSalesPerson__c,User__r.name'+
                       ' FROM   Sales_Person__c'+
                       ' WHERE  IsActive__c=true AND Primary__c=true' +
                        ' AND    ExtIDSalesPerson__c!=Null AND ';
        
        if(Acc.Assign_Specific_Owner__c<>Null)
        {
              String ASO=Acc.Assign_Specific_Owner__c;
              Query= Query+'  User__c=:ASO';
        }
        else
        {
             String UserId= userInfo.getUserId() ;
              Query= Query+'  User__c=:UserId';
        }
          
               Query= Query+' LIMIT 1';
        
        List<Sales_Person__c> SalesPersonId = Database.query(Query);
        system.debug('SalesPersonId'+SalesPersonId);
        if(SalesPersonId.size()>0)
        {
        Acc.RecordtypeId=Parent_RecordTypeId;
        Acc.Hierarchy__c='P';
        Acc.Payment_Term__c='Credit Card';
 
            if(SalesPersonId[0].User__r.name=='Dataloader') {
                   
               Sales_Person__c Exid = [select id,ExtIDSalesPerson__c from Sales_Person__c where User__r.name='Dataloader' and IsActive__c=true AND Primary__c=true and ExtIDSalesPerson__c ='EC11006'];
               Acc.Sales_PersonID__c= Exid.id;
            }
            else{
                Acc.Sales_PersonID__c=SalesPersonId.size()>0?SalesPersonId[0].Id:Null;
            }
        
        Insert Acc;
        
        cont.RecordtypeId=Contact_RecordTypeId;
        cont.Primary_Contact__c=true;
        cont.Accountid=Acc.id;
        cont.phone= cont.Phone1_Rep__c;
        Insert cont;
        
        Account newSite = new Account();
        newSite.Name=Acc.Name;
        newSite.recordtypeId=SiteId;
        newsite.Related_Account__c=Acc.id;
        newSite.Sales_PersonID__c=Acc.Sales_PersonID__c;        
        newSite.Primary_Site__c = true;
        newSite.address1__C= Acc.Address1__c;
        newSite.Address2__c= Acc.Address2__c;
        newSite.city__c=Acc.City__c;
        newSite.state__c=Acc.State__c;
        newSite.zip__c=Acc.Zip__c;
        newSite.Country__c=Acc.Country__c;
        
        Insert newSite;
        
        
        
        
      

      
        
        
       /*Account_Setup_Request__c  ASR=New Account_Setup_Request__c();
        ASR.Account__C=Acc.Id;
        ASR.Street_Address_Bill__c     = Acc.Address1__c;
        ASR.Street_Address_2_Bill__c   = Acc.Address2__c;
        ASR.State_Bill__c              = Acc.State__c;
        ASR.BILL_COUNTRY__c            = Acc.Country__c;
        ASR.Zip_Bill__c                = Acc.Zip__c;
        ASR.City_Bill__c               = Acc.City__c;
        ASR.Survey_Complete__c         = true;
        
        ASR.AUTO_BACK_FAX_OR_EMAIL_ADDR__c='9999999999';
        ASR.AUTO_BACK_FAX_EMAIL__c='F';
        ASR.Back_Orders_Flag__c='Y';
        ASR.Billing_Delivery_Method_Media_type__c='PRINT';
        ASR.Ultimate_Duns_Number__c='0';       
        ASR.Loyalty_Type__c='RG';
        ASR.Cost_Center__c='H';
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
        ASR.Off_Wholesale_percent__c='5';
        ASR.Off_Wholesale__c='L';
        ASR.Max_Order_Amount__c=1;
        ASR.PARENT_CODE__c='P';
        ASR.Add_Parent_ID__c='0';
        ASR.Invoice_Payment_Method__c='CC';
        ASR.PO__c='N';
        ASR.PD_Detail__c='Y';
        ASR.Price_Plan__c='7200000-300';
        ASR.PROMO_FLAG_EMAIL__c='Y';
        ASR.PROMO_FLAG_FLYER__c='Y';
        ASR.PROMO_FLAG_PHONE__c='Y';
        ASR.PROSPECT_SOURCE__c='SFDC';
        ASR.Release__c='N';
        ASR.Rep_ID__c=SalesPersonId.size()>0?SalesPersonId[0].ExtIDSalesPerson__c:Null;
        ASR.Revenue_Band__c='STANDARD';
        ASR.PD_Doc_Name__c='STANDARD INVOICE';
        ASR.Primary_Contact_Fax__c='0';
        ASR.Primary_Contact_Mobile_Phone__c='0';
        ASR.PD_Incl_Backup_Inc__c='N';
        ASR.Billing_Frequency__c='WEEKLY';
        ASR.SHIP_COUNTRY__c='USA';
        ASR.Small_Order_Fee_Flag__c='N';
        ASR.TAX_EXCEPTION_FLAG__c='N';
        ASR.Cross_Reference_number__c='0';
        ASR.Fax_Order_Flag__c='Y';      
        ASR.Backorders_displayed_on_packing_list__c='Y';
        ASR.Display_Purchase_Orders__c='Y';
        ASR.Tax_Exempt__c='N';
        ASR.Print_invoice__c='Y';
        ASR.Rename_Packlist__c='Y'; 

      
        Insert ASR;*/
        
        Pagereference pg=New Pagereference('/'+Acc.id);
        Return PG;
        }
        else
        {
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'No valid Sales Person Id exist');
             ApexPages.addMessage(msg);
        }
        Return Null;
    }

}