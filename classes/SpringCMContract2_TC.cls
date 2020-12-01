/**@@
    #CLASS NAME  :  SpringCMContract2_TC
    #DESCRIPTION :  Test class for "SpringCMContract2" 
    
@@**/

@IsTest
public class SpringCMContract2_TC {
    
    @TestSetup public static void setup(){
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', childAccountList [0].id, 5);
            List<Contract_Pricing_Terms__c> cptList = DataFactory.createContractPriceTermsTestRecords('Testing', contractList[0].id, 5);
        }
        
    }
    
    static testMethod void SpringCMContract2_Method(){
        List<Contract> contractList = [Select id From Contract Limit 10];
        PageReference pageRef = Page.SpringCMContract2;
        ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
        system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
        ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
        ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
        SpringCMContract2 controller = new SpringCMContract2(con);

        Test.StartTest();
        controller.saveindividualtab(); 
        Test.StopTest();
        
        
        system.debug('display_springcm_contract=>'+controller.display_springcm_contract);

        System.assertEquals(true, controller.display_springcm_contract);
        System.assertEquals(false, controller.Pricing_Call_Out_AutoSub_Language_Display);       
         
        
    }
    
    static testMethod void SpringCMContract2_Method2(){
        List<Account > accountList = [Select id From Account  Limit 10];
        List<Contract> contractList = [Select id From Contract Limit 10];
        
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('accId',accountList[0].id);
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
        Test.StopTest();
        
        
        system.debug('display_springcm_contract=>'+controller.display_springcm_contract);

        System.assertEquals(false, controller.display_springcm_contract);
        System.assertEquals(false, controller.Pricing_Call_Out_CostPlus_FloorType_Display);     
        
    }
    
 /*   static testMethod void SpringCMContract2_Method1(){
        //List<Contract> contractList = [Select id,Contract_Status__c,Other_contract_type__c From Contract Limit 10];
        List<Contract> contractList = [Select id,Contract_Status__c,Other_contract_type__c From Contract Where Item_count_restrictions__c= 'Single' Limit 10];
        
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.currentPage().getParameters().Put('clone','1');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            
            SpringCMContract2 controller = new SpringCMContract2(con);
            controller.newcontr.Contract_Status__c= 'Closed/Cancelled';
            controller.saveAsDraft();
        Test.StopTest();
        
        
        system.debug('display_springcm_contract=>'+controller.display_springcm_contract);

        System.assertEquals(true, controller.display_springcm_contract);        
    } */
    
    static testMethod void SpringCMContract2_Method3(){
        List<Contract> contractList = [Select id From Contract Limit 10];
        
        
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            controller.Item_count_conditionaldisplay();
        Test.StopTest();
        

        System.assertEquals(null, controller.newcontr.Item_count_threshold_tier_Count5__c);
        System.assertEquals(null, controller.newcontr.Item_count_threshold_tier_To5__c);
        
    }
    
    static testMethod void SpringCMContract2_Method3_Negative(){
        List<Contract> contractList = [Select id From Contract Where Item_count_restrictions__c= 'Single' Limit 10];
        
        
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            controller.Item_count_conditionaldisplay();
        Test.StopTest();
        
        System.debug('Item_count_threshold_tier_From1__c=>'+controller.newcontr.Item_count_threshold_tier_From1__c);
        System.assertEquals(0, controller.newcontr.Item_count_threshold_tier_From1__c); 
        System.assertEquals(0, controller.newcontr.Item_count_threshold_tier_To1__c);       
    }
    
    static testMethod void SpringCMContract2_Method4(){
         List<Account > accountList = [Select id From Account  Limit 10];
        List<Contract> contractList = [Select id From Contract Where Item_count_restrictions__c= 'Single' Limit 10];
        Id StandardRecordtypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            Test.setCurrentPage(pageRef);            
            ApexPages.currentPage().getParameters().Put('accid',accountList[0].id);
            ApexPages.currentPage().getParameters().Put('save_new','1');
            ApexPages.currentPage().getParameters().Put('RecordType',String.valueOf(StandardRecordtypeId));
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con); 
            
            PageReference pg = controller.redirectToPage();
        Test.StopTest();
        System.debug('URL=>'+ApexPages.currentPage().getURL());
        //System.assertEquals(true, controller.Pricing_Call_Out_CostPlus_FloorType_Display); 
        System.assertEquals(true, pg != null);      
    }
    
    static testMethod void SpringCMContract2_Method5(){
        List<Contract> contractList = [Select id From Contract Limit 10];
       
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            PageReference pg = controller.saveContractLegal();
        Test.StopTest();
        

        System.assertEquals(true, pg == null);      
    }
    
    static testMethod void SpringCMContract2_Method6(){
        List<Contract> contractList = [Select id From Contract Limit 10];
       
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            PageReference pg = controller.redirectnewlightning();
        Test.StopTest();
        

        System.assertEquals(true, pg != null);      
    }
    
   static testMethod void SpringCMContract2_Method7(){
        List<Contract> contractList = [Select id From Contract Limit 10];
        
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            PageReference pg = controller.redirectnew();
        Test.StopTest();
        

        System.assertEquals(true, pg != null);       
    }
    static testMethod void SpringCMContract2_Method8(){
        List<Contract> contractList = [Select id From Contract Limit 10];
        List<Contract_Pricing_Terms__c> cptList = [Select id From Contract_Pricing_Terms__c Limit 10];
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs');
            ApexPages.currentPage().getParameters().Put('selectedRecord',cptList[0].id);
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            PageReference page = controller.deletepricingterm();
        Test.StopTest();
        

        System.assertEquals(true, page != null);      
    }
    static testMethod void SpringCMContract2_Method9(){
        List<Contract> contractList = [Select id From Contract Limit 10];
       
        Test.StartTest();
            PageReference pageRef = Page.SpringCMContract2;
            ApexPages.currentPage().getParameters().Put('id',contractList[0].id);
            system.debug('id'+ApexPages.currentPage().getParameters().get('id'));
            ApexPages.currentPage().getParameters().Put('at','customerlevelimputs5');
            ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
            SpringCMContract2 controller = new SpringCMContract2(con);
            PageReference page = controller.deleteContractItem();
        Test.StopTest();
        

        System.assertEquals(true, page != null);       
    }
    static testMethod void SpringCMContract2_Method10(){
        List<Contract> contractList = [Select id From Contract Limit 10];
       
        Test.StartTest();           
           SpringCMContract2 SpringCMContractObj = new SpringCMContract2();
           PageReference pageRef = Page.SpringCMContract2;
           ApexPages.currentPage().getParameters().Put('save_new','1');
           ApexPages.StandardController con = new ApexPages.StandardController(contractList[0]);
           SpringCMContract2 controller = new SpringCMContract2(con);            
           PageReference page = controller.Cancel();
         Test.StopTest();        

        System.assertEquals(true, page != null);      
    }

}