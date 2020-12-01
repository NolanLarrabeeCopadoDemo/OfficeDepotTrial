/*************************************************************
*Name : ProductDataUtils
*Created By : Akash (Appirio Off)
*Created Date : 27th july,2011
*Purpose : To calculate roundOffs and Total for each column
****************************************************************/
public with sharing class ProductDataUtils {
  public static sObject roundOffValues(sObject obj,list<String> lstCategoryApi) {
    for(String fieldName : lstCategoryApi) {
      if((Decimal)obj.get(fieldName+'TY__c') != null) {
        obj.put(fieldName+'TY__c',((Decimal)obj.get(fieldName+'TY__c')).round());        
      }
      	
      if((Decimal)obj.get(fieldName+'LY__c') != null) {        
        obj.put(fieldName+'LY__c',((Decimal)obj.get(fieldName+'LY__c')).round());        
      }
      
      if((Decimal)obj.get(fieldName+'POT__c') != null) {
        obj.put(fieldName+'POT__c',((Decimal)obj.get(fieldName+'POT__c')).round());        
      }           
    }
    return obj;
  }  
  
  public static Map<String,OpportunityLineItem> calculateTotals(sObject obj,list<String> lstCategoryApi,Map<String,OpportunityLineItem> mpCategoryAmount,Map<String,OpportunityLineItem> mpTotalAmount) {
    for(String fieldName : lstCategoryApi) {
      if((Decimal)obj.get(fieldName+'TY__c') != null) {       
       OpportunityLineItem item = mpTotalAmount.get('TY Sales');
       item.TotalPrice += (Decimal)obj.get(fieldName+'TY__c');       
      }
      	
      if((Decimal)obj.get(fieldName+'LY__c') != null) {        
        OpportunityLineItem item = mpTotalAmount.get('LY Sales');
        item.TotalPrice += (Decimal)obj.get(fieldName+'LY__c');        
      }
      
      if((Decimal)obj.get(fieldName+'POT__c') != null) {
        OpportunityLineItem item = mpTotalAmount.get('Potential');
        item.TotalPrice += (Decimal)obj.get(fieldName+'POT__c');        
      }
      
      if((Decimal)obj.get(fieldName+'Diff__c') != null) {
        OpportunityLineItem item = mpTotalAmount.get('Difference');
        item.TotalPrice += (Decimal)obj.get(fieldName+'Diff__c');
      }            
    }
    OpportunityLineItem item = mpTotalAmount.get('Open');
    for(OpportunityLineItem lineItem : mpCategoryAmount.values()) {
      if(lineItem.TotalPrice != null) {         	        	           
        item.TotalPrice += lineItem.TotalPrice;       
      }
    } 
    return mpTotalAmount;
  }
  
  //==================================================================//
  //To test the functionality of ProductDataUtils class
  //==================================================================//
  @isTest
  private static void Test_ProductDataUtils() {
  	list<String> lstCategoryApi = new list<String>();
  	lstCategoryApi.add('Furniture_');
  	
  	Account acc = Test_Utils.CreateAccount();
  	acc.Furniture_LY__c = 1.6; 
  	acc.Furniture_TY__c = 1;
  	acc.Furniture_POT__c = 1.5;
  	
  	sObject obj = ProductDataUtils.roundOffValues(acc, lstCategoryApi);
  	  	
  	// To check whether figures are rounded off or not
  	system.assertEquals((Decimal)obj.get('Furniture_TY__c'), 1);
  	system.assertEquals((Decimal)obj.get('Furniture_LY__c'), 2);
  	system.assertEquals((Decimal)obj.get('Furniture_POT__c'), 2);  	
  	
  	OpportunityLineItem item = new OpportunityLineItem(TotalPrice=10);
  	Map<String,OpportunityLineItem> mpCategoryAmount = new Map<String,OpportunityLineItem>();
  	mpCategoryAmount.put('TY Sales',item);
  	Map<String,OpportunityLineItem> mpTotalAmount = new Map<String,OpportunityLineItem>();
  	mpTotalAmount.put('TY Sales',item);
  	mpTotalAmount.put('LY Sales',item);
  	mpTotalAmount.put('Potential',item);
  	mpTotalAmount.put('Difference',item);
  	mpTotalAmount.put('Open',item);
  	
  	Map<String,OpportunityLineItem> totalAmtMap = ProductDataUtils.calculateTotals(acc, lstCategoryApi, mpCategoryAmount, mpTotalAmount);
  	  	
  	//To check the result returned by calculate totals method
  	system.assertEquals(totalAmtMap.get('Difference').TotalPrice,30);
  	system.assertEquals(totalAmtMap.get('LY Sales').TotalPrice,30);
  	system.assertEquals(totalAmtMap.get('TY Sales').TotalPrice,30);
  }
  
}