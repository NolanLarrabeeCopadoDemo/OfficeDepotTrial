trigger PotentialDeDuplicateCheck on DMND_Duplicate__c (After Insert, After Update, before Delete) {

    set<id> warningsid = new set<id>();
    list<Account> accwarnings = new list<Account>();
    list<Lead> leadwarnings = new list<Lead>();
    list<Contact> cntwarnings = new list<Contact>();
    list<Opportunity> oppwarnings = new list<Opportunity>();
    list<DMND_Duplicate__c> potentialduplicates = new list<DMND_Duplicate__c>();
    Map<id,DMND_Duplicate__c> dmndMap = new Map<id,DMND_Duplicate__c>();
    List<DMND_Duplicate__c> dmndDupList;// = new List<DMND_Duplicate__c>();
    Map<id,List<DMND_Duplicate__c>> dmndDeleteMap = new Map<id,List<DMND_Duplicate__c>>();
    if(trigger.isInsert || trigger.isUpdate){
        system.debug('Trigger.New**'+Trigger.New);  
        for(DMND_Duplicate__c BD :Trigger.New){
          if(BD.Account__c != null || BD.Lead__c != null || BD.Contact__c != null || BD.Opportunity__c != null){
            system.debug('<<<<BD>>>>'+BD);
            if(BD.Account__c != null){
                warningsid.add(BD.Account__c); 
                dmndMap.put(BD.Account__c,BD);
                 system.debug('dmndMap**'+dmndMap);                
            }
            if(BD.Lead__c != null){
                warningsid.add(BD.Lead__c);
                dmndMap.put(BD.Lead__c,BD);
                system.debug('leaddmndMap**'+dmndMap);                
            }
            if(BD.Contact__c != null){
                warningsid.add(BD.Contact__c);
                dmndMap.put(BD.Contact__c,BD);
                system.debug('cntdmndMap**'+dmndMap);                
            }
            if(BD.Opportunity__c != null){
                warningsid.add(BD.Opportunity__c); 
                dmndMap.put(BD.Opportunity__c,BD);
                system.debug('oppdmndMap**'+dmndMap);                 
            }                                     
          }
          
       }
      accwarnings =[select id, Potential_DeDuplicate__c,Potential_Warning_Key__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from account where id =: warningsid];
      leadwarnings =[select id, Potential_DeDuplicate__c,Potential_Warning_Key__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from lead where id =: warningsid];
      cntwarnings =[select id, Potential_DeDuplicate__c,Potential_Warning_Key__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from contact where id =: warningsid];
      oppwarnings =[select id, Potential_DeDuplicate__c,Potential_Warning_Key__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from Opportunity where id =: warningsid];
      system.debug('<<<<leadwarnings>>>>'+leadwarnings);
      system.debug('<<<<cntwarnings>>>>'+cntwarnings);
        
      if(accwarnings.size()>0 || leadwarnings.size()>0 || cntwarnings.size()>0 || oppwarnings.size()>0){
          for(account a: accwarnings){
              a.Potential_DeDuplicate__c = true;
              system.debug(' Value**'+dmndMap.get(a.id).Potential_Duplicate_Warning__r.Warning_Key__c);
              //if(dmndMap.get(a.id).Disposition__c=='Keep'){//As per kishore's mail on 27th Aug
                  a.Pot_Disposition__c = dmndMap.get(a.id).Disposition__c;
                  a.Pot_Other_Disposition_Reason__c = dmndMap.get(a.id).Other_Disposition_Reason__c;
                  a.Pot_Disposition_Reason__c = dmndMap.get(a.id).Dispostion_Reason__c;
                  a.Potential_Warning_Key__c = dmndMap.get(a.id).Potential_Warning_Key__c;
              //}
          }
          for(Contact c: cntwarnings){
              c.Potential_DeDuplicate__c = true;
              system.debug(' CntValue**'+dmndMap.get(c.id).Potential_Duplicate_Warning__r.Warning_Key__c);
              //if(dmndMap.get(c.id).Disposition__c=='Keep'){
                  c.Pot_Disposition__c = dmndMap.get(c.id).Disposition__c;
                  c.Pot_Other_Disposition_Reason__c = dmndMap.get(c.id).Other_Disposition_Reason__c;
                  c.Pot_Disposition_Reason__c = dmndMap.get(c.id).Dispostion_Reason__c;
                  c.Potential_Warning_Key__c = dmndMap.get(c.id).Potential_Warning_Key__c;
              //}    
          }    
          for(Lead l: leadwarnings){
              l.Potential_DeDuplicate__c = true;
              system.debug(' leadValue**'+dmndMap.get(l.id).Potential_Duplicate_Warning__r.Warning_Key__c);
              //if(dmndMap.get(l.id).Disposition__c=='Keep'){
                  l.Pot_Disposition__c = dmndMap.get(l.id).Disposition__c;
                  l.Pot_Other_Disposition_Reason__c = dmndMap.get(l.id).Other_Disposition_Reason__c;
                  l.Pot_Disposition_Reason__c = dmndMap.get(l.id).Dispostion_Reason__c;
                  l.Potential_Warning_Key__c = dmndMap.get(l.id).Potential_Warning_Key__c;
              //}
          }    
          for(opportunity o: oppwarnings){
              o.Potential_DeDuplicate__c = true;
              //if(dmndMap.get(o.id).Disposition__c=='Keep'){  
              system.debug(' oppValue**'+dmndMap.get(o.id).Disposition__c);
                  o.Pot_Disposition__c = dmndMap.get(o.id).Disposition__c;
                  o.Pot_Other_Disposition_Reason__c = dmndMap.get(o.id).Other_Disposition_Reason__c;
                  o.Pot_Disposition_Reason__c = dmndMap.get(o.id).Dispostion_Reason__c;
                  o.Potential_Warning_Key__c = dmndMap.get(o.id).Potential_Warning_Key__c;
              //}    
          }    
      }
      update accwarnings;
      update cntwarnings;
      update leadwarnings;
      system.debug('oppValue before updating'+oppwarnings);
      update oppwarnings;
      system.debug('oppValue after updating'+oppwarnings);
      
    }
    
   /* if(trigger.isDelete){
        if(dmndDupList!=null)
            dmndDupList.clear();
        for (DMND_Duplicate__c BD : [select id, Lead__c,Contact__c,Opportunity__c,Account__c,Disposition__c,Other_Disposition_Reason__c,Dispostion_Reason__c from DMND_Duplicate__c]){
          if (BD.Account__c != null || BD.Lead__c != null || BD.Contact__c != null || BD.Opportunity__c != null){
                if(BD.Account__c != null){
                    warningsid.add(BD.Account__c); 
                    if(dmndDeleteMap.containsKey( BD.Account__c)){
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Account__c,dmndDupList);
                    }else{
                        dmndDupList = new List<DMND_Duplicate__c>();
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Account__c,dmndDupList);
                    }
                    dmndMap.put(BD.Account__c,BD);
                    system.debug('dmndaccDeleteMap size**'+dmndDeleteMap.get(BD.Account__c).size());
                }
                if(BD.Lead__c != null){
                   warningsid.add(BD.Lead__c);
                   system.debug('BD.Lead__c**'+BD.Lead__c);
                   if(dmndDeleteMap.containsKey(BD.Lead__c)){
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Lead__c,dmndDupList);
                        system.debug('dmndkeadDeleteMap sizeif**'+dmndDeleteMap.get(BD.Lead__c).size());
                    }else{                    
                        dmndDupList = new List<DMND_Duplicate__c>();
                        dmndDupList.add(BD);
                        dmndDeleteMap.put(BD.Lead__c,dmndDupList);
                        system.debug('dmndkeadDeleteMap size**else'+dmndDeleteMap.get(BD.Lead__c).size());
                    }
                    dmndMap.put(BD.Lead__c,BD);
                 }
                if(BD.Contact__c != null){
                    warningsid.add(BD.Contact__c);
                    if(dmndDeleteMap.containsKey(BD.Contact__c)){
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Contact__c,dmndDupList);
                    }else{
                        dmndDupList = new List<DMND_Duplicate__c>();
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Contact__c,dmndDupList);
                    }
                    dmndMap.put(BD.Account__c,BD);
                    system.debug('dmndcontDeleteMap size**'+dmndDeleteMap.get(BD.Contact__c).size());
                }
                if(BD.Opportunity__c != null){
                    warningsid.add(BD.Opportunity__c);
                    if(dmndDeleteMap.containsKey(BD.Opportunity__c)){
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Opportunity__c,dmndDupList);
                    }else{
                        dmndDupList = new List<DMND_Duplicate__c>();
                        dmndDupList.add(BD );
                        dmndDeleteMap.put(BD.Opportunity__c,dmndDupList);
                    }
                    dmndMap.put(BD.Account__c,BD);
                    system.debug('dmndappDeleteMap size**'+dmndDeleteMap.get(BD.Opportunity__c).size());
                }
                system.debug('@@@@warningsid@@@@'+warningsid);
            }
         }
      leadwarnings =[select id, Potential_DeDuplicate__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from lead where id =: warningsid];
      accwarnings =[select id, Potential_DeDuplicate__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from account where id =: warningsid];
      cntwarnings =[select id, Potential_DeDuplicate__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from contact where id =: warningsid];
      oppwarnings =[select id, Potential_DeDuplicate__c,Pot_Disposition__c,Pot_Other_Disposition_Reason__c,Pot_Disposition_Reason__c from Opportunity where id =: warningsid];
      if(accwarnings.size()>0 || leadwarnings.size()>0 || cntwarnings.size()>0 || oppwarnings.size()>0){
          for(account a: accwarnings){
               if(dmndDeleteMap.get(a.id).size()==1){
                      a.Potential_DeDuplicate__c = false;
                      a.Pot_Disposition__c = null;
                      a.Pot_Other_Disposition_Reason__c = null;
                      a.Pot_Disposition_Reason__c = null;
                  }else{
                     a.Potential_DeDuplicate__c = true;
                      if(dmndMap.get(a.id).Disposition__c!=null && dmndMap.get(a.id).Disposition__c=='Keep'){
                          a.Pot_Disposition__c = dmndMap.get(a.id).Disposition__c;
                          a.Pot_Other_Disposition_Reason__c = dmndMap.get(a.id).Other_Disposition_Reason__c;
                          a.Pot_Disposition_Reason__c = dmndMap.get(a.id).Dispostion_Reason__c;
                      }
                  }
          }
          for(Contact c: cntwarnings){
              if(dmndDeleteMap.get(c.id).size()==1){
                  c.Potential_DeDuplicate__c = false;
                  c.Pot_Disposition__c = null;
                  c.Pot_Other_Disposition_Reason__c = null;
                  c.Pot_Disposition_Reason__c = null;
              }else{
                  c.Potential_DeDuplicate__c = true;
                  if(dmndMap.get(c.id).Disposition__c!=null && dmndMap.get(c.id).Disposition__c=='Keep'){
                      c.Pot_Disposition__c = dmndMap.get(c.id).Disposition__c;
                      c.Pot_Other_Disposition_Reason__c = dmndMap.get(c.id).Other_Disposition_Reason__c;
                      c.Pot_Disposition_Reason__c = dmndMap.get(c.id).Dispostion_Reason__c;
                  } 
              }
          }
           for(Lead l: leadwarnings){
                  system.debug('l.idval**'+l.id+'**List**'+dmndDeleteMap.get(l.id)+'l.idval2**'+dmndDeleteMap.get(l.id).size());
                  system.debug('l.id**'+dmndDeleteMap.get(l.id).size());
                  if(dmndDeleteMap.get(l.id).size()==1){
                      l.Potential_DeDuplicate__c = false;
                      l.Pot_Disposition__c = null;
                      l.Pot_Other_Disposition_Reason__c = null;
                      l.Pot_Disposition_Reason__c = null;
                  }else{
                      l.Potential_DeDuplicate__c = true;
                      if(dmndMap.get(l.id).Disposition__c!=null && dmndMap.get(l.id).Disposition__c=='Keep'){
                          l.Pot_Disposition__c = dmndMap.get(l.id).Disposition__c;
                          l.Pot_Other_Disposition_Reason__c = dmndMap.get(l.id).Other_Disposition_Reason__c;
                          l.Pot_Disposition_Reason__c = dmndMap.get(l.id).Dispostion_Reason__c;
                      }
                  }        
          }
          for(opportunity o: oppwarnings){
              if(dmndDeleteMap.get(o.id).size()==1){
                  o.Potential_DeDuplicate__c = false;
                  o.Pot_Disposition__c = null;
                  o.Pot_Other_Disposition_Reason__c = null;
                  o.Pot_Disposition_Reason__c = null;
              }else{
                  o.Potential_DeDuplicate__c = true;
                  if(dmndMap.get(o.id).Disposition__c!=null && dmndMap.get(o.id).Disposition__c=='Keep'){
                      o.Pot_Disposition__c = dmndMap.get(o.id).Disposition__c;
                      o.Pot_Other_Disposition_Reason__c = dmndMap.get(o.id).Disposition__c;
                      o.Pot_Disposition_Reason__c = dmndMap.get(o.id).Dispostion_Reason__c;
                  }
              }
          }
      }
      update accwarnings;
      update cntwarnings;
      update leadwarnings;
      update oppwarnings;          
    }*/
}