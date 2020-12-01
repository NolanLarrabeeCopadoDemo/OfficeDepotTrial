//Created_by:Shravya channa
//Last_ModifeidBy:Shravya Channa
//Date:09/28/2018
public class submitCaseController {
    
    @AuraEnabled 
    public static User fetchLoginUserDetails() {
       User oUser = [select id,Name,Email,Phone from User where Id =: UserInfo.getUserId()];
       return oUser;
        }
    
    @AuraEnabled
    public static case saveCase(case objCase) {  
      String conid;
      String Accid;
      User u=[select id,contactid,contact.accountid,Email from user where id=:UserInfo.getUserId() limit 1]; 
      RecordType objRecType = [SELECT Id,Name,SobjectType FROM RecordType where DeveloperName='Channel_Partner' And sobjectType = 'Case' limit 1]; 
      objCase.RecordTypeId=objRecType.id;
      objCase.SuppliedEmail=u.Email;
      objCase.Via_Partner_Community__c=TRUE;
      objCase.Origin=label.Support_Origin;
      conid=u.contactid;
      Accid=u.contact.accountid;
      if(conid!=Null && Accid!=null ) {
          objCase.AccountId=Accid;
          objCase.ContactId=conid;
          }
      insert objCase;
      system.debug('@@@caseobject'+objCase);
      case oReturnCase = [select id,CaseNumber From Case Where Id = :objCase.Id];
      return oReturnCase;
      }
    
   
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
      List < String > allOpts = new list < String > ();
      Schema.sObjectType objType = objObject.getSObjectType();
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
      list < Schema.PicklistEntry > values =
      fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
      allOpts.sort();
      return allOpts;
       }   
}