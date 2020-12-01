/**
 * Created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
 */
@isTest
private class LatticeHighestPlaySelector_TC {
/*
    static testMethod void myUnitTest() {
        Account acct = createTestData();

        Test.startTest();

        Task t = createTask(acct, 'Completed', 'Salesprism Test', '[SR] X-Sell Break Room to Ink/Paper/Office Prod Buyer');
        insert t;
        
        LatticeHighestPlaySelector c = new LatticeHighestPlaySelector();
        Database.executeBatch(c);
        
        Test.stopTest();
    }
    
    static Account createTestData(){
        // Accounts
        List<Account> accts = new List<Account>();
        
        for (integer i = 0; i < 16; i++) {
            accts.add(Test_Utils.CreateAccount());
        }     
               
        // Plays
        List<Lattice_Play__c> plays = new List<Lattice_Play__c>();
        
        for (Account acct : accts) {
            plays.addAll(createAllPlays(acct));
        }
      
        insert plays;
        
        // Update flags in plays
        for (Lattice_Play__c play : plays) {
            integer random = Math.Random().intValue();
            string offer;
            
            if (random == 0) {
                offer = 'N';
            }
            else if (random == 1) {
                offer = 'Y';
            }
            
            updateFlags(play, offer, 'Y', 'Y');
        }

        update plays;

        return accts[0];
    }
    
    static void updateFlags(Lattice_Play__c play, String offer, String optIn, String legal) {
        play.Offer_Flag__c = offer;
        play.Opt_In_Out_Flag__c = optIn;
        play.Legal_WA_Flag__c = legal;
    }
    
    static Lattice_Play__c createPlay(Account header, Account acct, String product, integer score) {
        Lattice_Play__c lp = new Lattice_Play__c();
        lp.Header_Account__c = header.Id;
        lp.Account_ID__c = acct.Id;
        lp.Product_Category__c = product;
        lp.play_score__c = score;
        
        return lp;
    }
  
    static List<Lattice_Play__c> createAllPlays(Account acct) {
        List<Lattice_Play__c> plays = new List<Lattice_Play__c>();
        
        plays.add(createPlay(acct, acct, 'CBS', (Math.Random()*100).intValue()));
        plays.add(createPlay(acct, acct, 'Technology', (Math.Random()*100).intValue()));
        plays.add(createPlay(acct, acct, 'Furniture', (Math.Random()*100).intValue()));
        plays.add(createPlay(acct, acct, 'Supplies', (Math.Random()*100).intValue()));
        
        return plays;
    }
    
    static Task createTask(Account acct, String status, String disposition, String subject) {
        Task t = new Task();
        t.WhatId = acct.Id;
        t.Status = status;
        t.Disposition_Code__c = disposition;
        t.Subject = subject;
        
        return t;
    }
*/
}