global class VP_Trigger_Validator {
    
/* These are helper methods to aid in preventing running of duplicate triggers */    

    private static boolean TriggerExecuted = false;
    
    public static boolean HasTriggerExecuted(){
        return TriggerExecuted;
    }
    
    public static void SetTriggerExecuted() {
        TriggerExecuted = true;
    }
    
    public static void ResetTriggerExecuted(){
        TriggerExecuted = false;
    }
}