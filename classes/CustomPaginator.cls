/***************************************************************************
 Name         : CustomPaginator 
 Created By   : Lalit Malav
 Description  : Class for CustomListView Page for S-410488(00687615)
 Created Date : May  5, 2016               
****************************************************************************/
public without sharing class CustomPaginator { 
  
  /*******************************************************************************
  * @Class : WrapperObject
  * @Description: Abstract classes that could be extends 
  *******************************************************************************/
  public abstract class WrapperObject{ 
    
  }  
  
  /*******************************************************************************
  * @Class : Helper_Paginator
  * @Description: Helper classes that is used for custom paging.
  *******************************************************************************/
  public class Paginator {
    CustomPaginator dummayInstance = new CustomPaginator();
    private final Integer RESULTS_PER_PAGE;
    private boolean isOkey;
    public boolean isOkey(){ return isOkey;}
    public integer totalResults {set; get;}
    public Integer currentPage {set; get;}
    public Integer totalPage {set; get;}
    private Integer showingFrom;
    private Integer showingTo;
    private List<List<WrapperObject>> allResults = new List<List<WrapperObject>>();
    public boolean isNextPageAvailable {set; get;}
    public boolean isPreviousPageAvailable {set; get;}
      
    //----------------------------------------------------------------------------
    // @Description  : Constructor to use paging with list
    // @Parameters  : per page result, List<WrapperObject>
    // @Returns      : nothing
    //----------------------------------------------------------------------------
    public Paginator(Integer ppResults, List<WrapperObject> wrapperResultLst){
      
      isOkey = false;
      RESULTS_PER_PAGE = ppResults;
      totalResults = 0;
      
      try{
        allResults.add(wrapperResultLst);
        totalResults = totalResults + wrapperResultLst.size();
        init();
        isOkey = true;
        
      }catch(exception e){
        isOkey = false;
      }
    }
    
    //----------------------------------------------------------------------------
    // @Description  : method to show start indexing of record on current page 
    // @Parameters  : nothing
    // @Returns      : start index
    //----------------------------------------------------------------------------    
    public Integer getShowingFrom(){
      
      showingFrom = (currentPage * RESULTS_PER_PAGE ) - RESULTS_PER_PAGE + 1;
      return showingFrom;
    }
    
    //----------------------------------------------------------------------------
    // @Description  : method to show end indexing of record on current page 
    // @Parameters  : nothing
    // @Returns      : end index
    //----------------------------------------------------------------------------   
    public Integer getShowingTo(){
      
      showingTo = currentPage * RESULTS_PER_PAGE ;
      if (totalResults < showingTo){
        showingTo = totalResults;
      }
      return showingTo;
    }
            
    //----------------------------------------------------------------------------
    // @Description  : method to return list of records on current page
    // @Parameters  : page number
    // @Returns      : list of records on current page
    //----------------------------------------------------------------------------  
    public List<WrapperObject> getPage(Integer pageNo){
      
      WrapperObject[] selectedResult =  new WrapperObject[RESULTS_PER_PAGE];
      Integer endTo = RESULTS_PER_PAGE * pageNo;
      Integer startFrom = endTo - RESULTS_PER_PAGE;
      Integer currentRecordNo = 0;
      Integer resultIndex = 0;
      Integer recordIndex = -1;
      
      for (WrapperObject[] recordBatch:allResults){
        
        currentRecordNo = currentRecordNo + recordBatch.size();
        
        if (currentRecordNo >= startFrom ){
          
          for (WrapperObject record:recordBatch){
            recordIndex++;
            
            if (recordIndex >= startFrom && recordIndex <= endTo && resultIndex<RESULTS_PER_PAGE){
              selectedResult[resultIndex] = record ;
              resultIndex++ ;
            }else if (resultIndex == RESULTS_PER_PAGE){
              break;
            }
            
          }
        }else{
          recordIndex += recordBatch.size(); 
          if (resultIndex == RESULTS_PER_PAGE){
            break;
          }
        }
      }
      return selectedResult;
    } 
        
    //----------------------------------------------------------------------------
    // @Description  : method to return First page records
    // @Parameters  : nothing
    // @Returns      : first page records
    //---------------------------------------------------------------------------- 
    public List<WrapperObject> getFirstPage(){
      
      currentPage = 1;
      updateNavigationStatus();
      return getPage(1);
    }
    
    //----------------------------------------------------------------------------
    // @Description  : method to return Last page records
    // @Parameters  : nothing
    // @Returns      : last page records
    //---------------------------------------------------------------------------- 
    public List<WrapperObject> getLastPage(){
      
      currentPage = totalPage;
      updateNavigationStatus();
      return getPage(totalPage);
    }
        
    //----------------------------------------------------------------------------
    // @Description  : method to update boolean values for next and previous page
    // @Parameters  : nothing
    // @Returns      : nothing
    //---------------------------------------------------------------------------- 
    public void updateNavigationStatus(){
      
      if (totalPage >1){
        isNextPageAvailable = currentPage < totalPage ? true : false;
        isPreviousPageAvailable = currentPage > 1 ? true : false;
        
      } else {
        isNextPageAvailable = false;
        isPreviousPageAvailable = false;
      }
    }  
  
    //----------------------------------------------------------------------------
    // @Description  : method to return next page records
    // @Parameters  : nothing
    // @Returns      : records of next page
    //---------------------------------------------------------------------------- 
    public List<WrapperObject> getNextPage(){
      
      updateNavigationStatus();
      
      if (isNextPageAvailable){
        currentPage ++;
      }
      updateNavigationStatus();
      return getPage(currentPage);
    }
    
    //----------------------------------------------------------------------------
    // @Description  : method to return Previous page records
    // @Parameters  : nothing
    // @Returns      : records of previous page
    //---------------------------------------------------------------------------- 
    public List<WrapperObject> getPreviousPage(){
      
      updateNavigationStatus();
      
      if (isPreviousPageAvailable){
        currentPage --;
      }
      updateNavigationStatus();
      return getPage(currentPage);
    }
    
    //----------------------------------------------------------------------------
    // @Description  : method to Initialize variables at call of constructor
    // @Parameters  : nothing
    // @Returns      : nothing
    //---------------------------------------------------------------------------- 
    private void init(){
      
      currentPage = 1;
      totalPage = totalResults / RESULTS_PER_PAGE ;
      
      if (totalPage * RESULTS_PER_PAGE < totalResults){
        totalPage++;
      }
      
      isNextPageAvailable = currentPage < totalPage ?  true : false;
      isPreviousPageAvailable = false;
    }
  }
}