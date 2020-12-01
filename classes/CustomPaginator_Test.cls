/***************************************************************************
 Name         : CustomPaginator_Test 
 Created By   : Lalit Malav
 Description  : Test class for CustomPaginator for for S-410488(00687615)
 Created Date : May  5, 2016                 
****************************************************************************/
@isTest 
public with sharing class CustomPaginator_Test {
	
	static testmethod void unitTestCustomPaginator(){
		//create test data
	    List<ObjectWrapper> wrapList = new List<ObjectWrapper>();
	    for(Integer i=0; i<10; i++){
	  	Account acc = new Account(Name = 'TestAccount24022014' + i);
        wrapList.add(new ObjectWrapper(acc));
        }
	    CustomPaginator.Paginator paginator = new CustomPaginator.Paginator(3, wrapList);
	    paginator.getFirstPage();
	    System.assertEquals(1, paginator.currentPage);
	    paginator.getShowingFrom();
	    System.assertEquals(1, paginator.currentPage);
	    paginator.getNextPage();
	    System.assertEquals(2, paginator.currentPage);
	    paginator.getLastPage();
	    System.assertEquals(4, paginator.currentPage);
	    paginator.getShowingTo();
	    paginator.getPreviousPage();
	    System.assertEquals(3, paginator.currentPage);
	    paginator.updateNavigationStatus();
	    System.assertEquals(true, paginator.isOkey());    
	    paginator.getPage(4);
	    paginator.getPage(3);
	}
	
	public class ObjectWrapper extends CustomPaginator.WrapperObject{
	    Account acc;
	    public ObjectWrapper(Account acc){
	    	this.acc = acc; 
	    }
  }
  
}