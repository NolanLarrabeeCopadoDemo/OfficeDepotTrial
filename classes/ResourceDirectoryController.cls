public class ResourceDirectoryController {
    @AuraEnabled
        public static List<Resource_Directory__c> getDir(string ent) {
            return [SELECT Entity__c, Entity_code__c, Category__c, Issue__c, Contact_Email__c , Contact_Phone__c, 
            Contact_Instruction__c,   Escalation__c, SLA__c 
                     From Resource_Directory__c  Where Entity_code__c = :ent
                    Order by Entity_code__c, Category__c, Issue__c];
        }
    @AuraEnabled
        public static List<Resource_Directory__c> getDirEC(string ent, string cat) {
            return [SELECT Entity__c, Entity_code__c, Category__c, Issue__c, Contact_Email__c , Contact_Phone__c, 
            Contact_Instruction__c,   Escalation__c, SLA__c 
                     From Resource_Directory__c  Where Entity_code__c = :ent and Category__c = :cat
                    Order by Entity_code__c, Category__c, Issue__c];
        }
    @AuraEnabled
        public static List<RD_CS__c> getCat() {
            return [Select Id, Name, Entity__c, Entity_Name__c, Category__c From RD_CS__c Order by Entity__c, Category__c];
        }
    
}