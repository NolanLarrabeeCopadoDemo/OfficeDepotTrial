@IsTest
public with sharing class ageInITQueue_Test
{
	static String salesOpsQueueName = 'SalesOps Queue';
    static Group salesOpsQueueGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name =:salesOpsQueueName LIMIT 1];
    static RecordType supportRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'SalesOps_Pricing_Compliance'];

    @IsTest
    public static void testTrigger()
    {
        Case c1 = new Case
        (
            OwnerId = salesOpsQueueGroup.Id,
            RecordTypeId = supportRecordType.Id
        );
        insert c1;

        c1.Subject = '123';
        update c1;
    }
}