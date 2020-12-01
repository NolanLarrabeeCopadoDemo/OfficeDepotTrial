/**
* @author Rajendra Shahane, rajendra.shahane@officedepot.com
* @date 09/16/2020
*
* 
* @description This class methods are used by marketing360gmiltab LWC component to display and search Indivisual Email Result related to current account contacts
*              
*               test class => marketing360GMILController_Test class
* Created for JIRA: NAIT-148002 03049086 - Display Marketing Data in Customer 360/GMIL
*/
public class marketing360GMILController {
@AuraEnabled(cacheable=true)
    //public static Map <String,list<et4ae5__IndividualEmailResult__c>> getContactDetails(string accountId,string aopsCustId) {
    public static Map <String,list<et4ae5__IndividualEmailResult__c>> getContactDetails(string accountId) {
        Map <String,list<et4ae5__IndividualEmailResult__c>> mapContactEmailRes;
        datetime dtToday = datetime.now().adddays(-14);
        if(label.Marketing360_Past_Contact_Activity_Days != null)
        {
            if(label.Marketing360_Past_Contact_Activity_Days.isNumeric())
            {
                
                dtToday = datetime.now().adddays(integer.valueOf(label.Marketing360_Past_Contact_Activity_Days) * -1);
            }
        }
        datetime dtmodified = datetime.newInstance(dtToday.year(), dtToday.month(), dtToday.day());        
		for(et4ae5__IndividualEmailResult__c emailResult: [select Id,Sample_Email_Link__c, Name,et4ae5__Contact__r.Name,et4ae5__Opened__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c,et4ae5__Clicked__c,et4ae5__NumberOfTotalClicks__c,VIWB__c  
                                                           from et4ae5__IndividualEmailResult__c where AccountId__c =:accountId 
                                                           and lastmodifieddate >= :dtmodified order by lastmodifieddate desc])
        {
            if(mapContactEmailRes == null )	mapContactEmailRes = new Map <String,list<et4ae5__IndividualEmailResult__c>>();
            if(!mapContactEmailRes.containsKey(emailResult.et4ae5__Contact__r.Name))
            {
                if(mapContactEmailRes.size() < 10) 
                {
                    
                    mapContactEmailRes.put(emailResult.et4ae5__Contact__r.Name, new list<et4ae5__IndividualEmailResult__c>{emailResult});
                }
            }
            else	mapContactEmailRes.get(emailResult.et4ae5__Contact__r.Name).add(emailResult);                
        }
        
        system.debug('accountId ' + accountId);
        //system.debug('aopsCustId ' + aopsCustId);
        system.debug('mapContactEmailRes ' + mapContactEmailRes);	
        return mapContactEmailRes;
    }
    
    @AuraEnabled
    public static Map <String,list<et4ae5__IndividualEmailResult__c>> searchContactDetails(string accountId, string strContactName) {
        //strContactName += '%';
        Map <String,list<et4ae5__IndividualEmailResult__c>> mapContactEmailRes;
        datetime dtToday = datetime.now().adddays(-14);
        if(label.Marketing360_Past_Contact_Activity_Days != null)
        {
            if(label.Marketing360_Past_Contact_Activity_Days.isNumeric())
            {
                
                dtToday = datetime.now().adddays(integer.valueOf(label.Marketing360_Past_Contact_Activity_Days) * -1);
            }
        }
        datetime dtmodified = datetime.newInstance(dtToday.year(), dtToday.month(), dtToday.day());
        /*for(et4ae5__IndividualEmailResult__c emailResult : [select Id, Name,et4ae5__Contact__r.Name,et4ae5__Opened__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c,et4ae5__Clicked__c,et4ae5__NumberOfTotalClicks__c,VIWB__c  
                                                           from et4ae5__IndividualEmailResult__c where AccountId__c =:accountId and  
                                                            et4ae5__Contact__r.name like :strContactName 
                                                            and lastmodifieddate >= :dtmodified order by lastmodifieddate desc])*/
        for(et4ae5__IndividualEmailResult__c emailResult : [select Id,Sample_Email_Link__c, Name,et4ae5__Contact__r.Name,et4ae5__Opened__c,et4ae5__HardBounce__c,et4ae5__SoftBounce__c,et4ae5__Clicked__c,et4ae5__NumberOfTotalClicks__c,VIWB__c  
                                                           from et4ae5__IndividualEmailResult__c where AccountId__c =:accountId and  
                                                            lastmodifieddate >= :dtmodified order by lastmodifieddate desc])
        {
            if(mapContactEmailRes == null )	mapContactEmailRes = new Map <String,list<et4ae5__IndividualEmailResult__c>>();
            string strName = emailResult.et4ae5__Contact__r.Name.toUpperCase();
            if(strName.startsWith(strContactName.toUpperCase()))
            {
                if(!mapContactEmailRes.containsKey(emailResult.et4ae5__Contact__r.Name))
                {
                    if(mapContactEmailRes.size() < 10) 
                    {
                        
                        mapContactEmailRes.put(emailResult.et4ae5__Contact__r.Name, new list<et4ae5__IndividualEmailResult__c>{emailResult});
                    }
                }
                else	mapContactEmailRes.get(emailResult.et4ae5__Contact__r.Name).add(emailResult);
            }            
        }
        system.debug('accountId ' + accountId);
        //system.debug('aopsCustId ' + aopsCustId);
        system.debug('strContactName ' + strContactName);
        system.debug('mapContactEmailRes ' + mapContactEmailRes);	
        return mapContactEmailRes;
    }
}