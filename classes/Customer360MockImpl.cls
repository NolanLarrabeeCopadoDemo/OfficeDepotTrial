@isTest
global class Customer360MockImpl implements WebServiceMock {
 global void doInvoke(
      Object stub,
      Object request,
      Map < String, Object > response,
      String endpoint,
      String soapAction,
      String requestName,
      String responseNS,
      String responseName,
      String responseType) {
      Customer360.ErrorMessageOutput_element erlo = new Customer360.ErrorMessageOutput_element();
      erlo.AdapterName = 'Test';
      erlo.ErrorCode = 'Test';
      erlo.ErrorSummary = 'Test';
      erlo.ErrorDetails = 'Test';
      erlo.ErrorType = 'Test';
      erlo.ErrorSeverity = 'Test';
      erlo.ErrorDate = System.now();
      List < Customer360.ErrorMessageOutput_element > erlolst = new List < Customer360.ErrorMessageOutput_element > ();
      erlolst.add(erlo);
      Customer360.ErrorMessage_element erl = new Customer360.ErrorMessage_element();
      erl.ErrorMessageOutput = erlolst;
    
      Customer360.SelectAOPSTaxInfoOutput_element serlo = new Customer360.SelectAOPSTaxInfoOutput_element();
      serlo.address_state = 'Test';
      serlo.country_code = 'Test';
      serlo.exp_date = 'Test';
      serlo.tax_status = 'Test';
      serlo.federal_exempt_flag = 'Test';
      serlo.tax_certif_nbr = 'Test';
      Customer360.SelectAOPSTaxInfoOutput_element[] serlolst = new List < Customer360.SelectAOPSTaxInfoOutput_element > ();
      serlolst.add(serlo);
      Customer360.AOPSTaxInfo_element serl = new Customer360.AOPSTaxInfo_element();
      serl.SelectAOPSTaxInfoOutput = serlolst;
    
    
      Customer360.DbSelectCustMstrDtlsOutput_element dserlo = new Customer360.DbSelectCustMstrDtlsOutput_element();
      dserlo.business_name = 'Test';
      dserlo.street_address1 = 'Test';
      dserlo.street_address2 = 'Test';
      dserlo.city = 'Test';
      dserlo.state = 'Test';
      dserlo.province = 'Test';
      dserlo.zip = 'Test';
      dserlo.country_code = 'Test';
      dserlo.tax_geo_code = '4';
      dserlo.addl_addr_ind = 'Test';
      dserlo.cust_comm_ind = 'Test';
      dserlo.addr_comm_ind = 'Test';
      dserlo.deliver_charge_code = 'Test';
      dserlo.furn_dlvry_fee = 'Test';
      dserlo.minimum_order_value = '4';
      dserlo.tax_exempt_type = 'Test';
      dserlo.tax_certif_ind = 'Test';
      dserlo.duns_nbr = '2';
      dserlo.credit_ind = 'Test';
      dserlo.cust_type = 'Test';
      dserlo.cont_retail_code = 'Test';
      dserlo.po_ind = 'Test';
      dserlo.brand = 'Test';
      dserlo.less_mail_flag = 'Test';
      dserlo.reporting_loc = 'Test';
      dserlo.salesperson_id = 'Test';
      dserlo.salesperson_name = 'Test';
      dserlo.reporting_ind = 'Test';
      dserlo.buying_group_ind = 'Test';
      dserlo.backorder_allow_flag = 'Test';
      dserlo.po_required_code = 'Test';
      dserlo.release_required_code = 'Test';
      dserlo.location_req_code = 'Test';
      dserlo.ship_to_required_code = 'Test';
      dserlo.location_ind = 'Test';
      dserlo.department_ind = 'Test';
      dserlo.release_ind = 'Test';
      dserlo.field_header_ind = 'Test';
      dserlo.rebate_ind = 'Test';
      dserlo.signature_req = 'Test';
      dserlo.customer_comm = 'Test';
      dserlo.contract_code = 'Test';
      dserlo.price_plan = '4';
      dserlo.price_plan_seq = '3';
      dserlo.price_plan_descr = 'Test';
      dserlo.off_contract_price_code = 'Test';
      dserlo.off_contrat_prct = '3';
      dserlo.wholesaler_price_code = 'Test';
      dserlo.wholesaler_price_discount_prct = '2';
      dserlo.minimum_discount = '2';
      dserlo.gp_floor = '3';
      dserlo.cost_code = 'Test';
      dserlo.substitute_allowed = 'Test';
      dserlo.fax_ship_confirmation = 'Test';
      dserlo.fax_po_code = 'Test';
      dserlo.fax_reorder_code = 'Test';
      dserlo.fax_inv_code = 'Test';
      dserlo.commission_flag = 'Test';
      dserlo.take_back_flag = 'Test';
      dserlo.product_xref_nbr = '5';
      dserlo.rest_key_code = 'Test';
      dserlo.reporting_contact = 'Test';
      dserlo.order_rest_ind = 'Test';
      dserlo.dept_required_code = 'Test';
      dserlo.spc_services_flag = 'Test';
      dserlo.ar_flag = 'Test';
      dserlo.hedberg_flag = 'Test';
      dserlo.registered_on_time = 'Test';
      dserlo.addl_salesperson_ind = 'Test';
      dserlo.report_dist_flag = 'Test';
      dserlo.cust_legal_agreement_flag = 'Test';
      dserlo.parent_name = 'Test';
      dserlo.createdate = System.today();
      dserlo.status = 'Test';
      dserlo.sic_code = 'Test';
      dserlo.segmentation = 'Test';
      dserlo.sector = 'Test';
      dserlo.cust_comment1 = 'Test';
      dserlo.cust_comment2 = 'Test';
      dserlo.cust_comment3 = 'Test';
      dserlo.comments_createdate = System.today();
      dserlo.customer_id = '4';
      dserlo.parent_id = '4';
      dserlo.prmry_cntct_salutation = 'Test';
      dserlo.prmry_cntct_fname = 'Test';
      dserlo.prmry_cntct_lname = 'Test';
      dserlo.prmry_phn_ctry_cd = '6';
      dserlo.prmry_phn_area_cd = '8';
      dserlo.prmry_phn_pfx = '0';
      dserlo.prmry_phn_nbr = '4';
      dserlo.prmry_phn_ext = '8';
      dserlo.prmry_cntct_auth_buyer = 'Test';
      dserlo.hold_retrn_ind = 'Test';
      dserlo.allow_prnt_on_dmnd = 'Test';
      dserlo.tech_block = 'Test';
      dserlo.line_limit = '9';
      dserlo.order_limit = '9';
      dserlo.pricing_tier = 'Test';
      dserlo.bsdfin_block = 'Test';
      dserlo.pro_cards = 'Test';
      dserlo.spc_cards = 'Test';
      // Customer360.DbSelectCustMstrDtlsOutput_element[] dserlolst=new List<Customer360.DbSelectCustMstrDtlsOutput_element>(); 
      //dserlolst.add(dserlo);      
      Customer360.AOPSCustMstrDtls_element dserl = new Customer360.AOPSCustMstrDtls_element();
      dserl.DbSelectCustMstrDtlsOutput = dserlo;
    
    
      Customer360.DbSelectAOPSPricingOutput_element dberlo = new Customer360.DbSelectAOPSPricingOutput_element();
      dberlo.core_item_price_list_id = 'Test';
      dberlo.core_item_price_list_pri_code = 'Test';
      dberlo.core_item_price_list_desc = 'Test';
      dberlo.start_date = System.today();
      dberlo.end_date = System.today() + 4;
      List < Customer360.DbSelectAOPSPricingOutput_element > dberlolst = new List < Customer360.DbSelectAOPSPricingOutput_element > ();
      dberlolst.add(dberlo);
      Customer360.AOPSCorePricing_element dberl = new Customer360.AOPSCorePricing_element();
      dberl.DbSelectAOPSPricingOutput = dberlolst;
      Customer360.DbSelectEbizBillContactsOutput_element dbsele = new Customer360.DbSelectEbizBillContactsOutput_element();
      Customer360.AOPSCustInstructions_element dbacc = new Customer360.AOPSCustInstructions_element();
      Customer360.DbSelectAOPSCustInstructionsOutput_element dbacc12 = new Customer360.DbSelectAOPSCustInstructionsOutput_element();
      Customer360.DbSelectEbizBillTermsOutput_element dbacc13 = new Customer360.DbSelectEbizBillTermsOutput_element();
      Customer360.DbSelectEbizARCollectorOutput_element dbacc124 = new Customer360.DbSelectEbizARCollectorOutput_element();
      Customer360.AOPSCustPrefs_element dbacc123 = new Customer360.AOPSCustPrefs_element();
      Customer360.EbizARBalances_element dbacc122 = new Customer360.EbizARBalances_element();
      Customer360.EbizGparent_element dbacc121 = new Customer360.EbizGparent_element();
      Customer360.AOPSUniversalPricing_element dbacc120 = new Customer360.AOPSUniversalPricing_element();
      Customer360.EbizBillTerms_element dbacc129 = new Customer360.EbizBillTerms_element();
      Customer360.DbCallAOPSCustPrefsOutput_element dbacc130 = new Customer360.DbCallAOPSCustPrefsOutput_element();
      Customer360.EbizARCollector_element dbacc139 = new Customer360.EbizARCollector_element();
      Customer360.DbSelectUnivPricingOutput_element dbacc140 = new Customer360.DbSelectUnivPricingOutput_element();
      Customer360.DbSelectAOPSCustVhclsOutput_element dbacc149 = new Customer360.DbSelectAOPSCustVhclsOutput_element();
      Customer360.DbSelectAOPSCustTierDiscOutput_element dbacc147 = new Customer360.DbSelectAOPSCustTierDiscOutput_element();
      Customer360.EbizBillContacts_element dbacc148 = new Customer360.EbizBillContacts_element();
    
      Customer360.DbSelectEbizGparentOutput_element db11 = new Customer360.DbSelectEbizGparentOutput_element();
      Customer360.DbSelectEbizARBalancesOutput_element db22 = new Customer360.DbSelectEbizARBalancesOutput_element();
      Customer360.DbSelectEbizCreditLimitsOutput_element db33 = new Customer360.DbSelectEbizCreditLimitsOutput_element();
      Customer360.AOPSCustVhcls_element db44 = new Customer360.AOPSCustVhcls_element();
      Customer360.AOPSCustTierDisc_element db332 = new Customer360.AOPSCustTierDisc_element();
      Customer360.EbizCreditLimits_element db442 = new Customer360.EbizCreditLimits_element();
    
      Customer360.processResponse_element respElement = new Customer360.processResponse_element();
      respElement.customer_name = 'Mock response';
      respElement.ErrorMessage = erl;
      respElement.AOPSTaxInfo = serl;
      respElement.AOPSCustMstrDtls = dserl;
      respElement.AOPSCorePricing = dberl;
      response.put('response_x', respElement);
 }
}