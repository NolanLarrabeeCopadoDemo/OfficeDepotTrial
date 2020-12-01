public with sharing class fanaticDtlCntlr {

     
     public List<FanaticXmlReader.OrderItems > orderItems { get; set;      }     
   public string selectedoh {set; get;}
    public fanaticDtlCntlr() {
             if(ApexPages.currentPage().getparameters().get('fid') != null)
             {
                 pfid = ApexPages.currentPage().getparameters().get('fid');
                 pfodid = ApexPages.currentPage().getparameters().get('fodid');
                 process_data();
             }
    }
    public String resData { get; set; }

    public PageReference getData() {
     process_data();
        return null;
    }
 public String datadebug{ get; set; }
    public String pfid='';
    public String pfodid='';
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
      pfid =picst; 
    FanaticnetWS.FanaticOperation o = new FanaticnetWS.FanaticOperation();

o.OperationName='GETCOMPANY';
 //o.OperationKey='704784272';
//o.OperationKey='03114000';
o.OperationKey=pfid;
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


//System.debug('rawData= '+rawData);

FanaticXmlReader xr = new FanaticXmlReader();
o.OperationName='GETORDERITEMS';
 String rawData = y.process(ol);
 rawData=rawData.replace('&lt;', '<');
rawData=rawData.replace('&gt;', '>');
System.debug('First: '+rawData.IndexOf( pfodid ));
System.debug('LAst: '+rawData.lastIndexOf( pfodid ));
orderItems = xr.parseOrderItems(rawData,pfodid);



     }
     
     
    catch (Exception ce) {
    //  display_result_panel = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
    }
    }
    
    
     // Return a list of data points for a chart
    
    
    
    
}