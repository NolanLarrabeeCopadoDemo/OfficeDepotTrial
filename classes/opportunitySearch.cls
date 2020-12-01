global class opportunitySearch{ 
   webService static String getFieldValues()
   {
      System.debug('---------INVOKING WEBSERVICE------------');
      /*  String pickValues='';
       for( Schema.PicklistEntry f : Opportunity.Primary_Competitor__c.getDescribe().getPicklistValues())
       {
           pickValues = pickValues +f.getValue()+'+';
       }  
       
       System.debug('---------------------'+pickValues );
       
       return pickValues ; */
      String competetiors='';
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [select id, CompanyName,LanguageLocaleKey from User where id =:currentUserId];
        if(currentUser.CompanyName == 'Grand & Toy' && currentUser.LanguageLocaleKey == 'en_US') {
            for(Canada_Opportunity_Competitor__c c: Canada_Opportunity_Competitor__c.getall().values())
            {
                competetiors = competetiors+'+'+c.Canada_Competetior__c;
            }
        }
        else if(currentUser.CompanyName == 'Grand & Toy' && currentUser.LanguageLocaleKey == 'fr'){
            system.debug('@@@@@@@@@@@@french');
            for(Canada_Opportunity_Competitor__c c: Canada_Opportunity_Competitor__c.getall().values())
            {
                competetiors = competetiors+'+'+c.Canada_Competetior_FR__c;
            }
        }
        else {
            for(Opportunity_Competitor__c c: Opportunity_Competitor__c.getall().values())
            {
                competetiors = competetiors+'+'+c.Competetior__c;
            }
        }
       
       return competetiors ;
       
   }
}