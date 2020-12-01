public class pricecalc {

	public String picst {get;set;}
	public String selected_option {get;set;}
	public String selected_value {get;set;}
	public String piadrseq {get;set;}
	public String piadrkey {get;set;}
	public String piloc {get;set;}
	public String pisk {get;set;}
	public String piqty {get;set;}

	public String SKU {get;set;}
	public String SKU_DESC {get;set;}
	public String INV_LOCATION {get;set;}
	public String SELLING_PRICE {get;set;}
	public String LIST_PRICE {get;set;}
	public String DEPARTMENT {get;set;}
	public String DEPARTMENT_DESC {get;set;}
	public String CLASS_DESC {get;set;}
	public String CLASS_x {get;set;}
	public String CLASS_SUB_DESC {get;set;}
	public String CLASS_SUB {get;set;}
	public String VENDOR {get;set;}
	public String VENDOR_NAME {get;set;}
	public String pomanufprd {get;set;}
	public String REPLENISHED {get;set;}
	public String FRAME_SKU {get;set;}
	public String IMPRINT_SKU {get;set;}
	public String VW {get;set;}
	public String STD_ASSORT {get;set;}
	public String WHL_SOURCE {get;set;}
	public String INSTOCK_QTY_AVAIL {get;set;}
	public String VW_QTY_AVAIL {get;set;}
	public String INSTOCK_QTY_ON_HAND {get;set;}
	public String VW_QTY_ON_HAND {get;set;}
	public String INSTOCK_QTY_RESERVED {get;set;}
	public String VW_QTY_RESERVED {get;set;}
	public String CAT_PAGE_CONTRACT {get;set;}
	public String RETAIL {get;set;}
	public String LAST_RECPT_DATE {get;set;}
	public String NEXT_RECPT_DATE {get;set;}
	public String NEXT_RECPT_QTY {get;set;}
	public String UNIT_OF_MEASURE {get;set;}
	public String COST_CODE {get;set;}
	public String COST {get;set;}
	public String PRICE_SOURCE {get;set;}
	public String CONTRACT_PLAN_ID {get;set;}
	public String GP_PCT {get;set;}
	public String MIN_GP_PCT {get;set;}
	public String MIN_DESC_PCT {get;set;}
	public String RETAIL_CONTRACT {get;set;}
	public String OFF_RETAIL {get;set;}
	public String OFF_CATALOG {get;set;}
	public String OFF_LIST {get;set;}
	public String COST_UP {get;set;}
	public String SUB_SELL_SKU {get;set;}
	public String MASTER_SKU_NUMBER {get;set;}
	public String MASTER_QTY {get;set;}
	public String posellpck {get;set;}
	public String QTY_D_D {get;set;}
	public String PROPRIETARY_ITEM {get;set;}
	public String CURRENCE_CODE {get;set;}
	public String RECYCLED_FLAG {get;set;}
	public String HANDICAP_FLAG {get;set;}
	public String MINORITY_BUS {get;set;}
	public String BULK_PRICED {get;set;}
	public String OVERSIZED_ITEM {get;set;}
	public String FOR_BRAND {get;set;}
	public String RETURNABLE_ITEM {get;set;}
	public String ADDITIONAL_DELIVERY_CHARGE {get;set;}
	public String BUNDLE_ITEM {get;set;}
	public String PREMIUIM_ITEM {get;set;}
	public String DROP_SHIP {get;set;}
	public String GSA_ITEM {get;set;}
	public String FURNITURE_ITEM {get;set;}
	public String CUSTOMER_NAME {get;set;}
	public String ADDRESS_LINE1 {get;set;}
	public String ADDRESS_LINE2 {get;set;}
	public String CITY {get;set;}
	public String STATE {get;set;}
	public String PROVICENCE {get;set;}
	public String ZIP {get;set;}
	public String COUNTRY {get;set;}
	public String poerror {get;set;}
	public String pocontplanseq {get;set;}
	public boolean display_result_panel {get;set;}

	public class PriceCheckException extends Exception{}


	public class price_values {
		public String poprdc;
		public String poides;
		public String podacp;
	}

	public pricecalc() {
		display_result_panel = false;
		picst = ApexPages.currentPage().getParameters().get('customerId');
	}

	public void process_price_calc() {
		try {
			display_result_panel = true;
			xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricer price = new xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricer ();
			xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element return_val = new xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element();
			//String jndi_db2 = 'jdbc/Db2PriceCalDs';
			/*String picst = '30900737';
			String piadrseq = '1';
			String piadrkey = '0';
			String piloc = '0';
			String pisk = '1';
			String piqty =  '10';*/

			if ('Inventory Location'.equals(selected_option))
				piloc = selected_value;
			else if ('Address Key'.equals(selected_option))
				piadrkey = selected_value;
			else if ('Address Sequence'.equals(selected_option))
				piadrseq = selected_value;

			if (picst.trim() == '' || pisk.trim() == '')
				throw new PriceCheckException('Customer Number and SKU Number Are Required Values');

			boolean custidcheck = pattern.matches('[0-9]+',picst);
			boolean skucheck = pattern.matches('[0-9]+',pisk);
			boolean qtycheck = true;
			boolean addressSeqChk = true;
			if (piadrseq != null) {
				if (piadrseq.trim() != '') {
					addressSeqChk = pattern.matches('[0-9]+',piadrseq);
				}
			}
			if (piqty != null)  {
				if (piqty.trim() != '') {
					qtycheck = pattern.matches('[0-9]+',piqty);
				}
			}

			if (!custidcheck) {
				display_result_panel = false;
				throw new PriceCheckException('Value for field \'Customer Number\' should be numeric');
			}
			if (!skucheck) {
				display_result_panel = false;
				throw new PriceCheckException('Value for field \'SKU Number\' should be numeric');
			}
			if (!qtycheck) {
				display_result_panel = false;
				throw new PriceCheckException('Value for field \'Quantity\' should be numeric');
			}
			if (!addressSeqChk) {
				display_result_panel = false;
				throw new PriceCheckException('Value for field \'Address Sequence\' should be numeric');
			}

			return_val = price.process(picst, piadrseq, piadrkey, piloc, pisk, piqty);
			price_values pv = new price_values();

			SKU=return_val.SKU;
			SKU_DESC=return_val.SKU_DESC;
			INV_LOCATION=return_val.INV_LOCATION;
			SELLING_PRICE=return_val.SELLING_PRICE;
			LIST_PRICE=return_val.LIST_PRICE;
			DEPARTMENT=return_val.DEPARTMENT;
			DEPARTMENT_DESC=return_val.DEPARTMENT_DESC;
			CLASS_DESC=return_val.CLASS_DESC;
			CLASS_x=return_val.CLASS_x;
			CLASS_SUB_DESC=return_val.CLASS_SUB_DESC;
			CLASS_SUB=return_val.CLASS_SUB;
			VENDOR=return_val.VENDOR;
			VENDOR_NAME=return_val.VENDOR_NAME;
			pomanufprd=return_val.pomanufprd;
			REPLENISHED=return_val.REPLENISHED;
			FRAME_SKU=return_val.FRAME_SKU;
			IMPRINT_SKU=return_val.IMPRINT_SKU;
			VW=return_val.VW;
			STD_ASSORT=return_val.STD_ASSORT;
			WHL_SOURCE=return_val.WHL_SOURCE;
			INSTOCK_QTY_AVAIL=return_val.INSTOCK_QTY_AVAIL;
			VW_QTY_AVAIL=return_val.VW_QTY_AVAIL;
			INSTOCK_QTY_ON_HAND=return_val.INSTOCK_QTY_ON_HAND;
			VW_QTY_ON_HAND=return_val.VW_QTY_ON_HAND;
			INSTOCK_QTY_RESERVED=return_val.INSTOCK_QTY_RESERVED;
			VW_QTY_RESERVED=return_val.VW_QTY_RESERVED;
			CAT_PAGE_CONTRACT=return_val.CAT_PAGE_CONTRACT;
			RETAIL=return_val.RETAIL;
			LAST_RECPT_DATE=return_val.LAST_RECPT_DATE;
			NEXT_RECPT_DATE=return_val.NEXT_RECPT_DATE;
			NEXT_RECPT_QTY=return_val.NEXT_RECPT_QTY;
			UNIT_OF_MEASURE=return_val.UNIT_OF_MEASURE;
			COST_CODE=return_val.COST_CODE;
			COST=return_val.COST;
			PRICE_SOURCE=return_val.PRICE_SOURCE;
			CONTRACT_PLAN_ID=return_val.CONTRACT_PLAN_ID;
			GP_PCT=return_val.GP_PCT;
			MIN_GP_PCT=return_val.MIN_GP_PCT;
			MIN_DESC_PCT=return_val.MIN_DESC_PCT;
			RETAIL_CONTRACT=return_val.RETAIL_CONTRACT;
			OFF_RETAIL=return_val.OFF_RETAIL;
			OFF_CATALOG=return_val.OFF_CATALOG;
			OFF_LIST=return_val.OFF_LIST;
			COST_UP=return_val.COST_UP;
			SUB_SELL_SKU=return_val.SUB_SELL_SKU;
			MASTER_SKU_NUMBER=return_val.MASTER_SKU_NUMBER;
			MASTER_QTY=return_val.MASTER_QTY;
			posellpck=return_val.posellpck;
			QTY_D_D=return_val.QTY_D_D;
			PROPRIETARY_ITEM=return_val.PROPRIETARY_ITEM;
			CURRENCE_CODE=return_val.CURRENCE_CODE;
			RECYCLED_FLAG=return_val.RECYCLED_FLAG;
			HANDICAP_FLAG=return_val.HANDICAP_FLAG;
			MINORITY_BUS=return_val.MINORITY_BUS;
			BULK_PRICED=return_val.BULK_PRICED;
			OVERSIZED_ITEM=return_val.OVERSIZED_ITEM;
			FOR_BRAND=return_val.FOR_BRAND;
			RETURNABLE_ITEM=return_val.RETURNABLE_ITEM;
			ADDITIONAL_DELIVERY_CHARGE=return_val.ADDITIONAL_DELIVERY_CHARGE;
			BUNDLE_ITEM=return_val.BUNDLE_ITEM;
			PREMIUIM_ITEM=return_val.PREMIUIM_ITEM;
			DROP_SHIP=return_val.DROP_SHIP;
			GSA_ITEM=return_val.GSA_ITEM;
			FURNITURE_ITEM=return_val.FURNITURE_ITEM;
			CUSTOMER_NAME=return_val.CUSTOMER_NAME;
			ADDRESS_LINE1=return_val.ADDRESS_LINE1;
			ADDRESS_LINE2=return_val.ADDRESS_LINE2;
			CITY=return_val.CITY;
			STATE=return_val.STATE;
			PROVICENCE=return_val.PROVICENCE;
			ZIP=return_val.ZIP;
			COUNTRY=return_val.COUNTRY;
			poerror=return_val.poerror;
			pocontplanseq=return_val.pocontplanseq;

			if (poerror != null && customer_name.trim() != '') {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Succeeded'));
			}
			else {
				if (poerror != null) {
					display_result_panel = false;
					throw new PriceCheckException('Data Could not be Retrieved for the Provided Input' + poerror);
				}
				else {
					display_result_panel = false;
					throw new PriceCheckException('Data Could not be Retrieved for the Provided Input');
				}
			}
		}
		catch (PriceCheckException ce) {
			display_result_panel = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
		}
		catch (Exception e) {
			display_result_panel = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error:'+e));
		}
	}

	@AuraEnabled
	public static xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element doPriceCheck(String customer_id, String address_sequence, String address_key, String inventory_location, String sku, String quantity){
		xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricer price = new xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricer ();
		try{
			xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element result = price.process(customer_id, address_sequence, address_key, inventory_location, sku, quantity);
			if(String.isBlank(result.poerror) && !String.isBlank(result.CUSTOMER_NAME))
				return result;
			throw new PriceCheckException(result.poerror);
		} catch (PriceCheckException e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			System.debug(LoggingLevel.ERROR, e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			System.debug(LoggingLevel.ERROR, e.getStackTraceString());
			throw new AuraHandledException('An unexpected error occured, please create a case and reference the actions you were taking when the error occured.');
		}
	}
}