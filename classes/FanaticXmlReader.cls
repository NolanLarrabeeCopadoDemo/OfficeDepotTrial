public class FanaticXmlReader {

public  class OrderItems { 
public  String CustOrderNo { get; set; }  
public  String c4ssku { get; set; }  
public  String productid { get; set; }  
public  String mfgsku { get; set; }  
public  String qty { get; set; }  
public  String Cost { get; set; }  
public  String SalePrice { get; set; }  
public  String ShipAmt { get; set; }  
public  String TaxAmt { get; set; }  
public  String ShipTaxAmt { get; set; }  
public  String ProductName { get; set; }  
public  String IsBackOrdered { get; set; }  
public  String EnterDate { get; set; }  
public  String Returnable { get; set; }  
public  String SkuTypeId { get; set; }  
public  String mfgname { get; set; }  
public  String catlev1 { get; set; }  
public  String catlev2 { get; set; }  
public  String Cat1Name { get; set; }  
public  String Cat2Name { get; set; }  
public  String Status { get; set; }  
public  String OrderItemStatusID { get; set; }  
 public  String ItemID { get; set; }  
 public  String ItemPrice { get; set; }  
 public  String ItemTax { get; set; }  
 public  String ItemShipping { get; set; }  
 public  String ItemCost { get; set; }  
 public  String ExtCost { get; set; }  
 public  String ExtPrice { get; set; }  
 public  String MarginDollar { get; set; }  
public  String MarginPercent { get; set; }  
public  String IsBackOrder { get; set; }  
public  String WarrantyCode  { get; set; }  

 }  

public class Customer{
public  String CustomerID { get; set; }
public String CompanyName { get; set; }
Public String EnterDate { get; set; }
  Public String SalesRepName { get; set; }
  Public String  CreditContact { get; set; }
  Public String  BGEStatusID { get; set; }
  Public String Description  { get; set; }
  Public String CustomerTypeID { get; set; }
  Public String  ClassCode { get; set; }
  Public String URL  { get; set; }
  Public String Industry { get; set; }
  Public String StockSymbol  { get; set; }
  Public String ExtranetID { get; set; }
  Public String ZipCode { get; set; }
  Public String VarCode { get; set; }
  Public String Priority { get; set; }
  Public String CreditLimit { get; set; }
  Public String TaxExemptCode  { get; set; }
  Public String TaxExemptEprDate { get; set; }
  Public String TaxID  { get; set; }
  Public String PaymentTermCode { get; set; }
  Public String CredAllowAmt { get; set; }
  Public String CredAllowPercent { get; set; }
  Public String CredAllowID { get; set; }
  Public String YearsInBusiness { get; set; }
  Public String CreditRequested { get; set; }
  Public String BusinessType { get; set; }
  Public String BillToProfileID { get; set; }
  Public String ShipToProfileID { get; set; }
  Public String HasSpecialPricing { get; set; }
  Public String SecurityEnabled { get; set; }
  Public String CustomerSourceID  { get; set; }
  Public String CustomerSourceRefNo  { get; set; }
  Public String BGECode { get; set; }
  Public String RepState { get; set; }
  Public String BSDRep { get; set; }
  Public String MainAccountNumber  { get; set; }
  Public String ODAccountNumber { get; set; }
  Public String ODAcctNoTagDate { get; set; }
  Public String ShopperTypeID { get; set; }
  Public String CreditLimitDisplay { get; set; }
  Public String CreditContactDisplay { get; set; }
  Public String SicCode { get; set; }
  Public String DWCompanyID { get; set; }
  Public String LPTATypeID { get; set; }
  Public String BSDPunchoutDefault { get; set; }
  Public String UseThirdPartyFreight { get; set; }


}

public class Address { 
public  String ShopperProfileID  { get; set; } 
public  String ProfileName  { get; set; } 
public  String ShopperID  { get; set; } 
public  String IsPrimary  { get; set; } 
public  String BGEAccountNumber  { get; set; } 
public  String ProfileTypeID  { get; set; } 
public  String Company  { get; set; } 
public  String FName  { get; set; } 
public  String LName  { get; set; } 
public  String MName  { get; set; } 
public  String Street1  { get; set; } 
public  String Street2   { get; set; } 
public  String City  { get; set; } 
public  String State  { get; set; } 
public  String Zip  { get; set; } 
public  String Phone1  { get; set; } 
public  String Phone2   { get; set; } 
public  String Fax1   { get; set; } 
public  String Country  { get; set; } 
public  String EnterDate  { get; set; } 
public  String EndDate  { get; set; } 
public  String Fax2   { get; set; } 
public  String SequenceNumber  { get; set; } 
public  String AddressType  { get; set; } 
 }


public class Contact {

    public  String CustomerID  { get; set; } 
    public  String ContactID  { get; set; } 
    public  String ContactTypeID  { get; set; } 
    public  String ShopperID  { get; set; } 
    public  String FName  { get; set; } 
    public  String LName  { get; set; } 
    public  String MName  { get; set; } 
    public  String Street1  { get; set; } 
    public  String Street2   { get; set; } 
    public  String City  { get; set; } 
    public  String State  { get; set; } 
    public  String Zip  { get; set; } 
    public  String Phone1  { get; set; } 
    public  String Phone2   { get; set; } 
    public  String Fax   { get; set; } 
    public  String Country   { get; set; } 
    public  String Email  { get; set; } 
    public  String DoNotMail  { get; set; } 
    public  String Title  { get; set; } 
    public  String ContactStatusID  { get; set; } 
    public  String EnterDate  { get; set; } 
    public  String Buyer  { get; set; } 
    public  String Role  { get; set; } 
    public  String Phone1Ext   { get; set; } 
    public  String Phone2Ext   { get; set; } 
    public  String Cell   { get; set; } 
    public  String Pager   { get; set; } 
    public  String ShopperTypeID  { get; set; } 
    public  String Password  { get; set; } 
    public  String FullName  { get; set; } 
    public  String BillToProfileID  { get; set; } 
    public  String ShipToProfileID  { get; set; } 
    public  String ShopperActive  { get; set; } 
    public  String ShopperAction  { get; set; } 
    public  String CreateBillingAddress  { get; set; } 
    public  String CreateShippingAddress  { get; set; } 
 


}



public class OrderHeader {
  public  String CustOrderNo  { get; set; } 
    public  String OrderType  { get; set; } 
    public  String OrderStatus  { get; set; } 
    public  String Email  { get; set; } 
    public  String ShopperID  { get; set; } 
    public  String BasketID  { get; set; } 
    public  String ShipToCity  { get; set; } 
    public  String ShipToState  { get; set; } 
    public  String ShipToZip  { get; set; } 
    public  String BillToProfileID  { get; set; } 
    public  String ShipToProfileID  { get; set; } 
    public  String EnterDate  { get; set; } 
    public  String ShipMethod  { get; set; } 
    public  String BGEPO  { get; set; } 
    public  String Billed  { get; set; } 
    public  String HandlingTotal  { get; set; } 
    public  String HandlingTax  { get; set; } 
    public  String HandlingTotalDisplay  { get; set; } 
    public  String OrderStatusID  { get; set; } 
    public  String BilledTotal  { get; set; } 
    public  String ShipToSearch  { get; set; } 
}

public static string getValueFromXMLString(string xmlString, string keyField, integer location){
    string valueFound ='';
    if(xmlString.contains('<' + keyField +'>') && xmlString.contains('</' + keyField +'>')){
      try{
          valueFound = xmlString.substring(xmlString.indexOf('<' + keyField +'>', location) + keyField.length() + 2,
            xmlString.indexOf('</' + keyField +'>', location));   
        }catch (exception e){
            ////system.debug('Error in getValueFromXMLString.  Details:' + e.getMessage() +' keyfield:' + keyfield);
        }           
    }
    return valueFound;
}
public static string getValueFromXMLString(string xmlString, string keyField){
    string valueFound ='';
     integer location =0;
    if(xmlString.contains('<' + keyField +'>') && xmlString.contains('</' + keyField +'>')){
      try{
          valueFound = xmlString.substring(xmlString.indexOf('<' + keyField +'>', location) + keyField.length() + 2,
            xmlString.indexOf('</' + keyField +'>', location));   
        }catch (exception e){
            ////system.debug('Error in getValueFromXMLString.  Details:' + e.getMessage() +' keyfield:' + keyfield);
        }           
    }
    return valueFound;
}
   public List<Customer> parseCustomers(String reader) {
     List<Customer> Customers = new List<Customer>();
     String str=getValueFromXMLString(reader,'Customer',0 );
          Customer customer= parseCustomer(str) ;
                Customers.add(customer);
    return Customers;
   }

   Customer parseCustomer(String reader) {
     Customer customer= new Customer();
     
     
customer.CustomerID = getValueFromXMLString(reader,'CustomerID'); 
customer.CompanyName = getValueFromXMLString(reader,'CompanyName');
////system.debug('CompanyName ='+customer.CompanyName);
customer.EnterDate = getValueFromXMLString(reader,'EnterDate'); 
customer.SalesRepName = getValueFromXMLString(reader,'SalesRepName'); 
customer.CreditContact = getValueFromXMLString(reader,'CreditContact');
customer.BGEStatusID = getValueFromXMLString(reader,'BGEStatusID');
customer.Description = getValueFromXMLString(reader,'Description');
customer.CustomerTypeID = getValueFromXMLString(reader,'CustomerTypeID');
customer.ClassCode = getValueFromXMLString(reader,'CustomerTypeID');
customer.URL = getValueFromXMLString(reader,'URL');
customer.Industry = getValueFromXMLString(reader,'Industry');
customer.StockSymbol = getValueFromXMLString(reader,'StockSymbol');
customer.ExtranetID = getValueFromXMLString(reader,'ExtranetID');
customer.ZipCode = getValueFromXMLString(reader,'ZipCode');
customer.VarCode = getValueFromXMLString(reader,'VarCode');
customer.Priority = getValueFromXMLString(reader,'Priority');
customer.CreditLimit = getValueFromXMLString(reader,'CreditLimit');
customer.TaxExemptCode = getValueFromXMLString(reader,'TaxExemptCode');
customer.TaxExemptEprDate = getValueFromXMLString(reader,'TaxExemptEprDate');
customer.TaxID  = getValueFromXMLString(reader,'TaxID'); 
customer.PaymentTermCode  = getValueFromXMLString(reader,'PaymentTermCode'); 
customer.CredAllowAmt  = getValueFromXMLString(reader,'CredAllowAmt'); 
customer.CredAllowPercent  = getValueFromXMLString(reader,'CredAllowPercent'); 
customer.CredAllowID  = getValueFromXMLString(reader,'CredAllowID'); 
customer.YearsInBusiness  = getValueFromXMLString(reader,'YearsInBusiness'); 
customer.CreditRequested  = getValueFromXMLString(reader,'CreditRequested'); 
customer.BusinessType  = getValueFromXMLString(reader,'BusinessType'); 
customer.BillToProfileID  = getValueFromXMLString(reader,'BillToProfileID'); 
customer.ShipToProfileID  = getValueFromXMLString(reader,'ShipToProfileID'); 
customer.HasSpecialPricing  = getValueFromXMLString(reader,'HasSpecialPricing'); 
customer.SecurityEnabled  = getValueFromXMLString(reader,'SecurityEnabled'); 
customer.CustomerSourceID  = getValueFromXMLString(reader,'CustomerSourceID'); 
customer.CustomerSourceRefNo  = getValueFromXMLString(reader,'CustomerSourceRefNo'); 
customer.BGECode  = getValueFromXMLString(reader,'BGECode'); 
customer.RepState  = getValueFromXMLString(reader,'RepState'); 
customer.BSDRep  = getValueFromXMLString(reader,'BSDRep'); 
customer.MainAccountNumber  = getValueFromXMLString(reader,'MainAccountNumber'); 
customer.ODAccountNumber  = getValueFromXMLString(reader,'ODAccountNumber'); 
customer.ODAcctNoTagDate  = getValueFromXMLString(reader,'ODAcctNoTagDate'); 
customer.ShopperTypeID  = getValueFromXMLString(reader,'ShopperTypeID'); 
customer.CreditLimitDisplay  = getValueFromXMLString(reader,'CreditLimitDisplay'); 
customer.CreditContactDisplay  = getValueFromXMLString(reader,'CreditContactDisplay'); 
customer.SicCode  = getValueFromXMLString(reader,'SicCode'); 
customer.DWCompanyID  = getValueFromXMLString(reader,'DWCompanyID'); 
customer.LPTATypeID  = getValueFromXMLString(reader,'LPTATypeID'); 
customer.BSDPunchoutDefault  = getValueFromXMLString(reader,'BSDPunchoutDefault'); 
customer.UseThirdPartyFreight  = getValueFromXMLString(reader,'UseThirdPartyFreight'); 

     return customer;
   }
   
   
     public List<Address> parseAddresses(String reader) {
     List<Address> Addresses = new List<Address>();
      integer i=0;
      String xvar='Addresses';
     String str=getValueFromXMLString(reader,xvar,0 );
       
     while(str.length()>1)
     {
       
               Address address= parseAddress(str) ;
                Addresses.add(address);
                ////system.debug('i='+i+' :');

                i= reader.indexOf('</' + xvar+'>', 0)+3+xvar.length();
                ////system.debug('   '+reader.length()+'Before' +i);
                reader=reader.substring(i);
                ////system.debug('   '+reader.length()+'After');
                                               //  //system.debug('i='+i+' :' + reader);
                str=getValueFromXMLString(reader,xvar,0 );
                                
       }         
                 ////system.debug('Addresses ='+Addresses.size()); 
    return Addresses ;
   }
     @TestVisible
     Address parseAddress(String reader) {
     Address address= new Address();
     
     
address.ShopperProfileID = getValueFromXMLString(reader,'ShopperProfileID'); 
address.ProfileName = getValueFromXMLString(reader,'ProfileName');
address.ShopperID = getValueFromXMLString(reader,'ShopperID'); 
address.IsPrimary  = getValueFromXMLString(reader,'IsPrimary'); 
address.BGEAccountNumber = getValueFromXMLString(reader,'BGEAccountNumber');
address.ProfileTypeID  = getValueFromXMLString(reader,'ProfileTypeID');
address.Company  = getValueFromXMLString(reader,'Company');
address.FName  = getValueFromXMLString(reader,'FName');
address.LName  = getValueFromXMLString(reader,'LName');
address.MName  = getValueFromXMLString(reader,'MName');
address.Street1  = getValueFromXMLString(reader,'Street1');
address.Street2 = getValueFromXMLString(reader,'Street2');
address.City  = getValueFromXMLString(reader,'City');
address.State  = getValueFromXMLString(reader,'State');
address.Zip  = getValueFromXMLString(reader,'Zip');
address.Phone1  = getValueFromXMLString(reader,'Phone1');
address.Phone2 = getValueFromXMLString(reader,'Phone2');
address.Fax1 = getValueFromXMLString(reader,'Fax1');
address.Country  = getValueFromXMLString(reader,'Country'); 
address.EnterDate = getValueFromXMLString(reader,'EnterDate'); 
address.EndDate  = getValueFromXMLString(reader,'EndDate'); 
address.Fax2 = getValueFromXMLString(reader,'Fax2'); 
address.SequenceNumber  = getValueFromXMLString(reader,'SequenceNumber'); 
address.AddressType  = getValueFromXMLString(reader,'AddressType'); 

     return address;
   }
   
   
     public List<Contact> parseContacts(String reader) {
     List<Contact> contacts= new List<Contact>();
      integer i=0;
      String xvar='Contacts';
     String str=getValueFromXMLString(reader,xvar,0 );
       
     while(str.length()>1)
     {
       
               Contact contact= parseContact(str) ;
                contacts.add(contact);
                ////system.debug('i='+i+' :');

                i= reader.indexOf('</' + xvar+'>', 0)+3+xvar.length();
                ////system.debug('   '+reader.length()+'Before' +i);
                reader=reader.substring(i);
                ////system.debug('   '+reader.length()+'After');
                                               //  //system.debug('i='+i+' :' + reader);
                str=getValueFromXMLString(reader,xvar,0 );
                                
       }         
                
    return contacts;
   }
   
   @TestVisible
    Contact parseContact(String reader) {
     Contact contact= new Contact();
   contact.CustomerID= getValueFromXMLString(reader,'CustomerID');
contact.ContactID= getValueFromXMLString(reader,'ContactID');
contact.ContactTypeID= getValueFromXMLString(reader,'ContactTypeID');
contact.ShopperID= getValueFromXMLString(reader,'ShopperID');
contact.FName= getValueFromXMLString(reader,'FName');
contact.LName= getValueFromXMLString(reader,'LName');
contact.MName= getValueFromXMLString(reader,'MName');
contact.Street1= getValueFromXMLString(reader,'Street1');
contact.Street2= getValueFromXMLString(reader,'Street2');
contact.City= getValueFromXMLString(reader,'City');
contact.State= getValueFromXMLString(reader,'State');
contact.Zip= getValueFromXMLString(reader,'Zip');
contact.Phone1= getValueFromXMLString(reader,'Phone1');
contact.Phone2= getValueFromXMLString(reader,'Phone2');
contact.Fax= getValueFromXMLString(reader,'Fax');
contact.Country= getValueFromXMLString(reader,'Country');
contact.Email= getValueFromXMLString(reader,'Email');
contact.DoNotMail= getValueFromXMLString(reader,'DoNotMail');
contact.Title= getValueFromXMLString(reader,'Title');
contact.ContactStatusID= getValueFromXMLString(reader,'ContactStatusID');
contact.EnterDate= getValueFromXMLString(reader,'EnterDate');
contact.Buyer= getValueFromXMLString(reader,'Buyer');
contact.Role= getValueFromXMLString(reader,'Role');
contact.Phone1Ext= getValueFromXMLString(reader,'Phone1Ext');
contact.Phone2Ext= getValueFromXMLString(reader,'Phone2Ext');
contact.Cell= getValueFromXMLString(reader,'Cell');
contact.Pager= getValueFromXMLString(reader,'Pager');
contact.ShopperTypeID= getValueFromXMLString(reader,'ShopperTypeID');
contact.Password= getValueFromXMLString(reader,'Password');
contact.FullName= getValueFromXMLString(reader,'FullName');
contact.BillToProfileID= getValueFromXMLString(reader,'BillToProfileID');
contact.ShipToProfileID= getValueFromXMLString(reader,'ShipToProfileID');
contact.ShopperActive= getValueFromXMLString(reader,'ShopperActive');
contact.ShopperAction= getValueFromXMLString(reader,'ShopperAction');
contact.CreateBillingAddress= getValueFromXMLString(reader,'CreateBillingAddress');
contact.CreateShippingAddress= getValueFromXMLString(reader,'CreateShippingAddress');
   return contact;
   }
   
   
     public List<OrderHeader> parseOrderHeaders(String reader) {
     List<OrderHeader> ordhdrs= new List<OrderHeader>();
      integer i=0;
      String xvar='OrderHeader';
     String str=getValueFromXMLString(reader,xvar,0 );
       
     while(str.length()>1)
     {
       
               OrderHeader ohdr= parseOrderHeader(str) ;
                ordhdrs.add(ohdr);
                ////system.debug('i='+i+' :');

                i= reader.indexOf('</' + xvar+'>', 0)+3+xvar.length();
                ////system.debug('   '+reader.length()+'Before' +i);
                reader=reader.substring(i);
                //system.debug('   '+reader.length()+'After');
                                               //  //system.debug('i='+i+' :' + reader);
                str=getValueFromXMLString(reader,xvar,0 );
                                
       }         
                
    return ordhdrs;
   }
   
   public List<OrderItems> parseOrderItems (String reader, String value)
   {
   
      
        List<OrderItems> orddtls= new List<OrderItems>();
      integer i=0;
      
      
      system.debug(reader.IndexOf(value) + '  value');
      
        system.debug(reader.length() + '  len');
        
        
  //  system.debug(reader.substring(reader.IndexOf(value), reader.IndexOf(value)));
      
    //   reader= '';
     if(reader.indexOf(value)<=0)
      return orddtls;
      String xvar='OrderItems';
        
        
    // reader=  reader.substring((reader.substring(0, reader.IndexOf(value)).lastIndexOf(xvar)-1),((reader.substring(reader.lastIndexOf(value)).IndexOf(xvar)+xvar.length()+1)-(reader.substring(0, reader.IndexOf(value)).lastIndexOf(xvar)-1) )  );
     
  reader=  ( reader.substring((reader.substring(0, reader.IndexOf(value)).lastIndexOf(xvar)-1),reader.lastIndexOf(value)+(reader.substring(reader.lastIndexOf(value)).IndexOf(xvar))+xvar.length()+1));
      
//rawData=rawData.substring(rawData.IndexOf( pfodid )-1000, rawData.lastIndexOf( pfodid )+1000 );
     
     String str=getValueFromXMLString(reader,xvar,0 );
       
     while(str.length()>1)
     {     if(str.indexOf(value)>0)
            {
               OrderItems oddr= parseOrderItem(str) ;
                orddtls.add(oddr);
                }
                ////system.debug('i='+i+' :');

                i= reader.indexOf('</' + xvar+'>', 0)+3+xvar.length();
                ////system.debug('   '+reader.length()+'Before' +i);
                reader=reader.substring(i);
                //system.debug('   '+reader.length()+'After');
                                               //  //system.debug('i='+i+' :' + reader);
                str=getValueFromXMLString(reader,xvar,0 );
                
                                
       }         
                
    return orddtls;
   
   }
   
   @TestVisible
    OrderHeader parseOrderHeader (String reader) {
     OrderHeader ordrHdr= new OrderHeader ();
   ordrHdr.CustOrderNo = getValueFromXMLString(reader,'CustOrderNo');
ordrHdr.OrderType = getValueFromXMLString(reader,'OrderType');
ordrHdr.OrderStatus = getValueFromXMLString(reader,'OrderStatus');
ordrHdr.Email = getValueFromXMLString(reader,'Email');
ordrHdr.ShopperID = getValueFromXMLString(reader,'ShopperID');
ordrHdr.BasketID = getValueFromXMLString(reader,'BasketID');
ordrHdr.ShipToCity = getValueFromXMLString(reader,'ShipToCity');
ordrHdr.ShipToState = getValueFromXMLString(reader,'ShipToState');
ordrHdr.ShipToZip = getValueFromXMLString(reader,'ShipToZip');
ordrHdr.BillToProfileID = getValueFromXMLString(reader,'BillToProfileID');
ordrHdr.ShipToProfileID = getValueFromXMLString(reader,'ShipToProfileID');
ordrHdr.EnterDate = getValueFromXMLString(reader,'EnterDate');
ordrHdr.ShipMethod = getValueFromXMLString(reader,'ShipMethod');
ordrHdr.BGEPO = getValueFromXMLString(reader,'BGEPO');
ordrHdr.Billed = getValueFromXMLString(reader,'Billed');
ordrHdr.HandlingTotal = getValueFromXMLString(reader,'HandlingTotal');
ordrHdr.HandlingTax = getValueFromXMLString(reader,'HandlingTax');
ordrHdr.HandlingTotalDisplay = getValueFromXMLString(reader,'HandlingTotalDisplay');
ordrHdr.OrderStatusID = getValueFromXMLString(reader,'OrderStatusID');
ordrHdr.BilledTotal = getValueFromXMLString(reader,'BilledTotal');
ordrHdr.ShipToSearch = getValueFromXMLString(reader,'ShipToSearch');
return ordrHdr;
   }
   
     @TestVisible
     OrderItems parseOrderItem (String reader) {
     OrderItems ordrItem= new OrderItems();
   ordrItem.CustOrderNo     = getValueFromXMLString(reader,'CustOrderNo');
 ordrItem.c4ssku    = getValueFromXMLString(reader,'c4ssku');
 ordrItem.productid     = getValueFromXMLString(reader,'productid');
 ordrItem.mfgsku    = getValueFromXMLString(reader,'mfgsku');
 ordrItem.qty   = getValueFromXMLString(reader,'qty');
 ordrItem.SalePrice     = getValueFromXMLString(reader,'SalePrice');
 ordrItem.ShipAmt   = getValueFromXMLString(reader,'ShipAmt');
 ordrItem.TaxAmt    = getValueFromXMLString(reader,'TaxAmt');
 ordrItem.ShipTaxAmt    = getValueFromXMLString(reader,'ShipTaxAmt');
 ordrItem.ProductName   = getValueFromXMLString(reader,'ProductName');
 ordrItem.IsBackOrdered     = getValueFromXMLString(reader,'IsBackOrdered');
 ordrItem.Returnable    = getValueFromXMLString(reader,'Returnable');
 ordrItem.WarrantyCode      = getValueFromXMLString(reader,'WarrantyCode');
 ordrItem.SkuTypeId     = getValueFromXMLString(reader,'SkuTypeId');
  ordrItem.mfgname      = getValueFromXMLString(reader,'mfgname');
 ordrItem.catlev1   = getValueFromXMLString(reader,'catlev1');
 ordrItem.catlev2   = getValueFromXMLString(reader,'catlev2');
 ordrItem.Cat1Name      = getValueFromXMLString(reader,'Cat1Name');
 ordrItem.Cat2Name      = getValueFromXMLString(reader,'Cat2Name');
 ordrItem.Status    = getValueFromXMLString(reader,'Status');
 ordrItem.OrderItemStatusID     = getValueFromXMLString(reader,'OrderItemStatusID');
 ordrItem.ItemID    = getValueFromXMLString(reader,'ItemID');
 ordrItem.ItemPrice     = getValueFromXMLString(reader,'ItemPrice');
 ordrItem.ItemTax   = getValueFromXMLString(reader,'ItemTax');
 ordrItem.ItemShipping      = getValueFromXMLString(reader,'ItemShipping');
 ordrItem.ItemCost      = getValueFromXMLString(reader,'ItemCost');
 ordrItem.ExtCost   = getValueFromXMLString(reader,'ExtCost');
 ordrItem.ExtPrice      = getValueFromXMLString(reader,'ExtPrice');
 ordrItem.MarginDollar      = getValueFromXMLString(reader,'MarginDollar');
 ordrItem.MarginPercent     = getValueFromXMLString(reader,'MarginPercent');
 ordrItem.IsBackOrder   = getValueFromXMLString(reader,'IsBackOrder');
return ordrItem;
   }
}