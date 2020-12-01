public with sharing class fanaticUtil {

     public List<FanaticXmlReader.OrderHeader> orderHdr  = new List<FanaticXmlReader.OrderHeader>();
     
     public List<FanaticXmlReader.OrderItems > orderItems { get; set;      }     
     public List<FanaticXmlReader.OrderHeader> orderHdrInv { get; set;      }
      public List<FanaticXmlReader.OrderHeader> orderHdrQuote { get; set;       }
        public List<FanaticXmlReader.OrderHeader> orderHdrInv1 = new List<FanaticXmlReader.OrderHeader>();
      public List<FanaticXmlReader.OrderHeader> orderHdrQuote1 = new List<FanaticXmlReader.OrderHeader>();
      public string selectedoh {set; get;}
      public Decimal[] months = new Decimal[] {0,0,0,0,0,0,0,0,0,0,0,0};
  public fanaticUtil() {
             if(ApexPages.currentPage().getparameters().get('fid') != null)
             {
                 pvar = ApexPages.currentPage().getparameters().get('fid');
                 process_data();
             }
    }
    public String resData { get; set; }

    public PageReference getData() {
    System.debug('-----picst---'+picst);
     process_data();
        return null;
    }
 public String datadebug{ get; set; }
    public String pvar='';
    public String piqty { get; set; }

    public String pisk { get; set; }

    public String selected_value { get; set; }

    public String selected_option { get; set; }

    public String picst { get; set; }
   public List<FanaticXmlReader.Address> addresses  { get; set; }
   
   public FanaticXmlReader.Customer customer { get; set; }
    public List<FanaticXmlReader.Contact>  contacts { get; set; }
    public void process_data() {
    try {
    if(picst!=null && picst.trim()!='' )
      pvar=picst; 
    FanaticnetWS.FanaticOperation o = new FanaticnetWS.FanaticOperation();

o.OperationName='GETCOMPANY';
 o.OperationKey='704784272';
//o.OperationKey='03114000';
o.OperationKey=pvar;
o.OperationKeyType ='BGECUSTOMERNUMBER';
//o.OperationKeyType ='CUSTORDERNO';
o.DataType='eLiveData';
 FanaticnetWS.FanaticOperation[]  ao= new  FanaticnetWS.FanaticOperation[1];
     ao[0]=o;

FanaticnetWS.ArrayOfFanaticOperation af =  new FanaticnetWS.ArrayOfFanaticOperation();
af.FanaticOperation=ao;


FanaticnetWS.FanaticOperationList ol = new  FanaticnetWS.FanaticOperationList();
ol.OperationList = af;
ol.ModuleName='LPTA';
ol.OperationType='eLoad';
ol.Compressed=false;
ol.Guid=' ' ;
ol.ServResult=' ';

   FanaticProcessWS.FanaticTechDepotProcess_pt y =  new FanaticProcessWS.FanaticTechDepotProcess_pt();
String rawData = '';
if(!Test.IsRunningTest())
rawData=y.process(ol);
rawData=rawData.replace('&lt;', '<');
rawData=rawData.replace('&gt;', '>');
XmlStreamReader xsr = new XmlStreamReader(rawData);

System.debug('rawData= '+rawData);

FanaticXmlReader xr = new FanaticXmlReader();

FanaticXmlReader.Customer[] custs= xr.parseCustomers(rawData);
 System.debug(custs.size());

    for (FanaticXmlReader.Customer cust: custs) {
 //     System.debug('Custid='+cust.CompanyName);
      customer =cust;
// resData =cust.CompanyName+' ' +cust.CustomerID;
     }
     
//resData =custs.size()+'';


o.OperationName='GETADDRESSES';
if(!Test.IsRunningTest())
rawData = y.process(ol);

rawData=rawData.replace('&lt;', '<');
rawData=rawData.replace('&gt;', '>');
//System.debug('rawData1= '+rawData);

addresses= xr.parseAddresses(rawData);
//system.debug('addresses inside ='+addresses[0].ShopperProfileID); 
o.OperationName='GETCONTACTS';
if(!Test.IsRunningTest())
rawData = y.process(ol);

rawData=rawData.replace('&lt;', '<');
rawData=rawData.replace('&gt;', '>');
//System.debug('rawData2= '+rawData);
 contacts= xr.parseContacts(rawData);
 o.OperationName='GETORDERHEADERS';
 if(!Test.IsRunningTest())
 rawData = y.process(ol);
 rawData=rawData.replace('&lt;', '<');
rawData=rawData.replace('&gt;', '>');

orderHdr = xr.parseOrderHeaders(rawData);

/*BEGIN:Code added to fix the issue mentioned on Case#00155226*/
orderHdrInv1.clear();
months.clear();
months= new Decimal[] {0,0,0,0,0,0,0,0,0,0,0,0};
/*END:Code added to fix the issue mentioned on Case#00155226*/

 for (FanaticXmlReader.OrderHeader c: orderHdr )  {
        FanaticXmlReader.OrderHeader oh = new FanaticXmlReader.OrderHeader(); 
         oh =c;
         /*added the below line for case#00180564 */
         oh.billed = String.valueOf(decimal.valueof(oh.billed)/100);    
     if(c.OrderType == 'Quote')
     { 
         orderHdrQuote1.add(oh);
                  
     }
     else
        {
         orderHdrInv1.add(oh) ;
         System.debug('******orderHdrInv1*********'+oh);
         /*commented the below lines for case#00180564 */
         /*if(oh.EnterDate.substring(0,4)=='2013')
         {
         if(oh.EnterDate.substring(5,7)=='01')
       months[0]= months[0]+ decimal.valueOf(oh.Billed)/100 ;
       if(oh.EnterDate.substring(5,7)=='02')
        months[1]= months[1]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='03')
        months[2]= months[2]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='04')
        months[3]= months[3]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='05')
        months[4]= months[4]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='06')
        months[5]= months[5]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='07')
        months[6]= months[6]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='08')
        months[7]= months[7]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='09')
        months[8]= months[8]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='10')
        months[9]= months[9]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='11')
        months[10]= months[10]+ decimal.valueOf(oh.Billed)/100 ;
         if(oh.EnterDate.substring(5,7)=='12')
        months[11]= months[11]+ decimal.valueOf(oh.Billed)/100 ;
        
        }
        */ 
        if(oh.EnterDate.substring(0,4)=='2013')
         {
         if(oh.EnterDate.substring(5,7)=='01')
       months[0]= months[0]+ decimal.valueOf(oh.Billed) ;
       if(oh.EnterDate.substring(5,7)=='02')
        months[1]= months[1]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='03')
        months[2]= months[2]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='04')
        months[3]= months[3]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='05')
        months[4]= months[4]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='06')
        months[5]= months[5]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='07')
        months[6]= months[6]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='08')
        months[7]= months[7]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='09')
        months[8]= months[8]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='10')
        months[9]= months[9]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='11')
        months[10]= months[10]+ decimal.valueOf(oh.Billed) ;
         if(oh.EnterDate.substring(5,7)=='12')
        months[11]= months[11]+ decimal.valueOf(oh.Billed) ;
        
        }
         }
        
        }
