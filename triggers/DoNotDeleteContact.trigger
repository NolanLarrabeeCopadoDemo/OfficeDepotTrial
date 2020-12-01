/**************************************************************
*Name           : DoNotDeleteContact 
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 11th April,2012
*Purpose        : To prevent deletion of contact if any task or note is associated with that contact
********************************************************************/
trigger DoNotDeleteContact on Contact (before insert,before update,before delete) {
    // To Skip this trigger if the record type belongs to Bizbox or Techzone
    Set<Id> recordTypesToSkip = Util.bizBoxRTIdsByObject('Contact');
    Set<Id> moreRecordTypesToSkip = Util.checkRT('Contact');
    recordTypesToSkip.addAll(moreRecordTypesToSkip);
    if (Trigger.New != null) {
        for (Contact c : Trigger.New) {
            if (recordTypesToSkip.contains(c.RecordTypeId)) {
                return;
            }
        }
    }
    else {
        for (Contact c : Trigger.Old) {
            if (recordTypesToSkip.contains(c.RecordTypeId)) {
                return;
            }
        }
    }
    
  //--------------------------------------------//
  // To Bypass trigger code on certain condition
  //--------------------------------------------//
  if (Util.bypassTriggers('DoNotDeleteContact')) {
    Util.DEBUG('Bypassing trigger DoNotDeleteContact');
    return;
  }
  public Set<Id> accid= new Set<Id>();
  public Map<String,Schema.RecordTypeInfo> Accountrectype = Schema.SObjectType.Account.getRecordTypeInfosByName(); 
  public set<Id> setContact = new set<Id>(); 
  public List<String> ProfileNames= new List<String>();
  public List<Profile> profilePin= new List<Profile>();
  // fetch the error message from a custom label(For Pin contact validation on Customer (OfficeMax))
  String errormsg = Label.Error_Message_on_Contact;
  public List<user> u1= new List<User>();
  System.debug('The error message-->'+errormsg);
  if(Trigger.IsDelete)
  {
      // Make contact set from Task and Note
      for(Task task: [Select Id, WhoId From Task where WhoId IN :Trigger.OldMap.keySet() ] ) {
        setContact.add(task.whoId); 
      }
      for(Note note: [Select Id, ParentId From Note Where ParentId IN :Trigger.OldMap.keySet()] ) {
        setContact.add(note.ParentId); 
      }
      //Contact cannot be deleted if pin is present for OfficeMax (Customer)
      for(Contact con:Trigger.old)
      {
          if(con.accountid!=null)
          {
              accid.add(con.accountid);
          }
      }
  }
  if(Trigger.IsInsert || Trigger.IsUpdate)
  {
      for(Contact con:Trigger.new)
      {
          if(con.accountid!=null)
          {
              accid.add(con.accountid);
          }
          
     try {
          if ( con.MailingStreet != null || con.MailingStreet != '' ) {
             con.MailingStreet2__c = con.MailingStreet;
             String MailingStreet2 = con.MailingStreet2__c;
             String[] stringCharacters = MailingStreet2.split('');
             System.debug(stringCharacters);
             Integer[] vals;
             vals = MailingStreet2.getChars();
             String MSNLFstr =''; //MSNLFstr is MailingStreet2__c string without Line Feed and Carriage Return
          for (Integer x: vals)
                {   Integer AscNum = x; //x represents Ascii code for Line feed and Carriage Return (10, 13)
                    if( x== 10 || x==13)
                    { AscNum=32; } //AscNum represents Ascii code for Space
                    String myChar = String.fromCharArray( new List<integer> {AscNum} );
                    MSNLFstr = MSNLFstr + myChar ;
                 }
            System.debug(vals);
            System.debug(MSNLFstr);
            con.MailingStreet2__c = MSNLFstr;
          }
        }
    catch(System.NullPointerException e){  
        Return;
       }    
     }
  }
  Map<Id,Account> mapidacc= new Map<Id,Account>([Select id,recordtypeid from Account where id IN:accid]);
  //u1= [Select id,OD_Employee_ID__c from user where OD_Employee_ID__c='000005'];
  Id u1Id=Label.salesforce;
  

  if(Trigger.IsUpdate)
  {
     for(Contact contact : Trigger.New)
     {
         Account accalias= mapidacc.get(contact.accountid);
         if(accalias!=null)
         {
          //Connor Flynn - Adding additional boolean logic S-440206 OD 00586775 Start
             if(contact.Pin__c!=null && accalias.recordtypeid==Accountrectype.get('Customer (OfficeMax)').getRecordTypeId() &&
              /////u1.size()>0 && userinfo.getuserid() !=u1[0].id 
              userinfo.getuserid() !=u1Id
              && contact.CreatedById == Label.DoNotDeleteContact_trigger_Exemption)
             {
          //Connor Flynn - Adding additional boolean logic S-440206 OD 00586775 End
                 contact.adderror(errormsg);
             }
         }
     } 
  }
  
  if(Trigger.IsDelete)
  {
      // Check if Task or Note associated with it    
      for(Contact contact : Trigger.Old) 
      {
        Account accalias= mapidacc.get(contact.accountid);
        if(accalias!=null)
        {
            //Connor Flynn - Adding additional boolean logic S-440206 OD 00586775 Start
            if(contact.Pin__c!=null && accalias.recordtypeid==Accountrectype.get('Customer (OfficeMax)').getRecordTypeId() &&
            // u1.size()>0 && userinfo.getuserid() !=u1[0].id
                          userinfo.getuserid() !=u1Id
              && contact.CreatedById == Label.DoNotDeleteContact_trigger_Exemption)
            {
            //Connor Flynn - Adding additional boolean logic S-440206 OD 00586775 End
                contact.adderror(errormsg);
                //contact.addError('Contacts cannot be added, edited or deleted in SalesForce for any OfficeMax Customer Record Types. Please utilize OfficeMax Customer Service to make these changes. Contact changes will reflect in SalesForce on the next business day.');
            }
        }
        if(setContact.contains(contact.Id)) {
          contact.addError('<span style="color:#cc0000"><b><br>The contact cannot be deleted as it has task/notes tied to it</b></span>');
        }
        
      } 
  }
  
}