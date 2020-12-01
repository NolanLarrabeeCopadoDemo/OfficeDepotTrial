public class Process_B2B_Orders {
    
    public static void ProcessOrderStatus( String httpBody) {
        String aopsOrderNumber = '';
        String aopsOrderStatus = '';
        
        System.debug('In ProcessOrderStatus, httpBody =>' + httpBody);
        try {
        Map<String,Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(httpBody);
        List<Order_Header__c> lstOfORders = new List<Order_Header__c> ();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');        
        System.debug('Reached here 1');
        Map<String,Object> odPurchaseIDMAp = (Map<String,Object>)resultMap.get('ODPurchaseOrder');
        System.debug('Reached here 2');
        String orderID = (String)odPurchaseIDMAp.get('@documentid');
        System.debug('Reached here 3==='+ orderID);
        Map<String,Object> responseMap = (Map<String,Object>)odPurchaseIDMAp.get('Response');
        Map<String,Object> statusMap = (Map<String,Object>)responseMap.get('Status');
        String statusCode = (String) statusMap.get('Code');
        System.debug('Reached here 4=>' + statusCode);
        if (statusCode == '00') { // If success, order created in AOPS
            List<Object> detailList = (List<Object>)responseMap.get('Detail');
            Map<String,Object> firstDetail = (Map<String,Object>) detailList.get(0);
            Map<String,Object> ordDetailMap = (Map<String,Object>)firstDetail.get('OrderDetails');
            aopsOrderNumber = (String) ordDetailMap.get('OrderNumber');
            aopsOrderStatus = (String) ordDetailMap.get('OrderStatus');
        }
        
        if(httpBody == null || orderID == null) {
            res.statusCode=400;
            res.responseBody= Blob.valueOf('The Document ID does not exist in Salesforce. Please contact a Salesforce Administrator');

        } else {
            System.debug('Reached here 5');
            Order_Header__c qo =[select id, JSON_From_AOPS__c, AOPS_Order_Number__c, AOPS_Order_Status__c from Order_Header__c where id=: orderID limit 1];
            qo.JSON_From_AOPS__c = httpBody;
            qo.AOPS_Order_Number__c = aopsOrderNumber;
            qo.AOPS_Order_Status__c = aopsOrderStatus;
            lstOfORders.add(qo);
            system.debug('the list of order headers is:'+lstOfORders);
            if(lstOfORders.size() > 0) {
                res.responseBody= Blob.valueOf('The Order is updated in Salesforce');
                res.statusCode=200;
                update lstOfORders;
                system.debug('the updated order is'+lstOfORders);
            } 
        }
        }catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
        }
    }
}