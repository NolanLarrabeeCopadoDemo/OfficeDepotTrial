@Istest(seealldata = true)

class ODFoundationContactWS_TC
{
    private static testmethod void ODFoundationContactWS_testMethod()
    {
        ODFoundationContactWS.addContact('testName','testfirstname','t11@t.com','(999) 999-9999');
    }
    
}