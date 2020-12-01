public with sharing class ContactSearchController {
/**

  public String username ;
public  String password ;
    public void createMyAccount() {
     odf_acct = new OD_Foundation_Contact__c();
        
    }



    public String getMyPic() {
        return ConnectApi.ChatterUsers.getPhoto(null,'me').largePhotoUrl;
    }


    public Blob fileBody { get; set; }
   

    public OD_Foundation_Contact__c odf_contact { get; set;}
     public OD_Foundation_Contact__c odf_acct { get; set;}

    public String fileName { get; set; }

    public String Email { get; set; }

    public String Phone { get; set; }

    public String LastName { get; set; }

    public String FirstName { get; set; }

    public String AccountName { get; set; }

    public String msg { get; set; }
    public boolean display_event_selection {get;set;}
    
    public OD_Foundation_User__c ODFusr {get;set;}
    

   public ODFWinner winner{ get; set; }
   

    public String retUrl { get; set; }
    String  userId; 
    public Map<String,Boolean> pref_view_map {get;set;}
    public String[] events = new String[] {'Bass Fishing','Cooking','Deep Sea Fishing','Golf','Palm Beach International Raceway','Spa','Not participating in 2014','In-Shore Fishing','Homestead-Miami Speedway Racing'};
     
     public ODFCWrapper wrapper {get; set;}
      public  OD_Foundation_Contact__c fc {get; set;}
 
  public List<ODFCWrapper> wrappers {get; set;}
 public static Integer toDelIdent {get; set;}
 public static Integer addCount {get; set;}
 
 public ID EMAIL_TEMPLATE_ID; //PROD - 00XE0000000Dux9, UAT - 00XM0000000MGoa
 public static string  cendpoint = '';
 public PageReference save()
 {
  try
  {
  // New Code By Deepak - Fetching Record Types
   pagereference p = new pagereference('/apex/ODFHome#holderPrf');
 //Id uid = UserInfo.getUserId();
  //OD_Foundation_User__c ODFusr;
  

  
  //for (OD_Foundation_User__c u: [select id from OD_Foundation_User__c  where user__c = :uid limit 1 ])
   // ODFusr = u;
    
    
 // Service Call for creation Contact - starts
 partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
 String cid;
 partnerSoapSforceCom.LoginResult loginResult;
if (!Test.isRunningTest()){
 loginResult = sp.login(username, password);
system.debug('   loginResult ' + loginResult);
}
if (Test.isRunningTest()){
  loginResult = new partnerSoapSforceCom.LoginResult();
 loginResult.sessionId = '123456';
}
soapODFoundationContactWS.ODFoundationContactWS apexWebSvc = new soapODFoundationContactWS.ODFoundationContactWS();
soapODFoundationContactWS.SessionHeader_element sessionHeader = new soapODFoundationContactWS.SessionHeader_element();
sessionHeader.sessionId = loginResult.sessionId;
// The Web services have a maximum timeout of 2 minutes. The timeout value
// is in milliseconds.
apexWebSvc.timeout_x = 120000;
apexWebSvc.SessionHeader = sessionHeader;
 cid= apexWebSvc.addContact(odf_contact.LastName__c,odf_contact.FirstName__c,odf_contact.Email__c,odf_contact.Phone__c);
system.debug('   ' + cid);


// Service Call for creation Contact - ends

 /*if (ODFusr == null )
{

ODFusr = new OD_Foundation_User__c();
ODFusr.user__c = uid ;
insert ODFusr;
}*/
  //List<OD_Foundation_Contact__c> accs=new List<OD_Foundation_Contact__c>();
  /**ODFCWrapper wrap = new ODFCWrapper();
  //OD_Foundation_Contact__c fc1 = new OD_Foundation_Contact__c();

//system.debug('   prasad inside Conatct Account name' + odf_contact.AccountName__c );
 
 

 
    if(odf_contact.LastName__c!=null && odf_contact.Email__c!=null )
   if(( odf_contact.LastName__c.trim()!='' && odf_contact.Email__c.trim()!=''))
   {
   //&&((wrap.acc.Phone__c!=null && wrap.acc.Phone__c!='' )|| (wrap.acc.Email__c!=null && wrap.acc.Email__c!='' )) )
  
   
    odf_contact.OD_Foundation_User__c = ODFusr.Id;
 odf_contact.recordtypeid = rec_type_map.get('Contact');
 //upsert odf_contact;
   //call ws to create contact 
   // call commented by deepak
   

// New - added by deepak starts
      list <OD_Foundation_Contact__c> found_accounts = [SELECT ID 
                                                        from OD_Foundation_Contact__c 
                                                        where recordtype.name = 'Account'
                                                        and OD_Foundation_User__c = :ODFusr.Id
                                                        and AccountName__c = :odf_contact.AccountName__c
                                                       ];
       if (found_accounts.size() > 0) {
         system.debug ('Related Account Exists');
         odf_contact.related_account__c = found_accounts[0].ID;
       }
       else {
          system.debug ('New Account Creation Required');
          OD_Foundation_Contact__c acct_new = new OD_Foundation_Contact__c();
          acct_new.accountname__c = odf_contact.AccountName__c;
           acct_new.OD_Foundation_User__c = ODFusr.Id;
          acct_new.recordtypeid = rec_type_map.get('Account');
          insert acct_new;
          odf_contact.related_account__c = acct_new.id;
       }
  // New - added by deepak ends

odf_contact.contact__c=cid;
 upsert odf_contact; 
   }
 
  p.setRedirect(true);
  return p;
   }
    catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
        return null;
    }
 }
  
 public PageReference saveAcct()
 {
  // New Code By Deepak - Fetching Record Types
  pagereference p = new pagereference('/apex/ODFHome#holderPrf');
 /*Id uid = UserInfo.getUserId();
  OD_Foundation_User__c ODFusr;
  
  for (OD_Foundation_User__c u: [select id from OD_Foundation_User__c  where user__c = :uid limit 1 ])
    ODFusr = u;

 if (ODFusr == null )
{

ODFusr = new OD_Foundation_User__c();
ODFusr.user__c = uid ;
insert ODFusr;
}*//*
  //List<OD_Foundation_Contact__c> accs=new List<OD_Foundation_Contact__c>();
  ODFCWrapper wrap = new ODFCWrapper();
  //OD_Foundation_Contact__c fc1 = new OD_Foundation_Contact__c();

//system.debug('   prasad inside Conatct Account name' + odf_acct.AccountName__c );
 
 

 
    if(odf_acct.Accountname__C!=null  && odf_acct.Accountname__C.trim()!='' )
   {
   //&&((wrap.acc.Phone__c!=null && wrap.acc.Phone__c!='' )|| (wrap.acc.Email__c!=null && wrap.acc.Email__c!='' )) )
  
   
    odf_acct.OD_Foundation_User__c = ODFusr.Id;
 odf_acct.recordtypeid = rec_type_map.get('Account');
 //upsert odf_contact;
 
   //call ws to create contact 
      list <OD_Foundation_Contact__c> found_accounts = [SELECT Id from OD_Foundation_Contact__c where id = :odf_acct.id
                                                       ];
       if (found_accounts.size() > 0) {
   system.debug ('update Account Required');
           update odf_acct;
        
         
       }
       else {
          system.debug ('New Account Creation Required');
         /* OD_Foundation_Contact__c acct_new = new OD_Foundation_Contact__c();
          acct_new.accountname__c = odf_acct.AccountName__c;
          acct_new.business_unit__c = odf_acct.business_unit__c;
          acct_new.amount__c = odf_acct.amount__c;
          acct_new.status__c = odf_acct.status__c;*/
         /* 
          odf_acct.OD_Foundation_User__c = ODFusr.Id;
          odf_acct.recordtypeid = rec_type_map.get('Account');
          insert odf_acct;
       }
   }
 
  p.setRedirect(true);
  return p;
 }
  
  
 public class ODFCWrapper
 {
  public OD_Foundation_Contact__c acc {get; private set;}
  }



    public PageReference previewET() {
         load_template();
     PageReference pageRef=   new PageReference('/apex/ODFHome#ODFContactEmail');
               pageRef.setRedirect(true);
     return pageRef;
    }


   /* public PageReference cancechg() {
   
     
      return page.ODFedContact1;
    }*/

/*
  public void load_template() {
        EmailTemplate et = [Select Name, Id, HtmlValue From EmailTemplate where Id =:slctedTemplate  ];
        EmailBody = et.HtmlValue ;
    }

    public PageReference sendmail() {
   
    List<String> conIDList = new List<String>();
        clist = getdataContacts();
          
 for (ContactData p: clist )  {
        if (p.isCntSelected ) {
            if(p.email!= null)
            {
                String cid ='';
            Contact ccid = [select id, email from contact where email =:p.email ];
             if (ccid !=  null)
             {
                cid = ccid.id;
             }
             else
             {
                 // Service Call for creation Contact - starts

 partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
 partnerSoapSforceCom.LoginResult loginResult;
 
if (!Test.isRunningTest()){
loginResult = sp.login(username, password);}
 if (Test.isRunningTest()){
 loginResult = new partnerSoapSforceCom.LoginResult();
 loginResult.sessionId = '123456'; }
system.debug('   loginResult ' + loginResult);
soapODFoundationContactWS.ODFoundationContactWS apexWebSvc = new soapODFoundationContactWS.ODFoundationContactWS();
soapODFoundationContactWS.SessionHeader_element sessionHeader = new soapODFoundationContactWS.SessionHeader_element();
sessionHeader.sessionId = loginResult.sessionId;
// The Web services have a maximum timeout of 2 minutes. The timeout value
// is in milliseconds.
apexWebSvc.timeout_x = 120000;
apexWebSvc.SessionHeader = sessionHeader;
 cid= apexWebSvc.addContact(p.LastName,p.FirstName,p.Email,p.Phone);
system.debug('   ' + cid);
             }
            
             OD_Foundation_Contact__c contupt = [SELECT ID ,contact__c
                                                        from OD_Foundation_Contact__c 
                                                        where id= :p.foundationContactId
                                                       ];
                                                       contupt.contact__c= cid;
                                                       update contupt;
                                                       
                  user cusr =  [select id,name,email from user where id = :p.userid ] ;                                   
                                                       
                emailHelper.sendEmail(cid, p.foundationContactId , cusr.name, slctedTemplate  , cusr.email) ;
          
          
                                                       
         }
        }
    }
    
         return null;
    }


    public String EmailBody{ get; set; }
    public String slctedTemplate { get; set; }

    public PageReference preview() {
  //  emailHelper.sendEmail('003c0000007CZms', '003c0000007CZms' , 'SADF', '00Xc0000000QQgL' , 'aa@y.com') ;
     //   AddContacts();
     
          return new PageReference('/apex/ODFHome#ODFContactEmail' ); 
          
    }
    
    public List<ContactData > getdataContacts()
    {
      return dataContacts;
    }

    public PageReference associate() {
     PageReference pageRef = new PageReference('/apex/' + 'AddODFContact');
        pageRef.setRedirect(true);
        retUrl= '/apex/' + 'AddODFContact';
        return pageRef;
    }

     public class ContactData
    {
        public String firstName{get 
        
        ;set;}
        public String lastName {get;set;}
        public string accountName{get;set;}
          public string title {get;set;}
            public string email{get;set;}
            public string phone{get;set;}
         public Boolean isCntSelected {get;set;}
           public Boolean ismyContact {get;set;}
            public string contactid {get;set;}
             public string userid {get;set;}
            public ID foundationContactId {get;set;}
        
    }
     
        public class AccountData
    {
        public String Name{get; set;}
             public string BusinessUnit{get;set;}
            public decimal Amount{get;set;}
            public string Status{get;set;}
            public decimal SpclSponsorshipAmt{get;set;}
            public decimal SpclSponsorshipQty{get;set;}
            public decimal IndSponsorshipAmt {get;set;}
            public decimal IndSponsorshipQty {get;set;}
            public Boolean CurrentYear {get;set;}
            public string userid {get;set;}
        public ID foundationAcctId {get;set;}
    }
 
    
  // the soql without the order and limit
  private String soql {get;set;}
   private String soql1 {get;set;}
    private String acctsoql {get;set;}
  // the collection of contacts to display
 public List<ContactData>  contacts
 { get {
        return dataContacts ;
 }
 set {
 dataContacts  = contacts;
 
 }
 }
  public List<AccountData>  accts
 { get {
        return dataaccts ;
 }
 set {
 dataaccts = accts;
 
 }
 }
  public List<Contact> conts {get;set;}
    public List<OD_Foundation_Contact__C > myconts {get;set;}
      public List<OD_Foundation_Contact__C > myacts {get;set;}
    public  Set<OD_Foundation_Contact__C > distconts = new Set<OD_Foundation_Contact__C >();
       public  Set<OD_Foundation_Contact__C > distAccts = new Set<OD_Foundation_Contact__C >();
   public List<ContactData> dataContacts = new List<ContactData>();
    public List<AccountData> dataaccts = new List<AccountData>();
       List<ContactData> clist ;
   
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
  
  public void clear_all_views(Map<String,Boolean> pref_map) {
     pref_map.put(events[0],false);
     pref_map.put(events[1],false);
     pref_map.put(events[2],false);
     pref_map.put(events[3],false);
     pref_map.put(events[4],false);
     pref_map.put(events[5],false);
     pref_map.put(events[6],false);
     pref_map.put(events[7],false);
     pref_map.put(events[8],false);
   }
 
  public Map<String,ID> rec_type_map {get;set;}
 
  // init the controller and display some sample data when the page loads
  public ContactSearchController() {
 
  ODFSettings__c os = [select serviceuname__c,serviceuvalue__c,chatterendpoint__c,defaulttemplate__c from ODFSettings__c  where name  = 'odf'];
 username =  os.serviceuname__c;
 password = os.serviceuvalue__c; 
 EMAIL_TEMPLATE_ID = os.defaulttemplate__c;
cendpoint = os.chatterendpoint__c;
 
    EmailTemplate et = [Select Name, Id, HtmlValue From EmailTemplate where Id = :EMAIL_TEMPLATE_ID];
  
        EmailBody = et.HtmlValue ;
    rec_type_map = new Map<String,ID> ();
    For (Recordtype r : [SELECT Id, Name from recordtype where name in ('Contact','Account')])
      rec_type_map.put(r.name,r.id);  
 
    pref_view_map = new Map<String,Boolean> ();
    userId = String.valueOf(UserInfo.getUserId());
    soql = 'select firstname, lastname, account.name, Title from contact where account.name != null ';
     //soql1 = 'SELECT id,OD_Foundation_User__r.User__c, contact__C, Preference__c, Department__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c  from OD_Foundation_Contact__C where contact__C != null and LastName__c !=null and OD_Foundation_User__r.User__c =\''+String.escapeSingleQuotes(userId)+'\'' ;
     //changes deepak
     soql1 = 'SELECT id,OD_Foundation_User__r.User__c, contact__C, Preference__c, Department__c,Special_Description__c,individual_description__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c  from OD_Foundation_Contact__C where recordtypeid = \'' + rec_type_map.get('Contact') + '\' and LastName__c !=null and OD_Foundation_User__r.User__c =\''+String.escapeSingleQuotes(userId)+'\'' ;
    
    //accounts soql
    acctSoql = 'SELECT ID,Business_Unit__c,amount__c,status__C,AccountName__c,OD_Foundation_User__r.user__c , Special_Sponsorship_Amount__c ,  Special_Product_Sponsorship_Qty__c,  Individual_Sponsorship_Amount__c  ,  Individual_Sponsorship_Quantity__c , Current_Year__c from OD_Foundation_Contact__c where recordtypeid = \'' + rec_type_map.get('Account') + '\' and OD_Foundation_User__r.user__c = \''+String.escapeSingleQuotes(userId)+'\'' ;
    
    system.debug(acctSoql + ' acctSoql ' );
    
     clear_all_views(pref_view_map);
     list<AggregateResult> user_preference = [SELECT Event_Type__c,count(id) event_total from OD_Foundation_User_Preferences__c where user__c = :UserInfo.getUserId() group by Event_Type__c having count(id) > 0];
     
     for (AggregateResult up:user_preference) {
         string event_type = null;
         
         if (up.get('Event_Type__c') != null)
           event_type = string.valueof(up.get('Event_Type__c'));
           
        if ('Bass Fishing'.equals(event_type))
          pref_view_map.put(events[0],true);
        else if ('Cooking'.equals(event_type))
          pref_view_map.put(events[1],true);
        else if ('Deep Sea Fishing'.equals(event_type))
          pref_view_map.put(events[2],true);
        else if ('Golf'.equals(event_type))
          pref_view_map.put(events[3],true);
        else if ('Palm Beach International Raceway'.equals(event_type))
          pref_view_map.put(events[4],true);
        else if ('Spa'.equals(event_type))
          pref_view_map.put(events[5],true);
        else if ('Not participating in 2014'.equals(event_type))
          pref_view_map.put(events[6],true);
        else if ('In-Shore Fishing'.equals(event_type))
          pref_view_map.put(events[7],true);
        else if ('Homestead-Miami Speedway Racing'.equals(event_type))
          pref_view_map.put(events[8],true);
     }
    runQuery();
     addToList();
     runAcctQuery();
      addAcctToList();
     
      if (ApexPages.currentPage().getparameters().get('createMode') != null || ApexPages.currentPage().getparameters().get('id') != null) {
       event_pref_disp = false;
       event_pref_form = true;
     }
     else {
       event_pref_disp = true;
       event_pref_form = false;
     }
     current_user = userInfo.getUserId();
     userPref = [select id,name,event_type__c,createddate,lastmodifieddate from OD_Foundation_User_Preferences__c where user__c = :current_user];
     pref_view_map = new Map<string,boolean> ();
     clear_all_views(pref_view_map);  
     user_pref = new OD_Foundation_User_Preferences__c ();
     boolean record_found = false;
     user_pref.event_type__c = events[0];
     FOR (OD_Foundation_User_Preferences__c up : [SELECT ID,Associated_Contact__c,Hotel_Accomodation_Required__c,Transportation_Required__c,fishing_hat_size__c,Speedway_height__c,Speedway_weight__c,Racing_glove_size__c,Racing_Shirt_Size__c,Culinary_Shirt_Size__c,chef_jacket_size__c,OD_Business_Unit__c,Title_Sponsorship_Level__c,Dinner_Attendance__c
,Fishing_Licence_DOB__c,jacket_size__c,Shirt_Size__c,Robe_Emrbroidery__c,Pregnancy_Trimester__c,No_Participation_Reason_Other__c,No_Participation_Reason__c, Golf_Handicap__c,Golf_Vest_Size__c,Fishing_Licence_Zip__c,Fishing_Licence_State__c,Fishing_Licence_Legal_Name__c,Fishing_Licence_Drivers_licence__c,Fishing_Licence_City__c,Fishing_Licence_Address2__c,Fishing_Licence_Address1__c,Event_Type__c,Dietary_Preferences__c from OD_Foundation_User_Preferences__c where ID = :ApexPages.currentPage().getParameters().get('id')]) {
           user_pref = up;
           record_found = true;
           break;
       } 
     event_change_listener();
     
     //Over achiever
     List<aggregateResult> results =   [select OD_Foundation_User__c , sum(amount__c) total from OD_Foundation_Contact__c
where amount__c <> null and recordtype.name ='Account'
group by OD_Foundation_User__c order by sum(Amount__c) desc ];

 List<aggregateResult> SplAmtresults =   [select OD_Foundation_User__c , sum(Special_Sponsorship_Amount__c) total from OD_Foundation_Contact__c
where Special_Sponsorship_Amount__c <> null and recordtype.name ='Account'
group by OD_Foundation_User__c order by sum(Special_Sponsorship_Amount__c) desc ];

 List<aggregateResult> SplQtyresults =   [select OD_Foundation_User__c , sum(Special_Product_Sponsorship_Qty__c) total from OD_Foundation_Contact__c
where Special_Product_Sponsorship_Qty__c <> null and recordtype.name ='Account'
group by OD_Foundation_User__c order by sum(Special_Product_Sponsorship_Qty__c) desc ];

 List<aggregateResult> IndAmtresults =   [select OD_Foundation_User__c , sum(Individual_Sponsorship_Amount__c ) total from OD_Foundation_Contact__c
where Individual_Sponsorship_Amount__c <> null and recordtype.name ='Account'
group by OD_Foundation_User__c order by sum(Individual_Sponsorship_Amount__c ) desc ];

 List<aggregateResult> IndQtyresults =   [select OD_Foundation_User__c , sum(Individual_Sponsorship_Quantity__c) total from OD_Foundation_Contact__c
where Individual_Sponsorship_Quantity__c <> null and recordtype.name ='Account'
group by OD_Foundation_User__c order by sum(Individual_Sponsorship_Quantity__c) desc ];


ODFWinner wnr = new ODFWinner();
for (AggregateResult ar : results)
{
  System.debug('tot-'+ar.get('total'));
   wnr.PrimaryWinnerAmt=ar.get('total')+'';
String pid=ar.get('OD_Foundation_User__c')+'';
 OD_Foundation_User__c  fusr = [select user__r.name,user__r.id from OD_Foundation_User__c where id= :pid  ];
  
   wnr.PrimaryWinnerName=fusr.user__r.Name;
  wnr.PrimaryWinnerUrl= ConnectApi.ChatterUsers.getPhoto(null,fusr.user__r.id+'').largePhotoUrl;

 
  break;
 }  
 
 
 
 for (AggregateResult ar : SplAmtresults )
{
  System.debug('tot-'+ar.get('total'));
   wnr.SplAmtWinnerAmt=ar.get('total')+'';
String pid=ar.get('OD_Foundation_User__c')+'';
 OD_Foundation_User__c  fusr = [select user__r.name,user__r.id from OD_Foundation_User__c where id= :pid  ];
  
   wnr.SplAmtWinnerName=fusr.user__r.Name;
  wnr.SplAmtWinnerUrl= ConnectApi.ChatterUsers.getPhoto(null,fusr.user__r.id+'').largePhotoUrl;

 
  break;
 } 
 
 for (AggregateResult ar : SplQtyresults )
{
  System.debug('tot-'+ar.get('total'));
   wnr.SplQtyWinnerAmt=ar.get('total')+'';
String pid=ar.get('OD_Foundation_User__c')+'';
 OD_Foundation_User__c  fusr = [select user__r.name,user__r.id from OD_Foundation_User__c where id= :pid  ];
  
   wnr.SplQtyWinnerName=fusr.user__r.Name;
  wnr.SplQtyWinnerUrl= ConnectApi.ChatterUsers.getPhoto(null,fusr.user__r.id+'').largePhotoUrl;

 
  break;
 } 
 
 for (AggregateResult ar : IndAmtresults )
{
  System.debug('tot-'+ar.get('total'));
   wnr.IndAmtWinnerAmt=ar.get('total')+'';
String pid=ar.get('OD_Foundation_User__c')+'';
 OD_Foundation_User__c  fusr = [select user__r.name,user__r.id from OD_Foundation_User__c where id= :pid  ];
  
   wnr.IndAmtWinnerName=fusr.user__r.Name;
  wnr.IndAmtWinnerUrl= ConnectApi.ChatterUsers.getPhoto(null,fusr.user__r.id+'').largePhotoUrl;

 
  break;
 } 
 
  for (AggregateResult ar : IndQtyresults )
{
  System.debug('tot-'+ar.get('total'));
   wnr.IndQtyWinnerAmt=ar.get('total')+'';
String pid=ar.get('OD_Foundation_User__c')+'';
 OD_Foundation_User__c  fusr = [select user__r.name,user__r.id from OD_Foundation_User__c where id= :pid  ];
  
   wnr.IndQtyWinnerName=fusr.user__r.Name;
  wnr.IndQtyWinnerUrl= ConnectApi.ChatterUsers.getPhoto(null,fusr.user__r.id+'').largePhotoUrl;

 
  break;
 } 
 
 
  winner=wnr;
  

  }
  
  public void userSetup() {
    // Updating User Info Begins
    for (OD_Foundation_User__c u: [select id from OD_Foundation_User__c  where user__c = :UserInfo.getUserId() limit 1 ]) {
    ODFusr = u;
    ODFusr.last_login__c = Date.today();
    update ODFusr;
    }
    
  if (ODFusr == null )
  {
   ODFusr = new OD_Foundation_User__c();
   ODFusr.user__c = UserInfo.getUserId() ;
   ODFusr.last_login__c = Date.today();
   insert ODFusr;
  }
  // Updating User Info Ends
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
 //send email
 
 
 public void sendAdminMail()
 {
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 String[] toAddresses = new String[] {'prasad.devar@officedepot.com', 'indra.varada@officedepot.com', 'sabrina.conte@officedepot.com' };
        mail.setToAddresses(toAddresses);
     system.debug('msg'+ msg);
        mail.setSubject('Question from EventForce App '+ msg);

        mail.setPlainTextBody('The Question is :'+ msg+ '  ' );
        mail.setHtmlBody('The Question is: <b>'+ msg+ '</b> <b> </b>');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 }
 
 
  // runs the actual query
  public void runQuery() {
 
    try {
      
   myconts   = Database.query(soql1 + ' order by LastName__c'  + ' ' + sortDir + ' limit 100');
   
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e+''));
    }
    
    
         distconts.addall(myconts);
         
 

  }
 
   // runs the actual query
  public void runAcctQuery() {
     try {
     // system.debug('myacts :' + myacts.size());
    
   myacts = Database.query(acctSoql );
   //+ ' order by AccountName__c '  + ' ' + sortDir + ' limit 20'
   
     system.debug('myacts:' + myacts.size());
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e+''));
    }
    distAccts.addall(myacts);
    }
 
 public void addToList()
 {
   for (OD_Foundation_Contact__C c: distconts)  {
           ContactData cd = new ContactData ();
           cd.firstName = c.firstName__c ;
           cd.lastName = c.LastName__c;
          cd.accountName = c.AccountName__c ;
           cd.email= c.Email__c;
           cd.phone= c.Phone__c;
           cd.ismyContact =true;
           cd.isCntSelected  = false;
             cd.contactid =c.Contact__c;
             cd.userid  =c.OD_Foundation_User__r.User__c;
            cd.foundationContactId =c.id;
         dataContacts.add(cd);
        }
         system.debug('dataContacts: '+dataContacts.size() );
 }
 
  public void addAcctToList()
 { system.debug('Acct: inside' +distaccts.size());
   for (OD_Foundation_Contact__C c: distaccts)  {
           AccountData ad = new AccountData ();
          ad.Name = c.AccountName__c ;
          ad.userid  =c.OD_Foundation_User__r.User__c;
           ad.BusinessUnit =c.Business_Unit__c;
           ad.Amount=c.amount__c;
           ad.Status=c.status__C;
           ad.SpclSponsorshipAmt = c.Special_Sponsorship_Amount__c;
           ad.SpclSponsorshipQty =  c.Special_Product_Sponsorship_Qty__c;
           ad.IndSponsorshipAmt =c.Individual_Sponsorship_Amount__c;
           ad.IndSponsorshipQty =c.Individual_Sponsorship_Quantity__c;
           ad.CurrentYear =c.Current_Year__c ; 
            ad.foundationAcctId =c.id;
          
          
          
          system.debug('Acct: '+ad.Name );
         dataaccts.add(ad);
        }
        system.debug('AcctSize: '+dataaccts.size() );
        
 }
 
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String searchItm= Apexpages.currentPage().getParameters().get('searchItm');
 
 String srch = Apexpages.currentPage().getParameters().get('srch');
  userId = String.valueOf(UserInfo.getUserId());
 System.debug(searchItm +'searchItm');
dataContacts.clear();

distconts.clear();

       //soql = 'SELECT id,OD_Foundation_User__r.User__c, contact__C, Preference__c, Department__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c  from OD_Foundation_Contact__C where contact__C != null and LastName__c !=null and OD_Foundation_User__r.User__c = \''+String.escapeSingleQuotes(userId )+'\'';
       // Modified by deepak
       soql = 'SELECT id,OD_Foundation_User__r.User__c,Special_Description__c,individual_description__c, contact__C, Preference__c, Department__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c  from OD_Foundation_Contact__C where recordtypeid = \'' + rec_type_map.get('Contact') + '\' and LastName__c !=null and OD_Foundation_User__r.User__c = \''+String.escapeSingleQuotes(userId )+'\'';
    soql1=soql;
      soql1 += ' and  firstname__C LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';
        runQuery();
soql1=soql;
      soql1 += ' and lastname__C LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';
  runQuery();
  soql1=soql;
      soql1 += ' and AccountName__c  LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';  
       runQuery();
      soql1=soql;
      soql1 += ' and Email__c  LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';
  runQuery();
 
    // run the query again
  
 addToList();
 
    return null;
  }
  
  
  
    public PageReference runSearchAcct() {
 
    String searchItm= Apexpages.currentPage().getParameters().get('searchAcctItm');
 

  userId = String.valueOf(UserInfo.getUserId());
 System.debug(searchItm +'searchItm');
dataaccts.clear();

distaccts.clear();

   String acctSoql1 = 'SELECT ID,Business_Unit__c,amount__c,status__C,AccountName__c,OD_Foundation_User__r.user__c , Special_Sponsorship_Amount__c ,  Special_Product_Sponsorship_Qty__c,  Individual_Sponsorship_Amount__c  ,  Individual_Sponsorship_Quantity__c , Current_Year__c from OD_Foundation_Contact__c where recordtypeid = \'' + rec_type_map.get('Account') + '\' and OD_Foundation_User__r.user__c = \''+String.escapeSingleQuotes(userId)+'\'' ;
   
    acctSoql =acctSoql1 ;
      acctSoql += ' and  Business_Unit__c LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';
        runAcctQuery();
acctSoql =acctSoql1 ;
      acctSoql += ' and status__C LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';
  runAcctQuery();
  acctSoql =acctSoql1 ;
      acctSoql += ' and AccountName__c  LIKE \''+String.escapeSingleQuotes(searchItm)+'%\'';  
        
  runAcctQuery();
  system.debug('acctSoql1 : '+acctSoql );
 
    // run the query again
  
 addAcctToList();
 
    return null;
  }
  
     public List<SelectOption> TemplateList
    {
        get
        {
           // UserTemp = [Select  u.Id, u.Name From UserRole u];
            
            TemplateList= new List<SelectOption>();
                
               //TemplateList.add(new SelectOption('00Xc0000000QQgL', 'Thank You Email'));
                 TemplateList.add(new SelectOption(EMAIL_TEMPLATE_ID, 'Invitation Email'));

                 TemplateList.add(new SelectOption('00XE0000000DvcQ', 'Supply Chain Template'));
                 TemplateList.add(new SelectOption('00XE0000000DwE5', 'Follow Up Template'));
            //   TemplateList.add(new SelectOption('00XM0000000MHov', 'Supply Chain Template'));
            
            return TemplateList;
        }
        set;
    }
 
  // use apex describe to build the picklist values
  public List<String> technologies {
    get;
    /* {
      if (technologies == null) {
 
        technologies = new List<String>();
        Schema.DescribeFieldResult field = Contact.Title.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          technologies.add(f.getLabel());
 

 
      }
      return technologies;          
    }*//*
    set;
  }
    public PageReference UploadFile()  
    {  
        PageReference pr;  
        if(fileBody != null && fileName != null)  
        {  
         if (!Test.isRunningTest()){
         ConnectApi.BinaryInput bi=new ConnectApi.BinaryInput(fileBody, 'image/jpg', filename);
         ConnectApi.ChatterUsers.setPhoto(null,'me',bi);
         }
         
         
 
  //Set your username and password here
        String username = '';
        String password = '';
 
        //Construct HTTP request and response
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
 
        //Construct Authorization and Content header
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
        //Construct Endpoint
        
       // 'https://officedepot--uat.cs7.my.salesforce.com/services/data/v23.0/chatter/users/me/photo';
        //String endpoint = 'https://officedepot.my.salesforce.com/services/data/v23.0/chatter/users/me/photo';
        //Set Method and Endpoint and Body
        req.setMethod('POST');
        req.setEndpoint(cendpoint);
        req.setBody('{"fileUpload"'+fileBody+'"}');
 system.debug('   prasad  Here in Web' ); 
        try {
           //Send endpoint to JIRA
           if (!Test.isRunningTest()){
           res = http.send(req);
           }
           
        } catch(System.CalloutException e) {
            System.debug(res.toString());
        } 
             System.debug(res.toString());
               system.debug('   prasad  Here out Web' );                 
                                          
                   
             
        }  
         PageReference page = ApexPages.currentPage();
          page.setRedirect(true);
          return page;
        
    } 
 
 
 
 
 public ID current_user {get;set;}
   public OD_Foundation_User_Preferences__c user_pref {get;set;}
    
   public boolean golf_view {get;set;}
   public boolean deep_sea_view {get;set;}
   public boolean bass_view {get;set;}
   public boolean spa_view {get;set;}
   public boolean cooking_view {get;set;}
   public boolean racing_view {get;set;}
  // public Map<String,Boolean> pref_view_map {get;set;}
   public list<OD_Foundation_User_Preferences__c> userPref {get;set;}
   
  // public String[] events = new String[] {'Bass Fishing','Cooking','Deep Sea Fishing','Golf','Racing','Spa','Not participating in 2014'};
   public boolean event_pref_disp {get;set;}
   public boolean event_pref_form {get;set;}
   
   
   public void EditMyEvent() {
     //Pagereference p = new PageReference ('/apex/ODFHome?id=' + ApexPages.currentPage().getParameters().get('eventid')+'#holderPrf');
     //Pagereference p = new PageReference ('/apex/ODFHome_dee?id=' + ApexPages.currentPage().getParameters().get('eventid')+'#ODFAddPref');
     //p.setredirect(true);
     //return p;
     display_event_selection = false;
     FOR (OD_Foundation_User_Preferences__c up : [SELECT ID,Associated_Contact__c,Hotel_Accomodation_Required__c,Transportation_Required__c,fishing_hat_size__c,Speedway_height__c,Speedway_weight__c,Racing_glove_size__c,Racing_Shirt_Size__c,Culinary_Shirt_Size__c,chef_jacket_size__c,OD_Business_Unit__c,Title_Sponsorship_Level__c,Dinner_Attendance__c
,Fishing_Licence_DOB__c,jacket_size__c,Shirt_Size__c,Robe_Emrbroidery__c,Pregnancy_Trimester__c,No_Participation_Reason_Other__c,No_Participation_Reason__c,Golf_Handicap__c,Golf_Vest_Size__c,Fishing_Licence_Zip__c,Fishing_Licence_State__c,Fishing_Licence_Legal_Name__c,Fishing_Licence_Drivers_licence__c,Fishing_Licence_City__c,Fishing_Licence_Address2__c,Fishing_Licence_Address1__c,Event_Type__c,Dietary_Preferences__c from OD_Foundation_User_Preferences__c where ID = :ApexPages.currentPage().getParameters().get('eventid')]) {
           user_pref = up;
           //record_found = true;
           break;
       } 
       event_change_listener();
   }
   
   public void createMyEvent() {
     //Pagereference p = new PageReference ('/apex/ODFHome?createmode=true');
     //p.setredirect(true);
     //return p;
     display_event_selection = true;
     user_pref = new OD_Foundation_User_Preferences__c();
     event_change_listener();
   }
   
   public void createMyContact() {
     odf_contact = new OD_Foundation_Contact__c();
   }
   
   public void editmycontact() {
     for (od_foundation_contact__c con : [select Id, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Contact__c,Special_Description__c,individual_description__c, OD_Foundation_User__c, Preference__c, Department__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c, related_account__c, Business_Unit__c, Amount__c, Status__c,related_account__r.status__c,related_account__r.business_unit__c,related_account__r.amount__c from od_foundation_contact__c where id = :ApexPages.currentPage().getParameters().get('contactid')]) {
        odf_contact = con;
        break;
     }
   }
      public void editMyAcct() {
      system.debug('edit : '+ ApexPages.currentPage().getParameters().get('acctid'));
     for (od_foundation_contact__c con1 : [select Id, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,Special_Description__c,individual_description__c, LastActivityDate, Contact__c, OD_Foundation_User__c, Preference__c, Department__c, Email__c, HomePhone__c, Mobile__c, FirstName__c, LastName__c, OtherPhone__c, Phone__c, Title__c, AccountName__c, related_account__c, Business_Unit__c, Amount__c, Status__c,related_account__r.status__c,related_account__r.business_unit__c,related_account__r.amount__c, Special_Sponsorship_Amount__c, Special_Product_Sponsorship_Qty__c, Individual_Sponsorship_Amount__c, Individual_Sponsorship_Quantity__c, Current_Year__c from od_foundation_contact__c where id = :ApexPages.currentPage().getParameters().get('acctid')]) {
        odf_acct = con1;
         system.debug('edit inside : '+ ApexPages.currentPage().getParameters().get('acctid')+odf_acct.AccountName__c);
        break;
     }
   }
     public PageReference DelMyContact() {
     Pagereference p = new PageReference ('/apex/ODFHome#holderPrf');
     od_foundation_contact__c con = [SELECT ID FROM od_foundation_contact__c where id=:ApexPages.currentPage().getParameters().get('contactid')];
     Delete con ;
     p.setRedirect(true);
     return p;
   }
     public PageReference DelMyAcct() {
     Pagereference p = new PageReference ('/apex/ODFHome#holderPrf');
     od_foundation_contact__c acct= [SELECT ID FROM od_foundation_contact__c where id=:ApexPages.currentPage().getParameters().get('acctid')];
     Delete acct;
     p.setRedirect(true);
     return p;
   }
   public PageReference DelMyEvent() {
     Pagereference p = new PageReference ('/apex/ODFHome#holderPrf');
     OD_Foundation_User_Preferences__c upref = [SELECT ID FROM OD_Foundation_User_Preferences__c where id=:ApexPages.currentPage().getParameters().get('eventid')];
     Delete upref;
     p.setRedirect(true);
     return p;
   }
   
  

  /* public void clear_all_views(Map<String,Boolean> pref_map) {
     pref_map.put(events[0],false);
     pref_map.put(events[1],false);
     pref_map.put(events[2],false);
     pref_map.put(events[3],false);
     pref_map.put(events[4],false);
     pref_map.put(events[5],false);
     pref_map.put(events[6],false);
   }
   */

  /*
  public pagereference savePref() {
    try
    {
    pagereference p = new pagereference('/apex/ODFHome#holderPrf');
    user_pref.user__c = current_user;
    //user_pref.OD_Foundation_User__c = ODFusr.Id;
    
    if (events[0] <> user_pref.event_type__c) {
      user_pref.Fishing_Licence_Legal_Name__c = null;
      user_pref.Fishing_Licence_Address1__c = null;
      user_pref.Fishing_Licence_Address2__c = null;
      user_pref.Fishing_Licence_City__c = null;
      user_pref.Fishing_Licence_State__c = null;
      user_pref.Fishing_Licence_Zip__c = null;
      user_pref.Fishing_Licence_DOB__c = null;
      user_pref.Fishing_Licence_Drivers_licence__c = null;
    }
    if (events[3] <> user_pref.event_type__c) {
      user_pref.Golf_Handicap__c = null;
      user_pref.Golf_Vest_Size__c = null;
    }
    if (events[1] <> user_pref.event_type__c && events[5] <> user_pref.event_type__c) {
      user_pref.Robe_Emrbroidery__c = null;
    }
    if (events[5] <> user_pref.event_type__c) {
      user_pref.Pregnancy_Trimester__c = null;
    }
    if (events[5] == user_pref.event_type__c) {
      user_pref.Jacket_Size__c = null;
      user_pref.Shirt_Size__c = null;
      //user_pref.Transportation_Required__c = 'No';
    }
    upsert user_pref;
    p.setRedirect(true);
    return p;
    }
    catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
        return null;
    }
  }
  
  public void event_change_listener () {
    String event_type = user_pref.event_type__c;
    clear_all_views(pref_view_map);
    pref_view_map.put(event_type,true);
  /*
   }
   
  public class ODFWinner
 {
  public String PrimaryWinnerName {get; set;}
  public String PrimaryWinnerTitle {get; set;}
  public String PrimaryWinnerAmt {get; set;}
  public String PrimaryWinnerUrl {get; set;}
  
   public String SplAmtWinnerName {get; set;}
  public String SplAmtWinnerTitle {get; set;}
  public String SplAmtWinnerAmt {get; set;}
  public String SplAmtWinnerUrl {get; set;}
  
   public String SplQtyWinnerName {get; set;}
  public String SplQtyWinnerTitle {get; set;}
  public String SplQtyWinnerAmt {get; set;}
  public String SplQtyWinnerUrl {get; set;}
  
   public String IndAmtWinnerName {get; set;}
  public String IndAmtWinnerTitle {get; set;}
  public String IndAmtWinnerAmt {get; set;}
  public String IndAmtWinnerUrl {get; set;}
  
   public String IndQtyWinnerName {get; set;}
  public String IndQtyWinnerTitle {get; set;}
  public String IndQtyWinnerAmt {get; set;}
  public String IndQtyWinnerUrl {get; set;}
  
  
  
  
  
 }*/
}