public class SprintanalysisController 
{
    public string SprintName{get;set;}   
    public void SprintanalysisController()
    {
        
    }
    
    public PageReference Refresh()
    {
        system.debug('SprintName1-->'+SprintName);
        return null;
    }
}