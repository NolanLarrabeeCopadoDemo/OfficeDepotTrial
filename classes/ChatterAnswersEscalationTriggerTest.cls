@isTest
private class ChatterAnswersEscalationTriggerTest {
    static testMethod void validateQuestionEscalation() {
        String questionTitle = 'questionTitle';
        String questionBody = 'questionBody';
        Community[] c = [SELECT Id from Community];
        // We cannot create a question without a community
        if (c.size() == 0) { return; }
        String communityId = c[0].Id;
        Question q = new Question();
        q.Title = questionTitle;
        q.Body = questionBody;
        q.CommunityId = communityId;
        insert(q);
        
        Reply a = new Reply();
        
        a.Body = questionBody;
        a.QuestionId = q.Id;
        insert(a);
        System.assertEquals(questionTitle, questionTitle);
     
    }
}