global class ApexJobsMonitoringBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    final String DEFAULT_QUERY = 'SELECT Id, Label, Category__c,frequency__c,frequency_metric__c FROM Apex_Job__mdt';

    // Email constants
    final String BODY_TOP = '<table cellspacing="0" cellpadding="0" dir="ltr" border="1" style="table-layout:fixed;font-size:13px;font-family:arial,sans,sans-serif;border-collapse:collapse;border:none">' +
	                        '<colgroup><col width="286"><col width="150"><col width="100"><col width="243"></colgroup><tbody><tr style="height:21px"><td style="padding:2px 3px;background-color:rgb(159,197,232);border-color:rgb(0,0,0);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">' +
				            'Job Name</td><td style="padding:2px 3px;background-color:rgb(159,197,232);border-top-color:rgb(0,0,0);border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">' +
				            'Last<br>Execution</td><td style="padding:2px 3px;background-color:rgb(159,197,232);border-top-color:rgb(0,0,0);border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;font-weight:bold;word-wrap:break-word;vertical-align:middle;text-align:center">' +
				            'Currrent<br>Status</td><td style="padding:2px 3px;background-color:rgb(159,197,232);border-top-color:rgb(0,0,0);border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;font-weight:bold;vertical-align:middle;text-align:center">' +
				            'Status<br>Detail</td></tr>';
    final String BODY_BOTTOM = '</tbody></table>';
    
    global Map<String, List<AsyncApexJob>> categoryToApexJobs;
    global Map<String, List<String>> categoryToApexJobsM;
    global Map<String, boolean> jobsScheduledStatus;
    global Map<String,Decimal> jobsCountMap;
    global Map<String,Decimal> jobsDefCounts;
    global Map<String,String> jobCategories;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        categoryToApexJobs = new Map<String, List<AsyncApexJob>>();
        jobsScheduledStatus = new Map<String, boolean>();
        jobsCountMap = new Map<String,Decimal>();
        jobsDefCounts = new map<String,Decimal>();
        categoryToApexJobsM = new Map<String, List<String>>();
        jobCategories = new map<String,String>();
		return Database.getQueryLocator(DEFAULT_QUERY);
    }
    
    global void execute(Database.BatchableContext bc, List<Apex_Job__mdt> scope) {
        // Get job names and category from Custom Metadata Type
        DateTime curr = System.now();
        Map<String, String> jobNamesToCategory = new Map<String, String>();
        Map<String,DateTime> typeToTimeMap = new map<String,DateTime>();
        

        
        for (Apex_Job__mdt apexJob : scope) {
            
            jobNamesToCategory.put(apexJob.Label, apexJob.Category__c);
            jobsScheduledStatus.put(apexJob.Label, false);
            jobCategories.put(apexjob.category__c,apexjob.category__c);
            
            List<String> jobsUnderCategory;
            
            if (categoryToApexJobsM.containsKey(apexJob.Category__c)) {
                jobsUnderCategory = categoryToApexJobsM.get(apexJob.Category__c);
                jobsUnderCategory.add(apexjob.Label);
            }
            else {
                jobsUnderCategory = new List<String>();
                jobsUnderCategory.add(apexjob.Label);
                categoryToApexJobsM.put(apexJob.Category__c, jobsUnderCategory);
            }
            
            if (apexJob.frequency__c != null)
              jobsDefCounts.put(apexJob.Label,apexJob.frequency__c);
              
            if (!typeToTimeMap.containsKey(apexJob.frequency_metric__c)) {
                if (apexJob.frequency_metric__c == 'Day')
                  typeToTimeMap.put(apexJob.frequency_metric__c,system.now()-1);
                if (apexJob.frequency_metric__c == 'Week')
                  typeToTimeMap.put(apexJob.frequency_metric__c,system.now()-7);
                if (apexJob.frequency_metric__c == 'Month')
                  typeToTimeMap.put(apexJob.frequency_metric__c,system.now()-30);
            }
        }
        
        System.debug('ApexJobsMonitoringBatch > jobsScheduledStatus (1): ' + jobsScheduledStatus);
        System.debug('ApexJobsMonitoringBatch > jobNamesToCategory: ' + jobNamesToCategory);
        
        // Get last run for each job
        List<AggregateResult> jobs = [SELECT ApexClass.Name, MAX(ID) LatestRunId
                                      FROM AsyncApexJob 
                                      WHERE ApexClass.Name IN :jobNamesToCategory.keySet()
                                      AND JobType != 'BatchApexWorker'
                                      AND CreatedDate = LAST_N_DAYS:10
                                      GROUP BY ApexClass.Name];
        
        if (typeToTimeMap.containskey('Day')) {
          for(AggregateResult job : [SELECT ApexClass.Name jobname, count(id) jobRunCount
                                      FROM AsyncApexJob 
                                      WHERE ApexClass.Name IN :jobNamesToCategory.keySet()
                                      AND JobType != 'BatchApexWorker'
                                      AND CreatedDate >= :typeToTimeMap.get('Day')
                                      GROUP BY ApexClass.Name]) {
                                          jobsCountMap.put((String)job.get('jobname'),(Decimal)job.get('jobRunCount'));
                                      }
        }
        
        if (typeToTimeMap.containskey('Week')) {
                                     
          for(AggregateResult job : [SELECT ApexClass.Name jobname, count(id) jobRunCount
                                      FROM AsyncApexJob 
                                      WHERE ApexClass.Name IN :jobNamesToCategory.keySet()
                                      AND JobType != 'BatchApexWorker'
                                      AND CreatedDate >= :typeToTimeMap.get('Week')
                                      GROUP BY ApexClass.Name]) {
                                          jobsCountMap.put((String)job.get('jobname'),(Decimal)job.get('jobRunCount'));
                                      }
        }
        
        if (typeToTimeMap.containskey('Month')) {
          for(AggregateResult job : [SELECT ApexClass.Name jobname, count(id) jobRunCount
                                      FROM AsyncApexJob 
                                      WHERE ApexClass.Name IN :jobNamesToCategory.keySet()
                                      AND JobType != 'BatchApexWorker'
                                      AND CreatedDate >= :typeToTimeMap.get('Month')
                                      GROUP BY ApexClass.Name]) {
                                          jobsCountMap.put((String)job.get('jobname'),(Decimal)job.get('jobRunCount'));
                                          
                                      }
        }
        
     
        
        System.debug('ApexJobsMonitoringBatch > jobs: ' + jobs);
        
        List<ID> latestRunJobIds = new List<ID>();
        
        for (AggregateResult job : jobs) {
            ID jobId = (ID) job.get('LatestRunId');
            latestRunJobIds.add(jobId);
        }
        
        System.debug('ApexJobsMonitoringBatch > latestRunJobIds: ' + latestRunJobIds);
        
        // Get status for last run for each job
        List<AsyncApexJob> jobStatus = [SELECT ApexClass.Name, Status, ExtendedStatus, CreatedDate
                                        FROM AsyncApexJob 
                                        WHERE Id IN :latestRunJobIds];
       /* List<AsyncApexJob> jobStatus = [SELECT ApexClass.Name, Status, ExtendedStatus, CreatedDate
                                        FROM AsyncApexJob 
                                        where ApexClass.Name IN :jobNamesToCategory.keySet()
                                        and createddate IN :latestRunJobIds];*/
        
        System.debug('ApexJobsMonitoringBatch > jobStatus: ' + jobStatus);
        
        for (AsyncApexJob currentJob : jobStatus) {
            String category = jobNamesToCategory.get(currentJob.ApexClass.Name);
            List<AsyncApexJob> jobsUnderCategory;
            
            if (categoryToApexJobs.containsKey(category)) {
                jobsUnderCategory = categoryToApexJobs.get(category);
                jobsUnderCategory.add(currentJob);
            }
            else {
                jobsUnderCategory = new List<AsyncApexJob>();
                jobsUnderCategory.add(currentJob);
                categoryToApexJobs.put(category, jobsUnderCategory);
            }
            
            // Mark job as scheduled
            jobsScheduledStatus.put(currentJob.ApexClass.Name, true);
        }
        
        System.debug('ApexJobsMonitoringBatch > execute() > categoryToApexJobs: ' + categoryToApexJobs);
        System.debug('ApexJobsMonitoringBatch > jobsScheduledStatus (2): ' + jobsScheduledStatus);
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('ApexJobsMonitoringBatch > finish() > categoryToApexJobs: ' + categoryToApexJobs);
        
        // Send email
        String toAddressesLabel = Label.ApexJobsMonitoringBatch_Emails;
        String[] toAddresses = toAddressesLabel.split(';');
        String jstatus='GREEN';
        String bodyInner='';
        String subject = 'Apex Jobs Status:';
        boolean failedJobs = false;
        boolean categoryIssue = false;
       
        
        for (String category : jobCategories.keySet()) {
            // Add white row and category name row
            categoryIssue = false;
            bodyInner += createEmailCategoryTableRow(category);
            
            // Add a row for each job under the category
            //List<AsyncApexJob> jobsUnderCategory = ;
            
            for (String j:categoryToApexJobsM.get(category)) {
                if (!categoryToApexJobs.containsKey(category)) {
                    bodyInner += createEmailJobTableRow(j, '', 'Job Not Running', '','Critical');
                    failedJobs = true;
                    categoryIssue=true;
                }
                else {
                    boolean jobfound = false;
                    for (AsyncApexJob job : categoryToApexJobs.get(category)) {
                        if (job.ApexClass.Name == j)
                           jobfound = true;
                    }
                    if (jobfound == false) {
                      bodyInner += createEmailJobTableRow(j, '', 'Job Not Running', '','Critical');
                      failedJobs = true;
                      categoryIssue=true;
                    }
                }
            }
         
         if (categoryToApexJobs.containsKey(category))   {
            for (AsyncApexJob job : categoryToApexJobs.get(category)) {
                String jobName = job.ApexClass.Name;
                String createdDate = job.CreatedDate.format();
                String status = job.Status;
                String extendedStatus = ((job.ExtendedStatus == null) ? '' : job.ExtendedStatus);
                
               // bodyInner += createEmailJobTableRow(jobName, createdDate, status, extendedStatus);
                
                if (status == 'Failed') {
                    bodyInner += createEmailJobTableRow(jobName, createdDate, status, extendedStatus,'Critical');
                    failedJobs = true;
                    categoryIssue = true;
                }
                else if (extendedStatus != null && extendedStatus != '') {
                    bodyInner += createEmailJobTableRow(jobName, createdDate, status, extendedStatus,'High');
                    categoryIssue = true;
                }
                
                if (jobsCountMap.containsKey(jobName) && jobsDefCounts.containsKey(jobname)) {
                    if (jobsCountMap.get(jobname) <  jobsDefCounts.get(jobname)) {
                        categoryIssue = true;
                        failedJobs = true;
                        bodyInner += createEmailJobTableRow(jobName, '', 'Job Not Running', '','Critical');
                    }
                }
                else if (jobsDefCounts.containsKey(jobname) && !jobsCountMap.containsKey(jobName)) {
                    categoryIssue = true;
                    failedJobs = true;
                     bodyInner += createEmailJobTableRow(jobName, '', 'Job Not Running', '','Critical');
                }
            }
         }
            
            if (!categoryIssue)
               bodyInner += createNormalRun();
            
        }
        
        // Display jobs that are not scheduled at the end
        String unscheduledJobs = '';
        boolean first = true;
        
     /*   for (String jobName : jobsScheduledStatus.keySet()) {
            // If not scheduled
            if (!jobsScheduledStatus.get(jobName)) {
                
                if (first) {
                    first = false;
                    unscheduledJobs = '<br/>Jobs not scheduled to run: ' + jobName;
                }
                else {
                    unscheduledJobs += ', ' + jobName;
                }
            }
        }*/
        
        if (failedJobs) {
            subject = '***PAGE*** ' + subject;
            jstatus = 'RED';
        }
        
        // Create and populate the SingleEmailMessage instance
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
        email.saveAsActivity = false;
        email.setToAddresses(toAddresses);
        email.setSubject(subject + ' ' + jstatus);
        //email.setHTMLBody(BODY_TOP + bodyInner + BODY_BOTTOM + unscheduledJobs);
        email.setHTMLBody(BODY_TOP + '</br><b>Job Run Status: <font color="'+jstatus+'"/>'+jstatus+'</b></br></br></br>' + bodyInner + BODY_BOTTOM);
        
        Messaging.SingleEmailMessage[] emailsToSend = new Messaging.SingleEmailMessage[] {email};
        
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
    
    private String createEmailCategoryTableRow(String category) {
        String tableRow = '<tr style="height:21px"><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);border-left-color:rgb(0,0,0)"></td>' + 
                          '<td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)"></td><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)">' + 
                          '</td><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)"></td></tr>' +
                          '<tr style="height:21px"><td style="padding:2px 3px;background-color:rgb(159,197,232);border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);border-left-color:rgb(0,0,0);font-family:verdana;font-weight:bold;vertical-align:middle" rowspan="1" colspan="4">' +
                          category + '</td></tr>';
        
        return tableRow;
    }
    
     private String createNormalRun() {
        String tableRow = '<tr style="height:21px"><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);border-left-color:rgb(0,0,0)"></td>' + 
                          '<td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)"></td><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)">' + 
                          '</td><td style="padding:2px 3px;vertical-align:bottom;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0)"></td></tr>' +
                          '<tr style="height:21px"><td style="padding:2px 3px;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);border-left-color:rgb(0,0,0);font-family:verdana;color:green;font-weight:bold;vertical-align:middle" rowspan="1" colspan="4">Jobs Running Normal</td></tr>';
        
        return tableRow;
    }
    
    private String createEmailJobTableRow(String jobName, String createdDate, String status, String extendedStatus,String severity) {
        string color='color:green';
        if (severity == 'critical')
           color = 'color:red';
        else if (severity == 'high')
           color = 'color:orange';
        String tableRow = '<tr style="height:21px">	<td style="padding:2px 3px;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);border-left-color:rgb(0,0,0);font-family:verdana;vertical-align:middle;'+color+'">' +
				          jobName + '</td><td style="padding:2px 3px;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;vertical-align:middle;text-align:center"> ' +
                          createdDate + '</td><td style="padding:2px 3px;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;word-wrap:break-word;vertical-align:middle;text-align:center;'+color+'"> ' +
				          status + '</td><td style="padding:2px 3px;border-right-color:rgb(0,0,0);border-bottom-color:rgb(0,0,0);font-family:verdana;vertical-align:middle">' +
                          extendedStatus + '</td></tr>';
        return tableRow;
    }

	global void execute(SchedulableContext sc) {
		ApexJobsMonitoringBatch batch = new ApexJobsMonitoringBatch(); 
		Database.executebatch(batch, 1);
    }
}