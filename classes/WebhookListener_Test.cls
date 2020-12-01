@ IsTest
public class WebhookListener_Test {



	@isTest
	static void testissue() {
		Test.startTest();

		Case c = new Case(RecordTypeId = '012E00000008dWdIAI', 
				      Status= 'New', 
				      Origin= 'Internal', 
				      Subject= 'Test Case 1', 
				      Priority = '3-Medium', 
				      Description= 'Case 1', 
				      //  IT_BU_Reviewer__c = '005E0000003ccDFIAY',
				      IT_Classification__c = 'Enhancement', 
				      // IT_Priority__c ='3-Medium',
				      IT_Status__c = 'Assign', 
				      //IT_Production_Date__c =2020-01-26,
				      IT_Environment__c = 'Production', 
				      SPRINT_NAME__c= 'NAIT-000000', 
				      Jira_Label__c= 'CSM-Dashboard', 
				      Jira_Component__c = 'Sales Enablement (Disrupters)');
		insert c;


		Jira_Case__c jc = new Jira_Case__c(summary__c = 'prasad test', 
										   Case__c= c.id, 
										   EpicLink__c= 'NAIT-120447', 
										   Components__c= 'Sales Enablement (Disrupters)', 
										   Description__c= 'prasad test', 
										   Jira_ID__c= 'NAIT-000000', 
										   priority__c= '3-Medium', 
										   Issue_Type__c= 'Story', 
										   Found_In__c= 'Production', 
										   Labels__c= 'CSM_Dashboard', 
										   Bug_Environment__c= 'Production');


		insert jc;
		Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
		// Test.SetMock(HttpCallOutMock.class, new JIRACommentsWSMock());
		String json = '{"timestamp":1580092437751,"webhookEvent":"jira:issue_updated","issue_event_type_name":"issue_updated","user":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3Ada3b21fc-3eb1-407c-9d49-80b9300fd171","accountId":"557058:da3b21fc-3eb1-407c-9d49-80b9300fd171","avatarUrls":{"48x48":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=48&s=48","24x24":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=24&s=24","16x16":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=16&s=16","32x32":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=32&s=32"},"displayName":"Prasad Devar","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"issue":{"id":"686402","self":"https://officedepot.atlassian.net/rest/api/2/686402","key":"NAIT-000000","fields":{"customfield_16611":"prasad devar","customfield_15400":null,"customfield_17700":null,"customfield_16610":"2020-01-26T01:00:00.000-0500","customfield_16615":["SFDC"],"customfield_17704":null,"customfield_17703":null,"customfield_16614":123.0,"resolution":null,"customfield_16613":9.99888,"customfield_17702":null,"customfield_16612":"abc@test.com","customfield_17701":null,"customfield_16608":"2020-01-27","customfield_12800":null,"customfield_16607":["Production"],"customfield_16609":"1234","lastViewed":"2020-01-26T21:31:19.622-0500","customfield_14300":[],"customfield_16600":null,"customfield_12002":null,"labels":["CSM_Dashboard"],"customfield_16601":null,"aggregatetimeoriginalestimate":43200,"issuelinks":[],"assignee":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3Ada3b21fc-3eb1-407c-9d49-80b9300fd171","name":"prasad.devar","key":"prasad.devar","accountId":"557058:da3b21fc-3eb1-407c-9d49-80b9300fd171","avatarUrls":{"48x48":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=48&s=48","24x24":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=24&s=24","16x16":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=16&s=16","32x32":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=32&s=32"},"displayName":"Prasad Devar","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"components":[{"self":"https://officedepot.atlassian.net/rest/api/2/component/36705","id":"36705","name":"Sales Enablement (Disrupters)"}],"customfield_17000":null,"customfield_15501":null,"customfield_16707":null,"customfield_16706":null,"customfield_16705":null,"customfield_16709":null,"customfield_16708":null,"subtasks":[],"customfield_14400":null,"reporter":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3A642c1160-3270-447c-98d2-cfa5f64dd704","name":"ravinder.kothur","key":"ravinder.kothur","accountId":"557058:642c1160-3270-447c-98d2-cfa5f64dd704","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/bca9592366ef7dfa5e22d5459c3a8d97?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FRK-2.png&size=48&s=48","24x24":"https://secure.gravatar.com/avatar/bca9592366ef7dfa5e22d5459c3a8d97?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FRK-2.png&size=24&s=24","16x16":"https://secure.gravatar.com/avatar/bca9592366ef7dfa5e22d5459c3a8d97?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FRK-2.png&size=16&s=16","32x32":"https://secure.gravatar.com/avatar/bca9592366ef7dfa5e22d5459c3a8d97?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FRK-2.png&size=32&s=32"},"displayName":"Ravinder Kothur","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"customfield_12101":null,"customfield_12100":null,"customfield_16703":null,"customfield_12103":null,"customfield_16702":null,"customfield_12102":null,"customfield_12104":null,"customfield_16700":null,"customfield_11801":null,"progress":{"progress":0,"total":0},"votes":{"self":"https://officedepot.atlassian.net/rest/api/2/issue/NAIT-000000/votes","votes":0,"hasVoted":false},"issuetype":{"self":"https://officedepot.atlassian.net/rest/api/2/issuetype/7","id":"7","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://officedepot.atlassian.net/secure/viewavatar?size=medium&avatarId=16415&avatarType=issuetype","name":"Story","subtask":false,"avatarId":16415},"customfield_17102":null,"customfield_17101":null,"customfield_17100":null,"customfield_17106":null,"project":{"self":"https://officedepot.atlassian.net/rest/api/2/project/18101","id":"18101","key":"NAIT","name":"North America IT (OD)","projectTypeKey":"software","simplified":false,"avatarUrls":{"48x48":"https://officedepot.atlassian.net/secure/projectavatar?pid=18101&avatarId=21804","24x24":"https://officedepot.atlassian.net/secure/projectavatar?size=small&s=small&pid=18101&avatarId=21804","16x16":"https://officedepot.atlassian.net/secure/projectavatar?size=xsmall&s=xsmall&pid=18101&avatarId=21804","32x32":"https://officedepot.atlassian.net/secure/projectavatar?size=medium&s=medium&pid=18101&avatarId=21804"}},"customfield_17105":null,"customfield_17104":null,"customfield_15600":{"hasEpicLinkFieldDependency":false,"showField":false,"nonEditableReason":{"reason":"EPIC_LINK_SHOULD_BE_USED","message":"To set an epic as the parent, use the epic link instead"}},"customfield_17108":null,"customfield_17107":null,"customfield_16805":null,"customfield_16804":null,"customfield_10700":"NAIT-120447","customfield_16803":null,"resolutiondate":null,"watches":{"self":"https://officedepot.atlassian.net/rest/api/2/issue/NAIT-000000/watchers","watchCount":1,"isWatching":true},"customfield_16002":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/20102","value":"After","id":"20102"},"customfield_16001":null,"customfield_16006":null,"customfield_16005":null,"customfield_16004":null,"customfield_16003":null,"customfield_16802":null,"customfield_16801":null,"customfield_16800":null,"customfield_16007":null,"updated":"2020-01-26T21:33:57.748-0500","customfield_17201":null,"customfield_17200":null,"timeoriginalestimate":43200,"customfield_17205":null,"customfield_17204":null,"description":"prasad test","customfield_17203":"jayna marshal","customfield_17202":null,"customfield_15700":"{}","timetracking":{"originalEstimate":"12h","remainingEstimate":"0h","originalEstimateSeconds":43200,"remainingEstimateSeconds":0},"customfield_16905":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/24313","value":"Green","id":"24313"},"customfield_16904":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/24308","value":"Yes","id":"24308"},"customfield_10007":["com.atlassian.greenhopper.service.sprint.Sprint@2027848a[id=6182,rapidViewId=861,state=ACTIVE,name=Kaikaku24 - Sprint 173,goal=,startDate=2019-05-23T13:19:41.747Z,endDate=2019-06-19T11:44:00.000Z,completeDate=<null>,sequence=6182]"],"customfield_16903":null,"customfield_16902":null,"customfield_10800":null,"customfield_10801":null,"customfield_16908":null,"customfield_10802":null,"customfield_16907":null,"customfield_16906":null,"summary":"prasad test","customfield_16100":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/22220","value":"Purchase Order Management Replacement Phase 1- PR003529","id":"22220"},"customfield_10000":null,"customfield_16901":null,"customfield_10001":"2020-01-26T20:24:12.285-0500","customfield_14601":null,"customfield_10002":null,"customfield_16900":null,"customfield_10003":null,"customfield_14600":null,"customfield_10004":1.0,"environment":null,"duedate":null,"statuscategorychangedate":"2020-01-25T05:38:32.884-0500","customfield_17780":null,"customfield_15000":null,"customfield_17781":null,"fixVersions":[{"self":"https://officedepot.atlassian.net/rest/api/2/version/48899","id":"48899","description":"","name":"Non-Release Related","archived":false,"released":false}],"customfield_13500":null,"customfield_15800":null,"customfield_13501":null,"customfield_12408":null,"customfield_16200":null,"customfield_14700":[{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/16801","value":"SQ Test Not Required","id":"16801"},{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/16802","value":"End to End Testing Required","id":"16802"}],"priority":{"self":"https://officedepot.atlassian.net/rest/api/2/priority/3","iconUrl":"https://officedepot.atlassian.net/images/icons/priorities/major.svg","name":"Major","id":"3"},"customfield_15901":null,"customfield_15902":null,"timeestimate":0,"versions":[{"self":"https://officedepot.atlassian.net/rest/api/2/version/48402","id":"48402","description":"","name":"18.3.17","archived":false,"released":false,"releaseDate":"2018-03-03"}],"status":{"self":"https://officedepot.atlassian.net/rest/api/2/status/1","iconUrl":"https://officedepot.atlassian.net/images/icons/statuses/open.png","name":"Open","id":"1","statusCategory":{"self":"https://officedepot.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"New"}},"customfield_14131":null,"customfield_17762":null,"customfield_14132":null,"customfield_17761":null,"customfield_17760":null,"customfield_14130":null,"customfield_17764":null,"customfield_17763":null,"customfield_14134":null,"customfield_17400":null,"customfield_15900":null,"aggregatetimeestimate":0,"creator":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3Ada3b21fc-3eb1-407c-9d49-80b9300fd171","name":"prasad.devar","key":"prasad.devar","accountId":"557058:da3b21fc-3eb1-407c-9d49-80b9300fd171","avatarUrls":{"48x48":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=48&s=48","24x24":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=24&s=24","16x16":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=16&s=16","32x32":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=32&s=32"},"displayName":"Prasad Devar","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"customfield_14120":null,"customfield_17751":null,"customfield_17750":null,"customfield_14121":null,"customfield_16303":null,"customfield_14124":null,"customfield_14125":null,"customfield_16302":null,"customfield_14122":null,"aggregateprogress":{"progress":0,"total":0},"customfield_14123":null,"customfield_16300":null,"customfield_17759":null,"customfield_14007":null,"customfield_14008":null,"customfield_17758":null,"customfield_14126":null,"customfield_17757":null,"customfield_14119":null,"customfield_17749":null,"timespent":null,"customfield_14113":null,"customfield_15200":null,"customfield_17500":null,"customfield_14111":null,"customfield_14112":null,"customfield_14117":null,"aggregatetimespent":null,"customfield_14118":null,"customfield_17747":null,"customfield_14116":null,"customfield_14109":null,"workratio":0,"created":"2020-01-25T05:38:32.619-0500","customfield_17733":null,"customfield_17732":null,"customfield_17731":null,"customfield_16400":"ABC","customfield_17730":null,"customfield_17736":null,"customfield_12600":"2&#124;i04gon:","customfield_17735":null,"customfield_17734":null,"customfield_17729":null,"customfield_17728":null,"customfield_17727":null,"customfield_17722":null,"customfield_17600":null,"customfield_17721":null,"customfield_15300":null,"customfield_17726":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/27015","value":"Batch Incident","id":"27015"},"customfield_17725":null,"customfield_11500":null,"customfield_17724":null,"customfield_17723":null,"customfield_17719":null,"customfield_10402":null,"customfield_17717":null,"security":null,"customfield_17716":null,"attachment":[],"customfield_14201":null,"customfield_16622":"2020-01-27","customfield_16621":"qnxx","customfield_17710":null,"customfield_14202":null,"customfield_16620":["In_Progress"],"customfield_14200":null,"customfield_17715":null,"customfield_17714":null,"customfield_14203":null,"customfield_16503":["AccessDepot2017","Production"],"customfield_17713":null,"customfield_16502":{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/25301","value":"Account Courier","id":"25301"},"customfield_16623":"Test","customfield_17712":null,"customfield_17708":null,"customfield_16619":["Medium"],"customfield_16618":"01322610","customfield_17706":null,"customfield_16616":[{"self":"https://officedepot.atlassian.net/rest/api/2/customFieldOption/22028","value":"Yes","id":"22028"}]}},"changelog":{"id":"7078267","items":[{"field":"Vendor Last Update Date","fieldtype":"custom","fieldId":"customfield_16622","from":null,"fromString":null,"to":"2020-01-27","toString":"27/Jan/20"}]}}';
		String siteurl = 'http://officedepot-officemax.force.com/webhookservices/apexrest/postdata';

		RestRequest request = new RestRequest();
		request.requestUri = siteurl;
		request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(json);

		RestContext.request = request;
		WebhookListener.handlePost();
		Test.stopTest();


	}

