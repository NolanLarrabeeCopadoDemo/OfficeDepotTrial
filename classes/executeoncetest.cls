global class executeoncetest
{
    public static integer executeonce=0;
    public static integer execount=0;
    public static boolean CT_OnDeck_WRF_trg_check=true;
    public static boolean extendOMXAgreement=true;
    public static boolean isMod5Launch=false;
    public static boolean Update_Status_Age_check=true;
    public static boolean wrftasktrigger=true;
    public static boolean wrftasktrigger1=true;
    public static boolean insertlogic=true;    
    public static boolean deleteonce=true;
    public static boolean wrftaskbefore=true;
    public static boolean wrftaskbefore1=true;
    public static boolean useremailonce=true;
    public static boolean customerTransition_beforeUpdate =true;
    
    //Added by ivarada - 10/2/2015 AAC project
    public static boolean BypassAccountTrigger = true;
    
    // CaseTrigger execute once approval process
    public static boolean executeCaseApproval = true;
    
    //***********Case Management Class ************//
    public static boolean updaterecordhisCaseapp=true;
    public static boolean insertrecordhisCaseapp=true;   
    public static boolean CallAgainCase=true;
    public static boolean recallOnlyOnce=true;
    //**************End****************//
    
    //***********WRFTaskManagement Class***********//
    public static String casepricinganalyst1;
    public static boolean insertrecordhisWRFapp=true;
    public static boolean updaterecordhisWRFapp=true;
    public static boolean insertinitialtask=true;
    public static boolean insertsubtask=true;
    public static boolean WRFCase=true;
    public static boolean deletesubtask=true;
    public static boolean wrftaskupdate=true;
    public static boolean MPSStageimplement=true;
    public static boolean Tasktypeupdate=true;
    public static integer updateKPI=0;
    public static boolean querycaseonce=true;
    public static boolean querycaseonce1=true;
    //************End**************//
    
    //************Case Close Task trigger**********//
    public static boolean Closetaskonce=true;
    //************End*************//
    
    //*************CPMManagement Class************//
    public static boolean insertCPMrechis=true;
    public static boolean updateCPMrechis=true;
    public static boolean updatecasefromCPM =true;
    public static boolean updatewrftaskfromcase=true;
    public static boolean updateCPMActive=true;
    public static boolean upadteCPMPricingAnalyst=true;
    //***************End*********************//
    
    //**************TaskEvents***************//
    public static boolean updateTaskCase=true;
    public static boolean updateTaskCase1=true;
    //****************End*******************//
    
    //****************Customer Transition*******//
    public static boolean updateonceCustrans=true;
    public static boolean updateonceCustrans1=true;
    public static boolean updateonceCustransErr=true;
    public static boolean cascadedown=true;
    public static boolean OnceExecuted=true;
    public static boolean cascadeReviewDate;
    public static Set<Id> recCTset = new set<id>();
    public static boolean rerun_timetrack = true;
    public static boolean mod5extnhlpr = true;
    //*****************End******************//
    
    public static boolean onceprospectmsg = true;
    public static boolean oppemailsend=true;
    
    //FOR dnbi
    public static boolean DNBItrigger=true;
    
    //**************** Account Trigers *******//
    public static boolean notTriggered_AccountEvents_before = true; // trigger not in Prod
    public static boolean notTriggered_AccountEvents_after = true; // trigger not in Prod
    
    public static boolean notTriggered_AccountTriggers_before = true; // different uat and prod
    public static boolean notTriggered_AccountTriggers_after = true; // different uat and prod
    
    public static boolean notTriggered_BeforeAccountTrigger_before = true; // different
    public static boolean notTriggered_GT_DeleteContacts_after = true;
    public static boolean notTriggered_GT_SoldToChange_before = true;
    public static boolean notTriggered_UpdateAOPSAssignedOnRecordTypeChange_after = true;
    public static boolean bypassAccountExtension = false;
    //*****************End******************//
    
    
    //for Mod 5
    public static boolean mod5ByPass= true; // trigger not in Prod
    
    
    //**************** Contact Trigers *******//
    public static boolean notTriggered_checkDuplicateContacts_before = true; // different uat and prod
    public static boolean notTriggered_checkDuplicateContacts_after = true; // different uat and prod
    
    public static boolean notTriggered_GT_LinkContact_before = true; // not in prod
    public static boolean notTriggered_GT_LinkContact_after = true; // not in prod
    
    public static boolean notTriggered_DoNotDeleteContact_before = true;
    public static boolean notTriggered_GT_DeleteRelatedContactOnAccountChange_after = true;
    public static boolean notTriggered_primaryCheck_after = true;
    public static boolean notTriggered_removeContactLinks_before = true; // not in prod
    //*****************End******************//
}