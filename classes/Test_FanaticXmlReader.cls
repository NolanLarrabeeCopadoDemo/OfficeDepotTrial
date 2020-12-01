@isTest
public class Test_FanaticXmlReader{
    @isTest static void testFanaticXMLRead() {    
        Test.startTest();    
        FanaticXmlReader fxml= new FanaticXmlReader();
        FanaticXmlReader.OrderItems oi=new FanaticXmlReader.OrderItems();
        FanaticXmlReader.Customer cu = new FanaticXmlReader.Customer();
        FanaticXmlReader.Address ad= new FanaticXmlReader.Address();
        FanaticXmlReader.Contact ct= new FanaticXmlReader.Contact();
        FanaticXmlReader.OrderHeader oh = new FanaticXmlReader.OrderHeader();
        String reader = '<test> </test>';
        String reader2 = '<Addresses> </Addresses>';
        String reader3 = '<Contacts> </Contacts>';
        String reader4 = '<OrderHeader> </OrderHeader>';
        List<FanaticXmlReader.Customer> lst1=fxml.parseCustomers(reader);
        List<FanaticXmlReader.Address> lst2 = fxml.parseAddresses(reader2);
        ad = fxml.parseAddress(reader);
        List<FanaticXmlReader.Contact> lst3= fxml.parseContacts(reader3);
        ct= fxml.parseContact(reader);
        List<FanaticXmlReader.OrderHeader> lst4 = fxml.parseOrderHeaders(reader4);
        oh = fxml.parseOrderHeader(reader);
        oi = fxml.parseOrderItem(reader);
        
        fanaticDtlCntlr fctrl = new fanaticDtlCntlr();
        pagereference p=fctrl.getData();
        Test.stopTest();
    }
}