	@isTest
	static void testissueComment() {
		Test.startTest();

		Case c = new Case(RecordTypeId = '012E00000008dWdIAI', 
				      Status= 'New', 
				      Origin= 'Internal', 
				      Subject= 'Test Case 1', 
				      Priority = '3-Medium', 
				      Description= 'Case 1', 
				      //  IT_BU_Reviewer__c = '005E0000003ccDFIAY',
				      IT_Classification__c = 'Enhancement', 
				      // IT_Priority__c ='3-Medium',
				      IT_Status__c = 'Assign', 
				      //IT_Production_Date__c =2020-01-26,
				      IT_Environment__c = 'Production', 
				      SPRINT_NAME__c= 'NAIT-000000', 
				      Jira_Label__c= 'CSM-Dashboard', 
				      Jira_Component__c = 'Sales Enablement (Disrupters)');
		insert c;


		Jira_Case__c jc = new Jira_Case__c(summary__c = 'prasad test', 
										   Case__c= c.id, 
										   EpicLink__c= 'NAIT-120447', 
										   Components__c= 'Sales Enablement (Disrupters)', 
										   Description__c= 'prasad test', 
										   Jira_ID__c= 'NAIT-000000', 
										   priority__c= '3-Medium', 
										   Issue_Type__c= 'Story', 
										   Found_In__c= 'Production', 
										   Labels__c= 'CSM_Dashboard', 
										   Bug_Environment__c= 'Production');


		insert jc;
		CaseComment cc = new CaseComment(ParentId = c.id, CommentBody = '  @jiraIssuekey#:NAIT-000000#jiraIssuekey@    @jiraCommentid#:1000000#jiraCommentid@      @updatedBy#:sss#updatedBy@');
		insert cc;

		//  Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
		Test.SetMock(HttpCallOutMock.class, new JIRACommentsWSMock());
		String json = '{"timestamp":1580088335698,"webhookEvent":"comment_created","comment":{"self":"https://officedepot.atlassian.net/rest/api/2/issue/686402/comment/1000000","id":"1000000","author":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3Ada3b21fc-3eb1-407c-9d49-80b9300fd171","accountId":"557058:da3b21fc-3eb1-407c-9d49-80b9300fd171","avatarUrls":{"48x48":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=48&s=48","24x24":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=24&s=24","16x16":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=16&s=16","32x32":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=32&s=32"},"displayName":"Prasad Devar","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"body":"test","updateAuthor":{"self":"https://officedepot.atlassian.net/rest/api/2/user?accountId=557058%3Ada3b21fc-3eb1-407c-9d49-80b9300fd171","accountId":"557058:da3b21fc-3eb1-407c-9d49-80b9300fd171","avatarUrls":{"48x48":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=48&s=48","24x24":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=24&s=24","16x16":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=16&s=16","32x32":"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/initials/PD-3.png?size=32&s=32"},"displayName":"Prasad Devar","active":true,"timeZone":"America/New_York","accountType":"atlassian"},"created":"2020-01-26T20:25:35.698-0500","updated":"2020-01-26T20:25:35.698-0500","jsdPublic":true},"issue":{"id":"686402","self":"https://officedepot.atlassian.net/rest/api/2/686402","key":"NAIT-000000","fields":{"summary":"prasad test","issuetype":{"self":"https://officedepot.atlassian.net/rest/api/2/issuetype/7","id":"7","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://officedepot.atlassian.net/secure/viewavatar?size=medium&avatarId=16415&avatarType=issuetype","name":"Story","subtask":false,"avatarId":16415},"project":{"self":"https://officedepot.atlassian.net/rest/api/2/project/18101","id":"18101","key":"NAIT","name":"North America IT (OD)","projectTypeKey":"software","simplified":false,"avatarUrls":{"48x48":"https://officedepot.atlassian.net/secure/projectavatar?pid=18101&avatarId=21804","24x24":"https://officedepot.atlassian.net/secure/projectavatar?size=small&s=small&pid=18101&avatarId=21804","16x16":"https://officedepot.atlassian.net/secure/projectavatar?size=xsmall&s=xsmall&pid=18101&avatarId=21804","32x32":"https://officedepot.atlassian.net/secure/projectavatar?size=medium&s=medium&pid=18101&avatarId=21804"}},"assignee":null,"priority":{"self":"https://officedepot.atlassian.net/rest/api/2/priority/6","iconUrl":"https://officedepot.atlassian.net/images/icons/priorities/trivial.svg","name":"Unknown","id":"6"},"status":{"self":"https://officedepot.atlassian.net/rest/api/2/status/1","description":"","iconUrl":"https://officedepot.atlassian.net/images/icons/statuses/open.png","name":"Open","id":"1","statusCategory":{"self":"https://officedepot.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"To Do"}}}}}';
		String siteurl = 'http://officedepot-officemax.force.com/webhookservices/apexrest/postdata';

		RestRequest request = new RestRequest();
		request.requestUri = siteurl;
		request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(json);

		RestContext.request = request;
		WebhookListener.handlePost();
		Test.stopTest();


	}


}