public with sharing class OrderCreation {
    
    @AuraEnabled(cacheable=true)
    public static QuoteOrderInfo getQuoteOrderInfo(String quoteId) {
     
        QuoteOrderInfo qOrder = new QuoteOrderInfo();
        
        QuoteHeader qHeader = new QuoteHeader();
        
        try {
            qHeader = getQuoteHeader(quoteId);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            throw new AuraHandledException('An unexpected error occured. \n' + e.getMessage());
        }

        qOrder.quoteHeader = qHeader;
        
        List<CustomerOrder> orderList = new List<CustomerOrder>();
        

        try {
            orderList = getCustomerOrderList(quoteId);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            throw new AuraHandledException('An unexpected error occured. \n' + e.getMessage());
        }

        populateQuoteHeaderInfoIntoOrders(qHeader, orderList);
        calculateOrderShippingHandle(orderList);
        calculateOrderTotalCost(orderList);
        calculateOrderTotalPrice(orderList);
        populateMetadataSettings(qOrder);
        //populateVendorEDIFlags(orderList);
        populateVendorInfo(orderList);
        populateExistingAopsOrderNumbers(orderList);
        populateSoftheaderinfo(qHeader.accountId, orderList);

        if (orderList == null || orderList.size() == 0) {
            qOrder.errorMessage = 'There are no orders available.';                
            qOrder.isErrorExist = true;
        } else if (doAllOrdersExistAlready(orderList)) {
            qOrder.errorMessage = 'The following Sub-order requests were already placed. Please see the list of orders on the quote page.';                
            qOrder.isErrorExist = true;
        } else if(!isQuoteApprovedByCustomer(quoteId)) {
            qOrder.errorMessage = 'Customer approval is missing on the quote.';                
            qOrder.isErrorExist = true;
        } else {
            qOrder.isErrorExist = validateOrders(orderList);
            if (qOrder.isErrorExist) {
                qOrder.errorMessage = 'Please correct the validation errors at sub-order header and/or item level. Click on Expand All button to see the errors.';
            }
        }    
        qOrder.custOrderList = orderList;
        
        return qOrder;
    }
    
    private static void populateSoftheaderinfo(String accountId, List<CustomerOrder> orderList){

        List<Account> accountList = [SELECT Id, PO_REQUIRED_CODE__c, DEPT_REQUIRED_CODE__c, RELEASE_REQUIRED_CODE__c, LOCATION_REQ_CODE_7__c 
                                     FROM Account WHERE Id = :accountId LIMIT 1];
        
        for (CustomerOrder order : orderList) {
            order.customerPONumFlag = accountList[0].PO_REQUIRED_CODE__c;
            order.deptFlag = accountList[0].DEPT_REQUIRED_CODE__c;
            order.releaseFlag = accountList[0].RELEASE_REQUIRED_CODE__c;
            order.costCenterFlag = accountList[0].LOCATION_REQ_CODE_7__c;
        }
    }
    
    private static QuoteHeader getQuoteHeader(String quoteId) {
        
        QuoteHeader quote_header = new QuoteHeader();
        Quote quote = [
            SELECT 
                Id,
                NAME,
                Cost_Center__c,
                Desktop__c,
                Customer_PO_Number__c,
                Release__c,
                Department__c,
                CONTACT.FIRSTNAME,
                CONTACT.LASTNAME,
                CONTACT.MAILINGADDRESS,
                CONTACT.EMAIL,
                CONTACT.PHONE,
                OPPORTUNITY.NAME,
                OPPORTUNITY.ID,
                ACCOUNTID,
                ACCOUNT.NAME,
                ACCOUNT.AOPS_Cust_Id__c,
                Ship_To_Account__r.Address1__c,
                Ship_To_Account__r.Address2__c,
                ship_To_Account__r.City__c,
                ship_To_Account__r.State__c,
                Ship_To_Account__r.Zip__c,
                Ship_To_Account__r.Country__c ,
                Ship_To_Account__r.aops_seq_id__c                
            FROM QUOTE WHERE ID = :quoteId
        ];
        
        quote_header.quoteId = quote.Id;
        quote_header.quoteName = quote.Name;
        quote_header.opportunityId = quote.Opportunity.Id;
        quote_header.opportunityName = quote.opportunity.name;
        quote_header.accountId = quote.AccountId;
        quote_header.accountName = quote.account.name;
        quote_header.aopsCustId = quote.account.AOPS_Cust_Id__c;
        quote_header.contactFirstName = quote.contact.firstname;
        quote_header.contactLastName = quote.contact.lastname;
        quote_header.contactEmail = quote.contact.Email;
        quote_header.contactPhone = quote.contact.Phone;
                
        quote_header.shipToAopsSeqID = quote.ship_To_Account__r.aops_seq_id__c;
        quote_header.shipToCity = quote.Ship_To_Account__r.City__c;
        quote_header.shipToAddress1 = quote.Ship_To_Account__r.Address1__c;
        quote_header.shipToAddress2 = quote.Ship_To_Account__r.Address2__c;
        quote_header.shipToState = quote.ship_To_Account__r.State__c;
        quote_header.shipToZip = quote.ship_To_Account__r.Zip__c;
        quote_header.shipToCountry = quote.ship_To_Account__r.Country__c;
        
        quote_header.customerPONum = quote.Customer_PO_Number__c;
        quote_header.desktop = quote.Desktop__c;
        quote_header.department = quote.Department__c;
        quote_header.release = quote.Release__c;
        quote_header.costCenter = quote.Cost_Center__c;
        
        return quote_header;
    }
    
    public static List<CustomerOrder> getCustomerOrderList(String quoteId) {
        
        List<QuoteLineItem> lineItemList = getQuoteLineItemList(quoteId);
        List<CustomerOrder> custOrderList = getOrderListByVendor(lineItemList);
        
        return custOrderList;
    }
    
    private static void populateQuoteHeaderInfoIntoOrders(QuoteHeader qHeader, List<CustomerOrder> orderList) {
        
        for (CustomerOrder order : orderList) {
            order.aopsCustId = qHeader.aopsCustId;
            order.contactFirstName = qHeader.contactFirstName;
            order.contactLastName = qHeader.contactLastName;
            order.contactMailingAddress = qHeader.contactMailingAddress;
            order.contactEmail = qHeader.contactEmail;
            order.contactPhone = qHeader.contactPhone;
            order.opportunityId = qHeader.opportunityId;
            order.shipToAddress1 = qHeader.shipToAddress1;
            order.shipToAddress2 = qHeader.shipToAddress2;
            order.shipToCity = qHeader.shipToCity;
            order.shipToState = qHeader.shipToState;
            order.shipToZip = qHeader.shipToZip;
            order.shipToCountry = qHeader.shipToCountry;
            order.shipToAopsSeqID = qHeader.shipToAopsSeqID; 
            order.accountName = qHeader.accountName;
            order.customerPONum = qHeader.customerPONum;
            order.desktop = qHeader.desktop;
            order.department = qHeader.department;
            order.release = qHeader.release;
            order.costCenter = qHeader.costCenter;
        }
    }
    
    private static List<QuoteLineItem> getQuoteLineItemList(String quoteId) {
        List<QuoteLineItem> lineItemList = [
            SELECT 
                Id, 
                QuoteId, 
                OD_Item_Number__c,
                Vendor_Part_Number__c, 
                Mfg_Part_Number__c, 
                Description, 
                Cost__c, 
                UnitPrice, 
                Total_Cost__c, 
                Total_Price__c, 
                Quantity,
                Vendor_Name__c,
                Vendor_Number__c, 
                Vendor_Quote_Number__c, 
                Margin_Percent__c,
                Shipping_Handling__c,
                List_Price__c,
                Vendor_Manufacturer_ID__c,
                OD_Manufacturer_ID__c,
                OD_Manufacturer_Name__c,
                Unit_of_Measure__c,
                Package_Size__c,
                Department_Class_Code__c,
                Line_Number__c,
                Taxable__c,
                Vendor_Pack__c,             
                Catalog_Page__c,
                Item_Type__c
            FROM QuoteLineItem WHERE QuoteId = :quoteId 
        ];
        //System.debug('Count ========='+ lineItemList.size());//remove
        
        return lineItemList;
    }
    
    private static List<CustomerOrder> getOrderListByVendor(List<QuoteLineItem> lineItemList) {
        
        Map<String, CustomerOrder> custOrderMap = new Map<String, CustomerOrder>();
        
        String orderKey;
        CustomerOrder custOrder = null;
        Integer sequenceNumber = 0;
        String vendorNumber = '';
        
        Map<String, String> vendorMap = getVendorMapping();
        
        for (QuoteLineItem lineItem : lineItemList) {
            vendorNumber = getLongLeadVendorNumber(lineItem.Vendor_Number__c, vendorMap);
           // System.debug('vendor number = '+ vendorNumber + ', ' + lineItem.Vendor_Number__c);
            orderKey = lineItem.QuoteId + vendorNumber + lineItem.Vendor_Quote_Number__c;
            custOrder = custOrderMap.get(orderKey);
            System.debug(LoggingLevel.INFO, custOrder);
            if (custOrder == null) {
                custOrder = new CustomerOrder();
                custOrder.sequenceNumber = sequenceNumber++;
                custOrder.sfdcQuoteId = lineItem.QuoteId;
                custOrder.vendorNumber = vendorNumber;                
                custOrder.vendorName = lineItem.Vendor_Name__c;
                custOrder.vendorQuoteId = lineItem.Vendor_Quote_Number__c;
                //custOrder.vendorPartNumber =lineItem.Vendor_Part_Number__c;//added 12/5
                //custOrder.orderTotalCost = lineItem.SubTotal ==null ? 0.00 : lineItem.SubTotal.setScale(2); //added on 12/6
                //custOrder.orderTotalPrice = lineItem.TotalPrice ==null ? 0.00 : lineItem.TotalPrice.setScale(2); //added on 12/6
                custOrder.shippingHandleFee = lineItem.Shipping_Handling__c == null ? 0.00 : lineItem.Shipping_Handling__c.setScale(2);
                //custOrder.orderComments = (lineItem.Vendor_Quote_Number__c == null) ? '' : 'Vendor Quote Number : ' + lineItem.Vendor_Quote_Number__c;  //remove....
                if (custOrder.quoteLineItemList == null) {
                    custOrder.quoteLineItemList = new List<QuoteLineItem>();
                    custOrder.quoteLineItemList.add(lineItem);
                }
                System.debug('s&H = ' +custOrder.shippingHandleFee + ' '+lineItem.Shipping_Handling__c);//remove
                custOrderMap.put(orderKey, custOrder);
            } else {
               // custOrder.shippingHandleFee = custOrder.shippingHandleFee + lineItem.Shipping_Handling__c;
                custOrder.quoteLineItemList.add(lineItem);
            }
        }
        
      return custOrderMap.values();
    }
    
    private static Map<String, String> getVendorMapping() {
        
        Map<String, String> vendorMap = new Map<String, String>();
        
        List<Vendor_Mapping__c> vendorMapList = [
            SELECT Source_Vendor_ID__c, Target_Vendor_ID__c 
            FROM Vendor_mapping__c 
            WHERE isActive__c = true AND APP_ID__c = 'TECHSALENC' ];
        
        for (Vendor_Mapping__c mapEntry : vendorMapList) {
            vendorMap.put(mapEntry.Source_Vendor_ID__c, mapEntry.Target_Vendor_ID__c);
        }
        
        return vendorMap;
    }
    
    private static String getLongLeadVendorNumber(String vendorId, Map<String, String> vendorMap) {
        
        String vendorLongId = vendorMap.get(vendorId);
        
        if (String.isNotBlank(vendorLongId)) {
            return vendorLongId;
        } else {
            return vendorId;
        }
        
    }
    
    private static void calculateOrderShippingHandle(List<CustomerOrder> custOrderList) {
        
        for (CustomerOrder order : custOrderList) {
            
            List<QuoteLineItem> itemList = order.quoteLineItemList;
            decimal orderSHFee = 0;
            for(QuoteLineItem item : itemList) {
                decimal shFee = item.Shipping_Handling__c;
                if (shFee != null) {
                    orderSHFee = orderSHFee + shFee;
                }
            }
            order.shippingHandleFee = orderSHFee;
        }        
    }
    
    private static void calculateOrderTotalCost(List<CustomerOrder> custOrderList){
        
        for (CustomerOrder order : custOrderList){
            List<QuoteLineItem> itemList  = order.quoteLineItemList;
            decimal totalCost = 0;
            for (QuoteLineItem item : itemList) {
                  decimal tCost = item.Total_Cost__c;
                  if (tCost != null) {
                      totalCost = totalCost + tCost;
                  }
            }
            order.orderTotalCost = totalCost;
        }
    }
    
    
     private static void calculateOrderTotalPrice(List<CustomerOrder> custOrderList) {
        
        for (CustomerOrder order : custOrderList) {
            List<QuoteLineItem> itemList = order.quoteLineItemList;
            decimal totalPrice = 0;
            for(QuoteLineItem item : itemList) {
                decimal tPrice = item.Total_Price__c;
                if (tPrice != null) {
                    totalPrice = totalPrice + tPrice;
                }
            }
            order.orderTotalPrice = totalPrice;
        }        
    }
     
     private static boolean doAllOrdersExistAlready(List<CustomerOrder> orderList) {
        
         boolean ordersExist = true;
         for (CustomerOrder order : orderList) {
             if (String.isBlank(order.aopsOrderNumber)) {
                 ordersExist = false;
             }
         }
         
        return ordersExist;
    }
    
    private static void populateExistingAopsOrderNumbers(List<CustomerOrder> orderList) {
        
        boolean isAllOrdersExist = true;
        for (CustomerOrder order : orderList) {
            order.aopsOrderNumber = getAopsOrderNumber(order.sfdcQuoteId, order.aopsCustId, order.vendorNumber, order.vendorQuoteId);
        }
        
    }
    
    private static String getAopsOrderNumber(String sfdcQuoteId, String aopsCustId, String vendorNumber, String vendorQuoteId) {
        
        String aopsOrdNum = '';
        List<Order_Header__c> orderHeaderList  = [
            select AOPS_Order_Number__c
            from Order_Header__c
            where Quote_ID__c =:sfdcQuoteId 
                and Aops_ID__c = :aopsCustId
                and Vendor_Account_Number__c = :vendorNumber
                and Vendor_Quote_ID__c = :vendorQuoteId
        ];
        
        for (Order_Header__c order : orderHeaderList) {
            if (String.isNotBlank(order.AOPS_Order_Number__c)) {
                aopsOrdNum = order.AOPS_Order_Number__c;
            }
        }
        
        return aopsOrdNum;
    }
    
    private static boolean isQuoteApprovedByCustomer(String quoteId) {
         Quote qt  = [
            select
                 Status
            from quote
            where id =:quoteId                               
        ];
        if (qt.status == 'Customer Review Complete') {
            return true;
        } else {
            return false;
        }
    }
    
    private static boolean validateOrders(List<CustomerOrder> custOrderList) {
        
        boolean isErrorExist = false;
        
        for (CustomerOrder order : custOrderList) {            
            order.orderErrorList = new List<String>();

            if (String.isBlank(order.aopsCustId)) {
                order.orderErrorList.add('AOPS Customer Id is missing.');
            }
            if(((order.customerPONumFlag =='Y')||(order.customerPONumFlag =='V')) && (String.isBlank(order.customerPONum))) {
                order.orderErrorList.add('Customer PO Number is missing.');
            }
            
            if(((order.deptFlag =='Y')||(order.deptFlag =='V')) && (String.isBlank(order.desktop))) {
                order.orderErrorList.add('Desktop Number is missing.');
            }
            if(((order.releaseFlag =='Y')||(order.releaseFlag =='V')) && (String.isBlank(order.release))) {
                order.orderErrorList.add('Release Number is missing.');
            }
            if(((order.costCenterFlag  =='Y')||(order.costCenterFlag =='V')) && (String.isBlank(order.costCenter))) {
                order.orderErrorList.add('Cost Center Number is missing.');
            }
            if (String.isBlank(order.contactFirstName)) {
                order.orderErrorList.add('Contact First Name is missing.');
            } 
            
            if (String.isBlank(order.contactLastName)) {
                order.orderErrorList.add('Contact Last Name is missing.');
            }
            
            if (String.isBlank(order.contactEmail)) {
                order.orderErrorList.add('Contact Email is missing.');
            }
            
            if (String.isBlank(order.contactPhone)) {
                order.orderErrorList.add('Contact Phone is missing.');
            }
            
            if (String.isBlank(order.shipToAopsSeqID)) {
                order.orderErrorList.add('Ship to AOPS Sequence Id is missing.');
            }
            
            if (String.isBlank(order.vendorNumber)) {
                order.orderErrorList.add('Vendor number is missing.');
            }

            if (String.isNotBlank(order.vendorQuoteId) && order.vendorQuoteId.length() >18){
                order.orderErrorList.add('Vendor quote ID cannot have more than 18 characters.');
            }
                         
            if(String.isBlank(order.shipToAddress1)) {
                order.orderErrorList.add('Ship to address1 is missing.');
            }
            
            if(String.isBlank(order.shipToCity)) {
                order.orderErrorList.add('Ship to city is missing.');
            }
            
            if(String.isBlank(order.shipToState)) {
                order.orderErrorList.add('Ship to state is missing.');
            }
            
            if(String.isBlank(order.shipToZip)) {
                order.orderErrorList.add('Ship to zip is missing.');
            }
                     
            List<QuoteLineItem> itemList = order.quoteLineItemList;
            
            for (QuoteLineItem item : itemList) {
                List<String> itemErrorList = new List<String>();
                if (String.isBlank(item.Vendor_Part_Number__c)) {
                    itemErrorList.add('Vendor Part Number is required.');
                }
                
                if(item.Description == null || item.Description == ''){ //added 1/29
                    itemErrorList.add('Item Description is missing.');
                }
                
                if(item.Line_Number__c == null){
                    itemErrorList.add('Customer PO Line# is missing');
                }
                
                if(item.Quantity == null) {
                    itemErrorList.add('Quantity is required.');
                } else if (item.Quantity <= 0 || item.Quantity > 9999) {
                    itemErrorList.add('Quantity should be between 1 and 9999.');
                }
                
                if(item.UnitPrice == null) {
                    itemErrorList.add('Price is required.');
                } else if (item.UnitPrice < 0.00 ||item.UnitPrice >999999.00){
                    itemErrorList.add('Price should be between 0.00 and 999999.00');
                }
                
                if(item.List_Price__c < 0.00 || item.List_Price__c > 99999.99){
                   itemErrorList.add('List Price should be between 0.00 and 999999.00'); 
                }
                
                if(item.Cost__c == null) {
                   itemErrorList.add('Cost is required.'); 
                } else if (item.Cost__c < 0.00 || item.Cost__c > 99999.99){
                   itemErrorList.add('Cost should be between 0.00 and 999999.00');  
                } else if (item.Cost__c > item.UnitPrice){
                   itemErrorList.add('Cost should be less than Price.');   
                }
                
                system.debug('list='+ item.List_Price__c + ', cost= '+ item.Cost__c +', unit = '+ item.UnitPrice);
                
                if (item.List_Price__c < item.UnitPrice) {
                    itemErrorList.add('List price('+ item.List_Price__c +') should be greater than unit price('+ item.UnitPrice +').');   
                }
                
                if (item.List_Price__c < item.Cost__c) {
                    itemErrorList.add('List price('+ item.List_Price__c +') should be greater than the cost('+ item.Cost__c +').');   
                }
                
                if (item.Cost__c > item.UnitPrice) {
                    itemErrorList.add('Cost ('+ item.Cost__c +') should be less than unit price ('+ item.UnitPrice +').');   
                }
                
                if (item.Cost__c > item.List_Price__c) {
                    itemErrorList.add('Cost ('+ item.Cost__c +') should be less than list price ('+ item.List_Price__c +').');   
                }
                                                
                if(String.isNotBlank(item.Mfg_Part_Number__c) && String.isBlank(item.OD_Manufacturer_ID__c)) {
                    itemErrorList.add('Manufacturer Id is missing.');
                } else if (String.isNotBlank(item.OD_Manufacturer_ID__c) && (item.OD_Manufacturer_ID__c.length() >10)){
                    itemErrorList.add('Manufacturer Id cannot have more than 10 characters.');
                }
                
                if(String.isBlank(item.Mfg_Part_Number__c) && String.isNotBlank(item.OD_Manufacturer_ID__c)) {
                    itemErrorList.add('Manufacturer Part Number is missing.');
                } else if (String.isNotBlank(item.Mfg_Part_Number__c) && item.Mfg_Part_Number__c.length() >30){
                    itemErrorList.add('Manufacturer Part Number cannot have more than 30 characters.');
                }
                
                if(String.isBlank(item.Unit_of_Measure__c)) {
                    itemErrorList.add('UOM is missing.'); 
                } else if (item.Unit_of_Measure__c.length() > 2){
                    itemErrorList.add('UOM cannot have more than 2 characters.');  
                }
                
                if (item.Package_Size__c == null) {
                    itemErrorList.add('Units/Pack is missing.');
                } else if (item.Package_Size__c > 99999) {
                    itemErrorList.add('Units per pack cannot be greater than 99999.');  
                } else if (item.Package_Size__c < 1) {
                    itemErrorList.add('Units per pack cannot be shorter than 1.');  
                }
                
                /*
               if(item.Taxable__c != True && item.Taxable__c != False){
                   itemErrorList.add('Taxable is required.');
                }
               if(item.Vendor_Pack__c > 99999){
                   itemErrorList.add('Vendor Pack can have only 5 numeric positions.');  
                }
               if(item.Catalog_Page__c > 99999){
                    itemErrorList.add('Catlog Page can have only 5 numeric positions.');  
                }
                
                */
                if (itemErrorList != null && !itemErrorList.isEmpty()) {
                    item.Error_Message__c = String.valueOf(itemErrorList);
                    item.Is_Error_Message_Exist__c = true;
                    order.isAnyLineItemErrorExist = true;
                }
            }
            
            if (order.orderErrorList != null && !order.orderErrorList.isEmpty()) {
                order.isSubOrderErrorExist = true;
            }
            
            if (order.isSubOrderErrorExist == true || order.isAnyLineItemErrorExist == true) {
                isErrorExist = true;
            }
        }

        return isErrorExist;         
    }
    
    @AuraEnabled
    public static String placeOrder(String orderListJson, String orderType) {
        
        List<CustomerOrder> customerOrderList = (List<CustomerOrder>)JSON.deserialize(orderListJson, List<CustomerOrder>.class);
        String orderId;
        String currQuoteId = '';
        system.debug('order count...'+ customerOrderList.size() );//remove
        
        if (isPartialOrderCreationSuccessful(customerOrderList)) {
            System.debug('setting order type....to manual');
            orderType = 'manual';
        }
        
        List<RecordType> caseRecTypeIdList = [select ID from recordtype where developername = 'Order_Case' LIMIT 1];        
        ID caseRecordTypeId = caseRecTypeIdList.get(0).id;
        
        List<Order_Header__c> manualOrderListForUpdate = new List<Order_Header__c>();
        
        System.debug('order type is '+ orderType);
        for (CustomerOrder order : customerOrderList) {
            System.debug('order type ====='+ order.isVendorEdiEnabled);
            if ((orderType == 'manual' || order.isVendorEdiEnabled == false || order.isVendorEdiEnabled == null) && String.isBlank(order.aopsOrderNumber)) {
                //System.debug('In manual.........');
                orderId = saveOrderHeader(order);
                order.orderId = orderId;
                //saveOrderDetails(order);
                String caseId = saveOrderCase(order, caseRecordTypeId);
                Order_Header__c header = [SELECT id, Order_Case_ID__c from Order_Header__c where id = :orderId];
                header.Order_Case_ID__c = caseId;
                //System.debug('In manual.........'+ caseId);
                manualOrderListForUpdate.add(header);
                //update header;
            }
            System.debug('Order edi flag ===============' + order.isVendorEdiEnabled);
            if (orderType == 'automatic' && order.isVendorEdiEnabled == true && String.isBlank(order.aopsOrderNumber)) { // if the order was not already placed.
                orderId = saveOrderHeader(order);
                order.orderId = orderId;
                System.debug('Order ===============' + order.orderId);
                //saveOrderDetails(order);
                sendNonVWItemSetupRequestToOracleSCM(order);
                sendOrderRequestToB2B(order);
            }
            
            if (currQuoteId == '') {
                currQuoteId = order.sfdcQuoteId;
            }           
        }
        
        if (manualOrderListForUpdate.size() > 0) {
            update manualOrderListForUpdate;
        }
        
        if (orderType == 'automatic') {
            updateOrderWithSCMJsonMsg(customerOrderList);
        }
        
        saveAllOrderDetails(customerOrderList);
        updateQuoteStatus(currQuoteId);
        return 'success';
    }
    
    private static String saveOrderCase(CustomerOrder custOrder, ID caseRecordTypeId) {
        Case orderCase = new Case();
        orderCase.Subject = 'Non-code Order for QuoteId '+ custOrder.sfdcQuoteId + '- VendorName ' + custOrder.vendorName + '- OrderId ' + custOrder.orderId;
        String caseDesc = getOrderInfoForOracleCX(custOrder);
        orderCase.RecordTypeId = caseRecordTypeId;
        orderCase.New_Request__c = caseDesc;
        //orderCase.Order_Description__c = caseDesc;
        insert orderCase;
        return orderCase.Id;
    }
    
    private static boolean isPartialOrderCreationSuccessful(List<CustomerOrder> customerOrderList) {
        
        integer aopsOrderCount = 0;
        for (CustomerOrder order : customerOrderList) {
            if (String.isNotBlank(order.aopsOrderNumber)) {
                aopsOrderCount++;
            }
        }
        
        integer totalOrderCount = 0;
        if (customerOrderList != null) {
            totalOrderCount = customerOrderList.size();
        }
        
        System.debug('aops order count =' + aopsOrderCount + ', total count = '+ totalOrderCount);
            
        if ((aopsOrderCount > 0) && (aopsOrderCount < totalOrderCount)) {
            return true;
        }
        
        return false;
    }
    /*
    private static void populateVendorEDIFlags(List<CustomerOrder> orderList) {
        
        if (orderList == null || orderList.size() == 0) {
            return;
        }
        
        
        
        String vendorNum;
        for (CustomOrder order : orderList) {
            vendorNum = order.vendorNumber;
            
        }
    }
    */
    
    private static void populateVendorInfo(List<CustomerOrder> orderList) {
        if (orderList == null || orderList.size() == 0) {
            return;
        }
        
        List<Vendor__c> vendorList = [SELECT VendorNum__c, Is_EDI_Enabled__c from vendor__c where Active__c = true];
        Map<String, Boolean> vendorEdiMap = new Map<String, Boolean>();
        for (Vendor__c v : vendorList) {
            vendorEdiMap.put(v.VendorNum__c, v.Is_EDI_Enabled__c);            
        }
        
        for (CustomerOrder order : orderList) {
            order.isVendorEdiEnabled = vendorEdiMap.get(order.vendorNumber);  
            if (order.isVendorEdiEnabled == true) {
                order.orderMethod = 'Automatic';
            } else {
                order.orderMethod = 'Manual';
            }
        }
    }
    
    private static String getOrderInfoForOracleCX(CustomerOrder custOrder) {
        
        String orderString = '';
        
        List<String> orderDescList = new List<String>();
        
        orderDescList.add('CustomerID: ' + custOrder.aopsCustId);
        orderDescList.add('Business Name: '+ custOrder.accountName);
        orderDescList.add('Shipping Address ID or Seq: '+ custOrder.shipToAopsSeqID);
        orderDescList.add('Will Customer accept a drop ship: Yes');
        orderDescList.add('Customer First Name:'+ custOrder.contactFirstName);
        orderDescList.add('Customer Last Name:'+ custOrder.contactLastName);
        orderDescList.add('Customer Ship To Address:'+ custOrder.shipToAddress1 + ','+ custOrder.shipToCity + ','+ custOrder.shipToState + '-' + custOrder.shipToZip );
        orderDescList.add('Customer Phone Number:'+ custOrder.contactPhone);
        orderDescList.add('Customer Email:'+ custOrder.contactEmail);
        orderDescList.add('Number of Items: '+ custOrder.quoteLineItemList.size());
        
        integer rowNum = 1;
        for (QuoteLineItem item : custOrder.quoteLineItemList) {
            orderDescList.add('=== Item '+ rowNum++ +' ==============================================');
            orderDescList.add('Is item requested a Product or Service: Product');
            orderDescList.add('SKU Number: '+ item.OD_Item_Number__c);
            orderDescList.add('Has Customer ordered this item before: No'); //added 12/5
            orderDescList.add('Is there a Special Pricing Agreement, MFG Bid Letter, or Vendor Quote for this line item: '+item.Vendor_Quote_Number__c);
            orderDescList.add('Vendor Name: '+ item.Vendor_Name__c);
            orderDescList.add('Vendor Item Number: '+ item.Vendor_Part_Number__c);
            orderDescList.add('Manufacturer Name: '+ item.OD_Manufacturer_Name__c);
            orderDescList.add('Manufacturer Part Number : '+ item.Mfg_Part_Number__c);
            orderDescList.add('Item Description: '+ item.Description);
            orderDescList.add('Quantity: '+ Integer.valueOf(item.Quantity));
            orderDescList.add('Sell: '+ item.UnitPrice);
            orderDescList.add('Cost: ' + item.Cost__c);
            orderDescList.add('Margin: '+item.Margin_Percent__c);
        }
        
        orderDescList.add('==========================================================');
        orderDescList.add('Desktop Delivery: ');
        orderDescList.add('Purchase Order Number: ' + custOrder.customerPONum);
        orderDescList.add('Release Number: ' + custOrder.Release);
        orderDescList.add('Department: ' + custOrder.Department);
        orderDescList.add('Cost Center: ' + custOrder.CostCenter);
        orderDescList.add('Order Comments: ' + custOrder.orderComments);
        orderDescList.add('Tender Type: AB');
        orderDescList.add('Is rush delivery needed: ');
        orderDescList.add('Charge customer for freight: ');
        orderDescList.add('Please select the vendor being used for this order: ' + custOrder.vendorName);
        orderDescList.add('Should order be sent EDI: ' );
        orderDescList.add('Is this an LTL order: ');
        orderDescList.add('Item Being Sold Below Cost: ' );
        orderDescList.add('We receive deviated cost from manufacturer: ');
        orderDescList.add('Additional Comments: ');
        
        
        return string.join(orderDescList,'<br></br>');
    }
    
    private static String saveOrderHeader(CustomerOrder custOrder) {
        
        Order_Header__c header = new Order_Header__c();
        header.Account_ID__c = custOrder.aopsCustId;
        header.Comments__c = custOrder.orderComments;
        header.Opportunity_ID__c = custOrder.opportunityId;
        header.Name = custOrder.vendorName;
        header.Salesforce_Quote_ID__c = custOrder.sfdcQuoteId;
        header.Vendor_Account_Number__c = custOrder.vendorNumber;
        //header.Vendor_Email__c = 'vendor-email@email.com';
        header.Vendor_Quote_ID__c = custOrder.vendorQuoteId;
        header.Quote_ID__c = custOrder.sfdcQuoteId;
        header.Aops_ID__c = custOrder.aopsCustId;
        header.Shipping_Address1__c = custOrder.shipToAddress1;
        header.Shipping_Address2__c = custOrder.shipToAddress2;
        header.Shipping_City__c = custOrder.shipToCity;
        header.Shipping_State_Province__c = custOrder.shipToState;
        header.Shipping_Zip_Postal_Code__c = custOrder.shipToZip;
        header.Shipping_Country__c = custOrder.shipTocountry;
        header.Ship_To_Seq_Id__c = custOrder.shipToAopsSeqID;
                       
        insert header;
        return header.id;
    }
    /*
    private static void saveOrderDetails(CustomerOrder custOrder) {
        system.debug('custOrder.quoteLineItemList========'+ custOrder.quoteLineItemList.size());//remove
        List<Order_Line_Item_Details__c> lineItemList = new List<Order_Line_Item_Details__c>();
        for(QuoteLineItem lineItem : custOrder.quoteLineItemList ) {
            Order_Line_Item_Details__c details = new Order_Line_Item_Details__c();   
            details.Quantity__c            = lineItem.Quantity;
            details.Product_Description__c = lineItem.Description;
            details.Product_ID__c          = lineItem.OD_Item_Number__c;
            details.Vendor_Price__c        = lineItem.Cost__c; 
            details.Order_ID__c            = custOrder.orderId;  
            details.Total_Price__c         = lineItem.Total_Price__c;
            details.Shipping_Handling_Fee__c = lineItem.Shipping_Handling__c;//do we need S&H in order Line Item details
            lineItemList.add(details);
        }
        
        if (lineItemList.size() > 0) {
            insert lineItemList;
        }
        
        system.debug('in save order details....');//remove
    }
    */
    private static void saveAllOrderDetails(List<CustomerOrder> custOrderList) {
        
        List<Order_Line_Item_Details__c> lineItemList = new List<Order_Line_Item_Details__c>();
        
        for (CustomerOrder custOrder : custOrderList) {
            for(QuoteLineItem lineItem : custOrder.quoteLineItemList ) {
                Order_Line_Item_Details__c details = new Order_Line_Item_Details__c();   
                details.Quantity__c            = lineItem.Quantity;
                details.Product_Description__c = lineItem.Description;
                details.Product_ID__c          = lineItem.OD_Item_Number__c;
                details.Vendor_Price__c        = lineItem.Cost__c; 
                details.Order_ID__c            = custOrder.orderId;  
                details.Total_Price__c         = lineItem.Total_Price__c;
                details.Shipping_Handling_Fee__c = lineItem.Shipping_Handling__c;
                lineItemList.add(details);
                System.debug('Order in save all order details ======'+ details.Order_ID__c);
            }
        }
        
        if (lineItemList.size() > 0) {
            insert lineItemList;
        }
        
        system.debug('in save order details....');//remove
    }
    
    public static void updateQuoteStatus(String quoteId) {
        Quote q = [select id, Status from quote where id=:quoteId];
        q.Status = 'Completed';
        update q;    
    }
    
    public static void sendNonVWItemSetupRequestToOracleSCM(CustomerOrder order) {
        
        List<QuoteLineItem> qLineitemList = order.quoteLineItemList;
        if (qLineitemList == null || qLineitemList.size() == 0) {
            return;
        }
        
        List<String> jsonLineList;
        String jsonMsg;
        String allItemJsonMsg = '';
        for (QuoteLineItem lineItem : qLineitemList) {
            jsonLineList = new List<String>();
            if (String.isNotBlank(lineItem.OD_Item_Number__c) 
                && lineItem.Is_virtual_Warehouse_Item__c == false
                && 'ITEM6'.equalsIgnoreCase(lineItem.Item_Type__c)) {
                jsonLineList.add('{');
                jsonLineList.add('"ITEM":"'+ lineItem.OD_Item_Number__c + '",');
                jsonLineList.add('"ITEM_DESC":"'+ lineItem.Description +'",');
                jsonLineList.add('"PACKAGE_UOM":"'+ lineItem.Unit_Of_Measure__c +'",');
                jsonLineList.add('"STATUS":"A",');
                jsonLineList.add('"VIRTUAL_WHSE_FLG":"Y",');
                jsonLineList.add('"ACTION_TYPE":"U",');
                jsonLineList.add('"RMS_TIMESTAMP":"' + String.valueOf(DateTime.now()) +'"');
                jsonLineList.add('}');
                jsonMsg = string.join(jsonLineList,' ');
                allItemJsonMsg = allItemJsonMsg + '   ' + jsonMsg;
                invokeEAI(jsonMsg);
            }
        }
        order.allItemJsonMsgForSCM = allItemJsonMsg;
        //updateOrderWithSCMJsonMsg(order.orderId, allItemJsonMsg);
    }
    
    public static void sendOrderRequestToB2B(CustomerOrder order) {
        
        AOPSOrderStructure ordStruc = new AOPSOrderStructure();
        ordStruc.timeStamp = String.valueOf(DateTime.now());
        ordStruc.documentid = order.orderId;
        
        AOPSOrderStructure.OrderHeader ordhdr = new AOPSOrderStructure.OrderHeader();
        ordhdr.Sender = 'SalesForce';
        ordhdr.customerId = order.aopsCustId;
        if (String.isBlank(order.orderComments)) {
            ordhdr.comments = 'No Comments';
        } else {
            ordhdr.comments = order.orderComments;
        }
        // AOPS defaults
        ordhdr.dropship = 'Y';
        ordhdr.returnable = 'N';
        ordhdr.billOnly = 'N';
        ordhdr.shipComplete = 'N';
        
        ordStruc.header = ordhdr;
        
        AOPSOrderStructure.AddressSeq addrSeq = new AOPSOrderStructure.AddressSeq();
        if (order.shipToAopsSeqID != null) {
            List<String> strList = order.shipToAopsSeqID.split('-');
            if (strList != null && strList.size() > 1) {
                addrSeq.seq = strList.get(1);
            }
            //addrSeq.seq = '00017';
        }
        
        AOPSOrderStructure.ContactInfo contactInfo = new AOPSOrderStructure.ContactInfo();
        contactInfo.Name = order.contactFirstName + ' ' + order.contactLastName;
        AOPSOrderStructure.CustomerEmail contactEmail = new AOPSOrderStructure.CustomerEmail();
        contactEmail.body = order.contactEmail;
        AOPSOrderStructure.CustomerPhone custPhone = new AOPSOrderStructure.CustomerPhone();
        custPhone.CustomerPhoneNumber = order.contactPhone;
        
        contactInfo.Email = contactEmail;
        contactInfo.PhoneNumber = custPhone;
        
        addrSeq.Contact = contactInfo;
        
        AOPSOrderStructure.ShipToAddress shipTo = new AOPSOrderStructure.ShipToAddress();
        shipTo.addr = addrSeq;
        ordhdr.shipTo = shipTo;
        
        AOPSOrderStructure.OrderRequest ordrq = new AOPSOrderStructure.OrderRequest();
        ordrq.orderType = 'NC';
        
        AOPSOrderStructure.OrderAccounting accting = new AOPSOrderStructure.OrderAccounting();
        accting.costCenter = order.costCenter == null ? '' : order.costCenter;//'9900';
        accting.desktop = order.desktop == null ? '' : order.desktop;//'Cube123';
        accting.release = order.release == null ? '' : order.release;//XYZ';
        
        AOPSOrderStructure.PONumber ponum = new AOPSOrderStructure.PONumber();
        ponum.body = order.customerPONum == null ? '' : order.customerPONum;//'PO12345';
        accting.ponumber = ponum;
        
        ordrq.accounting = accting;
        
        AOPSOrderStructure.Payment payment = new AOPSOrderStructure.Payment();
        payment.method = 'AB';
        ordrq.payment = payment;
        
        List<QuoteLineItem> qLineitemList = order.quoteLineItemList;
        List<AOPSOrderStructure.ItemInfo> aopsItemList = new List<AOPSOrderStructure.ItemInfo>();
        Integer lineNum = 1;
        String tempStr;
        for (QuoteLineItem qLineItem : qLineitemList) {
            AOPSOrderStructure.ItemInfo item = new AOPSOrderStructure.ItemInfo();
            item.lineNumber = String.valueOf(lineNum);
            item.customerlinenumber = String.valueOf(lineNum);
            item.sku = qLineItem.Vendor_Part_Number__c;
            //item.sku = '12659974';
            tempStr = order.vendorNumber;//qLineItem.Vendor_Number__c;
            if (String.isNotEmpty(tempStr)) {
                tempStr = tempStr.leftPad(8, '0');
            }
            item.vendorID = tempStr; //'00455461';
            //item.vendorID = '';//'123';//'00994289';
            //item.vendorID = '00007219';//'00994289';
            item.qty = String.valueOf(Integer.valueOf(qLineItem.Quantity));
            item.unitPrice = String.valueOf(qLineItem.UnitPrice);
            item.listPrice = String.valueOf(qLineItem.List_Price__c);
            item.cost = String.valueOf(qLineItem.Cost__c);
            item.unitOfMeasure = qLineItem.Unit_Of_Measure__c;
            item.description = qLineItem.Description;
            if (qLineItem.Package_Size__c == null || qLineItem.Package_Size__c > 99999) {
                item.units = '1';
            } else {
                item.units = String.valueOf(Integer.valueOf(qLineItem.Package_Size__c));
            }
            item.vendorPack = '1';
            if (String.isNotEmpty(qLineItem.Department_Class_Code__c)) {
                item.merchClass = qLineItem.Department_Class_Code__c;
            } else {
                item.merchClass = '635'; // Charlie provided.
            }
            item.taxable = 'Y';
            item.catalogPage = '';
            item.manufacturerId = qLineItem.OD_Manufacturer_ID__c;
            tempStr = qLineItem.OD_Manufacturer_ID__c;
            if (String.isNotEmpty(tempStr)) {
                tempStr = tempStr.leftPad(10, '0');
            }
            item.manufacturerId = tempStr;
            item.manufacturerPartNum = qLineItem.Mfg_Part_Number__c;
            item.QuoteId = qLineItem.Vendor_Quote_Number__c;
            aopsItemList.add(item);
            lineNum++;
        }
        
        AOPSOrderStructure.ItemDetail detail = new AOPSOrderStructure.ItemDetail();
        detail.Item = aopsItemList;
        
        AOPSOrderStructure.OrderTotals orderTotals = new AOPSOrderStructure.OrderTotals();
        orderTotals.Delivery = String.valueOf(order.shippingHandleFee);
        orderTotals.Total = String.valueOf(order.orderTotalCost);
        orderTotals.SubTotal = String.valueOf(order.orderTotalPrice);
        
        detail.Totals = orderTotals;
        
        ordrq.detail = detail;
        
        ordStruc.request = ordrq; 
        
        String str = JSON.serialize(ordStruc);
        str = str.replace('timeStamp', '@timeStamp');
        str = str.replace('documentid', '@documentid');
        str = str.replace('seq', '@seq');
        str = str.replace('body', '*body');
        str = str.replace('method', '@method');
        str = str.replace('CustomerPhoneNumber', 'Number');
        str = '{"ODPurchaseOrder" : ' + str + '}';
        System.debug('js>' + str);
        invokeB2B(order.orderId, str);
    }
    
    @future (callout=true)
    public static void invokeEAI(String itemMessage) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setEndpoint('callout:TechSales_EAI2SCM_Endpoint/eaiapi/itemservice');
        request.setMethod('POST');
        request.setBody(itemMessage);
        
        HttpResponse response = null;
        
        System.debug('InvokeEAI Test.isRunningTest() =='+ Test.isRunningTest());
        if (Test.isRunningTest()) {
            HttpCalloutMock mock = new OrderCreation_TC.B2BServiceMock();
            response = mock.respond(request);
        } else {
            response = http.send(request);
        }
        
        //HttpResponse response = http.send(request);
        System.debug('response =======>'+ response.getStatus() + ',' + response.getStatusCode() + ',' + response.getBody());
    }
    
    @future (callout=true)
    public static void invokeB2B(String orderId, String orderMessage) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        //request.setEndpoint('https://b2bwmtest.officedepot.com/invoke/ODServices.api.orders/_receive');
        request.setEndpoint('callout:B2B_Order_Request_Endpoint');
        request.setMethod('POST');
        request.setBody(orderMessage);
        HttpResponse response = null;
        
        System.debug('invokeB2B Test.isRunningTest() =='+ Test.isRunningTest());
        if (Test.isRunningTest()) {
            HttpCalloutMock mock = new OrderCreation_TC.B2BServiceMock();
            response = mock.respond(request);
        } else {
            response = http.send(request);
        }
        
        System.debug('response =======>'+ response.getStatus() + ',' + response.getStatusCode() + ',' + response.getBody());
        updateOrderStatus(orderId, response.getBody(), orderMessage);
    }
    
    private static void updateOrderStatus(String orderId, String responseMsg, String orderMessage) {
        
        Order_Header__c ordHdr = [SELECT id, B2B_Order_Validation_Message__c, Order_Payload_To_B2B__c  FROM Order_Header__c where id = :orderId];
        ordHdr.B2B_Order_Validation_Message__c = responseMsg;
        ordHdr.Order_Payload_To_B2B__c = orderMessage;
        update ordHdr;
    }
    
    /*
    private static void updateOrderWithSCMJsonMsg(String orderId, String allItemJsonMsg) {
        Order_Header__c ordHdr = [SELECT id, Item_Message_To_SCM__c FROM Order_Header__c where id = :orderId];
        ordHdr.Item_Message_To_SCM__c = allItemJsonMsg;
        update ordHdr;
    }
    */
    
    private static void updateOrderWithSCMJsonMsg(List<CustomerOrder> orderList) {
        
        List<String> orderIdList = new List<String>();
        Map<String, CustomerOrder> orderMap = new Map<String, CustomerOrder>();
        for (CustomerOrder order : orderList) {
            orderIdList.add(order.orderId);
            orderMap.put(order.orderId, order);
        }
        CustomerOrder custOrder;
        List<Order_Header__c> ordHdrList = [SELECT id, Item_Message_To_SCM__c FROM Order_Header__c where id IN :orderIdList];
        for (Order_Header__c ordHdr : ordHdrList) {
            custOrder = orderMap.get(ordHdr.id);
            ordHdr.Item_Message_To_SCM__c = custOrder.allItemJsonMsgForSCM;   
            System.debug('order id = '+ ordHdr.id + ', scm msg = '+ custOrder.allItemJsonMsgForSCM);
        }
        
        update ordHdrList;
    }
    
    private static void populateMetadataSettings (QuoteOrderInfo qOrder){
        Tech_Sales_Order_Type__mdt metadata = [SELECT Id, Automatic_Order__c, Manual_Order__c
                                               FROM Tech_Sales_Order_Type__mdt LIMIT 1];
        qOrder.isAutomaticOrder = metadata.Automatic_Order__c;
        qOrder.isManualOrder = metadata.Manual_Order__c;
        system.debug('Auto order flag: ' + metadata.Automatic_Order__c);
        system.debug('Manual order flag: ' + metadata.Manual_Order__c);
    }
    
    public class QuoteOrderInfo {
        @AuraEnabled public QuoteHeader quoteHeader;
        @AuraEnabled public List<CustomerOrder> custOrderList;
        @AuraEnabled public boolean isErrorExist;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public boolean isQuoteApproved;
        @AuraEnabled public boolean isManualOrder;
        @AuraEnabled public boolean isAutomaticOrder;
    }
    
    public class QuoteHeader {
        @AuraEnabled public String quoteId;
        @AuraEnabled public String quoteName;
        @AuraEnabled public String opportunityId;
        @AuraEnabled public String opportunityName;
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;  
        @AuraEnabled public String aopsCustId;
        @AuraEnabled public String contactFirstName;
        @AuraEnabled public String contactLastName;
        @AuraEnabled public String contactMailingAddress;
        @AuraEnabled public String contactEmail;
        @AuraEnabled public String contactPhone;
        @AuraEnabled public String shipToCity;
        @AuraEnabled public String shipToAddress1;
        @AuraEnabled public String shipToAddress2;
        @AuraEnabled public String shipToState;
        @AuraEnabled public String shipToZip;
        @AuraEnabled public String shipToCountry;
        @AuraEnabled public String shipToAopsSeqID;
        @AuraEnabled public Decimal shippingHandleFee;
        @AuraEnabled public Decimal OrderTotalCost;
        @AuraEnabled public Decimal OrderTotalPrice;
        @AuraEnabled public String customerPONum;
        @AuraEnabled public String desktop;
        @AuraEnabled public String department;
        @AuraEnabled public String release;
        @AuraEnabled public String costCenter;
    }

    public class CustomerOrder {        
        @AuraEnabled public integer sequenceNumber;
        @AuraEnabled public String orderId;// SFDC Order Id
        @AuraEnabled public String aopsOrderNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public String vendorName;
        @AuraEnabled public String vendorNumber;
        @AuraEnabled public String vendorQuoteId;
        @AuraEnabled public String vendorEmail;
        @AuraEnabled public String vendorPartNumber;
        @AuraEnabled public Boolean isVendorEdiEnabled;
        @AuraEnabled public String orderMethod;
        @AuraEnabled public String opportunityName;
        @AuraEnabled public String sfdcQuoteId;
        @AuraEnabled public String orderComments;
        @AuraEnabled public String opportunityId;        
        @AuraEnabled public String aopsCustId;
        @AuraEnabled public String contactFirstName;
        @AuraEnabled public String contactLastName;
        @AuraEnabled public String contactMailingAddress;
        @AuraEnabled public String contactEmail;
        @AuraEnabled public String contactPhone;
        @AuraEnabled public String shipToCity;
        @AuraEnabled public String shipToAddress1;
        @AuraEnabled public String shipToAddress2;
        @AuraEnabled public String shipToState;
        @AuraEnabled public String shipToZip;
        @AuraEnabled public String shipToCountry;
        @AuraEnabled public String shipToAopsSeqID;
        @AuraEnabled public Decimal shippingHandleFee;
        @AuraEnabled public Decimal orderTotalCost;
        @AuraEnabled public Decimal orderTotalPrice;
        @AuraEnabled public String customerPONum;
        @AuraEnabled public String desktop;
        @AuraEnabled public String department;
        @AuraEnabled public String release;
        @AuraEnabled public String costCenter;
        // Soft-header fields start
        @AuraEnabled public String customerPONumFlag;
        @AuraEnabled public String deptFlag;
        @AuraEnabled public String releaseFlag;
        @AuraEnabled public String costCenterFlag;
        // Soft-header fields end
        @AuraEnabled public String allItemJsonMsgForSCM;
        @AuraEnabled public List<QuoteLineItem> quoteLineItemList;
        @AuraEnabled public List<String> orderErrorList;
        @AuraEnabled public List<String> itemErrorList;
        @AuraEnabled public Boolean isSubOrderErrorExist;
        @AuraEnabled public Boolean isAnyLineItemErrorExist;
    }
}