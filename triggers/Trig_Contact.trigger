trigger Trig_Contact on Contact (after insert, after update) {
       // added for ticket 01474559
       if (Trigger.New != null) {
         for (Contact myCont: Trigger.new) {
                   System.debug('&&&&&&Inside loop myCont'+myCont.recordtypeId);

          if (Util.bizBoxRTIdsByObject('Contact').contains(myCont.RecordTypeId)) {
          System.debug('&&&&&&Inside loop');
           return;
          }
         }
        }
     /*if (!Test.isRunningTest())
     et4ae5.triggerUtility.automate('Contact');
     else{     
     System.debug('&&&inside test class');    
     }*/
 }