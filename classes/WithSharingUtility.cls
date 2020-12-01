/***************************************************************************
 Name 		  : WithSharingUtility 
 Created By   : Lalit  Malav
 Description  : Utility class for the case portal display for S-410488(00687615)
 Created Date : May  5, 2016			
****************************************************************************/
public with sharing class WithSharingUtility {
   public static List<sObject> databasequery(String soql){
   		return database.query(soql);
   }
}