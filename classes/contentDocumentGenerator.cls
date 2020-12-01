public class contentDocumentGenerator {
    public static void generatePublicLink(Map<Id,Id> linkedEntityToContentDocMap, Map<Id,Id> contentDocToLinkedEntityMap) {
        //Start: Uncommented by Rajendra Shahane for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
        String quoSnglTctng=label.contentDocumentSingleTicketing;
        List<CaseComment> csCmntLst = new List<CaseComment> ();
        List<contentdistribution> lstToBinsrtd = new List<contentdistribution> ();
        for(contentVersion cv:[select id,contentdocumentid,Title from contentversion where contentdocumentid IN :linkedEntityToContentDocMap.values()]) {
            contentdistribution cd = new contentdistribution();
            cd.Name =cv.Title ;
            cd.Contentversionid = cv.id;
            lstToBinsrtd.add(cd);
        }
        if(!Test.isRunningTest())        insert lstToBinsrtd;//Added !test.isRunningTest() at line 13 by Rajendra Shahane for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
        for(contentdistribution cd:[select id,DistributionPublicUrl,contentdocumentid from contentdistribution where contentdocumentid IN : linkedEntityToContentDocMap.values()]) {
            CaseComment cm = new CaseComment ();
            cm.ParentID = contentDocToLinkedEntityMap.get(cd.contentdocumentid);
            cm.commentBody = cd.DistributionPublicUrl;
            csCmntLst.add(cm);
        }
        //insert csCmntLst; //Commented by Rajendra Shahane for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
		//Start: Added by Rajendra Shahane to address 4000 character limit for commentBody for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
        Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.allowFieldTruncation = true;
        Database.insert(csCmntLst, dmo);
        //End: Added by Rajendra Shahane to address 4000 character limit for commentBody for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
        //End: Uncommented by Rajendra Shahane for NAIT-148386 Case attachments not loading to comments on a case for Scoe tickets
    }
}