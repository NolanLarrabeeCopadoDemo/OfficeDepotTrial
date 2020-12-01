global with sharing class ACE_StdCustUserAccess{
    public Boolean AceAccess{get;set;}
    public ACE_StdCustUserAccess(ApexPages.StandardController controller){
        AceAccess=getAceAccess();
    }
    
    public Boolean getAceAccess(){
        List<GroupMember> grpMemList = [Select id,UserOrGroupId From GroupMember Where group.name='ACE Standard Group'];
        system.debug('grpMemList >>>>>>>>>>>>>>>>>>'+grpMemList );
        Set<ID> UserSet = new Set<ID>();
        
        for(GroupMember GM :grpMemList){
            UserSet.add(gm.UserOrGroupId);
        }
        system.debug('UserSet>>>>>'+UserSet+'>>>>>UserInfo.getUserId()>>>>>>'+UserInfo.getUserId());
        if(UserSet.contains(UserInfo.getUserId()))
            return true;
        else 
            return False;
    }

}