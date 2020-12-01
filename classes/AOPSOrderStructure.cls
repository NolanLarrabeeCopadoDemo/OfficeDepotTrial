public class AOPSOrderStructure {

    public String timeStamp;
    public String documentid;
    public OrderHeader Header;
    public OrderRequest Request;
    

	public class OrderHeader {
        public String Sender;
        public String CustomerID;
        public String Comments;
        public String DropShip;
        public String Returnable;
        public String BillOnly;
        public String ShipComplete;
        public ShipToAddress ShipTo;        
    }
    
    public class OrderRequest {
        public String OrderType;
        public OrderAccounting Accounting;
        public Payment Payment;
        public ItemDetail Detail;
    }
    
    public class ShipToAddress {
    	  public AddressSeq Addr;
    }
    
    public class AddressSeq {
        public String seq;
        public ContactInfo Contact;
    }
    
    public class ContactInfo {
        public String Name;
        public CustomerEmail Email;
        public CustomerPhone PhoneNumber;
    }
    
    public class CustomerEmail {
        public String body;
    }
    
    public class CustomerPhone {
        public String CustomerPhoneNumber;
    }

    public class OrderAccounting {
        public String CostCenter;
        public String Desktop;
        public String Release;
        public PONumber PONumber;
    }
    
    public class PONumber {
        public String body;
    }
    
    public class Payment {
        public String method;
    }
    
    public class ItemDetail {
        public OrderTotals Totals;
        public List<ItemInfo> Item;
    }
    
    public class OrderTotals {
        public String Delivery;
        public String Total;
        public String SubTotal;
    }
    
    public class ItemInfo {
    	public String LineNumber;
        public String CustomerLineNumber;
        public String Sku;
        public String VendorID;
        public String Qty;
        public String UnitPrice;
        public String ListPrice;
        public String Cost;
        public String UnitOfMeasure;
        public String Description;
        public String Units;
        public String VendorPack;
        public String MerchClass;
        public String Taxable;
        public String CatalogPage;
        public String ManufacturerID;
        public String ManufacturerPartNum;
        public String QuoteID;
    }
}