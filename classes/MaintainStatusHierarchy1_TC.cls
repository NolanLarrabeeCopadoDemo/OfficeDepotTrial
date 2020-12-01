// 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440217 (OD 00816640)

@isTest
private class MaintainStatusHierarchy1_TC
{
    static testMethod void MaintainStatusHierarchy1UnitTest()
    {
    List<recordtype> custRecId= [select id from recordtype where name ='Customer'];
    
    Account grandParentAcc = new Account();
    grandParentAcc.RecordtypeId = custRecId[0].id;
    grandParentAcc.AOPS_Seq_ID__c = '987654';
    grandParentAcc.OMX_Primary_Key__c='987654';
    grandParentAcc.Name='Grand Parent Test Account';
    insert grandParentAcc;
    
    Account parentAcc = new Account();
    parentAcc.RecordtypeId = custRecId[0].id;
    parentAcc.AOPS_Seq_ID__c = '654321';
    parentAcc.OMX_Primary_Key__c='654321';
    parentAcc.Name='Parent Test Account';
    parentAcc.parentid=grandParentAcc.id;
    insert parentAcc;
    
    Account acc = new Account();
    acc.RecordtypeId = custRecId[0].id;
    acc.AOPS_Seq_ID__c = '321987';
    acc.OMX_Primary_Key__c='321987';
    acc.Name='Test Account';
    acc.parentid=parentAcc.id;
    insert acc;
    
    Account noGPAcc = new Account();
    noGPAcc.RecordtypeId = custRecId[0].id;
    noGPAcc.AOPS_Seq_ID__c = '789456';
    noGPAcc.OMX_Primary_Key__c='789456';
    noGPAcc.Name='No GP Test Account';
    noGPAcc.parentid=grandParentAcc.id;
    insert noGPAcc;
    
    Account noParentAcc = new Account();
    noParentAcc.RecordtypeId = custRecId[0].id;
    noParentAcc.AOPS_Seq_ID__c = '123789';
    noParentAcc.OMX_Primary_Key__c='123789';
    noParentAcc.Name='No Parent Test Account';
    insert noParentAcc;
    
    List<Customer_Transition__c> insertCT = new List<Customer_Transition__c>();
    List<Customer_Transition__c> updateCT = new List<Customer_Transition__c>();
    
    Customer_Transition__c CTgrandParent = new Customer_Transition__c();
    CTgrandParent.Account__c=grandParentAcc.id;
    CTgrandParent.Status__c='Launched';
    CTgrandParent.Cascade_Down__c =false;
    //insert CTgrandParent;
    
    Customer_Transition__c CTparent = new Customer_Transition__c();
    CTparent.Account__c=parentAcc.id;
    CTparent.Status__c='Launched';
    CTparent.Cascade_Down__c =false;
    //insert CTparent;
    
    Customer_Transition__c CT = new Customer_Transition__c();
    CT.Account__c=acc.id;
    CT.Status__c='Launched';
    CT.Cascade_Down__c =false;
    //insert CT;
        
    Customer_Transition__c CTfornoGPAcc = new Customer_Transition__c();
    CTfornoGPAcc.Account__c=noGPAcc.id;
    CTfornoGPAcc.Status__c='Launched';
    CTfornoGPAcc.Cascade_Down__c =false;
    //insert CTfornoGPAcc;
    
    
    
    Customer_Transition__c CTnoParentAcc = new Customer_Transition__c();
    CTnoParentAcc.Account__c=noParentAcc.id;
    CTnoParentAcc.Status__c='Launched';
    CTnoParentAcc.Cascade_Down__c =false;
    //insert CTnoParentAcc;
    
    
    insertCT.add(CT);
    insertCT.add(CTparent);
    insertCT.add(CTgrandParent);
    insertCT.add(CTfornoGPAcc);
    insertCT.add(CTnoParentAcc);
    
    insert insertCT;
    
    CT.Account__c=acc.id;
    CT.Status__c = 'Launched' ;
    CT.Cascade_Down__c = true;
    //Connor Flynn S-440217 (OD 00816640) Start
    CT.Review_Start_Date__c = System.today();
    //Connor Flynn S-440217 (OD 00816640) END
    //update CT;
    
    CTparent.Account__c=acc.id;
    CTparent.Status__c = 'Launched' ;
    CTparent.Cascade_Down__c = true;
    //update CTparent;
    
    CTgrandParent.Account__c=acc.id;
    CTgrandParent.Status__c = 'Launched' ;
    CTgrandParent.Cascade_Down__c = true;
    //update CTgrandParent;
    
    CTfornoGPAcc.Account__c=noGPAcc.id;
    CTfornoGPAcc.Status__c = 'Launched' ;
    CTfornoGPAcc.Cascade_Down__c = true;
    //update CTfornoGPAcc;
    
    
    CTnoParentAcc.Account__c=noParentAcc.id;
    CTnoParentAcc.Status__c = 'Launched' ;
    CTnoParentAcc.Cascade_Down__c = true;
    //update CTnoParentAcc;
    
    
    
    updateCT.add(CT);
    updateCT.add(CTparent);
    updateCT.add(CTgrandParent);
    updateCT.add(CTfornoGPAcc);
    updateCT.add(CTnoParentAcc);
    
    update updateCT;
    
    
    }
}