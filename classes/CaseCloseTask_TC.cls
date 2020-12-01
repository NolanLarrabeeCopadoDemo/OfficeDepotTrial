@isTest
private class CaseCloseTask_TC
{


static testMethod  void CaseCloseTask_TC ()
{

Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
List<Sobject> InsertList = new List<Sobject>();
test.startTest();

Case cs = new Case();
cs.RecordTypeId = rtMapByName.get('Support').getRecordTypeId();
cs.status = 'Closed';
//START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
insert cs;
//InsertList.add(cs);
//END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage

Task ts = new Task();
ts.status ='New';
ts.WhatId= cs.Id;
InsertList.add(ts);
insert InsertList;
//insert ts;

test.stopTest();
//START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage 
executeoncetest.Closetaskonce = true;
cs.Subject = 'Test';
update cs;
//END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage

}

}