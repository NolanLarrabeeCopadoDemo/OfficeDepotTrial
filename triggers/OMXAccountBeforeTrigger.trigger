trigger OMXAccountBeforeTrigger on Account (before insert, before update) {
  //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');

    if (Constants.SkipAccountTrigger) 
    return;


    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)    
    
    /*for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/

    //variable declaration
    // This code is to remove the concatenation of name 1 and name 2 in OMX trigger
    
    
   if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
  //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)) {
      if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}
 
 
 
    public List<Address_Abbreviation__c> addAbb;    
    
    public String shortenAddress(String address) {           
      for (integer i = 0; address != null && address.length() > 25 && i < addAbb.size(); i++)
       {
            address=address .touppercase();
            if(addAbb[i].Abbreviation__c==null)
            address = address.replace( addAbb[i].name , '');
            else
            address = address.replace( addAbb[i].name , addAbb[i].Abbreviation__c);
        }
        return address;
    }
    

      Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
      Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
      boolean isOmxAccount = false;
      
      //added by ivarada - 3/9/2016 : starts
      
              // Removin below logic as confirmed by deepak 09/18/2017

      /*if (Trigger.isInsert && Trigger.isBefore) 
        
        list<String> omxmainframeIDs = new list<String> ();
        Map<String,String> HoverideMap = new Map<String,String>();
        Map<String,String> sTonMap = new Map<String,String>();
        Map<String,ID> xrepIdtoSPID = new Map<String,ID>();
        Map<String,ID> xRepIDtoUser = new Map<String,ID>();
        Map<String,ID> repIdtoSPID = new Map<String,ID>();
        Map<String,ID> repIdtoUser = new Map<String,ID>();
        
        for (Account a: Trigger.New) {
           if ((a.recordtypeId==CustOMX || a.recordtypeId==SiteOMX)) {
               omxMainframeIDs.add(a.OMX_Mainframe_Owning_Rep_Number__c);
           }
        }
        
        
        for (XREFHSE__c h: [select ODNID__c,ODS_ID__c from XREFHSE__c where ODNID__c=:omxMainframeIDs])
        {
          HoverideMap.put(h.ODNID__c,h.ODS_ID__c);
          stonMap.put(h.ODS_ID__c,h.ODNID__c);
        }
        
        for (sales_person__c s:[select id,user__c,Role_Relate_Id__c,ExtIDSalesPerson__c from sales_person__c where ExtIDSalesPerson__c in :HoverideMap.values() and isactive__c=true] ) {
           xrepIdtoSPID.put(stonMap.get(s.ExtIDSalesPerson__c),s.id);
           xRepIDtoUser.put(stonMap.get(s.ExtIDSalesPerson__c),s.user__c);
         }
   
         for (sales_person__c s:[select id,OMX_Rep_ID__c,user__c from sales_person__c where OMX_Rep_ID__c = :omxMainframeIDs and isactive__c=true]) {
           repIdtoSPID.put(s.omx_rep_id__c,s.id);
           repIdtoUser.put(s.omx_rep_id__c,s.user__c);
           
         }
         
         for (Account a: Trigger.New) {
          if (a.OMX_Mainframe_Owning_Rep_Number__c != null) {
            if (xrepIdtoSPID.containsKey(a.OMX_Mainframe_Owning_Rep_Number__c) ) {
             if (xRepIDtoUser.get(a.OMX_Mainframe_Owning_Rep_Number__c) != null) {
               a.ownerID = xRepIDtoUser.get(a.OMX_Mainframe_Owning_Rep_Number__c);
               a.Sales_PersonID__c = xrepIdtoSPID.get(a.OMX_Mainframe_Owning_Rep_Number__c);
             }
            }
            else if (repIdtoSPID.containsKey(a.OMX_Mainframe_Owning_Rep_Number__c)) {
               if (repIdtoSPID.get(a.OMX_Mainframe_Owning_Rep_Number__c) != null) {
                 a.ownerID = repIdtoUser.get(a.OMX_Mainframe_Owning_Rep_Number__c);
                 a.Sales_PersonID__c = repIdtoSPID.get(a.OMX_Mainframe_Owning_Rep_Number__c);
               }
            }
           }
         }
         
        
      }
      */
      // added by ivarada - 3/9/2016 : ends
   
      
     if(executeoncetest.mod5ByPass==true){
      
      
      
      for (Account a: Trigger.New) {
         if (a.recordtypeId==CustOMX || a.recordtypeId==SiteOMX) {
               isOmxAccount = true;
               
         }
      }
    
      if(isOmxAccount) {
         addAbb = [Select name ,Abbreviation__c,step__C from Address_Abbreviation__c order by step__C asc];
      }
      
      //
      
               
     for(Account a: Trigger.New){
           
           
           
              if(Trigger.isInsert){
                  if( a.recordtypeId==CustOMX  ||  a.recordtypeId==SiteOMX ){
                  a.OMXIsUpdated__c=true;
                  }
              }
              
             
    
     //Resubmittng for Oracle Party Id
     if(Trigger.isUpdate){
 
    
      if( a.recordtypeId==CustOMX  ||  a.recordtypeId==SiteOMX ){
        // Update a flag if any of field value changes
        // start case 00710320
        if( 
        /* (a.Legacy_CreatedDate__c!= trigger.oldMap.get(a.id).Legacy_CreatedDate__c)  ||  (a.Segment__c!= trigger.oldMap.get(a.id).Segment__c)   ||
        (a.OMX_GPO__c!= trigger.oldMap.get(a.id).OMX_GPO__c)   || (a.Phone!= trigger.oldMap.get(a.id).Phone)   ||
        (a.OMX_Mainframe_Consignee_ID__c!= trigger.oldMap.get(a.id).OMX_Mainframe_Consignee_ID__c)   || (a.Industry_OD_SIC_DB__c!= trigger.oldMap.get(a.id).Industry_OD_SIC_DB__c)   ||
        (a.OMX_Primary_Key__c!= trigger.oldMap.get(a.id).OMX_Primary_Key__c)  ||
        (a.Org_Number_of_Locations__c!= trigger.oldMap.get(a.id).Org_Number_of_Locations__c)   || (a.OMX_Mainframe_Owning_Rep_Number__c!= trigger.oldMap.get(a.id).OMX_Mainframe_Owning_Rep_Number__c)   ||
        (a.DNB_WCW_Here__c!= trigger.oldMap.get(a.id).DNB_WCW_Here__c)   || (a.Org_WCW_Count_Rep__c!= trigger.oldMap.get(a.id).Org_WCW_Count_Rep__c)   ||
        (a.State__c!= trigger.oldMap.get(a.id).State__c)   ||          (a.Legacy_LastModifiedDate__c!= trigger.oldMap.get(a.id).Legacy_LastModifiedDate__c)   || (a.OMX_Tier_1_Type__c!= trigger.oldMap.get(a.id).OMX_Tier_1_Type__c)   ||
          (a.Duns_Number__c!= trigger.oldMap.get(a.id).Duns_Number__c)   || (a.City__c!= trigger.oldMap.get(a.id).City__c)   ||
           (a.Type!= trigger.oldMap.get(a.id).Type)   || (a.DNB_WCW_Total__c!= trigger.oldMap.get(a.id).DNB_WCW_Total__c )   ||
                (a.Industry_OD_SIC_Rep__c!= trigger.oldMap.get(a.id).Industry_OD_SIC_Rep__c)   ||
                   (a.Status__c!= trigger.oldMap.get(a.id).Status__c)   || (a.Country__c!= trigger.oldMap.get(a.id).Country__c )   ||
                       (a.Sector__c!= trigger.oldMap.get(a.id).Sector__c)   || (a.DNB_Duns__c!= trigger.oldMap.get(a.id).DNB_Duns__c)   ||
                           (a.Name!= trigger.oldMap.get(a.id).Name)   || (a.SicDesc!= trigger.oldMap.get(a.id).SicDesc)   ||
                               (a.Zip__c!= trigger.oldMap.get(a.id).Zip__c)   || (a.Original_System__c!= trigger.oldMap.get(a.id).Original_System__c )   ||
                                   (a.Sic!= trigger.oldMap.get(a.id).Sic)   ||*/
                                   
                                   
                                   (a.State__c!= trigger.oldMap.get(a.id).State__c)   ||  
                                   (a.City__c!= trigger.oldMap.get(a.id).City__c)   ||
                                   (a.Status__c!= trigger.oldMap.get(a.id).Status__c)      ||
                                   (a.Country__c!= trigger.oldMap.get(a.id).Country__c )||
                                   (a.Name!= trigger.oldMap.get(a.id).Name) ||
                                   (a.Zip__c!= trigger.oldMap.get(a.id).Zip__c)   || 
                                   (a.Address1__c!= trigger.oldMap.get(a.id).Address1__c)   ||
                                     (a.Address2__c!= trigger.oldMap.get(a.id).Address2__c)  ) {
                                     a.OMXIsUpdated__c=true;
                                     }

 // end case 00710320
     }
     }
        String  address1= a.address1__C;
        String  address2=a.address2__C;
         // code to reduce length of address1 and address field from 26
    
    
         if (  (trigger.isInsert )  ||
          (Trigger.isUpdate
           &&
           (  (a.address1__C!= trigger.oldMap.get(a.id).address1__C)   || (a.address2__C!= trigger.oldMap.get(a.id).address2__C) )
           )
           )
              {
              if(a.omx_primary_key__C!=null){
                if( (a.recordtypeid == CustOMX   || a.recordtypeid == SiteOMX)  && a.Split_Record__c == false   &&  !(a.omx_primary_key__C.contains('OMX001'))   &&   !(a.omx_primary_key__C.contains('OMX002'))  ){
         
    
                   a.address1__C= shortenAddress(a.address1__C);
                   a.address2__C= shortenAddress(a.address2__C);
                }
                }
          }
    
         }
         
        
 }        
 }