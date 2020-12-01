public class ProspectReassignController {
    public boolean pAccess {get;set;}
    public boolean AdminAccess {get;set;}
    public string selectedTab {get;set;}
        public static string defaultTabName='ReAssignments';

    public void AccessAllowed() {
                this.selectedTab=ApexPages.currentPage().getParameters().get('selectedTab');
            System.debug(LoggingLevel.Info,'&&&&&&&&&&selectedTab '+selectedTab );
            if(string.isBlank(selectedTab) )
            selectedTab=ProspectReassignController.defaultTabName;


        ReassignUtils ru = new ReassignUtils();
        pAccess = ru.ReassignAllowed();
        AdminAccess=ru.getIsAdmin();
    }
    
    public String getselectedTab (){
     return selectedTab ;
    }
}