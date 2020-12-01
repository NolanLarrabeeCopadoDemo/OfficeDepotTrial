global class ConvertLead {
	
    /**
     * The parameter conversionIds is a List of Lists because of the
     * way flows call this method. The first Id is the Lead Id, the
     * second is the Account Id, and the third is the Contact Id.
     */
    @InvocableMethod
    global static void convertLead(List<List<Id>> conversionIds) {
        if(conversionIds.size() == 0 || conversionIds.get(0).size() != 3) return;
        
        Id leadId = conversionIds.get(0).get(0);
        Id accountId = conversionIds.get(0).get(1);
        Id contactId = conversionIds.get(0).get(2);
        
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(leadId);
        leadConvert.setAccountId(accountId);
        leadConvert.setContactId(contactId);

        List < LeadStatus > lstLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true];
        if (lstLeadStatus.size() > 0) {
            leadConvert.setConvertedStatus(lstLeadStatus[0].MasterLabel);
        }
        Database.LeadConvertResult leadConvertResult = Database.ConvertLead(leadConvert);
    }
}