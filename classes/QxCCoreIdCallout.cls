/*
* 
*/
public class QxCCoreIdCallout {
    
    public static String ccoreId;
    public static final String CL = 'CL-';
    
    @future(callout = true)
    public static void getQueryResults(Id quoteId){
		Long timeStampStart = DateTime.now().getTime();
		System.debug('CPQ Core Generation - Start :'+ DateTime.now());		
        String authToken = QxGenerateAuthToken.generateAuthenticationToken();
        if(authToken != ''){
            String reqBody = 
                '<Request uniqueId="JBoss">'+
                authToken+
                '<DataRequest dataProvider="RESULT" queryName="GetLatestCCoreId"></DataRequest></Request>';
            webserviceSystemProsrmCom.SystemServiceHttpsSoap12Endpoint ws = new webserviceSystemProsrmCom.SystemServiceHttpsSoap12Endpoint();
            String res = ws.getQueryResults(reqBody);
			System.debug('CPQ Core Generation - Completed :'+ DateTime.now() + ' - ' + (DateTime.now().getTime()-timeStampStart) + 'ms ellapsed');
            System.debug('CPQ Core Generation - Res :'+res);
            System.debug('CPQ Core Generation - Res :'+res.indexOf('<RESULT><RESULT>'));
            ccoreId = res.substring(res.indexOf('<RESULT><RESULT>')+16, res.indexOf('<RESULT><RESULT>')+23);
            if(!ccoreId.startsWith('3')){
                ccoreId = '3000000';
            }
            CameleonCPQ__QxQuote__c qxQuote = [SELECT Id,CameleonCPQ__AccountId__c,CameleonCPQ__AccountId__r.Custom_Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id =: quoteId];
            //Account acc = qxQuote.CameleonCPQ__AccountId__r;
            qxQuote.Core_Id__c = CL+ccoreId;
            //acc.Custom_Core_Id__c = CL+ccoreId;
            putCCORE();
            System.debug('CPQ Core Generation - Core inserted :'+ DateTime.now() + ' - ' + (DateTime.now().getTime()-timeStampStart) + 'ms ellapsed');
            update qxQuote;
            System.debug('CPQ Core Generation - Quote Updated/ Core generation completed :'+ DateTime.now() + ' - ' + (DateTime.now().getTime()-timeStampStart) + 'ms ellapsed');			

            //update acc;
            
        }
    }
    
    public static void putCCORE(){
        List<interfacesPpssProsrmComXsd.CCORE> data = new List<interfacesPpssProsrmComXsd.CCORE>();
        data.add(new interfacesPpssProsrmComXsd.CCORE());
        data[0].CCORE_ID = 'CL-'+ccoreId;
        data[0].CCORE_DESC = 'CL-'+ccoreId;
        System.debug('Core Id:'+ccoreId);
        ProsCustomSettings__c pcs = ProsCustomSettings__c.getInstance('CCORE'); 
        
        Map<String, String> headersMap = new Map<String, String>();
        String authHttpHeader = 'Basic ' + EncodingUtil.base64Encode( Blob.valueOf( pcs.CCORE_Username__c + ':' + pcs.CCORE_Password__c ) );
        headersMap.put('Authorization', authHttpHeader );
        
        interfacesPpssProsrmCom.CCORE_InterfaceHttpSoap11Endpoint ccore = new interfacesPpssProsrmCom.CCORE_InterfaceHttpSoap11Endpoint();
        ccore.inputHttpHeaders_x = headersMap;
        interfacesPpssProsrmComXsd.Return_Status[] res = ccore.putCCORE(1,data);
        System.debug('CPQ Core Generation - Res :'+res);
    }
    
    /*@future
    public static void updateCustomCoreId(Id quoteId){
        CameleonCPQ__QxQuote__c qxQuote = [SELECT Id,CameleonCPQ__AccountId__c,CameleonCPQ__AccountId__r.Custom_Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id =: quoteId];
        qxQuote.Core_Id__c = qxQuote.CameleonCPQ__AccountId__r.Custom_Core_Id__c;
        update qxQuote;
    }*/
}