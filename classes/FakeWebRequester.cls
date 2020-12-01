@isTest
public with sharing class FakeWebRequester extends WebRequester {
    public List<String> queuedResponses = new List<String>();
    
    public void clearQueuedResponses(){
        queuedResponses.clear();
    }
    
    public void queueResponse(String response){
        queuedResponses.add(response);
    }
        
	public override String post(String url, String body){
        System.debug('Removing the first of '+queuedResponses.size()+' responses');
        return queuedResponses.remove(0);
    }
}