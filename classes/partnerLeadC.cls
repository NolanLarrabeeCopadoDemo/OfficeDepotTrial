public class partnerLeadC { 
    public static lead newlead {get;set;}
    @AuraEnabled
    public static Map<String,String> initLead(String tempcode,String check) {
        system.debug('==>check is:'+check);
        Map<String,String> linkedinTmplst = new Map<String,String>();
        Map<String,String> facebookTmplst = new Map<String,String>();
        Map<String,String> googleTmplst = new Map<String,String>();
        Map<String,String> mapToBRtrnd = new Map<String,String>();
        if(check=='linkedin') {
            system.debug('==>Maps size is'+linkedinTmplst.size()+ 'of return values from Linkedin callout:'+linkedinTmplst);
            linkedinTmplst=PartnerRegistrationLinkedin.getAccessTokenLinkedin(tempcode);
        } else if(check=='facebook') {
            system.debug('==>Maps size is'+facebookTmplst.size()+'of return values from Facebook callout:'+facebookTmplst);
            facebookTmplst=PartnerRegistrationFacebook.getAccessTokenFacebook(tempcode);   
        } else if (check=='google') {
            system.debug('==>Maps size is'+googleTmplst.size()+ 'of return values from Google callout:'+googleTmplst);
            googleTmplst=PartnerRegistrationGoogle.getAccessTokenGoogle(tempcode);   
        }
        if(linkedinTmplst.size()!=0) {
            mapToBRtrnd.putall(linkedinTmplst); 
        } else if(facebookTmplst.size()!=0) {
            mapToBRtrnd.putall(facebookTmplst);    
        } else if (googleTmplst.size()!=0) {
            mapToBRtrnd.putall(googleTmplst);  
        }
        system.debug('map that we need to send'+mapToBRtrnd);
        return mapToBRtrnd;
    }
    /// state picklist method
    @AuraEnabled
    public static List<String> getPicklistValues(sObject objObject, String fieldName) 
    {
        return ODCommonUtilityMethods.getPicklistOptions(objObject, fieldName);
    }

    @AuraEnabled
    public static String saveLead(Lead l) {
        try {
            system.debug(l.company);
            system.debug('lead address==>'+l.address);
            List<String> idlst= new List<String>();
            List<User> usremail = new List<User>();
            List<String> emllst= new List<String>();
            Group queueID = [SELECT Id,name from group where type='Queue' and developername='Partner_Manager'];
            recordtype lr = [select id from recordtype where developername='Lead_Partner' and sobjecttype='lead'];
            l.recordtypeid=lr.id;
            l.country='USA';
            l.leadsource = 'Partner Registration Form';
            //QueueSObject qs = [SELECT Id, QueueId, SobjectType, CreatedById, SystemModstamp from QueueSObject where queueid=queue];
            l.ownerid=queueID.Id; 
            system.debug('==>lead is:'+l);
            insert l;
            return 'S';
        }
        catch (Exception e) {
            return e.getMessage();
        }
    }
    //Below method is used to get google api credentials from custom metadata type
    @AuraEnabled
    public static Partner_Registration_Google__mdt googleCred()
    {
        Partner_Registration_Google__mdt allCreds = [SELECT Auth_URL__c, ClientId__c, Secret__c, Token_URL__c FROM Partner_Registration_Google__mdt 
                                                     limit 1];
        return allCreds;
    }
    
    //Below method is used to get facebook api credentials from custom metadata type
    @AuraEnabled
    public static Facebook_Registration__mdt facebookCred()
    {
        Facebook_Registration__mdt allFB = [Select Facebook_ClientId__c, Facebook_Secret__c, Auth_Url__c, Token_Url__c, Access_Token_Url__c FROM Facebook_Registration__mdt
                                            Limit 1];
        return allFB; 
    }
    //Below method is used to get linkedin api credentials from custom metadata type
    @AuraEnabled
    public static Partner_Registration_Linkedin__mdt linkedinCred()
    {
        Partner_Registration_Linkedin__mdt allLnkdn = [select AuthURL__c,ClientId__c,Client_Secret__c,codeURL__c,tokenUrl__c,endpoint__c from Partner_Registration_Linkedin__mdt
                                                       Limit 1];
        return allLnkdn; 
    }
    //Added by Aravind to fetch events    
    @AuraEnabled
    public static List<PartnerEventsWrapper > getEvents() {       
        //return [Select    Name, Start_Date__c, Location__c, Start_Month__c, Start_Day__c, Start_Date_Format__c, Start_Date_Weekday__c, Start_Date_Year__c From Event__c ORDER BY End_Date__c DESC LIMIT 4 ];
        //return [Select    Name, Start_Date__c, Location__c, Start_Month__c, Start_Day__c, Start_Date_Format__c, Start_Date_Weekday__c, Start_Date_Year__c From Event__c ORDER BY End_Date__c DESC LIMIT 4 ];
        List<PartnerEventsWrapper> lstPartnerEvent = new List<PartnerEventsWrapper>();
        PartnerEventsWrapper objWrapper;
        
        string actDays = Label.days_active_post_expiry;
        integer intDays = Integer.ValueOf(actDays);
        date d = system.today().addDays(-intDays);
        for(event e: [select id, subject, location, StartDateTime, enddatetime, Profile_Name__c, recordtypeid  from event where enddatetime >= :d AND recordtype.name = 'Potential Partner Events' ORDER BY enddatetime LIMIT 4 ])
        {
            objWrapper = new PartnerEventsWrapper();
            objWrapper.name= e.subject;
            objWrapper.location = e.location;
            objWrapper.URL = e.Profile_Name__c;
            if(e.StartDateTime != null)
            {
                objWrapper.Start_Date_Format = string.valueof(e.StartDateTime.month()).leftpad(2,'0') + '.' + string.valueof(e.StartDateTime.day()).leftpad(2,'0') + '.' +  string.valueof(e.StartDateTime.year()).right(2);
                objWrapper.Start_Date_Weekday = e.StartDateTime.format('EEEE');
                objWrapper.Start_Date_Year = string.valueof(e.StartDateTime.year());
                objWrapper.Start_Day= string.valueof(e.StartDateTime.day()).leftpad(2,'0');
                objWrapper.Start_Month = e.StartDateTime.format('MMMMM');
                
                objWrapper.End_Date_Format = string.valueof(e.enddatetime.month()).leftpad(2,'0') + '.' + string.valueof(e.enddatetime.day()).leftpad(2,'0') + '.' +  string.valueof(e.enddatetime.year()).right(2);
                objWrapper.End_Date_Weekday = e.enddatetime.format('EEEE');
                objWrapper.End_Date_Year = string.valueof(e.enddatetime.year());
                objWrapper.End_Day= string.valueof(e.enddatetime.day()).leftpad(2,'0');
                objWrapper.End_Month = e.enddatetime.format('MMMMM');
            }
            lstPartnerEvent.add(objWrapper);
        }
        return lstPartnerEvent;
    }
    
    @AuraEnabled
    public static string getAddressAutoComplete(String input, String types) {
        return ODCommonUtilityMethods.getAddressAutoComplete(input, types);
    }
    
    @AuraEnabled
    public static string getAddressPlaceInfo(String input) {
        return ODCommonUtilityMethods.getAddressPlaceInfo(input);
    }

}