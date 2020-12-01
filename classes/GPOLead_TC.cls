/**********************************************************

Class Name : GPOLead_TC 
Created Date : May 21st, 2015
Created By : Mohit Batwada
Purpoae : Test Class for GPOLead 

***********************************************************/
@isTest
public with sharing class GPOLead_TC {
    

    static void testGPOLeadRequiredField(){
      

         User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
          System.runas(new user(ID = UserInfo.getUserID())){
         Account account = Test_Utils.getTestAccount(user,'123456');
         GPO_Lead__c gpoLeadData = Test_Utils.createGPOLead(account, true);
         
         GPOLead gpoLead = new GPOLead();
         gpoLead.saveLead();
         System.assertEquals(gpoLead.errorText,'Error: Please Enter All the Required Fields');
         
         //S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
         GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',true);
         GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,true);
         GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
         gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
         gpoGroup.Activated__c = true;
         gpoGroup.RecordTypeId = gpoCommunitySetup.defaultRecordType__c;
         insert gpoGroup;
         system.assertNotEquals(null, gpoGroup.Id);
         
         gpoLead = new GPOLead(new GPOCommunityLandingController());
         //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
     }
                     }
     
     @isTest
    static void testGPOLeadAddRequiredField(){
      Test.startTest();
      
         System.runAs(new user(ID = UserInfo.getUserID())){

         User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');
         Account account = Test_Utils.getTestAccount(user,'123456');
         GPOLead gpoLead = new GPOLead();
         gpoLead.newLead();
         System.assertEquals(gpoLead.successMsg,false);

         GPO_Lead__c gpoLeadData = Test_Utils.createGPOLead(account, false);
             gpoLeadData.WCW_Range__c = '1-19';
             //insert gpoLeadData;//S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
         System.debug('==gpoLeadData=='+gpoLeadData);
         
         
         
         PageReference gpoLeadPage = Page.GPOLead;
         Test.setCurrentPage( gpoLeadPage );
         //START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
         ApexPages.currentPage().getParameters().put( 'id', account.id );
         gpoLead.glead = gpoLeadData;
         gpoLead.saveLead();
         //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
         
         GPO_Lead__c gpLead = [select id, name,first_name__c,last_name__c,Phone__c,Email__c,Business_Name__c,Zip__c,WCW_Range__c from GPO_Lead__c limit 1];
         System.debug('=gpLead==='+gpLead );
         system.debug('==account.id=='+gpoLead.parentAccid);
         gpoLead.saveLead();
         //System.assertEquals(gpoLead.successMsg,true);
         
         }
         Test.stopTest();
     }        
    
}