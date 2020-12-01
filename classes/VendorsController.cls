public with sharing class VendorsController {
    @AuraEnabled(cacheable=true)
    public static List<Vendor__c> getVendorList(String qid) {
        system.debug('the quote id is'+qid);
        List<Vendor__c> lstOfVendors = new List<Vendor__c> ();
        Quote q = new quote();
        try {
            if(qid != null) {
                q=[SELECT id,Totalprice from quote WHERE id =:qid];
            }
            if(q.TotalPrice > 20000.00) {
                lstOfVendors=[SELECT Id, Name, Vendor_Number__c, Email__c, Active__c, Rep_Comment__c, VendorNum__c from Vendor__c WHERE Name='Procurement Team'];
            } else {
                lstOfVendors=  [SELECT Id, Name, Vendor_Number__c, Email__c, Active__c, Rep_Comment__c, VendorNum__c from Vendor__c WHERE Active__c = true];
            }
        } catch(Exception e) {
            throw new AuraHandledException('An error ocurred while fetching the vendors.');   
            
        }
        
        return lstOfVendors;
    }
    
    @AuraEnabled
    public static void VendorCaseCreate(String qid, List<Map<String,Object>> comAndids, String GlobalComment){
        
        System.debug('comAndids' +comAndids);
        // Creating a case and vendor case for each vendor id
        List<Case> new_cases = new List<Case>();
        List<Vendor_Case__c> new_vendor_cases = new List<Vendor_Case__c>();
        
        for (Map<String,Object> comAndid : comAndids)
        {
            Id SupplierRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
            Case new_case = new Case(
                RecordTypeId = SupplierRecordTypeId
            );
            insert new_case;
            new_cases.add(new_case);
            
            Vendor_Case__c new_vendor_case = new Vendor_Case__c(
                Quote__c    = qid,
                Case__c     = new_case.Id,
                Vendor__c   = (Id)comAndid.get('Id')
            );
            new_vendor_cases.add(new_vendor_case);
            sendemail((String)comAndid.get('Id'), qid, new_case, GlobalComment, (String)comAndid.get('Comment'));
            System.debug('XXXXXXXXXXXXXXXXXXXXXXXXX'+(String)comAndid.get('Comment'));
        }
        
        //insert new_cases;
        insert new_vendor_cases;
        
    }
    
    @AuraEnabled
    public static void sendemail(String id, String qid, Case new_case, String GlobalComment, String Comments){
        system.debug('the id is:'+id);
        Case updCase = [Select id, CaseRef__c from case WHERE id = :new_case.id];
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        Vendor__c vl = [SELECT id,name,Email__c from Vendor__c WHERE ID = :id];
        Quote qn = [Select id, QuoteNumber from Quote WHERE Id =:qid];
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        sendTo.add(vl.Email__c);
        mail.setToAddresses(sendTo);
        // Step 3: Set who the email is sent from
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User WHERE Username = : userName limit 1];
        String userEmail = activeUser.Email;
        System.debug('XXXXXXXXXXXXXXXXXXXXXXXXX'+userEmail);
        List<String> replymails = new List<String>();
        String TSEmailServiceAddress = System.Label.TechSalesEmailServicesAddress;
        replymails.add(TSEmailServiceAddress);
        replymails.add(userEmail);
        mail.setReplyTo(TSEmailServiceAddress);
        mail.setCcAddresses(replymails);
        mail.setSenderDisplayName('OD Sales Rep');
        // Step 4. Set email contents
        String VendorReqSub = System.Label.VendorRequestSubject;
        mail.setSubject(VendorReqSub+' '+qn.QuoteNumber);
        String VendorTemplate = System.Label.VendorEmailTemplate;
        String ProVendorTemplate = System.Label.VendorEmailTemplateProcurement_Team;  
        String RepComm = '';
        System.debug('procurement vendor template'+ProVendorTemplate);
        System.debug('XXXXXXXXXXXXXXXXXXXXXXXXX'+Comments);
        if (Comments != null) {
            RepComm = Comments;
        }
        else if (GlobalComment != null) {
            RepComm = GlobalComment;
        }
        String Qnum = '<b><u>Office Depot Quote Number</u>: </b>' +qn.QuoteNumber+ '<br/><br/>';
        String CaseRef = updCase.CaseRef__c;
        String s;
        String procurement_id=System.Label.Procuremenet_Id;
        system.debug('is prc id equal to id recieved'+id.equals(procurement_id)+'id recieved is'+id+'the prc id is'+procurement_id);
        if(id.equals(procurement_id)) {
            s = ProVendorTemplate + '<br/><br/>'+ '<b><u>Comments</u></b>' + '<br/><br/>'+  RepComm + '<br/><br/>'+ Qnum +'<table cellspacing="0" cellpadding="0" dir="ltr" border="1" style="table-layout:auto;font-size:13px;font-family:arial,sans,sans-serif;border-collapse:collapse;border:1px solid black;"><colgroup><col width="250"><col width="250"><col width="250"><col width="250"><col width="250"><col width="250"></colgroup><tbody><tr style="height:21px"><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">Product<br>Description</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;word-wrap:break-word;vertical-align:middle;text-align:center">Manufacturer Part Number</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;word-wrap:break-word;vertical-align:middle;text-align:center">Manufacturer Name</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">UPC</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">Quantity</td></tr>';
        } else {
            s = VendorTemplate + '<br/><br/>'+ '<b><u>Comments</u></b>' + '<br/><br/>'+  RepComm + '<br/><br/>'+ Qnum +'<table cellspacing="0" cellpadding="0" dir="ltr" border="1" style="table-layout:auto;font-size:13px;font-family:arial,sans,sans-serif;border-collapse:collapse;border:1px solid black;"><colgroup><col width="250"><col width="250"><col width="250"><col width="250"><col width="250"><col width="250"></colgroup><tbody><tr style="height:21px"><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">Product<br>Description</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;word-wrap:break-word;vertical-align:middle;text-align:center">Manufacturer Part Number</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;word-wrap:break-word;vertical-align:middle;text-align:center">Manufacturer Name</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">UPC</td><td style="padding:2px 3px;background-color:rgb(197,232,159);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">Quantity</td></tr>';
        }
        system.debug(' the strin s contains'+s);
        Integer i = 0;
        for(QuoteLineItem qli : [Select id, QuoteId, Quote.QuoteNumber, Description, Mfg_Part_Number__c, Manufacturer_Name__c, UPC__c, Quantity, Vendor_Part_Number__c, Cost__c from QuoteLineItem WHERE QuoteId =:qid]){          
            i++;
            s+='<tr><td style="text-align: center; vertical-align: middle; font-size: 10px; font-family:verdana;font-weight:bold;">'+qli.Description + '</td><td style="text-align: center; vertical-align: middle; font-size: 10px; font-family:verdana;font-weight:bold;">'+qli.Mfg_Part_Number__c + '</td><td style="text-align: center; vertical-align: middle; font-size: 10px; font-family:verdana;font-weight:bold;">'+qli.Manufacturer_Name__c + '</td><td style="text-align: center; vertical-align: middle; font-size: 10px; font-family:verdana;font-weight:bold;">'+qli.UPC__c + '</td><td style="text-align: center; vertical-align: middle; font-size: 10px; font-family:verdana;font-weight:bold;">'+qli.Quantity + '</td></tr>';
        }
        s+='</tbody></table>';
        s+='<br/><br/>'+CaseRef;
        mail.setHtmlBody(s);
        // Step 5. Add your email to the master list
        mails.add(mail);
        System.debug('Email sent');       
        // Step 6: Send all emails in the master list
        Messaging.sendEmail(mails);
        System.debug('Email sent XXXXXXXXXXXXXXXXXXXXX');
    }        
}