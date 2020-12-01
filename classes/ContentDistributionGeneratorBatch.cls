/*Created By: shravya channamadhavuni
*Query on Content Version that are created after December 8th. Because there are 2135 which do not have a content distribution and we want to create content distributions 
only for the content versions that do not have a content distribution
*/

global class ContentDistributionGeneratorBatch implements Database.Batchable<SObject> {
    /*Query all content versions created after Dec 8 201
*
*/
    global integer count = 1;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id,Title from contentversion where CreatedDate >= 2019-12-08T00:00:00Z]);
    }
    /*Query on content distribution and collect all the content version ids
* compare the content version ids queried in the scope to the content distribution's content version ids
* creating a content distribution record for the content versions that are unique
*/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Id> lsOfCntnVrsns = new List<Id> ();
        List<Id> lsOfCntnVrsnsWOCD = new List<Id> ();
        Map<Id,Object> mapOfCntnVrns = new Map<Id,Object> ();
        Map<Id,String> mapOfCntnVrnsWithCD = new Map<Id,String> ();
        for(sObject s:scope) {
            lsOfCntnVrsns.add(s.Id);
            mapOfCntnVrns.put(s.Id,s.get('Title'));
        }
        for(ContentDistribution c: [select id,ContentDocumentId,contentVersionId,Name from ContentDistribution where contentVersionId In :mapOfCntnVrns.keySet() ])     {
            mapOfCntnVrnsWithCD.put(c.contentVersionId,c.Name); 
        }
        for(Id i:lsOfCntnVrsns) {
            if(!mapOfCntnVrnsWithCD.containsKey(i)) {
                
                lsOfCntnVrsnsWOCD.add(i);    
            }
        }
        system.debug('the list of ids with no content distribution are'+lsOfCntnVrsnsWOCD);
        List<ContentDistribution> ContentDistributionLst = new List<ContentDistribution> ();
        for(ContentVersion cv:[select id,title from ContentVersion where id IN :lsOfCntnVrsnsWOCD ]) {
            count++;
            ContentDistribution c= new ContentDistribution();
            c.ContentVersionId=cv.Id;
            c.Name=cv.Title;
            ContentDistributionLst.add(c);
        }
        system.debug('the list of content documents inserted are:'+ContentDistributionLst);    
        insert ContentDistributionLst;
    }
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'shravya.channamadhavuni@officedepot.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Apex Job is done');
        mail.setPlainTextBody('Total' +'  '+ count +'  '+ 'Records updated sucessfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}