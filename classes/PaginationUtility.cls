/****************************************************************************************
Name         : PaginationUtility
Created By   : Appirio JDC (Nisha)
Description  : (S-429664)
******************************************************************************************/
public without sharing class PaginationUtility {
    static final Integer DEFAULT_LINKS_AT_A_TIME;
    static final Integer DEFAULT_NUMBER_OF_LINKS_BEFORE_CURRENT;

    static {
        DEFAULT_LINKS_AT_A_TIME = 4;
    DEFAULT_NUMBER_OF_LINKS_BEFORE_CURRENT = 2;
    }

    public Integer pageSize;
    public Integer currentPage;

    List<List<Object>> customPaginationList;
    Integer totalRecords;

    public PaginationUtility() {
        currentPage = 1;
        customPaginationList = new List<List<Object>>();
    }

    public List<Object> setPagination(List<Object> customList) {
        customPaginationList.clear();
        totalRecords = customList != null ? customList.size() : 0;
        //Set page size default to 20 if user not override this.
        if(pageSize == null) pageSize = 20;
        if(currentPage == null && currentPage <= 0) currentPage = 1;

        for(Object obj : customList) {
            if(customPaginationList.size() == 0 ||
                    customPaginationList.get(customPaginationList.size() - 1).size() == pageSize) {
            customPaginationList.add(new List<Object>());
        }
        customPaginationList.get(customPaginationList.size() - 1).add(Obj);
        }
        if(customPaginationList.size() > 0) {
            return customPaginationList.get(0);
        }
        return null;
    }

    public List<Object> getPage(Integer selectedPage) {
        system.debug('===>' + customPaginationList.size());
        if(customPaginationList != null && selectedPage > 0 &&
                selectedPage <= customPaginationList.size()) {
            currentPage = selectedPage;
            return customPaginationList.get(currentPage - 1);
        }
        
       
        return null;
    }

    public List<Object> next() {
        Integer nextPage = currentPage + 1;
        if(customPaginationList != null && nextPage > 0 &&
                nextPage <= customPaginationList.size()) {
            currentPage++;
            return customPaginationList.get(currentPage - 1);
        }
        return null;
    }

    public List<Object> previous() {
        Integer previousPage = currentPage - 1;
        if(customPaginationList != null && previousPage > 0 &&
                previousPage <= customPaginationList.size()) {
            currentPage--;
            return customPaginationList.get(currentPage - 1);
        }
        return null;
    }

    public List<Object> first() {
        if(customPaginationList != null &&
                customPaginationList.size() > 1) {
            currentPage = 1;
            return customPaginationList.get(currentPage - 1);
        }
        return null;
    }

    public List<Object> last() {
        if(customPaginationList != null) {
            currentPage = totalPage;
            return customPaginationList.get(currentPage - 1);
        }
        return null;
    }

    // Property that returs the total number of pages
    public Integer totalPage {
    get {
        if(customPaginationList != null) {
        return customPaginationList.size();
        }
        return 0;
    }
    }

    //----------------------------------------------------------------------------------------------------------------------------------------
    // Method that return the Index number of first record on the page
    //----------------------------------------------------------------------------------------------------------------------------------------
    private Integer getShowingFrom() {
    if(totalRecords != 0) {
        Integer showingFrom = (currentPage * pageSize) - pageSize + 1;
        return showingFrom;
    }
    return 0;
    }

    //----------------------------------------------------------------------------------------------------------------------------------------
    // Method that return the Index number of last record on the page
    //----------------------------------------------------------------------------------------------------------------------------------------
    public Integer getShowingTo() {
      Integer showingTo = currentPage * pageSize ;
      if (totalRecords < showingTo) {
        showingTo = totalRecords;
      }
      return showingTo;
    }

    //----------------------------------------------------------------------------------------------------------------------------------------
    // Property which return the list of page links to be display
    //----------------------------------------------------------------------------------------------------------------------------------------
    public List<Integer> listOfLinks {
        get {
            Integer current = currentPage;
            Integer startFrom = current - DEFAULT_NUMBER_OF_LINKS_BEFORE_CURRENT;

            if(startFrom <= 0) startFrom = 1;

            List<Integer> links = new List<Integer>();

            for(Integer linkNumber = startFrom; linkNumber <= totalPage; linkNumber++) {
                links.add(linkNumber);
                if(links.size() >= DEFAULT_LINKS_AT_A_TIME) break;
            }
            return links;
        }
    }

    //----------------------------------------------------------------------------------------------------------------------------------------
    // Property that return true if there are more links (in backward direction) to be display
    //----------------------------------------------------------------------------------------------------------------------------------------
    public Boolean isMorePrevious {
        get {
            if(listOfLinks.size() > 0 && Integer.valueOf(listOfLinks.get(0)) != 1) {
                return true;
        }
        return false;
        }
        set;
    }

    //----------------------------------------------------------------------------------------------------------------------------------------
    // Property that return true if there are more links (in forward direction) to be display
    //----------------------------------------------------------------------------------------------------------------------------------------
    public Boolean isMoreNext {
    get {
        if(listOfLinks.size() > 0 && Integer.valueOf(listOfLinks.get(listOfLinks.size() - 1)) < totalPage) {
            return true;
        }
        return false;
    }
    set;
    }
}