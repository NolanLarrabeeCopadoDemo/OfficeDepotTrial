public class COM_NewsCredInfo {
    private String serviceEndpoint= 'http://awsnwssqpcmb01.elasticbeanstalk.com/newsservice/v1/articles/';
    public String Response { get; set;}
    public String Headers { get; set; }
 
 public class NewsCredHdr{
     public   String title  { get; set;}
        public    String link { get; set;}
        public    String guid { get; set;}
        
       public NewsCredHdr()
       {}
        
       public NewsCredHdr(String t, String l, String g)
        {
            title= t;
            link= l;
            guid= g;
        }
        
    }
  
    public COM_NewsCredInfo () {
        if (!Test.isRunningTest()) {
         GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default'); 
         serviceEndpoint = commSetup.NewsCred_URL__c;
        }
    }
    public void fetchData() {
        getAndParse(ApexPages.currentPage().getParameters().get('id'),null,null);
    }

  public NewsCredHdr getAndParse(String objectId,String pageID,integer seq) 
  {

    // Get the XML document from the external server
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(serviceEndpoint+objectId+'/');
 
    req.setMethod('GET');
    HttpResponse res = http.send(req);

    System.debug(res.getBody());
  JSONParser parser = JSON.createParser(res.getBody());
    String xx= '';
    String title='';
    String guid ='';
    String link ='';
while (parser.nextToken() != null) 
 {
       if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
         {
        String fieldName = parser.getText();
         if(parser.getText()== 'guid' )
                { 
                  parser.nextToken();
                  guid= parser.getText();
                  system.debug('GUID:'+guid);
                }
             else
                if(fieldName == 'thumbnail' )
                   { 
                       parser.nextToken();
                       
                       if(parser.getCurrentToken() == JSONToken.START_OBJECT)
                        {

                            while(parser.nextToken() != null)
                                {
            
                                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
                                       {
                                            
                                          //if(parser.getText()== 'original_image' )
                                          if(parser.getText()== 'link' )
                                            { 
                                               
                                              parser.nextToken();
                                              link= parser.getText()+'?width=150&height=100';
                                              if (link != null)
                                                  link = link.replace('?width=75&height=75', '');
                                                system.debug('Image Link:' + link);
                                             }        
                                        }

                                   if(parser.getCurrentToken() == JSONToken.END_OBJECT)
                                       {
                                           break; 
                                       }
                                }
       
                         }   
                     }
                   else if(fieldName == 'title')
                         {
                             parser.nextToken();
                             title = parser.getText();
                             system.debug('TITLE:'+title);
                         }
     }

}
String coremetricString = 'Communities-_-'+pageId+'-_-Tile'+seq;
//guid = 'https://business.officedepot.com/article/prelogin/govhub/'+guid+'?cm_sp='+coremetricString;
guid = 'https://business.officedepot.com/article/prelogin/govhub/'+objectId+'?cm_sp='+coremetricString;
NewsCredHdr result = new NewsCredHdr(title ,link,guid);

return result ;
  }
}