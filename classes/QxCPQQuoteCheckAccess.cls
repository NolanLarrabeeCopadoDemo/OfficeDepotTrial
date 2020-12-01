/*
 * Author: Pavani Akula
 * Date: 07/25/2019
 * Description
*/
public class QxCPQQuoteCheckAccess {
    public static String currentProfile;
    public static Boolean isClone = false;
    public static Boolean checkPricingAnalyst(CameleonCPQ__QxQuote__c quote){
        if(currentProfile == null)
        currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;

        /*PROS_Access_Custom_Setting__c pricingAnalyst = PROS_Access_Custom_Setting__c.getInstance('Pricing Analyst_NO ACCESS');*/ 
        PROS_Access_Custom_Setting__c pricingAnalystAccess = PROS_Access_Custom_Setting__c.getInstance('Pricing Analyst_ACCESS'); 
        System.debug('currentProfile :'+pricingAnalystAccess.Profiles__c.contains(currentProfile));
        System.debug('currentProfile :'+quote.CameleonCPQ__Status__c);
        System.debug('currentProfile :'+quote.PricingAnalyst__c);
        if(pricingAnalystAccess.Profiles__c.contains(currentProfile) && quote.CameleonCPQ__Status__c != 'Fully Approved'  && quote.PricingAnalyst__c != null){
            System.debug('currentProfile');
            quote.addError('Can not clone when Status is not Fully Approved');
            return true;
        }
        /*if(pricingAnalyst.Profiles__c.contains(currentProfile) && quote.PricingAnalyst__c != null){
            System.debug('currentProfile :'+currentProfile);
            System.debug('currentProfile :'+quote);
            quote.addError('Can not edit when Pricing Analyst populated');
            return true;
        }*/
        return false;
    }
    
    public static void checkHostedFlag(List<CameleonCPQ__QxQuote__c> quotes, List<Id> accountIds){
        if(accountIds != null && !accountIds.isEmpty()){
            List<Account> accList = new List<Account>();
            Map<Id,Account> accMap = new Map<Id,Account>();
            accList =  [SELECT Id,Name,Hosted_Catalog_Flag__c FROM Account WHERE Id IN:accountIds ];
            for(Account acc : accList){
                accMap.put(acc.Id, acc);
            }
            if(currentProfile == null)
                currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
            PROS_Access_Custom_Setting__c hostedView = PROS_Access_Custom_Setting__c.getInstance('Hosted Flag_VIEW'); 
                    for(CameleonCPQ__QxQuote__c quote : quotes){
                        System.debug('Flag :'+accMap.get(quote.CameleonCPQ__AccountId__c).Hosted_Catalog_Flag__c);
                        if(hostedView.Profiles__c.contains(currentProfile) && !accMap.get(quote.CameleonCPQ__AccountId__c).Hosted_Catalog_Flag__c){
                            quote.addError(' Allowed to create a quote when the "Hosted Catalog" field on the Account is flagged');
                        }
                    }
        }
    }
    
    public static void checkQuoteStatus(CameleonCPQ__QxQuote__c quote){
        if(currentProfile == null)
        currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
       	PROS_Access_Custom_Setting__c inReviewView = PROS_Access_Custom_Setting__c.getInstance('In Review_VIEW'); 
        PROS_Access_Custom_Setting__c draftView = PROS_Access_Custom_Setting__c.getInstance('Draft_VIEW'); 
       
                if(inReviewView.Profiles__c.contains(currentProfile) && (quote.CameleonCPQ__Status__c == 'In Review') && !isClone){
                     quote.addError('Can not modify when Quote status is In Review');
                }
                else if(draftView.Profiles__c.contains(currentProfile) && quote.CameleonCPQ__Status__c != 'Draft' && !isClone ){
                    System.debug('currentProfile :'+currentProfile);
                    System.debug('currentProfile :'+quote.Name);

                    //quote.addError('Only allows to modify when Quote status is Draft');
                }
    }
}