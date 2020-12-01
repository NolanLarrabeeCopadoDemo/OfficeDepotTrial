/***
Description: This class updates the WRF cases where Acconut name is not mentioned.
 
Created By: Ankur Pradhan
Created Date: 10-May-2012

Modified By:
Modified Date:

Modify Reason:
**/
public class Update_Cust_Prosp_detailsonCase 
{
	public map <case,id> Cust_prosp_Updateoncase(List <Case> triggernew)
	{
		RecordType WRFRecType       = [select id from recordtype where name = 'Work Request' AND SobjectType = 'Case'];//For getting record type id
		map <string,case> Aops_ID_Caseid_map = new map <string,case>();// Map of Aops id and Case ID
		map <string,case> Part_ID_Caseid_map = new map <string,case>();// Map of party id and Case ID
		map <case,id> Caseid_Accid_map = new map <case,id>();// Map of Case and Account ID
		
		for(Case newcase:triggernew)
		{
			system.debug('>>>>>>>>inside if classss>>>>>>>');
			if(newcase.accountid==null && newcase.RecordTypeId==WRFRecType.id)
			//if(newcase.accountid==null && newcase.RecordTypeid==WRFRecType.id)
			{
				if(newcase.DUP_Acct_ID__c != null)
				{
					system.debug('>>>>>>>>inside first if classs>>>>>>>');
					if (newcase.DUP_Acct_Type__c=='Current Customer')
					{
						system.debug('>>>>>>>>inside 2 if classs>>>>>>>');
						Aops_ID_Caseid_map.put(newcase.DUP_Acct_ID__c,newcase);
					}
					else
					{
						 if (newcase.DUP_Acct_Type__c=='New Prospect')
						 {
						 	system.debug('>>>>>>>>inside 3 if classs>>>>>>>');
						 	Part_ID_Caseid_map.put(newcase.DUP_Acct_ID__c,newcase);
						 }
					}
				}
			}	
		}
		for (Account acc:[SELECT id, name, AOPS_Cust_Id__c from account where AOPS_Cust_Id__c in :Aops_ID_Caseid_map.keyset() and type = 'Customer'])
		{
			system.debug('>>>>>>>>inside 1 f0r>>>>>>>');
			Caseid_Accid_map.put(Aops_ID_Caseid_map.get(acc.AOPS_Cust_Id__c),acc.id);
		}
		for (Account acc:[SELECT id, name, Oracle_Party_Id__c from account where Oracle_Party_Id__c in :Part_ID_Caseid_map.keyset() and type = 'Prospect'])
		{
			system.debug('>>>>>>>>inside 2 f0r>>>>>>>');
			Caseid_Accid_map.put(Part_ID_Caseid_map.get(acc.Oracle_Party_Id__c),acc.id);
		}
		return Caseid_Accid_map;
		
		/****************************************************************************
		For implementing the functionality from batch class add the 
		following code after calling the method
		***************************************************************************** 
		list <Case> Case_lst = new list <Case>();
		for(Case c:Caseid_Accid_map.keyset())
		{
			system.debug('>>>>>>>>inside 3 f0r>>>>>>>');
			c.accountid=Caseid_Accid_map.get(c);
			Case_lst.add(c);
		}
		update Case_lst;
		****************************************************************************/
	}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
}