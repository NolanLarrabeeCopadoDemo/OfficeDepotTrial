public class OverlayListViewExtension {
  private final Account account = null;
  
  public List<AccountTeamMember> lstAccountTeamMember {get;set;}
  
  public OverlayListViewExtension(ApexPages.StandardController controller)
  {
    account = (Account)controller.getRecord();
    lstAccountTeamMember = LoadAccountTeamMembersForChildAccounts();
  }
  
  public List<AccountTeamMember> LoadAccountTeamMembersForChildAccounts()
  {     
    return [SELECT id, user.phone, User.Name, user.Short_Title__c, user.Manager__c, user.OD_Employee_ID__c, user.Region__c, user.Market__c,  User.UserRole.Name, Account.Name,TeamMemberRole FROM AccountTeamMember 
                            WHERE AccountId = :account.Id 
                            Order By Account.Name, User.Name];
  }
  
  @AuraEnabled
  public static List<AccountTeamMember> getAccountTeamMembers (String accountId)
  {
      return [SELECT Id, User.Phone, User.Name, User.Short_Title__c, User.Manager__c, User.OD_Employee_ID__c, User.Region__c, user.Market__c,  User.UserRole.Name, Account.Name, TeamMemberRole
                FROM AccountTeamMember 
                WHERE AccountId = :accountId 
                Order By Account.Name, User.Name];
  }
  
  @isTest
  private static void testOverlayListViewExtension() {
    User testUser = [select id,Roleid__c from user where isActive = true And profile.userLicense.name = 'Salesforce' /*AND isRoleChanged__c = false*/ limit 1];       
    
    System.runAs(testUser){            
        Account prospectAccount = Test_Utils.CreateAccount();
        Account siteAccount = Test_Utils.createAccount ('Site');
        insert siteAccount;
        
        siteAccount.Related_Account__c = prospectAccount.id;
        update siteAccount;
        
        AccountTeamMember accountTeamMember = Test_Utils.createAccountTeamMember(prospectAccount, testUser);
        List<AccountTeamMember> accountTeamMembers = getAccountTeamMembers(prospectAccount.Id);
                    
        ApexPages.StandardController controller = new ApexPages.StandardController(prospectAccount);
        OverlayListViewExtension overlayListView = new OverlayListViewExtension(controller);
        
        System.assertEquals(overlayListView.lstAccountTeamMember[0].accountId, prospectAccount.id);
        System.assertEquals(overlayListView.lstAccountTeamMember[0].userId, testUser.id); 
    }    
  }
}