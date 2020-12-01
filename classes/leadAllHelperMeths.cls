/**
* CreatedBy: Shravya Channamadhavuni
* Edited by : joseph tocco
* Date:04/01/2019
* Description: LeadTrigger Helper Class. Contains all the functionality cnsolidated by shravya channamadhavuni for mutiple triggers  and Process builder functionality
+ terraligh leasd assignment by joseph tocco
*/
// Shravya code starts here
public class leadAllHelperMeths {
    public static String funcGT(List<Lead> leadRecsToBChangd) {
        system.debug('BEFORE INSERT AND BEFORE UPDATE:  for Lead(Canada): Updating the AMOUNTCAD field');
        //Updating the Amount field with AmountCad field 
        for(Lead myLead:leadRecsToBChangd) {
            if(myLead.Amount_CAD__c !=null) {
                myLead.Amount__c = myLead.Amount_CAD__c;   
            }   
        }
        return 'success';
    }
    public static String funcTimeZone(List<Lead> leadRecsToBChangd, List<String> zipCodes) {
        system.debug('BEFORE UPDATE : for all record types: Time Zone');
        Map<String,String> zipToTimeZone= new Map<String,String>();
        //Zipcodes- List contains all the zip codes and query on Location Assignment sobject , save in zipToTimeZone Map
        for (Location_Assignment__c loc : [SELECT Name, Time_Zone__c FROM Location_Assignment__c WHERE Name IN :zipCodes]) {
            zipToTimeZone.put(loc.Name, loc.Time_Zone__c);
        }
        //Update the Timezone field on leads whose zip is not null
        for(Lead myLead:leadRecsToBChangd) {
            myLead.Time_Zone__c =zipToTimeZone.get(myLead.Zip_5digit__c);
        }        
        return 'success';    
    }
    public static string funcResponseTime(List<Lead> leadRecsToBChangd) {
        system.debug('BEFORE UPDATE :for all record types : Response Time');
        // Subtracting the Lead's Last Modified date and Created Date
        for(Lead myLead:leadRecsToBChangd) {
            datetime dttime = myLead.lastmodifieddate;
            date lstmod = date.newinstance(dttime.year(),dttime.month(),dttime.day());
            myLead.lead_response_time__c = lstmod.daysBetween(system.today());
        }
        return 'success';       
    }
    //Shravya code ends here
    public static String funcLeadAssgnmnt(List<Lead> leadRecsToBChangd) {
        system.debug('AFTER UPDATE & AFTER iNSERT :for LEAD(US) record type');
        // The Lead Assignment Settings controls what Alignment a Lead gets assigned to.
        List<Lead_Assignment_Setting__c> leadAssignmentSettings = [
            SELECT Id, Priority__c, Alignment__c, Min_WCW__c, Max_WCW__c, Assign_To_Lead_Triage__c
            FROM Lead_Assignment_Setting__c
            ORDER BY Priority__c ASC
        ];
        // Retrieve the Lead Triage Queue record.
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        // Retrieve the Lead Triage Alignment record.
        List<TAV4__Alignment__c> triageAlignments = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage' LIMIT 1];
        TAV4__Alignment__c leadTriageAlignment = null;
        if(triageAlignments.size() > 0) {
            leadTriageAlignment = triageAlignments[0];
        }
        // We retrieve the Sales Areas associated with the Leads.
        List<Id> salesAreaIds = new List<Id>();
        for(Lead l : leadRecsToBChangd) {
            salesAreaIds.add(l.TAV4__Sales_Area__c);
        }
        List<TAV4__Sales_Area__c> salesAreas = [
            SELECT Id, Sales_Rep_Owner__r.TAV4__Sales_Rep__r.TAV4__User__c
            FROM TAV4__Sales_Area__c WHERE Id IN :salesAreaIds
        ];
        List<Lead> leadsToUpdate = new List<Lead>();       
        for(Lead l : leadRecsToBChangd) {
            // We create a new reference to the Lead so that it can be compared with the old to see if changes have been made.
            // Note that this does not point to the same object as l in memory, but it has the same ID so will update the same object in the DB.
            Lead leadToUpdate = new Lead(Id = l.Id, TAV4__Alignment__c = l.TAV4__Alignment__c, OwnerId = l.OwnerId, Auto_Assign__c = l.Auto_Assign__c);
            
            // We go through the Lead Assignment Settings, which are sorted in ascending order by Priority, to see if the Lead matches any of their criteria.
            Lead_Assignment_Setting__c chosenSetting = null;
            for(Lead_Assignment_Setting__c las : leadAssignmentSettings) {
                // If the Lead matches the criteria for the Lead Assignment Setting, we set its Alignment to be the one specified in the Setting.
                if(l.WCW_Count__c >= las.Min_WCW__c && l.WCW_Count__c <= las.Max_WCW__c) {
                    chosenSetting = las;
                    break;
                }
            }
            leadToUpdate.TAV4__Alignment__c = chosenSetting == null ? null : chosenSetting.Alignment__c;           
            // If Auto Assign is set to true, we update the Lead Owner.
            if(l.Auto_Assign__c == true) {
                // Default to Lead Triage
                leadToUpdate.OwnerId = leadTriageQueue.QueueId;                
                // Set the Lead owner to be the corresponding Sales Area's Record Owner/Sales Rep. If there is
                // no corresponding Sales Area, or there is no Record Owner/Sales Rep, we change nothing here.
                for(TAV4__Sales_Area__c salesArea : salesAreas) {
                    if(l.TAV4__Sales_Area__c == salesArea.Id && salesArea.Sales_Rep_Owner__c != null && salesArea.Sales_Rep_Owner__r.TAV4__Sales_Rep__c != null && salesArea.Sales_Rep_Owner__r.TAV4__Sales_Rep__r.TAV4__User__c != null) {
                        leadToUpdate.OwnerId = salesArea.Sales_Rep_Owner__r.TAV4__Sales_Rep__r.TAV4__User__c;
                    }
                }                
                // If the Owner Id is null, or Lead Assignment Setting that was chosen specifies to do so, assign to the Lead Triage Queue.
                // Note that this overrides the Sales Area Record Owner that may have been assigned above.
                if(chosenSetting != null && chosenSetting.Assign_To_Lead_Triage__c == true) {
                    leadToUpdate.OwnerId = leadTriageQueue.QueueId;
                }               
                // If no changes have been made, we have already made the necessary changes. We turn Auto Assign off.
                if(leadToUpdate.TAV4__Alignment__c == l.TAV4__Alignment__c && leadToUpdate.OwnerId == l.OwnerId) {
                    leadToUpdate.Auto_Assign__c = false;
                }                
                // If Auto Assign is off and the Lead Owner is the Lead Triage Queue, we update the Alignment to match.
            } else if(leadToUpdate.OwnerId == leadTriageQueue.QueueId && leadTriageAlignment != null) {
                leadToUpdate.TAV4__Alignment__c = leadTriageAlignment.Id;
            }            
            // We only update the Leads that have been changed, to avoid an infinite loop of After Triggers.
            if(leadToUpdate.TAV4__Alignment__c != l.TAV4__Alignment__c || leadToUpdate.OwnerId != l.OwnerId || leadToUpdate.Auto_Assign__c != l.Auto_Assign__c) {
                leadsToUpdate.add(leadToUpdate);
            }
        }        
        // If any Leads have been changed, update them.
        if(leadsToUpdate.size() > 0) {
            update leadsToUpdate;
        }        
        return 'success';
    } 
    public static String funcDuplicateCheck(List<Lead> leadRecsToBChangd) {
        system.debug('AFTER iNSERT :for LEAD(US) record type: Flag Potential duplicate field');
        List<Id> leadIdsToCheck = new List<Id>();
        for(Lead ld : leadRecsToBChangd) {
            if(ld.Potential_Duplicate__c == false) {
                leadIdsToCheck.add(ld.Id);
            }
        }
        if(!Test.isRunningTest()) {
            setDupFlagIfNecessary(leadIdsToCheck);
        }     
        return 'success';
    }    
    @future(callout=true)
    public static void setDupFlagIfNecessary(List<Id> leadIds) {
        List<Lead> lds = [SELECT Id, Company, Address1__c, city__c, State__c, Zip__c FROM Lead WHERE Id IN: leadIds];        
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead ld : lds) {
            System.debug('Here: ' + ld.Company + ' : ' + ld.Address1__c + ' : ' + ld.city__c + ' : ' + ld.State__c + ' : ' + ld.Zip__c);
            List<Account> accnts = AggroServiceRunner.search_for_account_matches(ld.Company, ld.Address1__c, ld.city__c, ld.State__c, ld.Zip__c);
            System.debug('Here: ' + accnts.size());
            if(accnts.size() > 0) {
                ld.Potential_Duplicate__c = true;
                leadsToUpdate.add(ld);
            }
        }     
        update leadsToUpdate;
    }    
    public static String funcLegacyDuplicateCheck(List<Lead> leadRecsToBChangd) {
        system.debug('BEFORE iNSERT :for LEAD(Canada) record type');
        Set<String> nameSet = new Set<String>();
        Set<String> fNameSet = new Set<String>();
        Set<String> lNameSet = new Set<String>();
        Set<String> companySet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> zipSet = new Set<String>();
        Set<String> stateSet = new Set<String>();
        for(Lead ld: leadRecsToBChangd) {
            if(ld.Name != null && ld.Name != '')
                nameSet.add(ld.Name);
            if(ld.FirstName != null && ld.FirstName != '')
                fNameSet.add(ld.FirstName);
            if(ld.LastName != null && ld.LastName != '')
                lNameSet.add(ld.LastName);
            if(ld.Company != null && ld.Company != '')
                companySet.add(ld.Company);
            if(ld.Phone != null && ld.Phone != '')
                phoneSet.add(ld.Phone);
            if(ld.Email != null && ld.Email != '')
                emailSet.add(ld.Email);
            if(ld.Zip__c != null && ld.Zip__c != '')
                zipSet.add(ld.Zip__c);
            if(ld.State__c != null && ld.State__c != '')
                stateSet.add(ld.State__c);
        }       
        DuplicateLeadPotential dlp = new DuplicateLeadPotential();
        List<Lead> lstLeads = dlp.getMatchingLeads(nameSet, companySet, emailSet, phoneSet, zipSet, stateSet);
        List<contact>  lstContacts = dlp.getMatchingContacts(fNameSet, lNameSet, emailSet, phoneSet);
        List<Account>  lstAccounts = dlp.getMatchingAccounts(companySet, zipSet, stateSet);        
        for(Lead ld: leadRecsToBChangd) {
            Boolean dupFound = false;
            for(Lead l: lstLeads) {
                if(l.Name == ld.Name || l.Company == ld.Company || l.Phone == ld.Phone || l.Email == ld.Email) {
                    dupFound = true;
                    break;
                }
            }
            if(!dupFound) {
                for(Contact c: lstContacts) {
                    if((c.FirstName == ld.FirstName || c.LastName == ld.LAstName) && (c.Phone == ld.Phone || c.Email == ld.Email)) {
                        dupFound = true;
                        break;
                    }
                }
            }
            if(!dupFound) {
                for(Account a: lstAccounts) {
                    if(a.Name == ld.Company && (a.Zip__c == ld.Zip__c || a.State__c == ld.State__c)) {
                        dupFound = true;
                        break;
                    }
                }
            }
            if(dupFound)
                ld.Potential_Duplicate__c = true;
        }       
        return 'success';
    }
	
	//Start: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
	//Below method updates Sales_Person_ID__c and Owner on current lead based on Sales_Rep_Name__c
	public static void updateSalesrepAndOwner(Map<Id, Lead> oldLeadMap, list<Lead> newLeadList)
	{
		map<Id,list<Lead>> mapUserIdLead = new map<Id,list<Lead>>();
		
		for(Lead newLead: newLeadList)
		{
			if((oldLeadMap != null && newLead.Sales_Rep_Name__c != null && newLead.Sales_Rep_Name__c != oldLeadMap.get(newLead.Id).Sales_Rep_Name__c)
				|| oldLeadMap == null && newLead.Sales_Rep_Name__c != null)
			{
				if(mapUserIdLead.containskey(newLead.Sales_Rep_Name__c))
				{
					mapUserIdLead.get(newLead.Sales_Rep_Name__c).add(newLead);
				}
				else
				{
					list<Lead> lstNewLead = new list<Lead>();
					lstNewLead.add(newLead);
					mapUserIdLead.put(newLead.Sales_Rep_Name__c,lstNewLead);
				}	
			}
		}
		
		if(mapUserIdLead.size() > 0)
		{
			list<Sales_Person__c> lstSalesperson = [select Id,User__c from Sales_Person__c where Primary__c = true and User__c in:mapUserIdLead.keyset() order by createddate asc];
			if(lstSalesperson != null && lstSalesperson.size() > 0)
			{
				for(Sales_Person__c salesrep: lstSalesperson)
				{
					if(salesrep.User__c != null && mapUserIdLead.containskey(salesrep.User__c) && mapUserIdLead.get(salesrep.User__c) != null && mapUserIdLead.get(salesrep.User__c).size() > 0 )
					{
						for(Lead currLead: mapUserIdLead.get(salesrep.User__c))
						{
							currLead.Ownerid = salesrep.User__c;
							currLead.Sales_Person_ID__c = salesrep.Id;
						}
					}
				}
			}
		}
	}
	//End: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
}