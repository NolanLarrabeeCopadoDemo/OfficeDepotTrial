trigger afterInsertOfficeMaxOfficeDepotCrossReference  on OfficeMax_OfficeDepot_CrossReference__c (after Insert,after update) {
  TOOPProcess trig= new TOOPProcess();
  trig.updateTOOP(Trigger.New);
  }