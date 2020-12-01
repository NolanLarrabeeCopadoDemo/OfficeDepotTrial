global class MedalliaDailyCheckDateDrivenTriggers implements Schedulable{
    /* Execute StartDateDrivenSampling when schedule is triggered */
    public Flow.Interview.MedalliaDateDrivenTrigger DateDrivenSampling {get; set;}
    
    global static void execute(SchedulableContext sc){
        Flow.Interview.MedalliaDateDrivenTrigger startFlow= new Flow.Interview.MedalliaDateDrivenTrigger(new Map<String, Object>());
        startFlow.start();
    }
}