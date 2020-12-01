public class CTRestInteractor {
  private static final String CTREST = 'http://www.clicktools.com/dashboard/rest/';

  /**
   * Asynchronous method for updating an Account to have a unique URL to
   * link it to a set of question responses in Clicktools. This is done
   * by creating a blank response to a particular survey instance
   * (aka instance)
   * @param id the Id of the Account object to be updated
   * @param instanceId1 the id of the 1st Clicktools survey instance
   * @param instanceId2 the id of the 2nd Clicktools survey instance
   */

  // As this is an external HTTP request, the method must be run
  // asynchronously from APEX therefore it is labelled 'Future'
  public static void uniqueURLCreator(String id, String instanceId1, String instanceId2) {
     
    /****************************
    
     Second survey is no longer used.
     
    // Second survey - the first survey relies on this
    HttpRequest req2 = new HttpRequest();
    req2.setEndpoint(CTREST + 'addnewresponse?instance_id=' + instanceId2);
    req2.setMethod('GET');
    Http http2 = new Http();
    HttpResponse res2 = http2.send(req2);
    if (res2.getStatusCode() == 200) {
      String url2 = res2.getBody();
    ****************************************/
    
    // Can now get the URL for the first survey
    HttpRequest req1 = new HttpRequest();
    // pre-populate question 1 with the unique URL for the second
    // survey in order to allow easy navigation later
    req1.setEndpoint(CTREST + 'addnewresponse?instance_id=' + instanceId1);  // no longer used:   + '&q1=' + EncodingUtil.urlEncode(url2, 'UTF-8'));
    req1.setMethod('GET');
    Http http1 = new Http();
    HttpResponse res1 = http1.send(req1);
    
    if (res1.getStatusCode() == 200) {
      // everything is OK, now we can update the Account object
      String url1 = res1.getBody();
      Account acc = new Account(Id=id);
      acc.Setup_URL1__c = url1;
      // no longer used:  acc.Setup_URL2__c = url2;

    try {
          update acc;
        } catch (Exception e) {
          // needed to catch excecptions for recursive calls to a
          // futures method
        }
    } else {
        System.debug('Callout failed! Couldn\'t get unique for account ' + id + ' from instanceId1 ' + instanceId1 + ': ' + res1);
    }

    /****************************
    
     Second survey is no longer used.

    } else {
      System.debug('Callout failed. Could not get unique for account ' + id + ' from instanceId2 ' + instanceId2 + ': ' + res2);
    }
    *****************************/
  }
  
  
  @isTest 
  private static void testuniqueURLCreator() {   
try {  
     Account account =  Test_Utils.CreateAccount();
     String accid = account.Id;  
     Test.startTest();
     CTRestInteractor.uniqueURLCreator(accid, 'lguesqjuh01ly', null);
     Test.stopTest();      
}catch(Exception e){} //handle exception	 
  } 
}