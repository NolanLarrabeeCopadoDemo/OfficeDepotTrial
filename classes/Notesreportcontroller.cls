public with sharing class Notesreportcontroller 
{
    
    private Integer pageNumber;
    private Integer pageSize;
    private Integer totalPageNumber;
    
    public List <Account> acc_list = new List <Account> ();
    public List <Account> acc_id = new List <Account> ();
    public Account acc_name1 = new Account ();
    public Account acc1 {get;set;}
    Public List <Note> Note_list {get;set;}
    public string accid{ get;set;}
    
    public Notesreportcontroller ()
    {
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;
        ID acid = ApexPages.currentPage().getParameters().get('id');
        If (acid!=null)
        {
            loaddata(null,acid);
            BindData(1);
        }
        else
        {
            loaddata(null,null);
        }    
    } 
    
    public void loaddata(string accname,Id accid)
    {
        
        If (accname!=null&&accname!=''&&accid==null)
        {
            acc_id = [Select id, name, Related_Account__c, Parentid from Account where name = :accname];
            acc_list= [Select id, name, Related_Account__c, Parentid , lastmodifieddate from Account where id in :acc_id OR Parentid in :acc_id OR Related_Account__c in :acc_id];
            Note_list =  [Select Body, OwnerId, ParentId, Title, LastModifiedDate from Note where ParentId in: acc_list order by lastmodifieddate desc];
            
        }
        If (accid!=null&&(accname==null||accname==''))
        {
            acc_list= [Select id, name, Related_Account__c, Parentid , lastmodifieddate from Account where id = :accid OR Parentid = :accid OR Related_Account__c = :accid ];
            Note_list =  [Select Body, OwnerId, ParentId, Title, LastModifiedDate from Note where ParentId in: acc_list order by lastmodifieddate desc];
            
        }
        If (accid==null&&(accname==null||accname==''))
        {
            Note_list =  [Select Body, OwnerId, ParentId, Title, LastModifiedDate from Note limit 0];//where ParentId in: acc_list];
        } 
    }
    public void refreshnote()
    {
        if (accid == null||accid=='') 
        {
            system.debug('>>>>>>>>>nulll<<<<<'+accid );
            loaddata(null,null);
        }
        else
        {
            system.debug('>>>>>>>>>notnull<<<<<'+accid );
            loaddata(accid,null);
            BindData(1);
        }
        
    } 
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public List <Note> pageNotes{get;set;}
   
    public Integer getPageNumber()
    {
        return pageNumber;
    }
    public Integer getPageSize()

    {
       return pageSize;
    }

    public Boolean getPreviousButtonEnabled()

    {

        return !(pageNumber > 1);

    }

    public Boolean getNextButtonDisabled()

    {

        if (Note_list == null) return true;

        else

        return ((pageNumber * pageSize) >= Note_list.size());

    }

    public Integer getTotalPageNumber()

    {

        if (totalPageNumber == 0 && Note_list !=null)

        {

            totalPageNumber = Note_list.size() / pageSize;

            Integer mod = Note_list.size() - (totalPageNumber * pageSize);

            if (mod > 0){
            totalPageNumber++;}

        }

        return totalPageNumber;

    }
    private void BindData(Integer newPageIndex)

    {

        try

        {

            if (Note_list == null)
            {
                Note_list =  [Select Body, OwnerId, ParentId, Title, LastModifiedDate from Note limit 0];
            }
            
            pageNotes = new list <note> ();

            Transient Integer counter = 0;

            Transient Integer min = 0;

            Transient Integer max = 0;

            if (newPageIndex > pageNumber)

            {

                min = pageNumber * pageSize;

                max = newPageIndex * pageSize;

            }

            else

            {

                max = newPageIndex * pageSize;

                min = max - pageSize;



            }

            for(Note N : Note_list)

            {

                counter++;

                if (counter > min && counter <= max)

                pageNotes.add(N);

            }

            pageNumber = newPageIndex;

            if (pageNotes == null || pageNotes.size() <= 0)

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There are no note for this account'));

        }

        catch(Exception ex)

        {

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));

        }

    }

    public PageReference nextBtnClick() 
    {

        BindData(pageNumber + 1);

        return null;

    }

    public PageReference previousBtnClick() 
    {

        BindData(pageNumber - 1);

        return null;

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////
        
}