orderHdrQuote = orderHdrQuote1;
orderHdrInv = orderHdrInv1;

getDatag();
     }
     
     
    catch (Exception ce) {
    //  display_result_panel = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
    }
    }
    
    
     // Return a list of data points for a chart
    public List<Data> getDatag() {
        return getChartData();
    }
    
    
    
     public PageReference getOrderDetails() {
  
  PageReference p = new PageReference('/apex/FanaticDtl');
  p.getParameters().put('fid',pvar);
    p.getParameters().put('fodid',selectedoh);
 return p;
     
   //  return null;
//resData =custs.size()+'';
}
    
 
    // The actual chart data; needs to be static to be
    // called by a @RemoteAction method
    public List<Data> getChartData() {
        List<Data> data = new List<Data>();
        if(data.size()>0)
        data.clear();
        Data d1 = new Data();
        d1.name ='Jan';
        d1.data1 = months[0];
        data.add(d1);
        
           Data d2 = new Data();
        d2.name ='Feb';
        d2.data1 = months[1];
        
        data.add(d2);
           Data d3 = new Data();
        d3.name ='Mar';
        d3.data1 = months[2];
        data.add(d3);
           Data d4 = new Data();
        d4.name ='Apr';
        d4.data1 = months[3];
        
        data.add(d4);
           Data d5 = new Data();
        d5.name ='May';
      d5.data1 = months[4];
        
        data.add(d5);
       
           Data d6 = new Data();
        d6.name ='Jun';
        d6.data1 = months[5];
        data.add(d6);
           Data d7 = new Data();
        d7.name ='Jul';
        d7.data1 =months[6];
        
        data.add(d7);
           Data d8 = new Data();
        d8.name ='Aug';
        d8.data1 = months[7];
        data.add(d8);
           Data d9 = new Data();
        d9.name ='Sep';
        d9.data1 =months[8];
        data.add(d9);
           Data d10 = new Data();
        d10.name ='Oct';
        d10.data1 =months[9];
        data.add(d10);
           Data d11 = new Data();
        d11.name ='Nov';
        d11.data1 = months[10];
        data.add(d11);
           Data d12 = new Data();
        d12.name ='Dec';
        d12.data1 = months[11];
        data.add(d12);
        
        
        
   
        return data;
    }
    
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public Double data1 { get; set; }
      
    }
    
}