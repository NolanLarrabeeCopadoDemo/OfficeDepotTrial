trigger beforeInsertOfficeMaxOfficeDepotCrossReference  on OfficeMax_OfficeDepot_CrossReference__c (before Insert) {
  //TOOPProcess trig= new TOOPProcess();
  //trig.updateTOOP(Trigger.New);

  for(OfficeMax_OfficeDepot_CrossReference__c cr : Trigger.New) {

        cr.Unique_Key__c = cr.AOPS_Number__c  + cr.OMX_Key__c.substring(0,7);

    }


}