@IsTest
public class LeadBeforeTrigger_TC
{
	 static testMethod void businessProInfoTest()
	{

			Recordtype rtype1 = [select id from recordtype where sobjecttype='Lead' and recordtype.name = 'Lead (Business Pro)' limit 1];

			//Modified for S-429671[Case#00757318]
			Recordtype rtype2 = [select id from recordtype where sobjecttype='Lead' and recordtype.name = 'Lead (Canada)' limit 1];

			Canada_Lead_Assignment__c cs= new Canada_Lead_Assignment__c();
			cs.Name = 'A,B,C,D';
			cs.Postal_Code_Initials__c = 'A,B,C,D';
			cs.UserId__c = UserInfo.getUserId();
			insert cs;

			List<Lead> leadList = new List<Lead>();
			List<Lead> uplead = new List<Lead>();
			Lead ld =new lead();
			ld.Company='abcd';
			ld.LastName='nitish';
			ld.Title='anbcd';
			ld.New_Date_time__c=system.now();
			ld.Zip__c='12345';
			ld.LeadSource='BSD NET';
			ld.WCW_Count__c=123456;
			ld.RecordTypeid='012E000000093Ju';

			leadList.add(ld);


			Lead ld1 =new lead();
			ld1.Company='abcd';
			ld1.LastName='nitish';
			ld1.Title='anbcd';
			ld1.New_Date_time__c=system.now();
			ld1.Zip__c='A12345';
			ld1.LeadSource='Grand and Toy Web Lead';
			ld1.WCW_Count__c=123;
			ld1.RecordTypeid= rtype2.id;

			leadList.add(ld1);

			Lead ld2 =new lead();
			ld2.Company='abcd';
			ld2.LastName='nitish';
			ld2.Title='anbcd';
			ld2.New_Date_time__c=system.now();
			ld2.Zip__c='A12345';
			ld2.LeadSource='Grand and Toy Web Lead';
			ld2.WCW_Count__c=23;
			ld2.RecordTypeid= rtype2.id;

			leadList.add(ld2);

			insert leadList;

			ld1.Auto_Assign__c = true;
			ld2.Auto_Assign__c = true;

			uplead.add(ld1);
			uplead.add(ld2);

			update uplead;

			system.assertNotEquals(UserInfo.getUserId(), [Select id, ownerId from Lead where id=:ld2.id].OwnerId);
			//End S-429671[Case#00757318]

			Location_Assignment__c LA = new Location_Assignment__c();
			LA.Name='12345';
			LA.Time_Zone__c='Western';
			insert LA;


	}
}