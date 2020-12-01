/**
* @class name: ApprovalRuleEngineController
* @author :  Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date : 10/12/2020
* @description : This is Generic Framework which used to get Approvers based on the Bussiness Rules setup
*                
* @JIRA NAIT-128079 (02870008) : Automate Approval Process
*/
public without sharing class ApprovalRuleEngineController {
    // Utility functions.
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Given a Record and a List of rules, returns a List of titles that should approve the Quote.
     * The titles correspond to the Approver__c field on the Endless_Aisle_Internal_Approval_Rule__c object.
     */
    public static List<String> getApprovalTitles(SObject obj, List<Tech_Sales_Internal_Approval_Rule_Header__c> rules) {
        List<String> approvalTitles = new List<String>();

        for(Tech_Sales_Internal_Approval_Rule_Header__c rule : rules) {
            if(ruleIsMet(obj, rule)) {
                approvalTitles.add(rule.Approver__c);
            }
        }

        return approvalTitles;
    }

    /**
     * Given a Record and a rule, determines whether or not the Record meets all of the rule's criteria.
     */
    private static boolean ruleIsMet(SObject obj, Tech_Sales_Internal_Approval_Rule_Header__c rule) {
        System.debug('rule name =>'+rule.Name );
        for(Tech_Sales_Int_Approval_Rule_Criteria__c criteria : rule.Tech_Sales_Int_Approval_Rules_Criteria__r) {
            if(criteriaIsMet(obj, criteria) == false) {
                return false;
            }
        }
        return true;
    }

     /**
     * Given a Record and a specific criteria, checks if the criteria is met.
     */
    private static Boolean criteriaIsMet(SObject obj, Tech_Sales_Int_Approval_Rule_Criteria__c criteria) {
        //String data comparison
        System.debug('criteria.Text_Value__c =>'+criteria.Text_Value__c );
        
        if(criteria.Text_Value__c != null && criteria.Text_Value__c != ''){
            String fieldValue = getFieldValueString(obj, criteria.Criteria_Field__c);
            System.debug('fieldValue =>'+fieldValue );
            System.debug(' =>'+fieldValue.containsIgnoreCase(criteria.Text_Value__c) );
            switch on criteria.Operator__c {
                when 'Equal To'{
                    //if(fieldValue == criteria.Text_Value__c) { return true; } //Make it contains for Type field
                    if(fieldValue.containsIgnoreCase((criteria.Text_Value__c).unescapeHtml4())) { return true; }
                }
            }
        }else{
            Decimal fieldValue = getFieldValue(obj, criteria.Criteria_Field__c);
        
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
        }
        

        return false;
    }

    /**
     * Given a Record and a Criteria Field from the rule object, returns the Records value for that field.
     * Essentially, maps the Criteria Field from the rule object to a Record field.
     */
    private static Decimal getFieldValue(SObject obj, String criteriaField) {
        try{
            if(obj instanceof Quote){
                Quote q = (Quote) obj;
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
            return null;
        }catch(AuraHandledException e){
            throw new AuraHandledException('Rule has an invalid Criteria: ' + criteriaField);
        }
        
    }

    /**
     * Given a Record and a Criteria Field from the rule object, returns the Records value for that field.
     * Essentially, maps the Criteria Field from the rule object to a Records field.
     */
    private static String getFieldValueString(SObject obj, String criteriaField) {
        try{
            if(obj instanceof CameleonCPQ__QxQuote__c){
                CameleonCPQ__QxQuote__c q = (CameleonCPQ__QxQuote__c) obj;
                switch on criteriaField {
                    when 'Type' {   
                        return q.Type__c;//return obj.Margin_Percent__c;
                    }
                    when 'Issue Term' {
                        return q.Issue_Term__c;//return obj.Margin_Amount__c;
                    }
                    when else {
                        throw new AuraHandledException('Rule has an invalid Criteria: ' + criteriaField);
                    }
                }
            }
            return null;
        }catch(AuraHandledException e){
            throw new AuraHandledException('Rule has an invalid Criteria: ' + criteriaField);
        }
                
    }
    
    /**
     * Helper for getMapWithQuoteOwnerHierarchyAdded.
     * Adds Users from the Quote Account Owner's management hierarchy to the possible approvers Map.
     */
    public static Map<String, User> getMapWithAccOwnerHierarchyAdded(Map<String, User> possibleApprovalUsers, User accOwner) {
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

}