/******************************************************************************
Name            :  Constants
Created by      :  Hemant 11/4/2015
Story #         :  S-359750 [OD case # 00541425]
Description     :  To maintain all the hard coded (constant) values over the org
******************************************************************************/
public without sharing class Constants {

    //QuoteTriggerHandler constants
    public static final String STATUS_ACCEPTED_BY_CUSTOMER = 'Accepted by Customer';
    public static final String QUOTETRIGGER_ERROR_MSG_ANOTHER_QUOTE_OPP = 'Another Quote under the parent Opportunity already has status as \'Accepted by Customer\', only one Quote can have status as \'Accepted by Customer\' under parent Opportunity';


    public static boolean SiteCheck= true; // SalesDataBeforeTrigger

    public static boolean SkipAccountTrigger= false; // skip trigger



  //OpportunityTriggerHandler constants
  public static final String STATUS_CLOSED = 'closed';
  public static final String STATUS_OPEN = 'open';

  public static final String STAGENAME_0_PERCENT_LOST = 'Lost';
  public static final String STAGENAME_0_PERCENT_WALKAWAY = 'Walkaway';
  public static final String STAGENAME_0_PERCENT_DUPLICATE_CANCELLED = 'Duplicate/Cancelled';
  public static final String STAGENAME_100_PERCENT_WON = 'Close';
  public static final String ASSIGNMENT = 'Assignment'; // Added by Rahul Story S-389134
  public static final String UAT_MiGRATION = 'UAT Migration'; //Added this if block by Lalit for S-404756
  public static final String MiGRATION_TO_UAT_COMPLETED = 'Migration to UAT completed'; //Added this if block by Lalit for S-404756
  public static final String DESIGN = 'Design'; //Added  by Lalit for S-407213
  public static final String BUILD_UNIT_TEST = 'Build/Unit Test'; //Added  by Lalit for S-407213
  public static final String CODE_REVIEW = 'Code Review'; //Added  by Lalit forS-407213
  public static final String QA = 'QA'; //Added  by Lalit for S-407213
  public static final String UAT = 'UAT'; //Added  by Lalit for S-407213
  public static final String USABILITY = 'Usability'; //Added  by Lalit for S-407213
  public static final String ARB_REQUIRED = 'ARB Required'; //Added  by Lalit for S-407213
  public static final String LEAD_SOURCE = 'BSD Auto Account Setup';//Added  by Lalit for S-407235
  public static final String SINGLE = 'Single';//Added  by Lalit for S-407235
  public static final String SINGLE_USER = 'Single User';//Added  by Lalit for S-407235
  public static final String MULTIPLE = 'Multiple';//Added  by Lalit for S-407235
  public static final String MULTI_USER = 'Multi-User';//Added  by Lalit for S-407235
  public static final String LEAD_FIRST= 'Lead First';//Added  by Lalit for S-414430

  //START S-434793 [OD 00786800] - Hemant[8/26/2016]
  public static final String CASE_TASK_TYPE_BUSINESS = 'Business';
  public static final String CASE_TASK_TYPE_IT = 'IT';
  public static final String MSG_SELECT_CASE_RECORD = 'Please select atleast one support/case to proceed.';
  //END S-434793 [OD 00786800] - Hemant[8/26/2016]


  //START OD case # 00593320 (S-374378) [Hemant 2/10/2016]
  //customerTransitionTriggerHandler constants
  public static final String CT_STATUS_SCHEDULED = 'Scheduled';
  public static final String CT_STATUS_RESCHEDULED = 'ReScheduled';
  public static final String CT_STATUS_UNSCHEDULED = 'UnScheduled';
  public static final String CT_STATUS_LAUNCHED = 'Launched';
  public static final String CT_STATUS_ASSESSMENT = 'Assessment';
  public static final String CT_STATUS_LOSS_OF_CUSTOMER = 'Loss of Customer';
  public static final String CT_STATUS_READY_TO_ORDER = 'Ready to Order';
  public static final String CT_STATUS_ODP_AGREEMENT_IN_DEVELOPMENT = 'ODP Agreement in Development';
  public static final String CT_STATUS_AUTO_REDIRECTED = 'Auto Redirected';
  public static final String CT_STATUS_READY_FOR_ECOM_MOD = 'Ready for eCom Mod';
  public static final String CT_STATUS_ERROR_LAUNCHED = 'Error - Launched';
  public static final String CT_STATUS_REDIRECT_STOPPED = 'Redirect Stopped';
  public static final String CT_STATUS_TRANSITION_COMPLETE = 'Transition Complete';
  public static final String CT_STATUS_AGREEMENT_DEVELOPMENT = 'Agreement/Development';
  public static final String CT_STATUS_EXTENSION_DEVELOPMENT = 'Extension/Development';
  public static final String CT_STATUS_BUILDING = 'Building';
  public static final String CT_STATUS_FINALIZING = 'Finalizing';
  public static final String CT_STATUS_AUDIT_1 = 'Audit 1';
  public static final String CT_STATUS_AUDIT_2 = 'Audit 2';
  public static final String CT_STATUS_ORDERING = 'Ordering';
  public static final String CT_STATUS_ADMINISTRATIVE_CLOSE = 'Administrative Close';
  public static final String CT_STATUS_ON_DECK = 'On Deck';

  // Added Constant by Rahul For Story - S-377011
  public static final String SUPPORT = 'Support';
  public static final String IT_CASES = 'IT Cases';
  public static boolean HAS_PROCESSED = false;
  public static String EMAIL_SUBJECT_TASK = 'New Sprint Request Assigned to You for Case #';
  public static String EMAIL_BODY_HEADER = 'A new request for the following Support Case has been assigned to you: \n \n';
  // END - S-377011

  //Connor Flynn S-437498 (00801298)
  public static final String PARTNER_CASE = 'Partner Case';
  public static final String ACCOUNT_MAINTENANCE = 'Account Maintenance';
  public static final String ECOMMERCE_FIELD_SUPPORT = 'eCommerce – Field Support';
  public static final String GT_CASES = 'GT Cases';
  public static final String APPROVED = 'Approved';
  ////Connor Flynn S-437498 (00801298) End
  //Start - Added by Jyoti for Story S-407215
  public static final String NOT_STARTED = 'Not Started';
  public static final String QUEUE = 'Queue';
  public static final String IT_QUEUE  = 'IT Queue';
  public static final String FAST_TRACK = 'Fast Track';
  public static final String PRODUCTION_FIX = 'Production Fix';
  public static final String SPRINT = 'Sprint';
  //End - Story S-407215

  //Added for S-425887[Case#00756096]
  public static final String IT_RELEASE  = 'IT Release';
  //END S-425887[Case#00756096]


  public static final String LABEL_PLACE_OD_ORD = 'PLACE OD ORD';
  public static final String LABEL_Y = 'Y';
  public static final String LABEL_Z = 'Z';
  public static final String LABEL_R = 'R';
  public static final String LABEL_S = 'S';
  public static final String LABEL_B = 'B';
  public static final String LABEL_REDIRECT = 'REDIRECT';
  public static final String LABEL_WEB_USER = 'WEB USER';
  public static final String LABEL_NEW_LINE_TAG = ' \r\n';
  public static final String LABEL_STATUS = 'Status';
  public static final String LABEL_WA = 'WA';
  public static final String LABEL_NON_WA = 'nonWA';
  public static final String LABEL_HYPHEN = '-';
  public static final String LABEL_BLANK_SPACE = ' ';

  public static final String COMMENTS_AUTOMATIC_RECORD_LOCK = 'Automatic record lock.';

  public static final String CT_TRIGGER_ERROR_MSG_CAN_NOT_SELECT_ADMINISTRATIVE_CLOSE = 'Can not select Administrative Close check box when record is already launched OR DNS Confirmation/DNS Status Confirmed is not checked';
  public static final String CT_TRIGGER_ERROR_MSG_HIERARCHY_EXCEPTION = 'Record cannot be saved due to exception in hierarchy.';
  //END OD case # 00593320 (S-374378) [Hemant 2/10/2016]

  //ContactStagingAreaHandler Constants (S-386204 - Mohit 2/17/2016)
  public static final String ACTIVE = 'Active';


  //ProspectStagingAreaTriggerHandler Constants (S-386205 - Mohit 2/18/2016)
  public static final String BYPASS = 'ByPass';
  public static final String HEALTHCARE = 'Healthcare';
  public static final String ACQUISITION = 'Acquisition';

  //TaskTriggerHandler Constants (S-386208 - Mohit 2/25/2016)
  public static final String PRODUCTION_DATE_ERROR = 'A Production Date is required to complete the Validation task. Please go back to the Support case and add a Production Date and retry completing this task.';

  public static final String PrimaryCompetitorRT = 'US'; // added for story #S-399120
  //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
  public static final String Prospect_OfficeMax ='Prospect (OfficeMax)';
  public static final String CustomerProspect ='Customer';
  public static final String ProspectAccount ='Prospect';
  public static final String Customer_OfficeMax ='Customer (OfficeMax)';
  //END- Vipul
  //Modified By Vipul Jain for Story#S-457173 (00615193 - Tier 1: Story 05b Account Owner Chatter Group - Addition of Sales Diversity Managers and Ops) on December 27,2016
  public static final String TIER1_ACCOUNT_OWNERS_GROUP_NAME= 'Tier 1 Account Owners';
  //END - Vipul
  //Modified By Vipul Jain for Story#S-457177 (00899744 - Tier 1: Story 21.1 Partner-Level Contract Object) on December 30,2016
  public static final String STANDARD_CONTRACT_RECORD_TYPE = 'Standard';
  //END -Vipul
}