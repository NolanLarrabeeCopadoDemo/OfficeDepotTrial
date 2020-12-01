public with sharing class GPOSiteTemplate1ConExt {

     //private GPO_Group_Detail__c[] news {get; set;}
    private string GPOId; 
    public List<GPO_Group_Detail__c> newsItems {get; set;} //TODO news need to be moved into the controller extention
    GPOCommunityAuthLandingController authCon;
     
    public GPOSiteTemplate1ConExt(GPOCommunityLandingController cont) {
    	 
        
       //Modified by ivarada for pre login news item default
       //GPOId = String.valueOf(cont.selectedGroup.ID);
       gpo_group__c g = [select id from gpo_group__c where GPO_Template__c = :cont.commSetup.defaultTemplate__c AND RecordTypeID = :cont.commSetup.defaultRecordType__c];
       GPOId = g.id;
       pupulateNews(GPOId);
    }
    
    public GPOSiteTemplate1ConExt(GPOCommunityAuthLandingController cont) {
        GPOId = String.valueOf(cont.selectedGroup.ID);
        authCon = cont;
        pupulateNews(GPOId);
    }
    
    private void pupulateNews(string GPOid){    
        newsItems = [Select id, Name__c, Value1__c, Value2__c from GPO_Group_Detail__c where type__c = 'News' AND GPO_Group__c =: GPOid order by name Limit 4];  
    }
    
    
    public PageReference NewsSave()    //This class will take the input from the user and update the corresponding CaseComments
    { 
        update(newsItems);
        PageReference returnPage = authCon.save();
        return returnPage;
    }  
    
    
    public PageReference Cancel()   
    {         
        return null;
    }  
    
    public List<GPO_Group_Detail__c> getNewsItems() {
        return newsItems;
    }
    
    // Create community with community details, details can be template specific
    public PageReference enableCommunityWithTemplateDetails(){
            
       //TODO - add security check to validate that the right GPO admin is requesting the enable community function.  
       //otherwise an error should be returned.  Also this should check that the user is a GPO admin based on profile.  
      
       if ( ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('up') == null) {
           // TODO - Display meanifull error message to user, this should redirect to one of the site standard error pages instead of returning null
          return null;
       } else {
          //Create base community elements
          PageReference pageAfterCreate = authCon.enablecommunity();

          List<GPO_Group_Detail__c> news = [ SELECT ID, Name,Name__c,Type__c,Value1__c,Value2__c FROM GPO_Group_Detail__c where GPO_Group__c =: authCon.defaultTemplateGroup.ID ];
          List<GPO_Group_Detail__c> newNews = new List<GPO_Group_Detail__c>();
          For(GPO_Group_Detail__c newsItem: news) {
               GPO_Group_Detail__c newNewsItem = new GPO_Group_Detail__c();
               newNewsItem.Name = newsItem.Name + ApexPages.currentPage().getParameters().get('id');
               newNewsItem.Name__c = newsItem.Name__c;
               newNewsItem.Type__c = newsItem.Type__c;
               newNewsItem.Value1__c = newsItem.Value1__c;
               newNewsItem.Value2__c = newsItem.Value2__c;
               newNewsItem.GPO_Group__c = authCon.newEnabledGroup.id;
               newNews.add(newNewsItem);
          }           
          upsert newNews;
          return pageAfterCreate;
        }
    }
     
}