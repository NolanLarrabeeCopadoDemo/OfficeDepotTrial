@isTest
private class COM_NewsCredInfo_TC
{
    static testMethod void myUnitTest() 
    {
    COM_NewsCredInfo newCreds = new COM_NewsCredInfo ();
    
    COM_NewsCredInfo.NewsCredHdr hdr = new COM_NewsCredInfo.NewsCredHdr();
    COM_NewsCredInfo.NewsCredHdr hdr2 = new COM_NewsCredInfo.NewsCredHdr('a' , 'b' , 'c');
    String res = newCreds.Response;
    String hed = newCreds.Headers;
    try{
    newCreds.fetchData();
    }
    catch(exception ex){}
    }
}