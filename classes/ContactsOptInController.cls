public class ContactsOptInController {
  @AuraEnabled
  //public ID contId {get;set;} 
  //public List<contactData> cntdatalist;
  //public List<contactData> cntphndatalist; 
  public static List<contact> getContacts(ID contId, String Type) {
      List<contact> cntdatalist = new list<contact>();
      List<contact> cntchpdatalist = new list<contact>();
      List<contact> cntphndatalist = new list<contact>();
      List<contact> cntmdatalist = new list<contact>();
      List<contact> cntndatalist = new list<contact>();
      List<contact> cntsocialdatalist = new list<contact>();
    //public ID contId {get;set;}
    //contId = ApexPages.currentPage().getParameters().get('id');
    For (contact c: [SELECT Id, Direct_Mail__c, D_M_OptIn__c,channel_preference__c, E_OptIn1__c, E_OptIn2__c, E_OptIn3__c, Email1__c, Email2__c, Email3__c, Phone1__c, Phone2__c, Phone3__c,
            		 P_OptIn1__c, P_OptIn2__c, P_OptIn3__c, Acxiom_Full_Name__c,NPX_Linkedin_Profile__c
                 	 FROM Contact where Id =: contId]) {
  //When adding to if-else statement make sure the API name is exactly the same (case sensitive)// 
                         if (c.Email1__c !=null ) {
                             Contact ced = new Contact();
                             ced.Email1__c=c.Email1__c;
                             ced.E_OptIn1__c=c.E_OptIn1__c;
                             cntdatalist.add(ced);   
                         }
                         if (c.Email2__c != null) {
                             Contact ced = new Contact();
                             ced.Email1__c=c.Email2__c;
                             ced.E_OptIn1__c=c.E_OptIn2__c;
                             cntdatalist.add(ced);
                         }
                         if (c.Email3__c != null) {
                             Contact ced = new Contact();
                             ced.Email1__c=c.Email3__c;
                             ced.E_OptIn1__c=c.E_OptIn3__c;
                             cntdatalist.add(ced);
                         }
                         
                         if (c.Email1__c == null && c.Email2__c == null && c.Email3__c == null) {
                             Contact ced = new Contact();
                             ced.Email1__c='Data Not Available';
                             //ced.E_OptIn1__c='N/A';
                             cntdatalist.add(ced);
                         }
                         
                         if (c.Phone1__c !=null ) {
                             contact cpd = new contact();
                             cpd.Phone1__c=c.Phone1__c;
                             cpd.P_OptIn1__c=c.P_OptIn1__c;
                             cntphndatalist.add(cpd);
                         }
                         if (c.Phone2__c != null ) {
                             contact cpd = new contact();
                             cpd.Phone1__c=c.Phone2__c;
                             cpd.P_OptIn1__c=c.P_OptIn2__c;
                             cntphndatalist.add(cpd);
                         }
                         if (c.Phone3__c != null ) {
                             contact cpd = new contact();
                             cpd.Phone1__c=c.Phone3__c;
                             cpd.P_OptIn1__c=c.P_OptIn3__c;
                             cntphndatalist.add(cpd);
                         }
                         
                         if (c.Phone1__c == null && c.Phone3__c == null && c.Phone2__c == null) {
                             Contact cpd = new Contact();
                             cpd.Phone1__c='Data Not Available';
                             //cpd.P_OptIn1__c='N/A';//'Y
                             cntphndatalist.add(cpd);
                         }
                         
                         if (c.Direct_Mail__c !=null) {
                             contact cmd = new contact();
                             cmd.Direct_Mail__c=c.Direct_Mail__c;
                             cmd.D_M_OptIn__c=c.D_M_OptIn__c;
        
                             cntmdatalist.add(cmd);
                         }
                         
                         if (c.Direct_Mail__c == null) {
                             contact cmd = new contact();
                             cmd.Direct_Mail__c='Data Not Available';
                             //cmd.D_M_OptIn__c='Y';
                             cntmdatalist.add(cmd);
                         }
                         
                         if (c.Acxiom_Full_Name__c !=null) {
                             contact cnd = new contact();
                             cnd.Acxiom_Full_Name__c=c.Acxiom_Full_Name__c;
                             //cmd.D_M_OptIn__c=c.DM_OptIn__c;
        
                             cntndatalist.add(cnd);
                         }
                         
                         if (c.Acxiom_Full_Name__c == null) {
                             contact cnd = new contact();
                             cnd.Acxiom_Full_Name__c='Data Not Available';
                             //cmd.D_M_OptIn__c='Y';
                             cntndatalist.add(cnd);
                           
                         } 
                         if (c.Channel_Preference__c != null){
                             contact chpf =new contact();
                             chpf.Channel_Preference__c = c.Channel_Preference__c;
                             cntchpdatalist.add(chpf);
                         }
                         else
                         {
                             contact chpf = new contact();
                             chpf.Channel_Preference__c='Data Not Available';
                             cntchpdatalist.add(chpf);   
                         }
                         
                         if (c.NPX_Linkedin_Profile__c != null){
                             contact cns =new contact();
                             cns.NPX_Linkedin_Profile__c = c.NPX_Linkedin_Profile__c;
                             cntsocialdatalist.add(cns);
                         }
                         else
                         {
                             contact cns = new contact();
                             cns.NPX_Linkedin_Profile__c='Data Not Available';
                             cntsocialdatalist.add(cns);   
                         }
      If (Type == 'phone') {return cntphndatalist;}
                         
      else If (Type == 'email') { return cntdatalist; }
      
      else If (Type == 'directmail') {return cntmdatalist; }  //If (Type == 'directmail')
      else If (Type == 'channelpreference') {return cntchpdatalist; }
      else If (Type == 'social') {return cntsocialdatalist;}
      else {return cntndatalist;}
}
      return null;
  } 
}