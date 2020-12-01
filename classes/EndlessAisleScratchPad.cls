public without sharing class EndlessAisleScratchPad
{
    private static Boolean MANUFACTURERS_CACHE_ENABLED = true;
    private static Boolean MANUFACTURERS_CACHED = false;
    private static String MANUFACTURERS_CACHE_PARTITION = 'EndlessAisleManufacturers';
	private static Integer MANUFACTURERS_RESPONSE_AMOUNT = 5;
	private static String DEFAULT_UNIT_OF_MEASURE = 'EA';
	private static Decimal DEFAULT_PACKAGE_SIZE = 1;

    /**
    * Saves the current state of the scratch pad. This includes updating the quote notes,
    * deleting line items that are no longer there, and adding line items that have been added.
    */
    @AuraEnabled
    public static void saveScratchPadUpdates(String quoteId, String customerNotes, List<Map<String,Object>> lineItems, Decimal estimatedTax, Decimal shipping)
    {
        Savepoint sp = Database.setSavepoint();
        try
        {
            updateQuoteStatus(quoteId);
            updateQuoteNotes(quoteId, customerNotes);
            updateQuoteEstimatedTax(quoteId, estimatedTax);
            updateQuoteShipping(quoteId, shipping);
        }
        catch(Exception e)
        {
            System.debug(e.getStackTraceString());
            Database.rollback(sp);
            throw new AuraHandledException('An error ocurred while updating the Quote: ' + e.getMessage());
        }

        try
        {
            deleteQuoteLineItemsNoLongerInScratchPad(quoteId, lineItems);
            updateQuoteLineItems(quoteId, lineItems);
        }
        catch(Exception e)
        {
            System.debug(e.getStackTraceString());
            Database.rollback(sp);
            throw new AuraHandledException('An error ocurred while saving the Quote Line Items: ' + e.getMessage());
        }
    }
    /**
    * Helper for saveScratchPadUpdates.
    */
    private static void updateQuoteShipping(String quoteId, Decimal shipping)
    {
        Quote q = [SELECT Id, ShippingHandling FROM Quote WHERE Id =: quoteId];
        q.ShippingHandling = shipping;
        update q;
    }

    /**
    * Helper for saveScratchPadUpdates.
    */
    private static void updateQuoteNotes(String quoteId, String customerNotes)
    {
        Quote q = [SELECT Id, Notes_To_Customer__c FROM Quote WHERE Id =: quoteId];
        q.Notes_To_Customer__c = customerNotes;
        update q;
    }

    private static void updateQuoteStatus(String quoteId)
    {
        Quote q = [SELECT Id, Status FROM Quote WHERE Id = :quoteId];
        q.Status = 'Draft';
        update q;
    }

    /**
    * Updates the Estimated Tax field on the quote.
    */
    private static void updateQuoteEstimatedTax(String quoteId, Decimal estimatedTax)
    {
        Quote q = [SELECT Id, Tax FROM Quote WHERE Id =: quoteId];
        q.Tax = estimatedTax;
        update q;
    }

    /**
    * Helper for saveScratchPadUpdates.
    * Given a Quote SFDC ID and an updated list of its line items,
    * deletes any line items that are no longer in the list.
    */
    private static void deleteQuoteLineItemsNoLongerInScratchPad(String quoteId, List<Map<String, Object>> scratchPadLineItems)
    {
        List<QuoteLineItem> existingLineItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId =: quoteId];
        List<QuoteLineItem> lineItemsNoLongerInScratchPad = getLineItemsNotInScratchPad(existingLineItems, scratchPadLineItems);
        delete lineItemsNoLongerInScratchPad;
    }

    /**
    * Helper for deleteQuoteLineItemsNoLongerInScratchPad.
    * Given a list of line items currently on the quote and a list of line items
    * from the scratch pad, returns which line items are no longer in the scratch pad.
    */
    private static List<QuoteLineItem> getLineItemsNotInScratchPad(List<QuoteLineItem> existingLineItems, List<Map<String, Object>> scratchPadLineItems)
    {
        List<QuoteLineItem> lineItemsNotInScratchPad = new List<QuoteLineItem>();
        for(QuoteLineItem existingLineItem : existingLineItems) {
            if(!lineItemInScratchPad(scratchPadLineItems, existingLineItem)) {
                lineItemsNotInScratchPad.add(existingLineItem);
            }
        }
        return lineItemsNotInScratchPad;
    }

    /**
    * Helper for getLineItemsNotInScratchPad.
    * Given a list of scratch pad line items and a single line
    * item, checks if the single item is in the scratch pad.
    */
    private static Boolean lineItemInScratchPad(List<Map<String, Object>> scratchPadLineItems, QuoteLineItem lineItem)
    {
        for(Map<String, Object> scratchPadLineItem : scratchPadLineItems) {
            if(scratchPadLineItem.get('quoteLineItemId') == (String) lineItem.Id) {
                return true;
            }
        }
        return false;
	}
	
	@TestVisible
	private static String getUnitOfMeasure(Map<String, Object> item)
	{
        String odSkuNumber = (String) item?.get('odSkuNumber');    
        String unitOfMeasure = (String) item?.get('unitOfMeasure');
        if (String.isBlank(odSkuNumber) || String.isBlank(unitOfMeasure)) 
            return DEFAULT_UNIT_OF_MEASURE;
        else 
            return unitOfMeasure;
	}

	@TestVisible
	private static Decimal getPackageSize(Map<String, Object> item)
	{
        String odSkuNumber = (String) item?.get('odSkuNumber');    
        Decimal packageSize = (Decimal) item?.get('packageSize');
        if (String.isBlank(odSkuNumber) || packageSize == null || packageSize < 1) 
            return DEFAULT_PACKAGE_SIZE;
        else 
            return packageSize;
	}

    /**
    * Helper for saveScratchPadUpdates.
    * Given a quote SFDC ID and a list of line items, upserts the line items.
    * When inserts are necessary, creates a corresponding product and pricebook entry as well.
    */
    private static void updateQuoteLineItems(String quoteId, List<Map<String, Object>> items)
    {
        List<QuoteLineItem> updated_items = new List<QuoteLineItem>();
        for (Map<String, Object> item : items)
        {
            Id      quoteLineItemId             = item.containsKey('quoteLineItemId')               ? (Id)      item.get('quoteLineItemId')             : null;
            String  vendorManufacturerName      = item.containsKey('vendorManufacturerName')        ? (String)  item.get('vendorManufacturerName')      : null;
            String  odItemNumber                = item.containsKey('odSkuNumber')                   ? (String)  item.get('odSkuNumber')                 : null;
            Decimal maxListPrice                = item.containsKey('maxListPrice')                  ? (Decimal) item.get('maxListPrice')                : null;
            String  manufacturerPartNumber      = item.containsKey('mfgPartNumber')                 ? (String)  item.get('mfgPartNumber')               : null;
            String  vendorPartNumber            = item.containsKey('supplierPartNumber')            ? (String)  item.get('supplierPartNumber')          : null;
            String  lineItemDescription         = item.containsKey('itemDescription')               ? (String)  item.get('itemDescription')             : null;
            Decimal customerPrice               = item.containsKey('customerPrice')                 ? (Decimal) item.get('customerPrice')               : null;
            String  upc                         = item.containsKey('upcCode')                       ? (String)  item.get('upcCode')                     : null;
            String  vendorName                  = item.containsKey('supplierName')                  ? (String)  item.get('supplierName')                : null;
            Decimal cost                        = item.containsKey('adjustedCost')                  ? (Decimal) item.get('adjustedCost')                : null;
            String  supplierItemDescription     = item.containsKey('itemDescription')               ? (String)  item.get('itemDescription')             : null;
            String  vendorNumber                = item.containsKey('vendorNumber')                  ? (String)  item.get('vendorNumber')                : null;
            Decimal shipping                    = item.containsKey('shipping')                      ? (Decimal) item.get('shipping')                    : null;
            String  vendorQuoteNumber           = item.containsKey('vendorQuoteNumber')             ? (String)  item.get('vendorQuoteNumber')           : null;
            String  Catalogue                   = item.containsKey('Catalogue')                     ? (String)  item.get('Catalogue')                   : null;
            String  departmentClassCode         = item.containsKey('departmentClassCode')           ? (String)  item.get('departmentClassCode')         : null;
            Boolean isVirtualWarehouseItem      = item.containsKey('isVirtualWarehouseItem')        ? (Boolean) item.get('isVirtualWarehouseItem')      : null;
            Decimal originalCost                = item.containsKey('originalCost')                  ? (Decimal) item.get('originalCost')                : null;
            String  productCategorycode         = item.containsKey('productCategorycode')           ? (String)  item.get('productCategorycode')         : null;
            String  productCategoryDescription  = item.containsKey('productCategoryDescription')    ? (String)  item.get('productCategoryDescription')  : null;
            String  webAvailabilityCode         = item.containsKey('webAvailabilityCode')           ? (String)  item.get('webAvailabilityCode')         : null;
            String  subClassCode                = item.containsKey('subClassCode')                  ? (String)  item.get('subClassCode')                : null;
            String  vendorManufacturerId        = item.containsKey('vendorManufacturerId')          ? (String)  item.get('vendorManufacturerId')        : null;
            String  odManufacturerName          = item.containsKey('odManufacturerName')            ? (String)  item.get('odManufacturerName')          : null;
            String  odManufacturerId            = item.containsKey('odManufacturerId')              ? (String)  item.get('odManufacturerId')            : null;
            String  itemType                    = item.containsKey('itemType')                      ? (String)  item.get('itemType')                    : null;
            Integer quantity                    = item.containsKey('quantity') && (Decimal)item.get('quantity') != null ? ((Decimal)item.get('quantity')).intValue() : null;
            Integer lineNumber                  = item.containsKey('lineNumber') && (Decimal)item.get('lineNumber') != null ? ((Decimal)item.get('lineNumber')).intValue() : null;
            String  unitOfMeasure               = getUnitOfMeasure(item);
            Decimal packageSize                 = getPackageSize(item);

            if (isVirtualWarehouseItem == null)
            {
                isVirtualWarehouseItem = false;
            }

            List<QuoteLineItem> updated_item = [SELECT Id FROM QuoteLineItem WHERE Id = :quoteLineItemId];

            // If the line item does not already exist.
            if (updated_item.size() == 0)
            {
                insertQuoteLineItem(quoteId,                    vendorManufacturerName, odItemNumber,
                                    maxListPrice,               manufacturerPartNumber, vendorPartNumber,
                                    lineItemDescription,        customerPrice,          upc,
                                    vendorName,                 quantity,               cost,
                                    supplierItemDescription,    vendorNumber,           shipping,
                                    vendorQuoteNumber,          Catalogue,              departmentClassCode,
                                    isVirtualWarehouseItem,     originalCost,           productCategorycode,
                                    productCategoryDescription, webAvailabilityCode,    subClassCode,
                                    unitOfMeasure,              packageSize,            vendorManufacturerId,
                                    lineNumber,                 odManufacturerName,     odManufacturerId,
                                    itemType);
            }
            // If the line item already exists.
            else if (updated_item.size() > 0)
            {
                QuoteLineItem real_updated_item                     = updated_item.get(0);

                real_updated_item.Vendor_Quote_Number__c            = vendorQuoteNumber;
                real_updated_item.Shipping_Handling__c              = shipping;
                real_updated_item.Original_Cost__c                  = originalCost;
                real_updated_item.Vendor_Manufacturer_Name__c       = vendorManufacturerName;
                real_updated_item.List_Price__c                     = maxListPrice;
                real_updated_item.Mfg_Part_Number__c                = manufacturerPartNumber;
                real_updated_item.Vendor_Part_Number__c             = vendorPartNumber;
                real_updated_item.Description                       = lineItemDescription;
                real_updated_item.UnitPrice                         = customerPrice;
                real_updated_item.Vendor_Name__c                    = vendorName;
                real_updated_item.Quantity                          = quantity;
                real_updated_item.Cost__c                           = cost;
                real_updated_item.Supplier_Item_Description__c      = supplierItemDescription;
                real_updated_item.Vendor_Number__c                  = vendorNumber;
                real_updated_item.Shipping_Handling__c              = shipping;
                real_updated_item.Catalogue__c                      = Catalogue;
                real_updated_item.Department_Class_Code__c          = departmentClassCode;
                real_updated_item.Is_virtual_Warehouse_Item__c      = isVirtualWarehouseItem;
                real_updated_item.Product_Category_Code__c          = productCategorycode;
                real_updated_item.Product_Category_Description__c   = productCategoryDescription;
                real_updated_item.Subclass_Code__c                  = subClassCode;
                real_updated_item.Unit_of_Measure__c                = unitOfMeasure;
                real_updated_item.Package_Size__c                   = packageSize;
                real_updated_item.Vendor_Manufacturer_ID__c         = vendorManufacturerId;
                real_updated_item.Line_Number__c                    = lineNumber;
                real_updated_item.OD_Manufacturer_Name__c           = odManufacturerName;
                real_updated_item.OD_Manufacturer_Id__c             = odManufacturerId;
                real_updated_item.Item_Type__c                      = itemType;
    
                updated_items.add(real_updated_item);
            }
        }
        update updated_items;
    }

    /**
    * Helper for updateQuoteLineItems.
    * Inserts a new quote line item, and a corresponding product and pricebook entry.
    */
    public static void insertQuoteLineItem(
            String quoteId,
            String vendorManufacturerName,
            String odItemNumber,
            Decimal maxListPrice,
            String manufacturerPartNumber,
            String vendorPartNumber,
            String lineItemDescription,
            Decimal salesPrice,
            String upc,
            String vendorName,
            Integer quantity,
            Decimal cost,
            String supplierItemDescription,
            String vendorNumber,
            Decimal shipping,
            String vendorQuoteNumber,
            String Catalogue,
            String departmentClassCode,
            Boolean isVirtualWarehouseItem,
            Decimal originalCost,
            String productCategorycode,
            String productCategoryDescription,
            String webAvailabilityCode,
            String subClassCode,
            String unitOfMeasure,
            Decimal packageSize,
            String vendorManufacturerId,
            Integer lineNumber,
            String odManufacturerName,
            String odManufacturerId,
            String itemType)
    {
        // Inserts and returns a new product.
        Product2 prod = getProduct(lineItemDescription, manufacturerPartNumber);
        // Inserts and returns a new pricebook entry.
        PriceBookEntry price_book_entry = getPriceBookEntry(prod.Id, salesPrice);

        QuoteLineItem new_quote_line_item = new QuoteLineItem
            (
                Vendor_Quote_Number__c          = vendorQuoteNumber,
                Catalogue__c                    = Catalogue,
                Shipping_Handling__c            = shipping,
                Department_Class_Code__c        = departmentClassCode,
                Is_virtual_Warehouse_Item__c    = isVirtualWarehouseItem,
                Original_Cost__c                = originalCost,
                Product_Category_Code__c        = productCategorycode,
                Product_Category_Description__c = productCategoryDescription,
                Subclass_Code__c                = subClassCode,
                Web_Availability_Code__c        = webAvailabilityCode,
                QuoteId                         = quoteId,
                PricebookEntryId                = price_book_entry.Id,
                Product2Id                      = prod.Id,
                Vendor_Manufacturer_Name__c     = vendorManufacturerName,
                OD_Item_Number__c               = odItemNumber,
                List_Price__c                   = maxListPrice,
                Mfg_Part_Number__c              = manufacturerPartNumber,
                Vendor_Part_Number__c           = vendorPartNumber,
                Description                     = lineItemDescription,
                UnitPrice                       = salesPrice,
                UPC__c                          = upc,
                Vendor_Name__c                  = vendorName,
                Quantity                        = quantity,
                Cost__c                         = cost,
                Supplier_Item_Description__c    = supplierItemDescription,
                Vendor_Number__c                = vendorNumber,
                Unit_of_Measure__c              = unitOfMeasure,
                Package_Size__c                 = packageSize,
                Vendor_Manufacturer_ID__c       = vendorManufacturerId,
                Line_Number__c                  = lineNumber,
                OD_Manufacturer_Name__c         = odManufacturerName,
                OD_Manufacturer_ID__c           = odManufacturerId,
                Item_Type__c                    = itemType);
        insert new_quote_line_item;
    }

    /**
    * Helper for insertQuoteLineItem.
    * Inserts and returns a new Product.
    */
    private static Product2 getProduct(String productName, String manufacturerPartNumber)
    {
        Product2 prod = new Product2(
            Name = productName,
            Manufacturer_Part_Number__c = manufacturerPartNumber,
            IsActive = true
        );
        insert prod;
        return prod;
    }

    /**
    * Helper for insertQuoteLineItem.
    * Inserts and returns a new Pricebook Entry.
    */
    private static PriceBookEntry getPriceBookEntry(Id productId, Decimal salesPrice)
    {
        // When running a test, the standard pricebook ID must be retrieved using
        // the Test utility method. Otherwise, it is retrieved through a query.
        Id price_book_id;
        if (Test.isRunningTest())
        {
            price_book_id = Test.getStandardPricebookId();
        }
        else
        {
            Pricebook2 price_book = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
            price_book_id = price_book.Id;
        }

        PriceBookEntry price_book_entry = new PriceBookEntry
                                            (
            Pricebook2Id        = price_book_id,
            UnitPrice           = salesPrice,
            Product2Id          = productId,
            UseStandardPrice    = false,
            IsActive            = true
                                            );
        insert price_book_entry;

        return price_book_entry;
    }
    
    // @AuraEnabled
    // public static List<Map<String, Object>> getQuoteLineItems(String quoteId)
    // {
    //  List<QuoteLineItem> quote_line_items = [SELECT Vendor_Quote_Number__c,
    //                                                  Id,
    //                                                  Catalogue__c,
    //                                                  Shipping_Handling__c,
    //                                                  Department_Class_Code__c,
    //                                                  Is_virtual_Warehouse_Item__c,
    //                                                  Original_Cost__c,
    //                                                  Product_Category_Code__c,
    //                                                  Product_Category_Description__c,
    //                                                  Subclass_Code__c,
    //                                                  Web_Availability_Code__c,
    //                                                  QuoteId,
    //                                                  PricebookEntryId,
    //                                                  Product2Id,
    //                                                  Vendor_Manufacturer_Name__c,
    //                                                  OD_Item_Number__c,
    //                                                  List_Price__c,
    //                                                  Mfg_Part_Number__c,
    //                                                  Vendor_Part_Number__c,
    //                                                  Description,
    //                                                  UnitPrice,
    //                                                  UPC__c,
    //                                                  Vendor_Name__c,
    //                                                  Quantity,
    //                                                  Cost__c,
    //                                                  Supplier_Item_Description__c,
    //                                                  Vendor_Number__c,
    //                                                  Unit_of_Measure__c,
    //                                                  Package_Size__c,
    //                                                  Manufacturer_ID__c,
    //                                                  Line_Number__c,
    //                                                  OD_Manufacturer_Name__c,
    //                                                  OD_Manufacturer_Id__c,
    //                                                  Vendor_Manufacturer_Id__c,
    //                                                  Item_Type__c
    //                                                  FROM QuoteLineItem
    //                                                  WHERE QuoteId = :quoteId];
    //  List<Map<String, Object>> responses = new List<Map<String, Object>>();

    //  for (QuoteLineItem quote_line_item : quote_line_items)
    //  {
    //      String key                              = 'searchKey';
    //      String value                            = 'supplier_vpn=' + quote_line_item.Vendor_Part_Number__c;
    //      Map<String, Object> params              = new Map<String, Object>();
    //      Map<String, Object> line_item           = new Map<String, Object>();

    //      // First add the data that we saved on the Quote Line Item that we dont get
    //      // from the product search service.
    //      line_item = getQuoteLineItemData(quote_line_item);

    //      // Prepare the parameters to use for the product search service.
    //      // We are searching for each product by its supplier part number.
    //      params.put(key, value);

    //      if (quote_line_item.Vendor_Part_Number__c != null)
    //      {
    //          // Get the product details from the search service
    //          ProductSearchServiceRequest.ProductSearchResult product_details = ProductSearchServiceRequest.MainCallOut(params);

    //          if (product_details != null)
    //          {
    //              // If this product exists in the search service, then use the results data (suppliers)
    //              line_item.put('results', product_details.product_list.get(0).results);
    //          }
    //      }
    //      responses.add(line_item);
    //  }
    //  return responses;
    // }
    
    @AuraEnabled
    public static String getQuoteLineItems(String quoteId)
    {
        List<QuoteLineItem> quote_line_items = [SELECT Vendor_Quote_Number__c,
                                                        Id,
                                                        Catalogue__c,
                                                        Shipping_Handling__c,
                                                        Department_Class_Code__c,
                                                        Is_virtual_Warehouse_Item__c,
                                                        Original_Cost__c,
                                                        Product_Category_Code__c,
                                                        Product_Category_Description__c,
                                                        Subclass_Code__c,
                                                        Web_Availability_Code__c,
                                                        QuoteId,
                                                        PricebookEntryId,
                                                        Product2Id,
                                                        Vendor_Manufacturer_Name__c,
                                                        OD_Item_Number__c,
                                                        List_Price__c,
                                                        Mfg_Part_Number__c,
                                                        Vendor_Part_Number__c,
                                                        Description,
                                                        UnitPrice,
                                                        UPC__c,
                                                        Vendor_Name__c,
                                                        Quantity,
                                                        Cost__c,
                                                        Supplier_Item_Description__c,
                                                        Vendor_Number__c,
                                                        Unit_of_Measure__c,
                                                        Package_Size__c,
                                                        Manufacturer_ID__c,
                                                        Line_Number__c,
                                                        OD_Manufacturer_Name__c,
                                                        OD_Manufacturer_Id__c,
                                                        Vendor_Manufacturer_Id__c,
                                                        Item_Type__c
                                                        FROM QuoteLineItem
                                                        WHERE QuoteId = :quoteId];
        List<Map<String, Object>> responses = new List<Map<String, Object>>();

        for (QuoteLineItem quote_line_item : quote_line_items)
        {
            String key                              = 'searchKey';
            String value                            = 'supplier_vpn=' + quote_line_item.Vendor_Part_Number__c;
            Map<String, Object> params              = new Map<String, Object>();
            Map<String, Object> line_item           = new Map<String, Object>();

            // First add the data that we saved on the Quote Line Item that we dont get
            // from the product search service.
            line_item = getQuoteLineItemData(quote_line_item);

            // Prepare the parameters to use for the product search service.
            // We are searching for each product by its supplier part number.
            params.put(key, value);

            if (quote_line_item.Vendor_Part_Number__c != null)
            {
                // Get the product details from the search service
                ProductSearchServiceRequest.ProductSearchResult product_details = ProductSearchServiceRequest.MainCallOut(params);

                if (product_details != null)
                {
                    // If this product exists in the search service, then use the results data (suppliers)
                    line_item.put('results', product_details.product_list.get(0).results);
                }
            }
            responses.add(line_item);
        }
        return JSON.serialize(responses);
    }

    private static Map<String, Object> getQuoteLineItemData(QuoteLineItem lineItem)
    {
        Map<String, Object> formattedMap = new Map<String,Object>();

        formattedMap.put('quoteLineItemId',         lineItem.Id != null                                     ? lineItem.Id : null);
        formattedMap.put('vendorManufacturerName',  lineItem.Vendor_Manufacturer_Name__c != null            ? lineItem.Vendor_Manufacturer_Name__c : null);
        formattedMap.put('odSkuNumber',             lineItem.OD_Item_Number__c != null                      ? lineItem.OD_Item_Number__c : null);
        formattedMap.put('maxListPrice',            lineItem.List_Price__c != null                          ? lineItem.List_Price__c : null);
        formattedMap.put('mfgPartNumber',           lineItem.MFG_Part_Number__c != null                     ? lineItem.MFG_Part_Number__c : null);
        formattedMap.put('supplierPartNumber',      lineItem.Vendor_Part_Number__c != null                  ? lineItem.Vendor_Part_Number__c : null);
        formattedMap.put('itemDescription',         lineItem.Description != null                            ? lineItem.Description : null);
        formattedMap.put('customerPrice',           lineItem.UnitPrice != null                              ? lineItem.UnitPrice : null);
        formattedMap.put('upcCode',                 lineItem.UPC__c != null                                 ? lineItem.UPC__c : null);
        formattedMap.put('supplierName',            lineItem.Vendor_Name__c != null                         ? lineItem.Vendor_Name__c : null);
        formattedMap.put('quantity',                lineItem.Quantity != null                               ? lineItem.Quantity : null);
        formattedMap.put('adjustedCost',            lineItem.Cost__c != null                                ? lineItem.Cost__c : null);
        formattedMap.put('vendorNumber',            lineItem.Vendor_Number__c != null                       ? lineItem.Vendor_Number__c : null);
        formattedMap.put('shipping',                lineItem.Shipping_Handling__c != null                   ? lineItem.Shipping_Handling__c : null);
        formattedMap.put('vendorQuoteNumber',       lineItem.Vendor_Quote_Number__c != null                 ? lineItem.Vendor_Quote_Number__c : null);
        formattedMap.put('Catalogue',               lineItem.Catalogue__c != null                           ? lineItem.Catalogue__c : null);
        formattedMap.put('departmentClassCode',     lineItem.Department_Class_Code__c != null               ? lineItem.Department_Class_Code__c : null);
        formattedMap.put('isVirtualWarehouseItem',  lineItem.Is_virtual_Warehouse_Item__c != null           ? lineItem.Is_virtual_Warehouse_Item__c : null);
        formattedMap.put('originalCost',            lineItem.Original_Cost__c != null                       ? lineItem.Original_Cost__c : null);
        formattedMap.put('productCategorycode',     lineItem.Product_Category_Code__c != null               ? lineItem.Product_Category_Code__c : null);
        formattedMap.put('productCategoryDescription',  lineItem.Product_Category_Description__c != null    ? lineItem.Product_Category_Description__c : null);
        formattedMap.put('webAvailabilityCode',     lineItem.Web_Availability_Code__c != null               ? lineItem.Web_Availability_Code__c : null);
        formattedMap.put('subClassCode',            lineItem.Subclass_Code__c != null                       ? lineItem.Subclass_Code__c : null);
        formattedMap.put('unitOfMeasure',           lineItem.Unit_of_Measure__c != null                     ? lineItem.Unit_of_Measure__c : null);
        formattedMap.put('packageSize',             lineItem.Package_Size__c != null                        ? lineItem.Package_Size__c : null);
        formattedMap.put('vendorManufacturerId',    lineItem.Vendor_Manufacturer_Id__c != null              ? lineItem.Vendor_Manufacturer_Id__c : null);
        formattedMap.put('lineNumber',              lineItem.Line_Number__c != null                         ? lineItem.Line_Number__c : null);
        formattedMap.put('vendorManufacturer',      lineItem.Vendor_Manufacturer_Name__c != null            ? lineItem.Vendor_Manufacturer_Name__c : null);
        formattedMap.put('odManufacturerName',      lineItem.OD_Manufacturer_Name__c != null                ? lineItem.OD_Manufacturer_Name__c : null);
        formattedMap.put('odManufacturer',          lineItem.OD_Manufacturer_Name__c != null                ? lineItem.OD_Manufacturer_Name__c : null);
        formattedMap.put('odManufacturerId',        lineItem.OD_Manufacturer_Id__c != null                  ? lineItem.OD_Manufacturer_Id__c : null);
        formattedMap.put('itemType',                lineItem.Item_Type__c != null                           ? lineItem.Item_Type__c : null);

        return formattedMap;
    }

    @AuraEnabled
    public static String getQuoteNotesToCustomer(String quoteId)
    {
        try
        {
            Quote q = [SELECT Id, Notes_To_Customer__c FROM Quote WHERE Id =: quoteId];
            return q.Notes_To_Customer__c;
        }
        catch(Exception e)
        {
            throw new AuraHandledException('An error ocurred while retrieving the Quote: ' + e.getMessage());
        }
    }

    /**
     * Returns whether the Quote's status is Completed or not.
     */
    @AuraEnabled
    public static Boolean isQuoteLocked(String quoteId)
    {
        try
        {
            Quote q = [SELECT Id, Status FROM Quote WHERE Id = :quoteId];
            List<Order_Header__c> orders = [SELECT Id FROM Order_Header__c WHERE Quote_Id__c = :quoteId];

            if (q.Status != 'Draft' || orders.size() > 0)
            {
                return true;
            }

            return false;
        }
        catch (Exception e)
        {
            throw new AuraHandledException('An error ocurred while retrieving the Quote\'s status: ' + e.getMessage());
        }
    }

    /**
     * Retrieves the AOPS_CUST_ID__c of the Account the Quote is related to.
     */
    @AuraEnabled
    public static string getAopsCustIdFromQuote(String quoteId)
    {
        try {
            Quote q = [SELECT Id, AccountId FROM Quote WHERE Id = :quoteId];
            Account a = [SELECT Id, Aops_Cust_Id__c FROM Account WHERE Id = :q.AccountId];
            return a.Aops_Cust_Id__c;
        } catch (Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the Quote\'s AOPS Cust Id: ' + e.getMessage());
        }
    }

    /**
     * Gets the Contract Price (calls a service) of the item item based on the account with the aops id of aopsCustId.
     * item must have keys 'odSkuNumber' and 'quantity' with proper values.
     */
    @AuraEnabled
    public static Decimal getContractPrice(String aopsCustId, Map<String, Object> item)
    {
        if (item.containsKey('odSkuNumber') && item.containsKey('quantity') && String.isNotEmpty(aopsCustId))
        {
            String sku = (String)item.get('odSkuNumber');
            Decimal quantity = (Decimal)item.get('quantity');
            
            try {
                xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element response = pricecalc.doPriceCheck(aopsCustId, '', '', '', sku, String.valueOf(quantity));
                Decimal contractPrice = Decimal.valueOf(response.SELLING_PRICE);
                return contractPrice;
            }
            catch (Exception e)
            {
                throw new AuraHandledException('An error ocurred while retrieving the item\'s contract price: ' + e.getMessage());
            }
        }
        return null;
    }

    /**
     * Returns the tax dollar amount stored on the Quote.
     */
    @AuraEnabled
    public static Decimal getQuoteTaxAmount(String quoteId)
    {
        try {
            Quote q = [SELECT Id, Tax FROM Quote WHERE Id = :quoteId];
            return q.Tax;
        } catch (Exception e) {
            throw new AuraHandledException('An error ocurred while retrieving the Quote\'s status: ' + e.getMessage());
        }
    }

    /**
    * Returns a list of manufacturers pickable from the Scratchpad Line Items.
    */
    @AuraEnabled
    public static List<Map<String, Object>> getManufacturers(String name)
    {
        try
        {
            if (MANUFACTURERS_CACHE_ENABLED)
            {
                if (MANUFACTURERS_CACHED && Cache.Session.contains('local.' + MANUFACTURERS_CACHE_PARTITION + '.manufacturers'))
                {
                    return (List<Map<String, Object>>) Cache.Session.get('local.' + MANUFACTURERS_CACHE_PARTITION + '.manufacturers');
                }
    
                List<Map<String, Object>> manufacturers = findManufacturers(name);
                Cache.Session.put('local.' + MANUFACTURERS_CACHE_PARTITION + '.manufacturers', manufacturers);
                return manufacturers;
            }
    
            return findManufacturers(name);
        }
        catch (cache.Session.SessionCacheException ex)
        {
            return findManufacturers(name);
        }
    }

    /**
    * Retrieves a formatted list of manufacturer maps.
    */
    private static List<Map<String, Object>> findManufacturers(String name)
    {
        List<Tech_Sales_Manufacturer__c> rawManufacturers = queryManufacturersLike(name);
        List<Map<String, Object>> manufacturers = new List<Map<String,Object>>();

        for (Tech_Sales_Manufacturer__c rawManufacturer : rawManufacturers)
        {
            Map<String, Object> manufacturer = new Map<String, Object>{'id' => String.valueOf(rawManufacturer.Manufacturer_Id__c), 'name' => rawManufacturer.Name};
            manufacturers.add(manufacturer);
        }

        return manufacturers;
    }

    /**
    * Retrieves a list of manufacturers. Raw from a query.
    */
    private static List<Tech_Sales_Manufacturer__c> queryManufacturersLike(String name)
    {
        String searchTerm = '%' + name + '%';
        List<Tech_Sales_Manufacturer__c> manufacturers = [SELECT Manufacturer_Id__c, Name FROM Tech_Sales_Manufacturer__c WHERE Name LIKE :searchTerm LIMIT :MANUFACTURERS_RESPONSE_AMOUNT];
        return manufacturers;
    }
}