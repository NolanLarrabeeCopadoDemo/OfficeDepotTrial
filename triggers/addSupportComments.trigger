/*
*   Adds and Updates the Production Date on IT Support Cases.
*   Removes IT Support Cases from release parents based on certain criteria.
*/
trigger addSupportComments on Case (after update, after insert, after delete) {
    final String ITCaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Constants.IT_CASES).getRecordTypeId();
    final String ITReleaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Constants.IT_RELEASE).getRecordTypeId();
    final String prodDateInsertComment = 'Production Date Added/Updated: \n - Date/Time Added to Case: <timeStamp> \n- Added/Updated By: <currentUser> \n- Production Date: <pDate> \n- Action: Changed Production Date* to <pDate>';
    final String prodDateUpdateComment = 'Production Date Added/Updated: \n - Date/Time Added to Case: <timeStamp> \n- Added/Updated By: <currentUser> \n- Production Date: <pDate> \n- Action: Changed Production Date* from <pDateOld> to <pDate>';
    final String childCaseRemovedComment = '- Case removed from release parent: <caseNumber> \n- Date/Time removed: <timeStamp> \n- Removed by: <currentUser>';

    final String TIME_ZONE = 'America/New_York';
    final String TIME_STAMP_FORMAT = 'MM/dd/yyyy hh:mm:ss a';
    final String TIME_STAMP = '<timeStamp>';
    final String PRODUCTION_DATE = '<pDate>';
    final String PRODUCTION_DATE_OLD = '<pDateOld>';
    final String CURRENT_USER = '<currentUser>';
    final String CASE_NUMBER = '<caseNumber>';

    if (Trigger.isAfter)
    {
        if (Trigger.isInsert)
        {
            List <CaseComment> caseComments = new List<CaseComment>();
            for (Case newCase: Trigger.new) {
                if (newCase.RecordTypeId == ITCaseRecType && newCase.IT_Production_Date__c != null) {
                    CaseComment caseComment = new CaseComment();
                    String timeStamp = (System.now()).format(TIME_STAMP_FORMAT,TIME_ZONE);
                    String commentText = prodDateInsertComment;
                    commentText = commentText.replace(TIME_STAMP, timeStamp);
                    commentText = commentText.replaceAll(PRODUCTION_DATE, (newCase.IT_Production_Date__c).format());
                    commentText = commentText.replace(CURRENT_USER, UserInfo.getName());
                    caseComment.ParentId = newCase.id;
                    caseComment.commentBody = commentText;
                    caseComments.add(caseComment);
                }
            }
            if (caseComments.size() > 0) {
                insert caseComments;
            }
        }
        
        if (Trigger.isUpdate)
        {
            List <CaseComment> caseComments = new List<CaseComment>();
            for (Case newCase: Trigger.new) {
                if (newCase.RecordTypeId == ITCaseRecType && Trigger.oldMap.get(newCase.id).IT_Production_Date__c != newCase.IT_Production_Date__c ) {
                    CaseComment caseComment = new CaseComment();
                    String timeStamp = (System.now()).format(TIME_STAMP_FORMAT,TIME_ZONE);
                    String commentText = prodDateUpdateComment;
                    commentText= commentText.replace(TIME_STAMP, timeStamp);
                    commentText = commentText.replaceAll(PRODUCTION_DATE, newCase.IT_Production_Date__c != null ?(newCase.IT_Production_Date__c).format() : '""');
                    commentText = commentText.replace(CURRENT_USER, UserInfo.getName());
                    commentText = commentText.replace(PRODUCTION_DATE_OLD, Trigger.oldMap.get(newCase.id).IT_Production_Date__c != null ?(Trigger.oldMap.get(newCase.id).IT_Production_Date__c).format():'""');
                    caseComment.ParentId = newCase.id;
                    caseComment.commentBody = commentText;
                    caseComments.add(caseComment);
                }
            }

            Set <Id> parentCaseIds = new Set <Id>();
            for (Case newCase: Trigger.new) {
                if (newCase.Release_Parent__c == null && Trigger.oldMap.get(newCase.id).Release_Parent__c != newCase.Release_Parent__c) {
                    parentCaseIds.add(Trigger.oldMap.get(newCase.id).Release_Parent__c);
                }
            }

            Map <Id, Case> parentCaseMap = new Map<Id, Case>([Select id, IT_Production_Date__c, CaseNumber from Case where RecordTypeId =:ITReleaseRecType and id in:parentCaseIds]);
            for (Case newCase: Trigger.new) {
                String previousParentCase = Trigger.oldMap.get(newCase.id).Release_Parent__c;
                if (newCase.Release_Parent__c == null &&
                        previousParentCase != newCase.Release_Parent__c &&
                        parentCaseMap.containsKey(previousParentCase) &&
                        newCase.IT_Production_Date__c == parentCaseMap.get(previousParentCase).IT_Production_Date__c) {
                    CaseComment caseComment = new CaseComment();
                    String timeStamp = (System.now()).format(TIME_STAMP_FORMAT,TIME_ZONE);
                    String commentText = childCaseRemovedComment;
                    commentText = commentText.replace(TIME_STAMP, timeStamp);
                    commentText = commentText.replaceAll(CASE_NUMBER, newCase.CaseNumber);
                    commentText = commentText.replace(CURRENT_USER, UserInfo.getName());
                    caseComment.ParentId = previousParentCase;
                    caseComment.commentBody = commentText;
                    caseComments.add(caseComment);
                }
            }
            if (caseComments.size() > 0) {
                insert caseComments;
            }
        }
    }
}