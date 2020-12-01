global class DeDupOnetimeWarning
{
webservice String test;
    webService static boolean getFieldValues(String test)
    {
        System.debug('---------'+test);
        List<DMND_Duplicate__c> Duppotential=new List<DMND_Duplicate__c>();
        //List<Contact> list_Contacts = [select id,Phone from contact where accountid =:test];
        if(test.startsWith('006'))
        {
            system.debug('@@@@@opportunity');
            Duppotential=[select Name,Disposition__c from DMND_Duplicate__c where Opportunity__c=:test and (Disposition__c='Merge'or Disposition__c='Delete')];
        }
        if(test.startsWith('003'))
        {
            system.debug('@@@@@Contact');
            Duppotential=[select Name,Disposition__c from DMND_Duplicate__c where Contact__c=:test and (Disposition__c='Merge'or Disposition__c='Delete')];
        }
        if(Duppotential.size()>0)
        {
            system.debug('return true@@@');            
            return true;           
        }
        else
        {
            system.debug('return false@@@');
            return false;
        }
    }
    webService static boolean SetNullValues(String test)
    {
        System.debug('---------111'+test);
        list<DMND_Duplicate__c > list_UpdateDuplicates = new list<DMND_Duplicate__c >();
        List<DMND_Duplicate__c> Duppotential = new List<DMND_Duplicate__c>();
        if(test.startsWith('006'))
        {
            Duppotential=[select Name,Disposition__c,opportunity__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Opportunity__c=:test];
        }
        if(test.startsWith('003'))
        {
            Duppotential=[select Name,Disposition__c,opportunity__c,Contact__c,Other_Disposition_Reason__c from DMND_Duplicate__c where Contact__c=:test];
        }
        for(DMND_Duplicate__c alias:Duppotential )
                {
                    if(alias.Disposition__c!='' && alias.Disposition__c!=NULL )
                    {
                        alias.Disposition__c='';
                        alias.Dispostion_Reason__c = '';
                        alias.Other_Disposition_Reason__c='';
                        list_UpdateDuplicates.add(alias);
                    }
                }
                if(list_UpdateDuplicates.size()>0)
                    update list_UpdateDuplicates;
                return true;
    }
    
}