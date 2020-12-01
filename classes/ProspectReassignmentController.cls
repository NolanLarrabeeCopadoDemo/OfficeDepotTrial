public with sharing class ProspectReassignmentController {
    public class AccessDataWrapper{
        @AuraEnabled
        public boolean pageAccess;       
        @AuraEnabled
        public boolean adminAccess;
    }
    @AuraEnabled(cacheable=true)
    public static AccessDataWrapper getAccessAllowed() {
        AccessDataWrapper adw = new AccessDataWrapper();
        ReassignUtils ru = new ReassignUtils();
        adw.pageAccess = ru.ReassignAllowed();
        adw.adminAccess=ru.getIsAdmin();
        return adw;
    }
}