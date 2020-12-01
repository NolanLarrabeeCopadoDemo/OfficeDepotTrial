public with sharing class EndlessAisleInternalApproval {
    
    /**
     * Retrieves a Quote using it's SFDC ID.
     */
    @AuraEnabled
    public static Quote getQuote(String quoteId) {
        try {
            Quote q = [SELECT Id, QuoteNumber, Internal_Approval_Status__c FROM Quote WHERE Id =: quoteId];
            return q;
        } catch(Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the quote.');
        }
    }

    // Approval Users.
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Given a Quote's SFDC ID, returns the internal Users who should approve that Quote.
     * Who should approve a particular quote is decided based on a rules table.
     */
    @AuraEnabled
    public static List<User> getApprovalUsers(String quoteId) {
        try {
            Quote q = [SELECT Id, OwnerId, Account.OwnerId, Margin_Percent__c, Margin_Amount__c, TotalPrice, Total_Cost_Rollup__c, Total_Line_Item_Qty__c
                        FROM Quote WHERE Id =: quoteId];
            List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                        FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c = 'Tech Sale' AND Approver__c != 'Procurement Queue' AND Active__c = true];
            Map<String, User> possibleApprovalUsers = getPossibleApprovalUsers(q);
            Endless_Aisle_Internal_Approver_Ordering__mdt metadata = [SELECT Id, Approver_1__c, Approver_2__c, Approver_3__c,Approver_4__c,
                                                        Approver_5__c, Approver_6__c, Approver_7__c,Approver_8__c,Approver_9__c,Approver_10__c
                                                        FROM Endless_Aisle_Internal_Approver_Ordering__mdt LIMIT 1];
            
            List<String> approvalTitles = getApprovalTitles(q, rules);
            List<String> orderedApprovalTitles = getOrderedUserApprovalTitles(approvalTitles, metadata);
            List<User> approvalUsers = getActualApprovalUsers(possibleApprovalUsers, orderedApprovalTitles);
            return approvalUsers;
        } catch(Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the approval users.');
        }
    }

    /**
     * Helper for getApprovalUsers.
     * Given a quote, returns the possible approvers from the Quote Owner's
     * management hierarchy and the Quote Account Owner's management hierarchy.
     * The result is organized in a Map - Key: Position, Value: User, where the position
     * corresponds to the Approver__c field on the Endless_Aisle_Internal_Approval_Rule__c object.
     * Note: If more Queues are added as options in the Rules table, they should also be added here.
     */
    private static Map<String, User> getPossibleApprovalUsers(Quote q) {
        User quoteOwner = [SELECT Id, Manager_ID__c, Director_ID__c, Senior_Director_ID__c, VP_ID__c, SVP_ID__c FROM User WHERE Id =: q.OwnerId];
        User accOwner = [SELECT Id, Manager_ID__c, Director_ID__c, Senior_Director_ID__c, VP_ID__c, SVP_ID__c FROM User WHERE Id =: q.Account.OwnerId];
        
        Map<String, User> possibleApprovalUsers = new Map<String, User>();
        possibleApprovalUsers = getMapWithQuoteOwnerHierarchyAdded(possibleApprovalUsers, quoteOwner);
        possibleApprovalUsers = getMapWithAccOwnerHierarchyAdded(possibleApprovalUsers, accOwner);

        return possibleApprovalUsers;
    }

    /**
     * Helper for getMapWithQuoteOwnerHierarchyAdded.
     * Adds Users from the Quote Owner's management hierarchy to the possible approvers Map.
     */
    private static Map<String, User> getMapWithQuoteOwnerHierarchyAdded(Map<String, User> possibleApprovalUsers, User quoteOwner) {
        Map<String, User> mapWithAdditions = new Map<String, User>(possibleApprovalUsers);

        User quoteManager = getUser(quoteOwner.Manager_ID__c);
        User quoteDirector = getUser(quoteOwner.Director_ID__c);
        User quoteSeniorDirector = getUser(quoteOwner.Senior_Director_ID__c);
        User quoteVP = getUser(quoteOwner.VP_ID__c);
        User quoteSVP = getUser(quoteOwner.SVP_ID__c);
        if(quoteManager != null) { mapWithAdditions.put('Quote Owner Manager', quoteManager); }
        if(quoteDirector != null) { mapWithAdditions.put('Quote Owner Director', quoteDirector); }
        if(quoteSeniorDirector != null) { mapWithAdditions.put('Quote Owner Senior Director', quoteSeniorDirector); }
        if(quoteVP != null) { mapWithAdditions.put('Quote Owner VP', quoteVP); }
        if(quoteSVP != null) { mapWithAdditions.put('Quote Owner SVP', quoteSVP); }

        return mapWithAdditions;
    }

    /**
     * Helper for getMapWithQuoteOwnerHierarchyAdded.
     * Adds Users from the Quote Account Owner's management hierarchy to the possible approvers Map.
     */
    private static Map<String, User> getMapWithAccOwnerHierarchyAdded(Map<String, User> possibleApprovalUsers, User accOwner) {
        Map<String, User> mapWithAdditions = new Map<String, User>(possibleApprovalUsers);

        User accManager = getUser(accOwner.Manager_ID__c);
        User accDirector = getUser(accOwner.Director_ID__c);
        User accSeniorDirector = getUser(accOwner.Senior_Director_ID__c);
        User accVP = getUser(accOwner.VP_ID__c);
        User accSVP = getUser(accOwner.SVP_ID__c);
        if(accManager != null) { mapWithAdditions.put('Account Owner Manager', accManager); }
        if(accDirector != null) { mapWithAdditions.put('Account Owner Director', accDirector); }
        if(accSeniorDirector != null) { mapWithAdditions.put('Account Owner Senior Director', accSeniorDirector); }
        if(accVP != null) { mapWithAdditions.put('Account Owner VP', accVP); }
        if(accSVP != null) { mapWithAdditions.put('Account Owner SVP', accSVP); }

        return mapWithAdditions;
    }

    /**
     * Given a User's SFDC ID, returns the User with select fields populated.
     * If the User can't be found, null is returned.
     */
    private static User getUser(String userId) {
        List<User> usrs = [SELECT Id, Name, Job_Code_Level__c FROM User WHERE Id =: userId AND IsActive = true];
        if(usrs.size() > 0) {
            return usrs[0];
        }
        return null;
    }

    /**
     * Helper for getApprovalUsers.
     * Returns the approval titles ordered based on the metadata settings.
     */
    private static List<String> getOrderedUserApprovalTitles(List<String> approvalTitles, Endless_Aisle_Internal_Approver_Ordering__mdt metadata) {
        List<String> orderedApprovalTitles = new List<String>();
        if(approvalTitles.contains(metadata.Approver_1__c)) { orderedApprovalTitles.add(metadata.Approver_1__c); }
        if(approvalTitles.contains(metadata.Approver_2__c)) { orderedApprovalTitles.add(metadata.Approver_2__c); }
        if(approvalTitles.contains(metadata.Approver_3__c)) { orderedApprovalTitles.add(metadata.Approver_3__c); }
        if(approvalTitles.contains(metadata.Approver_4__c)) { orderedApprovalTitles.add(metadata.Approver_4__c); }
        if(approvalTitles.contains(metadata.Approver_5__c)) { orderedApprovalTitles.add(metadata.Approver_5__c); }
        if(approvalTitles.contains(metadata.Approver_6__c)) { orderedApprovalTitles.add(metadata.Approver_6__c); }
        if(approvalTitles.contains(metadata.Approver_7__c)) { orderedApprovalTitles.add(metadata.Approver_7__c); }
        if(approvalTitles.contains(metadata.Approver_8__c)) { orderedApprovalTitles.add(metadata.Approver_8__c); }
        if(approvalTitles.contains(metadata.Approver_9__c)) { orderedApprovalTitles.add(metadata.Approver_9__c); }
        if(approvalTitles.contains(metadata.Approver_10__c)) { orderedApprovalTitles.add(metadata.Approver_10__c); }
        return orderedApprovalTitles;
    }

    /**
     * Helper for getApprovalUsers.
     * Given the Map of possible approvers and a list of positions/titles that
     * should approve, returns a List of the Users who will be approving.
     */
    private static List<User> getActualApprovalUsers(Map<String, User> possibleApprovalUsers, List<String> approvalTitles) {
        List<User> actualApprovalUsers = new List<User>();
        for(String title : approvalTitles) {
            if(!possibleApprovalUsers.containsKey(title)) { continue; }
            if(listIncludesUser(actualApprovalUsers, possibleApprovalUsers.get(title))) { continue; }
            
            actualApprovalUsers.add(possibleApprovalUsers.get(title));
        }
        return actualApprovalUsers;
    }

    /**
     * Helper for getActualApprovalUsers.
     * Given a List of Users and a single User, determines if the User is in the List.
     */
    private static boolean listIncludesUser(List<User> usrs, User usr) {
        for(User listUser : usrs) {
            if(listUser.Id == usr.Id) {
                return true;
            }
        }
        return false;
    }

    // Approval Groups
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Given a Quote's SFDC ID, returns the Groups that should approve that Quote.
     * Which Groups should approve a particular quote is decided based on a rules table.
     */
    @AuraEnabled
    public static List<String> getApprovalGroups(String quoteId) {
        try {
            Quote q = [SELECT Id, Margin_Percent__c, Margin_Amount__c, TotalPrice, Total_Cost_Rollup__c, Total_Line_Item_Qty__c
                        FROM Quote WHERE Id =: quoteId];
            List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                        FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c = 'Tech Sale' AND Approver__c = 'Procurement' AND Active__c = true];
            Endless_Aisle_Internal_Approver_Ordering__mdt metadata = [SELECT Id, Group_Approver_1__c
                                                        FROM Endless_Aisle_Internal_Approver_Ordering__mdt LIMIT 1];

            List<String> approvalGroups = getApprovalTitles(q, rules);
            List<String> orderedApprovalGroups = getOrderedApprovalGroups(approvalGroups, metadata);
            return orderedApprovalGroups;
        } catch(Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the approval groups.');
        }
    }

    /**
     * Helper for getApprovaGroups.
     * Returns the approval groups ordered based on the metadata settings.
     * Ensures each group only exists once in the returned List.
     */
    private static List<String> getOrderedApprovalGroups(List<String> approvalGroups, Endless_Aisle_Internal_Approver_Ordering__mdt metadata) {
        List<String> orderedApprovalGroups = new List<String>();
        if(approvalGroups.contains(metadata.Group_Approver_1__c) && !orderedApprovalGroups.contains(metadata.Group_Approver_1__c)) {
            orderedApprovalGroups.add(metadata.Group_Approver_1__c);
        }
        return orderedApprovalGroups;
    }

    // Approval Process
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Given a quote SFDC ID, sets the proper approver values and submits the Approval Process.
     * If no approvers are necessary, it doesn't submit for approval, but marks the Internal
     * Approval Status as 'Approved'.
     */
    @AuraEnabled
    public static void initiateApprovalProcess(String quoteId) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<String> groupApprovers = getApprovalGroups(quoteId);
            List<User> userApprovers = getApprovalUsers(quoteId);
            Quote q = [SELECT Id, Procurement__c, Approver_1__c, Approver_2__c,Approver_3__c, Approver_4__c,Approver_5__c,
                        Approver_6__c, Approver_7__c, Approver_8__c, Approver_9__c, Approver_10__c
                        FROM Quote WHERE Id =: quoteId];

            updateQuote(q, groupApprovers, userApprovers); // Note that q is modified in this function.
            
            if(hasApprovers(q)) {
                submitApprovalProcess(q);
            } else {
                q.Internal_Approval_Status__c = 'Approved';
                q.Status = 'Approved by OD';
                update q;
            }
        } catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException('An error ocurred while submitting the quote for approval.');
        }
    }

    /**
     * Helper for initiateApprovalProcess.
     * Given a quote and list of Group and User approvers, sets the approvers on the quote.
     * Note that this function has a side effect. It updates the quote in the database.
     */
    private static void updateQuote(Quote q, List<String> groupApprovers, List<User> userApprovers) {
        clearQuoteApprovers(q);

        if(groupApprovers.contains('Procurement')) { q.Procurement__c = true; }
        if(userApprovers.size() >= 1) { q.Approver_1__c = userApprovers.get(0).Id; }
        if(userApprovers.size() >= 2) { q.Approver_2__c = userApprovers.get(1).Id; }
        if(userApprovers.size() >= 3) { q.Approver_3__c = userApprovers.get(2).Id; }
        if(userApprovers.size() >= 4) { q.Approver_4__c = userApprovers.get(3).Id; }
        if(userApprovers.size() >= 5) { q.Approver_5__c = userApprovers.get(4).Id; }
        if(userApprovers.size() >= 6) { q.Approver_6__c = userApprovers.get(5).Id; }
        if(userApprovers.size() >= 7) { q.Approver_7__c = userApprovers.get(6).Id; }
        if(userApprovers.size() >= 8) { q.Approver_8__c = userApprovers.get(7).Id; }
        if(userApprovers.size() >= 9) { q.Approver_9__c = userApprovers.get(8).Id; }
        if(userApprovers.size() >= 10) { q.Approver_10__c = userApprovers.get(9).Id; }
        
        update q;
    }

    /**
     * Helper for updateQuote.
     * Clears all of the approver values on the quote.
     * Note that this function modifies the supplied Quote.
     */
    private static void clearQuoteApprovers(Quote q) {
        q.Procurement__c = false;
        q.Approver_1__c = null;
        q.Approver_2__c = null;
        q.Approver_3__c = null;
        q.Approver_4__c = null;
        q.Approver_5__c = null;
        q.Approver_6__c = null;
        q.Approver_7__c = null;
        q.Approver_8__c = null;
        q.Approver_9__c = null;
        q.Approver_10__c = null;
    }

    /**
     * Helper for initiateApprovalProcess.
     * Returns true if there are any approvers on the Quote.
     */
    private static boolean hasApprovers(Quote q) {
        if(q.Procurement__c == true || q.Approver_1__c != null) {
            return true;
        }
        return false;
    }

    /**
     * Helper for initiateApprovalProcess.
     * Given the quote, launches the Approval Process.
     */
    private static void submitApprovalProcess(Quote q) {
        // We must temporarily set this flag to true so that the
        // Quote meets the Approval Process entry criteria.
        q.Internal_Approval_Allowed__c = true;
        update q;
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setObjectId(q.Id);
        approvalRequest.setProcessDefinitionNameOrId('Endless_Aisle_Internal_Approvals');
        Approval.ProcessResult result = Approval.process(approvalRequest);
        if(!result.isSuccess()) {
            throw new AuraHandledException('Approval process failed to submit.');
        }
    }

    // Utility functions.
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Given a Quote and a List of rules, returns a List of titles that should approve the Quote.
     * The titles correspond to the Approver__c field on the Endless_Aisle_Internal_Approval_Rule__c object.
     */
    private static List<String> getApprovalTitles(Quote q, List<Tech_Sales_Internal_Approval_Rule_Header__c> rules) {
        List<String> approvalTitles = new List<String>();

        for(Tech_Sales_Internal_Approval_Rule_Header__c rule : rules) {
            if(ruleIsMet(q, rule)) {
                approvalTitles.add(rule.Approver__c);
            }
        }

        return approvalTitles;
    }

    /**
     * Given a Quote and a rule, determines whether or not the Quote meets all of the rule's criteria.
     */
    private static boolean ruleIsMet(Quote q, Tech_Sales_Internal_Approval_Rule_Header__c rule) {

        for(Tech_Sales_Int_Approval_Rule_Criteria__c criteria : rule.Tech_Sales_Int_Approval_Rules_Criteria__r) {
            if(criteriaIsMet(q, criteria) == false) {
                return false;
            }
        }
        return true;
    }

    /**
     * Given a Quote and a specific criteria, checks if the criteria is met.
     */
    private static Boolean criteriaIsMet(Quote q, Tech_Sales_Int_Approval_Rule_Criteria__c criteria) {
        Decimal fieldValue = getFieldValue(q, criteria.Criteria_Field__c);
        
        switch on criteria.Operator__c {
            when 'Greater Than' {
                if(fieldValue > criteria.Value__c) { return true; }
            }
            when 'Greater Than Or Equal To' {
                if(fieldValue >= criteria.Value__c) { return true; }
            }
            when 'Less Than' {
                if(fieldValue < criteria.Value__c) { return true; }
            }
            when 'Less Than Or Equal To' {
                if(fieldValue <= criteria.Value__c) { return true; }
            }
        }

        return false;
    }

    /**
     * Given a Quote and a Criteria Field from the rule object, returns the Quotes value for that field.
     * Essentially, maps the Criteria Field from the rule object to a Quote field.
     */
    private static Decimal getFieldValue(Quote q, String criteriaField) {
        switch on criteriaField {
            when 'Margin Percentage' {
                return q.Margin_Percent__c;
            }
            when 'Margin Amount' {
                return q.Margin_Amount__c;
            }
            when 'Price' {
                return q.TotalPrice;
            }
            when 'Cost' {
                return q.Total_Cost_Rollup__c;
            }
            when 'Quantity' {
                return q.Total_Line_Item_Qty__c;
            }
            when else {
                throw new AuraHandledException('Rule has an invalid Criteria: ' + criteriaField);
            }
        }
    }
}