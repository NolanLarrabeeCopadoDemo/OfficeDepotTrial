@isTest
private class CaseEmailEvent_TC {

    static testmethod void CaseEmailEvent_TC(){
    case cs=new case();
     cs.subject='This is test case';
     cs.status='Closed';
     Recordtype Rec=new Recordtype();
    Rec =[select id from recordtype where name='Support' limit 1];
     cs.recordtypeid=Rec.id;
     insert cs;
    emailmessage em = new emailmessage();
                em.fromaddress = 'Test@test.com';
                em.incoming = true;
                em.toaddress = 'test1@test.com';
                em.subject = 'Test Email';
                em.status='0';
                em.textbody = 'testing';
                em.parentid = cs.id;
                test.starttest();
                insert em;
                test.stoptest();
    
    }
    }