@isTest
private class ACE_StdCustUserAccess_TC {
    static testMethod void ACE_StdCustUserAccess_method(){
       Account acc = new Account(Name='abcd');
       insert acc ;
       ApexPages.StandardController con = new ApexPages.StandardController(acc );
       ACE_StdCustUserAccess aceStdCustUserAccess = new ACE_StdCustUserAccess(con);
       Group grp = new Group(Name = 'ACE Standard Group');
       insert grp;
       
       
    }
}