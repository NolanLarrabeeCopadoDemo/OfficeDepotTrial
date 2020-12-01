@isTest
public class TokenWebSerCallCtrl_TC
{

    static testMethod void TokenWebSerCallCtrl_TC()
    {
        TechDepotSetting__c TDS = new TechDepotSetting__c();
        TDS.Crypto_Key__c='Sz3oFf2pAWtdogFgIfN5nmQ1Jsz3L3muo/68QJYPKjw=';
        TDS.User_Title__c='THISISTITLE';
        TDS.Name='Key';
        insert TDS;
        
        TokenWebSerCallCtrl inst1 = new TokenWebSerCallCtrl ();
        inst1.token='MiiVeRDKtMTvPvgoyk2IaCqMpors77JjadZ6s8TnkdxYIpAkq4jOexMw%2Bttfbw%2FED67Xf%2FSjga3hozl5qYChdQ%3D%3D';
        //inst1.token1='8816a510788bfc20a85f33ee0799f100';
        inst1.decodeu();
        inst1.decryptu();
        inst1.rspnsFlds.Emp_F_Name='abc';
        inst1.rspnsFlds.Emp_Id='abc';
        inst1.rspnsFlds.Name='abc';
        inst1.rspnsFlds.Emp_L_Name='abc';
        inst1.rspnsFlds.Emp_Email='abc';
        inst1.rspnsFlds.Manager='abc';
        inst1.rspnsFlds.Mngr_F_Name='abc';
        inst1.rspnsFlds.Mngr_L_Name='abc';
        inst1.rspnsFlds.Manager_Email='abc';
        inst1.rspnsFlds.ManagerEmpid='abc';
        //inst1.rspnsFlds.
        inst1.CallWebSerMethod();
        //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
    }
}