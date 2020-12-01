/**
 * Filter Feed Items for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 */
 // Modified  - S-401328- commented code body to remove inactive trigger from coverage class
trigger BlacklistWordFilterOnPost on FeedItem (before insert) 
{
 /*if((UserInfo.getUserId() != '005E0000003HO2X')&&(UserInfo.getUserId() != '005E0000000SJyw')&&(UserInfo.getUserId() != '005E0000004wF7k')&&(UserInfo.getUserId() != '005E00000023ms4IAA')&&(UserInfo.getUserId() !='005E0000000lNbVIAU')){
     new BlacklistFilterDelegate().filterFeedItems(trigger.new);
  }*/
}