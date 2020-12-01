trigger LeadStagingTrigger on LeadStaging__c (after insert) {

    List<LeadStaging__c> stagingLeads = [
            SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ConnectionReceivedId, ConnectionSentId,
            First_Name__c, Last_Name__c, Email__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Company__c, Source__c, Phone__c, Status__c,StatusMessage__c,
            CreatedLead__c,Product__c,employee_ID__c,employee_Last_Name__c,employee_First_Name__c,additional_Info__c,Relationship__c,Contact_Permission__c,Employee_Location__c,
            ExternalRefID__c,Store_Number__c,URL_Reference__c,Contact_Timeframe__c,Marketing_Opt_In__c,website__c,Company_Size__c
            from leadstaging__c
            WHERE Id IN:Trigger.newMap.keySet()
    ];
    List<String> emailsInStaging = new List<String>();
    List<String> storesRelatedToStagedLeadsNum = new List<String>();
    List<Store__c> storesRelatedToStagedLeadsStore = new List<Store__c>();
    Map<String, Store__C> numToStore = new Map<String, Store__C>();
    
    Id bizBoxLeadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
    Set<ID> bizBoxAccountRts = Util.bizBoxRTIdsByObject('Account');
    Group myGroups = [SELECT Id from Group where Type = 'Queue' and DeveloperName = 'BizBox_Lead_Triage' limit 1];
    Id bizBoxQueueId = myGroups.id;
    System.Debug(bizBoxQueueId);

    //Map of Products	
    BizBoxProducts__mdt[] myBizBoxProducts = [select BizBox_URL_NAME__c, SFDC_Name__c from BizBoxProducts__mdt];
    Map<String, String> SFDCProductAPINameMap = new Map<String, String>();
    for (BizBoxProducts__mdt bbP : myBizBoxProducts) {
        SFDCProductAPINameMap.put(bbp.BizBox_URL_NAME__c, bbp.SFDC_Name__c);
    }

    List<Lead> leadsToUpdate = new List<Lead>();
    List<Lead> leadsToInsert = new List<Lead>();
    List<Task> tasksToInsert = new List<Task>();
    List<LeadStaging__c> lsDupeErrorToUpdate = new List<LeadStaging__c>();
    if (stagingLeads != null) {
        for (LeadStaging__c ls : stagingLeads) {
            if (ls.email__c != null) {
                // System.Debug('Inside staging loop');
                emailsInStaging.add(ls.email__c);
            }
            if (ls.Store_Number__c != null) {

                String paddedNum = ls.Store_Number__c.leftPad(6, '0');
                storesRelatedToStagedLeadsNum.add(paddedNum);
            }

        }
        if (storesRelatedToStagedLeadsNum.size() > 0) {
            storesRelatedToStagedLeadsStore = [Select id, id__C from Store__C where id__c in :storesRelatedToStagedLeadsNum];
            if (storesRelatedToStagedLeadsStore != null) {
                for (Store__c myStore : storesRelatedToStagedLeadsStore) {
                    numToStore.put(myStore.id__C, myStore);
                }
            }
        }


        Map<String, List<Lead>> emailLeadMap = new Map<String, List<Lead>>();
        Map<String, List<Account>> emailAccountMap = new Map<String, List<Account>>();
        List<Lead> bizBoxLeads = new List<Lead>();
        List<Account> bizBoxAccounts = new List<Account>();
        if (emailsInStaging.size() > 0) {
            System.Debug(emailsInStaging.size());
            system.debug('emailsInStaging...' + emailsInStaging);
            bizBoxLeads = [SELECT Id, Email,OwnerID,LastModifiedDate,Products__c from Lead WHERE email in:emailsInStaging and RecordType.DeveloperName = 'Lead_BizBox' and Status != 'Converted' and Status != 'Closed'];
            bizBoxAccounts = [SELECT Id, BizBox_email__c,OwnerID,LastModifiedDate from Account WHERE BizBox_email__c in:emailsInStaging and RecordTypeID in :bizBoxAccountRts];
        }
        System.Debug('BBSize ' + bizBoxLeads.size());
        if (bizBoxLeads.size() != 0 && bizBoxLeads != null) {
            System.Debug('In Existing Leads Loop');
            System.Debug(bizBoxLeads.size() + ' ' + bizBoxLeads);

            for (String iEmail : emailsInStaging) {
                if (iEmail != null) {
                    List<Lead> mappedList = new List<Lead>();
                    for (Lead iLead : bizBoxLeads) {
                        if (iLead.email == iEmail)
                            mappedList.add(iLead);
                    }
                    if (mappedList.size() > 0) {
                        emailLeadMap.put(iEmail, mappedList);
                    }
                }
            }
        }
        if (bizBoxAccounts.size() != 0 && bizBoxAccounts != null) {
            System.Debug('In Existing Acc Loop');
            System.Debug(bizBoxAccounts.size() + ' ' + bizBoxAccounts);

            for (String iEmail : emailsInStaging) {
                if (iEmail != null) {
                    List<Account> mappedList = new List<Account>();
                    for (Account iAccount : bizBoxAccounts) {
                        if (iAccount.BizBox_email__c == iEmail)
                            mappedList.add(iAccount);
                    }
                    if (mappedList.size() > 0) {
                        emailAccountMap.put(iEmail, mappedList);
                    }
                }
            }
        }
        System.debug('SL Size' + stagingLeads.size());
        for (LeadStaging__c ls : stagingLeads) {
            //class
            if (ls.Last_Name__c == null) {
                String errorMessage;
                ls.status__c = 'Error';
                if (ls.Last_Name__c == null) {
                    errorMessage = 'LastName ';
                }
                errorMessage += 'is null, cannot create lead';
                ls.StatusMessage__c = errorMessage;
                System.Debug('Updating LS with error');
                //update ls;
                lsDupeErrorToUpdate.add(ls);
            } else {
                if (emailAccountMap.size() > 0 && ls.email__c != null) {
                    System.Debug('In account map ');
                    List<Account> accountsFromEmail = emailAccountMap.get(ls.email__c);
                    if (accountsFromEmail != null) {
                        Account recentAcc = accountsFromEmail[0];
                        String subjectString = 'Duplicate Lead received: ' + ls.last_name__c;
                        for (Account iAccount : accountsFromEmail) {
                            if (iAccount.LastModifiedDate >= recentAcc.LastModifiedDate) {
                                recentAcc = iAccount;
                            }

                        }
                        Task newTask = LeadStagingUtil.createTask(ls);
                        newTask.WhatID = recentAcc.id;
                        System.debug('Inserting account task info');
                        System.Debug(recentAcc.id);
                        System.Debug(recentAcc.OwnerId);
                        if (((String) recentAcc.OwnerId).startsWithIgnoreCase('005')) {
                            newTask.OwnerId = recentAcc.OwnerId;
                        }


                        //insert newTask;
                        tasksToInsert.add(newTask);

                        ls.status__c = 'Dupe';
                        ls.StatusMessage__c = 'Task Created';
                        //update ls;
                        lsDupeErrorToUpdate.add(ls);
                        continue;
                    }
                } else if (emailLeadMap.size() > 0 && ls.email__c != null) {
                    System.Debug('In dupe lead');
                    List<Lead> leadsFromEmail = emailLeadMap.get(ls.email__c);
                    if (leadsFromEmail != null) {
                        //TODO:Create Task

                        
                        Lead recentLead = leadsFromEmail[0];
                        System.debug(recentLead.LastModifiedDate);
                        String subjectString = 'Duplicate Lead received: ' + ls.last_name__c;
                        for (Lead iLead : leadsFromEmail) {
                            if (iLead.LastModifiedDate >= recentLead.LastModifiedDate) {
                                recentLead = iLead;
                            }

                        }
                        System.Debug('Lead about to task ' + recentLead.id + ' ' + recentLead.OwnerId);
                        Task newTask = LeadStagingUtil.createTask(ls);

                        newTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('BizBox').getRecordTypeId();

                        newTask.WhoId = recentLead.id;
                        if (((String) recentLead.OwnerId).startsWithIgnoreCase('005')) {
                            newTask.OwnerId = recentLead.OwnerId;
                        }


                        //insert newTask;
                        tasksToInsert.add(newTask);

                        ls.status__c = 'Dupe';
                        ls.StatusMessage__c = 'Task Created';
                        //update ls;
                        lsDupeErrorToUpdate.add(ls);
                        if (ls.Product__c != null) {
                            recentLead.Products__c = consolidateProducts(ls, recentLead, SFDCProductAPINameMap);
                            //update recentLead;
                            leadsToUpdate.add(recentLead);
                        }
                    } else {
                        createLead(ls);
                    }
                } else {
                    createLead(ls);
                }

            }
        }

        update lsDupeErrorToUpdate;
        insert tasksToInsert;
        update leadsToUpdate;
        insert leadsToInsert;
        List<ID> StagingLeadsInsertedList = new List<ID>();
        //List<Note> NewNotes = new List<Note>();
        for (Lead lead : leadsToInsert) {
            if (lead.LeadStaging__c != null) {
                StagingLeadsInsertedList.add(lead.LeadStaging__c);
            }

        }
        List<LeadStaging__c> insertedLeadStaging = [Select ID,additional_Info__c,CreatedLead__c from LeadStaging__c where id in :StagingLeadsInsertedList];
        if (insertedLeadStaging != null) {
            for (Lead lead : leadsToInsert) {
                for (LeadStaging__c ls : insertedLeadStaging) {
                    if (lead.LeadStaging__c == ls.id) {
                        ls.CreatedLead__c = lead.id;
                        ls.StatusMessage__c = 'Lead created';
                        ls.status__c = 'Complete';
                        /*if(ls.additional_info__c != null) {
                            Note newNote = New Note();
                            newNote.ParentId = lead.id;
                            newNote.Body = ls.additional_Info__c;
                            newNote.Title = 'Additional Information';
                            NewNotes.add(newNote);
                        }*/
                        break;
                    }

                }

            }
        }
        update insertedLeadStaging;
        //insert NewNotes;
        //update lsCreatedToUpdate;
    }

    private String consolidateProducts(LeadStaging__c ls, Lead l, Map<String, String> SFDCAPINames) {
        String respProducts = '';
        if (ls.product__c != null) {
            Set<String> currentProducts = new Set<String>();
            Set<String> indicatedProducts = new Set<String>();
            Set<String> mergedSet = new Set<String>();
            Set<String> SFDCAPINamesSet = new Set<String>();
            SFDCAPINamesSet.addAll(SFDCAPINames.values());

            if (l.Products__c != null) {
                List<String> listCurrentProducts = l.Products__c.split(';');
                System.Debug(listCurrentProducts);
                for (String product : listCurrentProducts) {
                    currentProducts.addAll(listCurrentProducts);
                }

            }

            if (!SFDCAPINamesSet.isEmpty()) {
                List<String> listIndicatedProducts = ls.Product__c.split(';');
                System.Debug(listIndicatedProducts);
                for (String product : listIndicatedProducts) {
                    indicatedProducts.addAll(listIndicatedProducts);
                }

                for (String product : indicatedProducts) {
                    if (!SFDCAPINamesSet.contains(product)) {
                        String productFromMap = SFDCAPINames.get(product);
                        if (productFromMap != null) {
                            product = productFromMap;
                            System.Debug(product);
                        } else {
                            product = 'Other';
                            System.Debug(product);
                        }
                        System.Debug(product);
                        currentProducts.add(product);

                    } else {
                        System.Debug(product);
                        currentProducts.add(product);
                    }
                }
                //mergedSet.addAll(indicatedProducts);
            }
            for (String product : currentProducts) {
                respProducts += product + ';';
            }
        }

        if (respProducts == '') {
            respProducts = l.Products__c;
        }
        System.Debug(respProducts);
        return respProducts;
    }

    private static void createLead(LeadStaging__c ls) {
        System.debug('EnteredCreateLead');
        if (ls.company__c == null) {
            if (ls.first_name__c != null) {
                ls.company__c = ls.last_name__c + ' ' + ls.first_name__c;
            } else {
                ls.company__c = ls.last_name__c;
            }

        }
        Matcher MyEmailMatcher;
        Matcher MyPhoneMatcher;
        Boolean emailMatch = true;
        Boolean phoneMatch = true;
        if (ls.Email__c != null) {
            System.debug('in null email');
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,100}$';
            Pattern MyPattern = Pattern.compile(emailRegex);
            MyEmailMatcher = MyPattern.matcher(ls.email__c);
            emailMatch = MyEmailMatcher.matches();
        }

        if (emailMatch == False) {
            ls.StatusMessage__c = 'Invalid Email';
            ls.status__c = 'Error';
            lsDupeErrorToUpdate.add(ls);
            return;
        }

        if (emailMatch || ls.email__c == null) {
            Lead insertLead = new Lead();
            insertLead.firstname = ls.first_name__c;
            insertLead.lastname = ls.last_name__c;
            insertLead.email = ls.email__c;
            insertLead.company = ls.company__c;
            insertLead.leadsource = ls.source__c;
            insertLead.state__c = ls.state__c;
            insertLead.address1__c = ls.address1__c;
            insertLead.address2__c = ls.address2__c;
            insertLead.zip__c = ls.zip__c;
            insertLead.city__c = ls.city__c;
            insertLead.phone = ls.phone__c;
            insertLead.RecordTypeId = bizBoxLeadRT;
            insertLead.OwnerId = bizBoxQueueId;
            insertLead.Employee_ID__c = ls.employee_ID__c;
            insertLead.Website = ls.Website__c;
			insertLead.BizBox_Company_Size__c = ls.Company_Size__c;
            //Flag Lead Page Source if lead is from Employee Referral NAIT-41232
            if(ls.source__c == 'Employee Referral')
            {
                insertLead.Lead_Page_Source__c = 'BB/TZ Store Associate Referral Form';
            }

            if (ls.employee_First_Name__c != null || ls.employee_Last_Name__c != null) {
                if (ls.employee_First_Name__c != null && ls.employee_Last_Name__c != null) {
                    insertLead.Employee_Name__c = ls.employee_First_Name__c + ' ' + ls.employee_Last_Name__c;
                } else if (ls.employee_First_Name__c != null && ls.employee_Last_Name__c == null) {
                    insertLead.Employee_Name__c = ls.employee_First_Name__c;
                } else if (ls.employee_Last_Name__c != null && ls.employee_First_Name__c == null) {
                    insertLead.Employee_Name__c = ls.employee_Last_Name__c;
                }
            }
            insertLead.Relationship__c = ls.Relationship__c;
            insertLead.Contact_Permission__c = ls.Contact_Permission__c;
            insertLead.Employee_Location__c = ls.Employee_Location__c;
            insertLead.Marketing_Opt_In__c = ls.Marketing_Opt_In__c;
            insertLead.Contact_Time_Frame__c = ls.Contact_Timeframe__c;
            if (ls.Product__c != null) {
                insertLead.Products__c = consolidateProducts(ls, insertLead, SFDCProductAPINameMap);
            }
            System.debug('Products from cp ' + insertLead.Products__c);

            insertLead.ExternalRefID__c = ls.ExternalRefID__c;
            insertLead.Store_Number__c = ls.Store_Number__c;
            insertLead.LeadStaging__c = ls.ID;
            insertLead.Comments__c = ls.additional_Info__c;
            insertLead.Campaign_Source_URL__c = ls.URL_Reference__c;

            if (ls.Store_Number__c != null) {
                Store__c myStore = numToStore.get(ls.Store_Number__c.leftPad(6, '0'));
                if (myStore != null) {
                    insertLead.Store__c = myStore.id;
                }
            }
            //System.Debug(insertLead.id);
            //insert insertLead;
            leadsToInsert.add(insertLead);

            /*  if (ls.additional_Info__c != null) {

                  Note newNote = New Note();
                  newNote.ParentId = insertLead.id;
                  newNote.Body = ls.additional_Info__c;
                  newNote.Title = 'Additional Information';
                  insert newNote;
              }*/
            //ls.CreatedLead__c = insertLead.id;
            //ls.StatusMessage__c = 'Lead created';
            //ls.status__c = 'Complete';
            //lsCreatedToUpdate.add(ls);
            //update ls;
        } 
    }

}