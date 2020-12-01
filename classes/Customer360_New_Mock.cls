@IsTest
public with sharing class Customer360_New_Mock implements HttpCalloutMock
{
	/**
	 * These are the endpoints.
	 */
	final String AOPSGhostCard_ENDPOINT             = Customer360_New.AOPSGhostCard_ENDPOINT;
	final String AOPSFreightCharge_ENDPOINT         = Customer360_New.AOPSFreightCharge_ENDPOINT;
	final String AOPSDeliveryChargeCode_ENDPOINT    = Customer360_New.AOPSDeliveryChargeCode_ENDPOINT;
	final String AOPSItemRestrictionCode_ENDPOINT   = Customer360_New.AOPSItemRestrictionCode_ENDPOINT;
	final String AOPSCustomerInstructions_ENDPOINT  = Customer360_New.AOPSCustomerInstructions_ENDPOINT;
	final String AOPSCustomerTierDiscounts_ENDPOINT = Customer360_New.AOPSCustomerTierDiscounts_ENDPOINT;
	final String AOPSCorePricing_ENDPOINT           = Customer360_New.AOPSCorePricing_ENDPOINT;
	final String AOPSUniversalPricing_ENDPOINT      = Customer360_New.AOPSUniversalPricing_ENDPOINT;
	final String AOPSCustomerVehicles_ENDPOINT      = Customer360_New.AOPSCustomerVehicles_ENDPOINT;
	final String AOPSCustomerPreferences_ENDPOINT   = Customer360_New.AOPSCustomerPreferences_ENDPOINT;
	final String AOPSTaxInformation_ENDPOINT        = Customer360_New.AOPSTaxInformation_ENDPOINT;
	final String AOPSCustomerMasterDetails_ENDPOINT = Customer360_New.AOPSCustomerMasterDetails_ENDPOINT;
	final String EbizGetCustomerInfo_ENDPOINT       = Customer360_New.EbizCustomerInformation_ENDPOINT;

	/**
	 * These are the mocked JSON responses.
	 */
	final String AOPSGhostCardResponse              = '{"AOPSGhostCard":[{"HAS_GHOSTCARD":"N"}]}';
	final String AOPSFreightChargeResponse          = '{"AOPSFreightCharge":[{"CCU007F_FREIGHT_CHG_REQ_FLAG":"N"}]}';
	final String AOPSDeliveryChargeCodeResponse     = '{"AOPSDlvChargeCode":[{"DLV_CODE":"061"}]}';
	final String AOPSItemRestrictionCodeResponse    = '{"AOPSItemRestrictionCode":[{"REST_CODE_E_I":"E"}]}';
	final String AOPSCustomerInstructionsResponse   = '{"AOPSCustInstructions":[{"COMMENT_CODE":"MFS","COMMENT":"THIS CUSTOMER RECEIVES TUESDAY DELIVERIES ONLY!! DO NOT PROCESS FOR","CODE_DESCRIPTION":"Driver\'s Manifest"}]}';
	final String AOPSCustomerTierDiscountResponse   = '{"AOPSCustTierDisc":[{"FROM_AMT":100,"TO_AMT":500,"PERCENT_DISC":0.02}]}';
	final String AOPSCorePricingResponse            = '{"AOPSCorePricing":[{"CORE_ITEM_PRICE_LIST_ID":"2013676-0","CORE_ITEM_PRICE_LIST_PRI_CODE":"W","CORE_ITEM_PRICE_LIST_DESC":"STD BW COPIES PLAN C","START_DATE":"2004-06-25","END_DATE":null},{"CORE_ITEM_PRICE_LIST_ID":"2013681-0","CORE_ITEM_PRICE_LIST_PRI_CODE":"X","CORE_ITEM_PRICE_LIST_DESC":"STD CPC FINISHING SVCS PLAN N","START_DATE":"2004-06-25","END_DATE":null},{"CORE_ITEM_PRICE_LIST_ID":"2013690-0","CORE_ITEM_PRICE_LIST_PRI_CODE":"Y","CORE_ITEM_PRICE_LIST_DESC":"STD COLOR COPIES PLAN C","START_DATE":"2004-06-25","END_DATE":null}]}';
	final String AOPSUniversalPricingResponse       = '{"AOPSUnivPricing":[{"UNIV_PRICING_PROG_CODE":"BUSMACH   ","UNIV_PRICING_DISCOUNT":0,"UNIV_PRICING_EXCLUDE":"Y"},{"UNIV_PRICING_PROG_CODE":"MEDICAL   ","UNIV_PRICING_DISCOUNT":0,"UNIV_PRICING_EXCLUDE":"Y"},{"UNIV_PRICING_PROG_CODE":"MISC      ","UNIV_PRICING_DISCOUNT":0,"UNIV_PRICING_EXCLUDE":"Y"},{"UNIV_PRICING_PROG_CODE":"TECH      ","UNIV_PRICING_DISCOUNT":0,"UNIV_PRICING_EXCLUDE":"Y"}]}';
	final String AOPSCustomerVehiclesResponse       = '{"AOPSCustVhcls":[{"VHCL_CODE":"ML","VHCL_DESC":"Mail"}]}';
	final String AOPSCustomerPreferencesResponse    = '{"AOPSCustPrefs":[{"code":"BSDADS","publicFlag":"","value":"0"}]}';
	final String AOPSTaxInformationResponse         = '{"AOPSTaxInfo":[{"ADDRESS_STATE":"  ","COUNTRY_CODE":"USA","EXP_DATE":"2005-04-11","TAX_STATUS":"Expired","FEDERAL_EXEMPT_FLAG":"N","TAX_CERTIF_NBR":"Temp Certif         "}]}';
	final String AOPSCustomerMasterDetailsResponse  = '{"AOPSCustMstrDtls":[{"BUSINESS_NAME":"LOAD TEST","STREET_ADDRESS1":"2100 S CONGRESS AVE","STREET_ADDRESS2":"","CITY":"DELRAY BEACH","STATE":"FL","PROVINCE":"","ZIP":"334457340","COUNTRY_CODE":"USA","TAX_GEO_CODE":100990370,"ADDL_ADDR_IND":"Y","CUST_COMM_IND":"N","ADDR_COMM_IND":"N","DELIVER_CHARGE_CODE":null,"FURN_DLVRY_FEE":"Y","MINIMUM_ORDER_VALUE":0,"FREIGHT_CHG_REQ_FLAG":"N","TAX_EXEMPT_TYPE":" ","TAX_CERTIF_IND":"N","DUNS_NBR":0,"CREDIT_IND":"Y","CUST_TYPE":"RG","CONT_RETAIL_CODE":"C","PO_IND":"N","BRAND":"OD","LESS_MAIL_FLAG":"Y","REPORTING_LOC":"1081","SALESPERSON_ID":"S301006","SALESPERSON_NAME":"OLD (10/12 SALTAFORMAGGIO","REPORTING_IND":"Y","BUYING_GROUP_IND":"N","BACKORDER_ALLOW_FLAG":"Y","PO_REQUIRED_CODE":"May be entered in OE","RELEASE_REQUIRED_CODE":"May be entered in OE","LOCATION_REQ_CODE":"Hidden in OE","SHIP_TO_REQUIRED_CODE":"Y","LOCATION_IND":"N","DEPARTMENT_IND":"Y","RELEASE_IND":"N","FIELD_HEADER_IND":"N","REBATE_IND":"N","SIGNATURE_REQ":"Y","CUSTOMER_COMM":"N","CONTRACT_CODE":"N","PRICE_PLAN":0,"PRICE_PLAN_SEQ":0,"PRICE_PLAN_DESCR":"Anthony Test","OFF_CONTRACT_PRICE_CODE":"R","OFF_CONTRAT_PRCT":0.1,"WHOLESALER_PRICE_CODE":"L","WHOLESALER_PRICE_DISCOUNT_PRCT":0.12,"MINIMUM_DISCOUNT":0,"GP_FLOOR":0.05,"COST_CODE":"T","SUBSTITUTE_ALLOWED":"Y","FAX_SHIP_CONFIRMATION":"Y","FAX_PO_CODE":"N","FAX_REORDER_CODE":"N","FAX_INV_CODE":"N","COMMISSION_FLAG":"Y","TAKE_BACK_FLAG":"Y","PRODUCT_XREF_NBR":0,"REST_KEY_CODE":" ","REPORTING_CONTACT":"               ","ORDER_REST_IND":"N","DEPT_REQUIRED_CODE":"May be Entered in OE     ","SPC_SERVICES_FLAG":"N","AR_FLAG":"Y","HEDBERG_FLAG":"E","REGISTERED_ON_TIME":"N","ADDL_SALESPERSON_IND":"N","REPORT_DIST_FLAG":"N","CUST_LEGAL_AGREEMENT_FLAG":"N","PARENT_NAME":"THE BRINKMAN GROUP INC        ","CREATEDATE":"2010-10-06","STATUS":"A","SIC_CODE":"        ","SEGMENTATION":"Large     ","SECTOR":"                         ","CUST_COMMENT1":"","CUST_COMMENT2":"","CUST_COMMENT3":"","COMMENTS_CREATEDATE":null,"CUSTOMER_ID":58989528,"PARENT_ID":59001118,"PRMRY_CNTCT_SALUTATION":"","PRMRY_CNTCT_FNAME":"FA58989528-MAIN","PRMRY_CNTCT_LNAME":"LA58989528","PRMRY_PHN_CTRY_CD":1,"PRMRY_PHN_AREA_CD":200,"PRMRY_PHN_PFX":59,"PRMRY_PHN_NBR":8349,"PRMRY_PHN_EXT":0,"PRMRY_CNTCT_AUTH_BUYER":"Y","HOLD_RETRN_IND":" ","ALLOW_PRNT_ON_DMND":"Y","TECH_BLOCK":" ","LINE_LIMIT":0,"ORDER_LIMIT":0,"PRICING_TIER":"Regular","BSDFIN_BLOCK":"N","PRO_CARDS":"N","SPC_CARDS":"N"}]}';
	final String EbizGetCustomerInfoResponse        = '{"pcustout":{"agingbuckettab":{"agingbuckettabitem":[{"accountnumber":"49142","acctestdate":"1999/09/22 00:00:00","aopsnum":"28996244-00001-A0","collectorcode":"887002","creditlimit":700000,"curr":122.39,"custaccountid":56582,"disputedtotalaged":0,"partyname":"GOOGLE INC","partynumber":"3450536","paymentterms":"MTON230000N030","pd130":0,"pd181365":-298.43,"pd3160":0,"pd366":0,"pd6190":3272.67,"pd91180":120318.74,"totaldue":123415.37},{"accountnumber":"363534","acctestdate":"2005/05/17 00:00:00","aopsnum":"40813682-00001-A0","collectorcode":"887002","creditlimit":1,"curr":0,"custaccountid":377194,"disputedtotalaged":0,"partyname":"GOOGLE PRINTING","partynumber":"12798812","paymentterms":"MTON230000N030","pd130":0,"pd181365":4520.59,"pd3160":0,"pd366":0,"pd6190":12198.83,"pd91180":175873.58,"totaldue":192593},{"accountnumber":"365696","acctestdate":"2004/05/13 00:00:00","aopsnum":"38540444-00001-A0","collectorcode":"887002","creditlimit":1,"curr":1996.71,"custaccountid":379356,"disputedtotalaged":0,"partyname":"GOOGLE INTERNET SUPPLY ACCT","partynumber":"12779818","paymentterms":"MTON230000N030","pd130":0,"pd181365":-129.38,"pd3160":0,"pd366":0,"pd6190":7507.89,"pd91180":107952.39,"totaldue":117327.61},{"accountnumber":"369724","acctestdate":"2005/05/05 00:00:00","aopsnum":"40752907-00001-A0","collectorcode":"751481","creditlimit":1,"curr":0,"custaccountid":383384,"disputedtotalaged":0,"partyname":"GOOGLE PO","partynumber":"12797669","paymentterms":"MTON230000N030","pd130":0,"pd181365":8261.69,"pd3160":0,"pd366":0,"pd6190":0,"pd91180":0,"totaldue":8261.69},{"accountnumber":"42382173","acctestdate":"2017/11/06 00:00:00","aopsnum":"86703221-00001-A0","collectorcode":"887002","creditlimit":1,"curr":0,"custaccountid":43155704,"disputedtotalaged":0,"partyname":"GOOGLE X","partynumber":"198290967","paymentterms":"MTON230000N030","pd130":0,"pd181365":4031.2,"pd3160":0,"pd366":0,"pd6190":0,"pd91180":7049.61,"totaldue":11080.81}]},"arcollectortab":{"arcollectortabitem":[]},"creditlimtstab":{"creditlimtstabitem":[]},"ebillcontacttab":{"ebillcontacttabitem":[{"contactpointtype":"KUMAR","emailaddress":"AP","extension":"866","jobtitle":"ANIL","lastname":"382506603","partyid":170771187,"phoneareacode":"Telephone","phonecountrycode":"GEN","phonelntype":"PHONE","phonenumber":"1","preferredflag":"48342","primarycontactpoint":"2014670","salutation":"DUN"},{"contactpointtype":"KUMAR","emailaddress":"AP","extension":"866","jobtitle":"ANIL","lastname":"411599577","partyid":177804348,"phoneareacode":"Telephone","phonecountrycode":"GEN","phonelntype":"PHONE","phonenumber":"1","preferredflag":"48342","primarycontactpoint":"2014670","salutation":"DUN"},{"contactpointtype":"KUMAR","emailaddress":"AP","extension":"866","jobtitle":"ANIL","lastname":"529308546","partyid":209359748,"phoneareacode":"Telephone","phonecountrycode":"GEN","phonelntype":"PHONE","phonenumber":"1","preferredflag":"48342","primarycontactpoint":"2014670","salutation":"DUN"},{"contactpointtype":"KUMAR","emailaddress":"AP","extension":"866","jobtitle":"ANIL","lastname":"627353702","partyid":235607621,"phoneareacode":"Telephone","phonecountrycode":"GEN","phonelntype":"PHONE","phonenumber":"1","preferredflag":"48342","primarycontactpoint":"2014670","salutation":"DUN"},{"contactpointtype":"SPENCER","emailaddress":"AP","extension":"650","jobtitle":"CINDY","lastname":"712521073","partyid":259516426,"phoneareacode":"Telephone","phonecountrycode":"GEN","phonelntype":"PHONE","phonenumber":"1","primarycontactpoint":"2536986","salutation":"DUN"}]},"grandparenttab":{"grandparenttabitem":[{"gpid":611,"gpname":"Google","origsystemreference":"28996244-00001-A0"}]},"paymenttermstab":{"paymenttermstabitem":[{"abbillingflag":"Y","address1":"PO BOX 2050","billdocsautoreprint":"N","billdocsdeliverymeth":"ELEC","billdocsdirectflag":"Y","billdocsdoctype":"Consolidated Bill","billdocsefffromdate":"2009-06-21 00:00:00.0","billdocssigreq":"Y","city":"MOUNTAIN VIEW","country":"US","county":"SANTA CLARA","locationid":699114,"paymentterm":"Net 30","paytermfrequency":"MNTH","paytermpercentage":"30","paytermreportingday":"23","postalcode":"940422050","state":"CA"}]}}}';

	/**
	 * This is a map of the endpoint -> JSON response.
	 */
	Map<String, String> endpointToResponseMap = new Map<String, String>
	{
		AOPSGhostCard_ENDPOINT              => AOPSGhostCardResponse,
		AOPSFreightCharge_ENDPOINT          => AOPSFreightChargeResponse,
		AOPSDeliveryChargeCode_ENDPOINT     => AOPSDeliveryChargeCodeResponse,
		AOPSItemRestrictionCode_ENDPOINT    => AOPSItemRestrictionCodeResponse,
		AOPSCustomerInstructions_ENDPOINT   => AOPSCustomerInstructionsResponse,
		AOPSCustomerTierDiscounts_ENDPOINT  => AOPSCustomerTierDiscountResponse,
		AOPSCorePricing_ENDPOINT            => AOPSCorePricingResponse,
		AOPSUniversalPricing_ENDPOINT       => AOPSUniversalPricingResponse,
		AOPSCustomerVehicles_ENDPOINT       => AOPSCustomerVehiclesResponse,
		AOPSCustomerPreferences_ENDPOINT    => AOPSCustomerPreferencesResponse,
		AOPSTaxInformation_ENDPOINT         => AOPSTaxInformationResponse,
		AOPSCustomerMasterDetails_ENDPOINT  => AOPSCustomerMasterDetailsResponse,
		EbizGetCustomerInfo_ENDPOINT        => EbizGetCustomerInfoResponse
	};

	/**
	 * This method sends the appropriate JSON response based on
	 * the endpoint in the HttpRequest by using the map created above.
	 */
	public HttpResponse respond(HttpRequest req)
	{
		String url = req.getEndpoint();
		String endpoint = url.substring(url.lastIndexOf('/') + 1);
		String responseBody = endpointToResponseMap.get(endpoint);

		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(responseBody);
		res.setStatusCode(200);

		return res;
	}
}