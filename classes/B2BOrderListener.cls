/* Created by: Shravya channamadhavuni
* Created date : Jan 09 2020
* Purpose: For Tech Sales Project to recieve error and success messages from B2B
**/
@RestResource(urlMapping='/B2BMessages/*')
global without sharing class B2BOrderListener {
    @HttpPost  
    global static void getOrderStatus() {
    	System.debug('In get order status=>');
        RestRequest req = RestContext.request;
       	Process_B2B_Orders.ProcessOrderStatus(req.requestBody.toString());
    }
}