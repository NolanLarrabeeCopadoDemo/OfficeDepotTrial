global class SessionValidationService {
  
  webservice static String  getOrgId(){
    return UserInfo.getOrganizationId();
  }
  
  @isTest
  private static void Test_getOrgId() {
    SessionValidationService.getOrgId();
  }
}