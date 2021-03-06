//Generated by wsdl2apex

public class soapQuoteupdate2 {
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class DebuggingHeader_element {
        public soapQuoteupdate2.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public class QuoteUpdate {
        public String endpoint_x = 'https://cs7.salesforce.com/services/Soap/class/QuoteUpdate';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public soapQuoteupdate2.SessionHeader_element SessionHeader;
        public soapQuoteupdate2.DebuggingHeader_element DebuggingHeader;
        public soapQuoteupdate2.DebuggingInfo_element DebuggingInfo;
        public soapQuoteupdate2.CallOptions_element CallOptions;
        public soapQuoteupdate2.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/QuoteUpdate';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/QuoteUpdate';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/QuoteUpdate';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/QuoteUpdate';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/QuoteUpdate';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate', 'soapQuoteupdate2'};
        public String QuoteOperation(soapQuoteupdate2.ServiceQuote serQuot) {
            soapQuoteupdate2.QuoteOperation_element request_x = new soapQuoteupdate2.QuoteOperation_element();
            soapQuoteupdate2.QuoteOperationResponse_element response_x;
            request_x.serQuot = serQuot;
            Map<String, soapQuoteupdate2.QuoteOperationResponse_element> response_map_x = new Map<String, soapQuoteupdate2.QuoteOperationResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/QuoteUpdate',
              'QuoteOperation',
              'http://soap.sforce.com/schemas/class/QuoteUpdate',
              'QuoteOperationResponse',
              'soapQuoteupdate2.QuoteOperationResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
    public class ServiceQuote {
        public String A0PS_CONTACT_NUMBER;
        public String AOPS_CUSTOMER_ID;
        public String CLOSE_DATE;
        public String COMMENT;
        public String CONTACT_EMAIL;
        public String CONTACT_FNAME;
        public String CONTACT_LNAME;
        public String CONTACT_PHONE;
        public String CREATION_DATE;
        public String CUSTOMER_SHIP_ID;
        public String DELIVERY_CHARGE;
        public String LAST_UPDATE_DATE;
        public String LINK_TO_BSD_SITE;
        public String QUANTITY;
        public String QUOTE_ID;
        public String QUOTE_NAME;
        public String REMARKS;
        public String STATUS;
        public String SUBMITTER_EMAIL;
        public String SUBMITTER_FNAME;
        public String SUBMITTER_LNAME;
        public String SUBMITTER_PHONE;
        public String SUBMITTER_ROLE;
        public String SUBMITTER_USERNAME;
        public String TOTAL_AMOUNT;
        public String TOTAL_COST;
        public String TOTAL_RETAIL;
        private String[] A0PS_CONTACT_NUMBER_type_info = new String[]{'A0PS_CONTACT_NUMBER','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] AOPS_CUSTOMER_ID_type_info = new String[]{'AOPS_CUSTOMER_ID','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CLOSE_DATE_type_info = new String[]{'CLOSE_DATE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] COMMENT_type_info = new String[]{'COMMENT','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CONTACT_EMAIL_type_info = new String[]{'CONTACT_EMAIL','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CONTACT_FNAME_type_info = new String[]{'CONTACT_FNAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CONTACT_LNAME_type_info = new String[]{'CONTACT_LNAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CONTACT_PHONE_type_info = new String[]{'CONTACT_PHONE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CREATION_DATE_type_info = new String[]{'CREATION_DATE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] CUSTOMER_SHIP_ID_type_info = new String[]{'CUSTOMER_SHIP_ID','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] DELIVERY_CHARGE_type_info = new String[]{'DELIVERY_CHARGE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] LAST_UPDATE_DATE_type_info = new String[]{'LAST_UPDATE_DATE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] LINK_TO_BSD_SITE_type_info = new String[]{'LINK_TO_BSD_SITE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] QUANTITY_type_info = new String[]{'QUANTITY','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] QUOTE_ID_type_info = new String[]{'QUOTE_ID','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] QUOTE_NAME_type_info = new String[]{'QUOTE_NAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] REMARKS_type_info = new String[]{'REMARKS','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] STATUS_type_info = new String[]{'STATUS','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_EMAIL_type_info = new String[]{'SUBMITTER_EMAIL','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_FNAME_type_info = new String[]{'SUBMITTER_FNAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_LNAME_type_info = new String[]{'SUBMITTER_LNAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_PHONE_type_info = new String[]{'SUBMITTER_PHONE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_ROLE_type_info = new String[]{'SUBMITTER_ROLE','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] SUBMITTER_USERNAME_type_info = new String[]{'SUBMITTER_USERNAME','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] TOTAL_AMOUNT_type_info = new String[]{'TOTAL_AMOUNT','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] TOTAL_COST_type_info = new String[]{'TOTAL_COST','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] TOTAL_RETAIL_type_info = new String[]{'TOTAL_RETAIL','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'A0PS_CONTACT_NUMBER','AOPS_CUSTOMER_ID','CLOSE_DATE','COMMENT','CONTACT_EMAIL','CONTACT_FNAME','CONTACT_LNAME','CONTACT_PHONE','CREATION_DATE','CUSTOMER_SHIP_ID','DELIVERY_CHARGE','LAST_UPDATE_DATE','LINK_TO_BSD_SITE','QUANTITY','QUOTE_ID','QUOTE_NAME','REMARKS','STATUS','SUBMITTER_EMAIL','SUBMITTER_FNAME','SUBMITTER_LNAME','SUBMITTER_PHONE','SUBMITTER_ROLE','SUBMITTER_USERNAME','TOTAL_AMOUNT','TOTAL_COST','TOTAL_RETAIL'};
    }
    public class QuoteOperation_element {
        public soapQuoteupdate2.ServiceQuote serQuot;
        private String[] serQuot_type_info = new String[]{'serQuot','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'serQuot'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class QuoteOperationResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://soap.sforce.com/schemas/class/QuoteUpdate',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/QuoteUpdate','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
}