@IsTest
private class EndlessAisleScratchPad_TC
{
    @TestSetup
    static void makeData()
    {
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];

        Account acc             = new Account(Name='TestAcc1', OwnerId=owner.Id, RecordtypeId=rtCust.Id, Aops_Cust_Id__c='1');
        insert acc;
        Account siteAcc1        = new Account(Name='Siteacc1', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='2');
        Account siteAcc2        = new Account(Name='Siteacc2', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='3');
        List<Account> accounts  = new List<Account>{ siteAcc1, siteAcc2 };
        insert accounts;

        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Qualify', CloseDate=Date.today(), AccountId=acc.Id);
        insert opp;
        
        Id standardPBID = Test.getStandardPricebookId();
        
        Quote q1            = new Quote(Name='TestQuote1', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        Quote q2            = new Quote(Name='TestQuote2', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        Quote q3            = new Quote(Name='TestQuote3', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Completed');
        List<Quote> quotes  = new List<Quote>{ q1, q2, q3 };
        insert quotes;
        
        Tech_Sales_Manufacturer__c m1 = new Tech_Sales_Manufacturer__c();
        m1.Name = 'm1';
        m1.Manufacturer_Id__c = 1;
        insert m1;
    }

    // @IsTest
    // public static void getMultipleLineItems() {
    //     Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
    //  EndlessAisleScratchPad.insertQuoteLineItem(String.valueOf(q.Id), '1', '1', 1.0, '1', '1', '1', 1.0, '1', '1', 1, 1.0, '1', '1', 1.0, '1', '1', '1', false, 1.0, '1', '1', '1', '1', 'EA', 1.0, '1', 1, '1', '1', '1');
    //  EndlessAisleScratchPad.insertQuoteLineItem(String.valueOf(q.Id), '2', '2', 2.0, '2', '2', '2', 2.0, '2', '2', 2, 2.0, '2', '2', 2.0, '2', '2', '2', false, 2.0, '2', '2', '2', '2', 'EA', 1.0, '1', 1, '1', '1', '1');
    //  Test.setMock(HttpCalloutMock.class, new ProductSearchServiceRequest_TC.ProductSearchServiceMock('search'));
    //  Test.startTest();
    //     List<Map<String, Object>> lineItems = (List<Map<String, Object>>)JSON.deserialize(EndlessAisleScratchPad.getQuoteLineItems(String.valueOf(q.Id)), List<Map<String,Object>>.class);
    //  Test.stopTest();
    //  System.debug(lineItems);
    //     System.assert(lineItems.size() == 2);
    // }

    @IsTest
    public static void getNoLineItems() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote2'];
        Test.setMock(HttpCalloutMock.class, new ProductSearchServiceRequest_TC.ProductSearchServiceMock('search'));
        Test.startTest();
        List<Map<String, Object>> lineItems = (List<Map<String, Object>>)JSON.deserialize(EndlessAisleScratchPad.getQuoteLineItems(String.valueOf(q.Id)), List<Map<String,Object>>.class);
        Test.stopTest();
        System.debug(lineItems);
        System.assert(lineItems.size() == 0);
    }

    // @IsTest
    // public static void getSingleLineItem() {
    //     Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote3'];
    //  EndlessAisleScratchPad.insertQuoteLineItem(String.valueOf(q.Id), '3', '3', 3.0, '3', '3', '3', 3.0, '3', '3', 3, 3.0, '3', '3', 3.0, '3', '3', '3', false, 3.0, '3', '3', '3', '3', 'EA', 1.0, '1', 1, '1', '1', '1');
    //  Test.setMock(HttpCalloutMock.class, new ProductSearchServiceRequest_TC.ProductSearchServiceMock('search'));
    //  Test.startTest();
    //     List<Map<String, Object>> lineItems = (List<Map<String, Object>>)JSON.deserialize(EndlessAisleScratchPad.getQuoteLineItems(String.valueOf(q.Id)), List<Map<String,Object>>.class);
    //  Test.stopTest();
    //  System.debug(lineItems);
    //     System.assert(lineItems.size() == 1);
    // }

    @IsTest
    public static void saveScratchPadUpdatesCompletes() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerComments = 'Test\nTest';
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerComments, lineItems, estimatedTax,0);
        Test.stopTest();
    }

    @IsTest
    public static void saveScratchPadUpdatesUpdatesQuote() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = 'Test\nTest';
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectCustomerNotesOnQuote('Test\nTest');
    }

    @IsTest
    public static void saveScratchPadUpdatesUpdatesQuoteWithNullValue() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectCustomerNotesOnQuote(null);
    }

    @IsTest
    public static void saveScratchPadUpdatesBadQuoteId() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = 'Test\nTest';
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            EndlessAisleScratchPad.saveScratchPadUpdates('1234', customerNotes, lineItems, estimatedTax,0);
        } catch(AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        checkCorrectCustomerNotesOnQuote(null);
        checkCorrectNumberOfLineItemsCreated(0);
        System.assertEquals(true, exceptionThrown);
    }

    @IsTest
    public static void saveScratchPadUpdatesInsertsOneLineItem() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectNumberOfLineItemsCreated(1);
        checkQuoteLineItems(lineItems);
    }

    @IsTest
    public static void saveScratchPadUpdatesInsertsMultipleLineItems() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(5, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectNumberOfLineItemsCreated(5);
        checkQuoteLineItems(lineItems);
    }

    @IsTest
    public static void saveScratchPadUpdatesInsertsNoItems() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(0, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectNumberOfLineItemsCreated(0);
    }

    @IsTest
    public static void saveScratchPadUpdatesOnConflictUpdatesLineItems() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(3, q.Id);
        List<Map<String, Object>> firstSetOfItems = new List<Map<String, Object>> { lineItems[0], lineItems[1] };
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, firstSetOfItems, estimatedTax,0);
        setIdField(lineItems[0]);
        setIdField(lineItems[1]);
        setUpdateableFields(lineItems[0], 4);
        setUpdateableFields(lineItems[1], 5);
        // At this point, Line Items 0 and 1 have different values in all their fields, and have their SFDC IDs added.
        List<Map<String, Object>> secondSetOfItems = new List<Map<String, Object>> { lineItems[0], lineItems[1], lineItems[2] };

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, secondSetOfItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectNumberOfLineItemsCreated(3);
        checkQuoteLineItems(secondSetOfItems);
    }

    @IsTest
    public static void saveScratchPadUpdatesDeleteExtraLineItems() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(4, q.Id);
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        lineItems.remove(3);
        lineItems.remove(2);
        setIdField(lineItems[0]);
        setidField(lineItems[1]);
        
        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectNumberOfLineItemsCreated(2);
        checkQuoteLineItems(lineItems);
    }

    @IsTest
    public static void saveScratchPadUpdatesWithEstimatedTax() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String customerNotes = null;
        Decimal estimatedTax = 12472.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);

        Test.startTest();
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, customerNotes, lineItems, estimatedTax,0);
        Test.stopTest();

        checkCorrectEstimatedTaxOnQuote(12472.0);
    }

    @IsTest
    public static void getQuoteNotesToCustomer() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        q.Notes_To_Customer__c = 'Test Notes';
        update q;

        Test.startTest();
        String retrievedNotes = EndlessAisleScratchPad.getQuoteNotesToCustomer(q.Id);
        Test.stopTest();

        System.assertEquals(q.Notes_To_Customer__c, retrievedNotes);
    }

    @IsTest
    public static void getQuoteBadId() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            EndlessAisleScratchPad.getQuoteNotesToCustomer(null);
        } catch(AuraHandledException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown);
    }

    private static List<Map<String, Object>> generateLineItems(Integer num, String quoteId) {
        List<Map<String, Object>> lineItems = new List<Map<String, Object>>();
        for(Integer i = 1; i <= num; i++) {
            Map<String, Object> lineItem = new Map<String, Object> {
                'vendorQuoteNumber' => '1111111' + i,
                'Catalogue' => 'Test' + i,
                'shipping' => i,
                'departmentClassCode' => 'Test' + i,
                'isVirtualWarehouseItem' => false,
                'originalCost' => i,
                'productCategorycode' => '1111111' + i,
                'productCategoryDescription' => 'Test' + i,
                'subClassCode' => '1111111' + i,
                'webAvailabilityCode' => '1111111' + i,
                'QuoteId' => quoteId,
                'vendorManufacturerName' => 'Test' + i,
                'odSkuNumber' => '1111111' + i,
                'maxListPrice' => i,
                'mfgPartNumber' => '1111111' + i,
                'supplierPartNumber' => '1111111' + i,
                'itemDescription' => 'Test' + i,
                'customerPrice' => i,
                'upcCode' => '1111111' + i,
                'supplierName' => 'Test' + i,
                'quantity' => i,
                'adjustedCost' => i,
                'itemDescription' => 'Test' + i,
                'vendorNumber' => '1111111' + i
            };
            lineItems.add(lineItem);
        }
        return lineItems;
    }

    private static void setIdField(Map<String, Object> lineItem) {
        QuoteLineItem savedItem = [SELECT Id FROM QuoteLineItem WHERE Vendor_Number__c =: (String) lineItem.get('vendorNumber')];
        lineItem.put('quoteLineItemId', savedItem.Id);
    }

    private static void setUpdateableFields(Map<String, Object> lineItem, Integer num) {
        lineItem.put('vendorQuoteNumber', '1111111' + num);
        lineItem.put('shipping', num);
        lineItem.put('originalCost', num);
        lineItem.put('vendorManufacturerName', 'Test' + num);
        lineItem.put('maxListPrice', num);
        lineItem.put('mfgPartNumber', '1111111' + num);
        lineItem.put('supplierPartNumber', '1111111' + num);
        lineItem.put('itemDescription', 'Test' + num);
        lineItem.put('customerPrice', num);
        lineItem.put('supplierName', 'Test' + num);
        lineItem.put('quantity', num);
        lineItem.put('adjustedCost', num);
        lineItem.put('itemDescription', 'Test' + num);
        lineItem.put('vendorNumber', '1111111' + num);
    }

    private static void checkCorrectCustomerNotesOnQuote(String notes) {
        Quote q = [SELECT Id, Notes_To_Customer__c FROM Quote WHERE Name = 'TestQuote1'];
        System.assertEquals(notes, q.Notes_To_Customer__c);
    }

    private static void checkCorrectEstimatedTaxOnQuote(Decimal estimatedTax) {
        Quote q = [SELECT Id, Tax FROM Quote WHERE Name = 'TestQuote1'];
        System.assertEquals(estimatedTax, q.Tax);
    }

    private static void checkCorrectNumberOfLineItemsCreated(Integer num) {
        List<QuoteLineItem> createdItems = [SELECT Id FROM QuoteLineItem];
        System.assertEquals(num, createdItems.size());
    }

    private static void checkQuoteLineItems(List<Map<String, Object>> lineItems) {
        for(Map<String, Object> lineItem : lineItems) {
            checkQuoteLineItem(lineItem);
        }
    }

    private static void checkQuoteLineItem(Map<String, Object> lineItem) {
        QuoteLineItem createdItem = [SELECT Id, Vendor_Quote_Number__c, Catalogue__c, Shipping_Handling__c, Department_Class_Code__c,
                Is_virtual_Warehouse_Item__c, Original_Cost__c, Product_Category_Code__c, Product_Category_Description__c,
                Subclass_Code__c, Web_Availability_Code__c, QuoteId, Vendor_Manufacturer_Name__c, OD_Item_Number__c, List_Price__c,
                Mfg_Part_Number__c, Vendor_Part_Number__c, Description, UnitPrice, UPC__c, Vendor_Name__c, Quantity,
                Cost__c, Supplier_Item_Description__c, Vendor_Number__c, Product2Id, PricebookEntryId
                FROM QuoteLineItem WHERE Vendor_Number__c =: (String) lineItem.get('vendorNumber')];
        Product2 prod = [SELECT Id FROM Product2 WHERE Id =: createdItem.Product2Id];
        PriceBookEntry entry = [SELECT Id FROM PriceBookEntry WHERE Pricebook2Id =: Test.getStandardPricebookId()
                                    AND Product2Id =: prod.Id
                                    AND IsActive = true];

        System.assertEquals(lineItem.get('vendorQuoteNumber'), createdItem.Vendor_Quote_Number__c);
        System.assertEquals(lineItem.get('Catalogue'), createdItem.Catalogue__c);
        System.assertEquals(lineItem.get('shipping'), createdItem.Shipping_Handling__c);
        System.assertEquals(lineItem.get('departmentClassCode'), createdItem.Department_Class_Code__c);
        System.assertEquals(lineItem.get('isVirtualWarehouseItem'), createdItem.Is_virtual_Warehouse_Item__c);
        System.assertEquals(lineItem.get('originalCost'), createdItem.Original_Cost__c);
        System.assertEquals(lineItem.get('productCategorycode'), createdItem.Product_Category_Code__c);
        System.assertEquals(lineItem.get('productCategoryDescription'), createdItem.Product_Category_Description__c);
        System.assertEquals(lineItem.get('subClassCode'), createdItem.Subclass_Code__c);
        System.assertEquals(lineItem.get('webAvailabilityCode'), createdItem.Web_Availability_Code__c);
        System.assertEquals(lineItem.get('QuoteId'), createdItem.QuoteId);
        System.assertEquals(lineItem.get('vendorManufacturerName'), createdItem.Vendor_Manufacturer_Name__c);
        System.assertEquals(lineItem.get('odSkuNumber'), createdItem.OD_Item_Number__c);
        System.assertEquals(lineItem.get('maxListPrice'), createdItem.List_Price__c);
        System.assertEquals(lineItem.get('mfgPartNumber'), createdItem.Mfg_Part_Number__c);
        System.assertEquals(lineItem.get('supplierPartNumber'), createdItem.Vendor_Part_Number__c);
        System.assertEquals(lineItem.get('itemDescription'), createdItem.Description);
        System.assertEquals(lineItem.get('customerPrice'), createdItem.UnitPrice);
        System.assertEquals(lineItem.get('upcCode'), createdItem.UPC__c);
        System.assertEquals(lineItem.get('supplierName'), createdItem.Vendor_Name__c);
        System.assertEquals(lineItem.get('quantity'), createdItem.Quantity);
        System.assertEquals(lineItem.get('adjustedCost'), createdItem.Cost__c);
        System.assertEquals(lineItem.get('itemDescription'), createdItem.Supplier_Item_Description__c);
        System.assertEquals(lineItem.get('vendorNumber'), createdItem.Vendor_Number__c);
        System.assertEquals(prod.Id, createdItem.Product2Id);
        System.assertEquals(entry.Id, createdItem.PricebookEntryId);
    }

    @IsTest
    public static void checkQuoteStatusDraft()
    {
        Quote q = [SELECT Id, Status FROM Quote WHERE Name = 'TestQuote1'];
        System.assertEquals(false, EndlessAisleScratchPad.isQuoteLocked(q.Id));
    }

    @IsTest
    public static void checkQuoteStatusCompleted()
    {
        Quote q = [SELECT Id, Status FROM Quote WHERE Name = 'TestQuote3'];
        System.assertEquals(true, EndlessAisleScratchPad.isQuoteLocked(q.Id));
    }

    @IsTest
    public static void checkCorrectAopsCustId()
    {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];

        Test.startTest();
        System.assertEquals(EndlessAisleScratchPad.getAopsCustIdFromQuote(q.Id), '1');
        Test.stopTest();
    }

    @IsTest
    public static void chcekGetQuoteTaxAmount()
    {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        Decimal estimatedTax = 1.0;
        List<Map<String, Object>> lineItems = generateLineItems(1, q.Id);
        EndlessAisleScratchPad.saveScratchPadUpdates(q.Id, null, lineItems, estimatedTax,0);

        Test.startTest();
        System.assertEquals(EndlessAisleScratchPad.getQuoteTaxAmount(q.Id), 1);
        Test.stopTest();
    }

    @IsTest
    public static void checkGetSomeManufacturers()
    {
        Test.startTest();
        System.assertEquals(EndlessAisleScratchPad.getManufacturers('m1').size(), 1);
        Test.stopTest();
    }

    @IsTest
    public static void checkGetNoManufacturers()
    {
        Test.startTest();
        System.assertEquals(EndlessAisleScratchPad.getManufacturers('asd').size(), 0);
        Test.stopTest();
	}
	
	@IsTest
	static void testGetUnitOfMeasure1()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'unitOfMeasure' => ''
		};
		Test.startTest();
		String unitOfMeasure = EndlessAisleScratchPad.getUnitOfMeasure(item);
		Test.stopTest();
		System.assertEquals(unitOfMeasure, 'EA');
	}
	
	@IsTest
	static void testGetUnitOfMeasure2()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'unitOfMeasure' => null
		};
		Test.startTest();
		String unitOfMeasure = EndlessAisleScratchPad.getUnitOfMeasure(item);
		Test.stopTest();
		System.assertEquals(unitOfMeasure, 'EA');
	}
	
	@IsTest
	static void testGetUnitOfMeasure3()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'unitOfMeasure' => 'Pack'
		};
		Test.startTest();
		String unitOfMeasure = EndlessAisleScratchPad.getUnitOfMeasure(item);
		Test.stopTest();
		System.assertEquals(unitOfMeasure, 'EA');
	}
	
	@IsTest
	static void testGetPackageSize1()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'packageSize' => 0.05
		};
		Test.startTest();
		Decimal packageSize = EndlessAisleScratchPad.getPackageSize(item);
		Test.stopTest();
		System.assertEquals(packageSize, 1);
	}
	
	@IsTest
	static void testGetPackageSize2()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'packageSize' => null
		};
		Test.startTest();
		Decimal packageSize = EndlessAisleScratchPad.getPackageSize(item);
		Test.stopTest();
		System.assertEquals(packageSize, 1);
	}
	
	@IsTest
	static void testGetPackageSize3()
	{
		Map<String, Object> item = new Map<String, Object>
		{
			'packageSize' => 2
		};
		Test.startTest();
		Decimal packageSize = EndlessAisleScratchPad.getPackageSize(item);
		Test.stopTest();
		System.assertEquals(packageSize, 1);
	}
}