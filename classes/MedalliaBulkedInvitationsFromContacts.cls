global class MedalliaBulkedInvitationsFromContacts {
@InvocableMethod
    global static void sendToMedallia(List<surveyPayload> records) {
        try { 
            if (!records.isEmpty()) {
                List<Id> accountIdsToSurvey = new List<Id>();
                for (Account account :records[0].accountsToSurvey){
                    accountIdsToSurvey.add(account.Id);
                }
                /* Fecth all contacts flagged to be included in the survey wave in each account */
            	List<Contact> contactsToSurvey = [SELECT Id FROM Contact WHERE Medallia_Include_in_surveys__c = true AND Contact.AccountId IN :accountIdsToSurvey];
                
                // Get master data from config
                // Bulked Integration only works for Contacts
                String sObjectTypeMaster = 'Contact';
                // Fetch API details
                String endpoint = records[0].endpoint;
                String username = records[0].service;
                String password = records[0].password;
         
                // Build the query
                String query = 'SELECT ';
                List<String> allFields = new List<String>();
                Map<String, Schema.FieldSet> finalfs = new Map<String, Schema.FieldSet>();
                
                //Gather all fields from fieldsets to query
                String fsname = records[0].fieldSet;
                Schema.FieldSet fields = MedalliaBulkedInvitationsFromContacts.readFieldSet(fsname, sObjectTypeMaster);
				
                allFields = MedalliaBulkedInvitationsFromContacts.allFieldsCheck(allFields, fields);
                query = fieldQuery(query, allFields);
                
                // Fetch Ids of contacts to be surveyed
                List<Id> contactIds = new List<Id>();
                for (Contact contact : contactsToSurvey){
                    contactIds.add(contact.Id);
                    finalfs.put(contact.Id, fields);
                }
                                          
                //Complete FROM and WHERE Statements and query
                query = query.removeEnd(', ');
                query += ' FROM '+sObjectTypeMaster+' WHERE ID IN :contactIds LIMIT 20000';
                List<SObject> allr = Database.query(query);

                //Map records
                Map<Id, sObject> allrmap = new Map<Id, sObject>();
                for (sObject s : allr) {
                    allrmap.put((Id)s.get('Id'), s);
                }

                //Loop through submitted records and build surveyAndSobj object for them 
                List<surveyAndSobj> typeCastRecords = new List<surveyAndSobj>();
                for (surveyPayload rec : records) {
                     for (Id con : contactIds){
                        sObject match = allrmap.get(con);
                        MedalliaBulkedInvitationsFromContacts.surveyAndSobj newxml = new MedalliaBulkedInvitationsFromContacts.surveyAndSobj();
                        newxml.payload = rec;
                        newxml.obj = match;
    
                        typeCastRecords.add(newxml);
                     }
                }

                // Convert to JSON
                String jsonval = MedalliaBulkedInvitationsFromContacts.toJSON(typeCastRecords, finalfs);

                // Send the request
                MedalliaBulkedInvitationsFromContacts.sendDocJSON(jsonval, endpoint, username, password, sObjectTypeMaster, 'Bulk');
            }
        } catch (Exception e) {
            System.debug(e);
            Medallia_Integration_Log__c log = new Medallia_Integration_Log__c();
            log.Body__c = JSON.serialize(records);
            log.Status_Code__c = e.getMessage();
            log.Error_Message__c = e.getStackTraceString();
            try {
                log.Object__c = 'Contact';
                log.Record_Id__c = 'Bulk';
            } catch (Exception e2) {
                
            }

            insert log;
        }

            
    }   

    @future(callout=true)
    global static void sendDocJSON(String docstring, String endpoint, String username, String password, String objecttype, String recid) {
        String logall = Label.LogAllMedalliaMessages;

        HttpRequest req = new HttpRequest();
        
        // Use Basic auth if a password is set - Standard Base64 encoding is applied to credentials
        if(password != null){
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
        // For request with IP whitelisting only, the username needs to be appended as a parameter
        }else{
            endpoint = endpoint + '?' + username;
        }
        
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'text/json');
       
        
        
        req.setBody(docstring);
        
        Http http = new Http();
        if (!Test.isRunningTest()) {
            HttpResponse res = http.send(req);
            Medallia_Integration_Log__c log = new Medallia_Integration_Log__c();
            log.Body__c = res.getBody();
            log.Status_Code__c = String.valueOf(res.getStatusCode());
            log.Error_Message__c = '';
            log.Object__c = objecttype;
            log.Record_Id__c = String.valueOf(recid);

            insert log;
        }
        

    }

    global static String toJSON(List<surveyAndSobj> objects, Map<String, Schema.FieldSet> ffs) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();

        for (surveyAndSobj s : objects) {
            sObject sobj = s.obj;
            gen.writeStartObject();
            Schema.FieldSet fieldset = ffs.get((String)sobj.get('Id'));
            List<FieldSetMember> fieldsetm = fieldset.getFields();

            for (FieldSetMember fsm : fieldsetm) {
                String fieldpath = fsm.getFieldPath();
                if (fieldpath.contains('.')) {
                    List<String> fieldpath2 = fieldpath.split('\\.');
                    System.debug(fieldpath2);
                    sObject sobj2 = sobj.getSobject(fieldpath2[0]);
                    if (sobj2 != null) {
                        String val = String.valueOf(sobj2.get(fieldpath2[1]));
                        if (val != null) {
                            gen.writeObjectField(fieldpath, val);
                        } else {
                            gen.writeObjectField(fieldpath, '');
                        }
                    }
                        
                } else {
                    String val = String.valueOf(sobj.get(fieldpath));
                    if (val != null) {
                        gen.writeObjectField(fieldpath, val);
                    } else {
                        gen.writeObjectField(fieldpath, '');
                    }
                }
                
            }
            gen.writeEndObject();
        }   

        gen.writeEndArray();
        return gen.getAsString();
    }
    public static String fieldQuery(String current, List<String> allFields) {

        for(String f : allFields) {
            current += f + ', ';
        }

        return current;
    }

    public static List<String> allFieldsCheck(List<String> currentfields, Schema.FieldSet fieldset) {
        if (fieldset == null) {
            return null;
        } else {
            List<Schema.FieldSetMember> li = fieldset.getFields();
    
            for(Schema.FieldSetMember f : li) {
                Boolean exists = false;
                for (String c : currentfields) {
                    if (f.getFieldPath() == c) {
                        exists = true;
                    }
                }
    
                if (!exists) {
                    currentfields.add(f.getFieldPath());
                }
            }
            return currentfields;
        }
            
    }

    public static Schema.FieldSet readFieldSet(String fieldSetName, String ObjectName) {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        System.debug(fieldSetObj);
        System.debug(DescribeSObjectResultObj);
        return fieldSetObj; 
    }  

    global class surveyPayload {
        @InvocableVariable(required=true)
        global String endpoint;
        
        @InvocableVariable(required=true)
        global String fieldSet;
        
        @InvocableVariable(required=true)
        global List<Account> accountsToSurvey;
        
        @InvocableVariable(required=true)
        global String service;
        
        @InvocableVariable(required=false)
        global String password;
    }

    global class surveyAndSobj {
        global MedalliaBulkedInvitationsFromContacts.surveyPayload payload {get;set;}
        global sObject obj {get;set;}
    }
}