/*
 * Copyright (c) 2015 - 2019 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 */
 
/**
 * CPQx Import Quote Data.
 *
 * @author rderval
 */
public with sharing class QxCPQImportQuoteData {

    /** 
     * Import Quote Data
     *
     * @param crmQuoteId The Salesforce PROS Quote identifier.
     * @param qxQuoteId The CPQx Quote identifier.
     */
    @future (callout=true)
    public static void execute(final Id crmQuoteId, final String qxQuoteId, final String docName, String JsonString, String JsonDeletionString) {
       Document[] doc = [SELECT Body FROM Document WHERE Name=: docName];
       if(doc.size()>0 || JsonString.length()>0) {
          final CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx = new CameleonCPQ.QxApiClient.QxRequestContext();
          qxReqCtx.crmQuoteId = crmQuoteId;
          qxReqCtx.qxQuoteId = qxQuoteId;
       
          // Init Qx session
          final CameleonCPQ.QxApiClient.InitSessionResponse response1 = CameleonCPQ.QxApiClient.InitSession(new CameleonCPQ.QxApiClient.InitSessionRequest());
          if(response1.qxException!=null) {
             throw new QxImportQuoteDataException(response1.qxException);
          }
          qxReqCtx.sessionId = response1.sessionId;
          qxReqCtx.authToken = response1.authToken;
          if (qxReqCtx.sessionId!=null) {
              qxReqCtx.requestId = qxReqCtx.sessionId.replace('-',''); // Use sessionId as requestId
          }
       
          CameleonCPQ.QxApiClient.ImportQuoteRequest request = new CameleonCPQ.QxApiClient.ImportQuoteRequest();
          request.qxReqCtx = qxReqCtx;
          //Proceed with Json import if Json String parameter not empty and Excel import if it is
           if(JsonString.length()>0){
               request.fileName = 'Import_Json.json';
               if(JsonDeletionString.length()>0){
                   request.fileContent = Blob.valueOf(JsonDeletionString); 
               }else{
                   request.fileContent = Blob.valueOf(jsonString); 
               }
                
           }else{
               request.fileName = 'Import_Lines.xlsx';
               request.fileContent = doc[0].body;               
           }

          request.fileMimeType = 'application/octet-stream';
          request.updatePolicy = null;
          request.insertPosition = null;
          request.insertPoint = null;
          request.country = null;
          request.language = null;
          request.dataProviderName = null;
          request.defaultFolderRowTemplate = null;
          request.defaultSpecificRowTemplate = null;
       
          // Import Quote Data           
          final CameleonCPQ.QxApiClient.ImportQuoteResponse response2 = CameleonCPQ.QxApiClient.importQuote(request);
          if(response2.qxException!=null) {
             throw new QxImportQuoteDataException(response2.qxException);
          }
           
          //Wait for command to be completed 
          Boolean importCompleted = QxCPQQuoteHelper.waitCommandCompletion(qxReqCtx,response2.Id);
          
           if(importCompleted){
               if(JsonDeletionString.length()>0){
                   System.debug('Inherited CPT Deletion Import successfully completed');
                   request.fileContent = Blob.valueOf(jsonString);
                   
                   // Import Quote Data           
                   final CameleonCPQ.QxApiClient.ImportQuoteResponse response3 = CameleonCPQ.QxApiClient.importQuote(request);
                   if(response3.qxException!=null) {
                       throw new QxImportQuoteDataException(response3.qxException);
                   }
                   
                   //Wait for command to be completed 
                   if(QxCPQQuoteHelper.waitCommandCompletion(qxReqCtx,response3.Id))
  						System.debug('Inherited CPT Import successfully completed');
               }else if (JsonString.length()>0){

                   System.debug('Inherited CPT Import successfully completed');
                   
                   // Proceed with quote synchronization for initial import
                   // Step 1 : Retrieving already created Quote Context Object
                   // Step 2 :Refresh the context
                   final CameleonCPQ.QxApiClient.RefreshContextRequest apiRequest2 = new CameleonCPQ.QxApiClient.RefreshContextRequest();
                   apiRequest2.qxReqCtx = qxReqCtx;
                   final CameleonCPQ.QxApiClient.RefreshContextResponse apiResponse2 = CameleonCPQ.QxApiClient.refreshContext(apiRequest2);
                   if (apiResponse2.statusCode>=400) {
                       throw new QxImportQuoteDataException(apiResponse2.qxException);
                   }
                   
                   // Step 3 :Refresh the quote
                   final CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest apiRequest3 = new CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest();
                   apiRequest3.qxReqCtx = qxReqCtx;
                   apiRequest3.actionType = CameleonCPQ.QxApiClient.QuoteActionType.REFRESH;
                   apiRequest3.actionName = 'REFRESH_ALL_HIDDEN';
                   final CameleonCPQ.QxApiClient.ExecuteQuoteActionResponse apiResponse3 = CameleonCPQ.QxApiClient.executeQuoteAction(apiRequest3);
                   if (apiResponse3.statusCode>=400) {
                       throw new QxImportQuoteDataException('Unable to refresh quote',apiResponse3.qxException);
                   }
                   
                   // Step 4 :Synchronize the quote
                   final CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest apiRequest4 = new CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest();
                   apiRequest4.qxReqCtx = qxReqCtx;
                   apiRequest4.actionType = CameleonCPQ.QxApiClient.QuoteActionType.SYNCHRONIZE;
                   apiRequest4.actionName = 'SFDC_SYNCHRO';
                   final CameleonCPQ.QxApiClient.ExecuteQuoteActionResponse apiResponse4 = CameleonCPQ.QxApiClient.executeQuoteAction(apiRequest4);
                   
                   if (apiResponse4.statusCode>=400) {
                       throw new QxImportQuoteDataException('Unable to synchronize the quote',apiResponse4.qxException);
                   }
                   
               }
           }
           
          
       }
    }

    
    /**
     * 
    Build Json format for Quote Line import
    */
    public static string buildJsonFormat(List<Contract_Pricing_Terms__c> cpts,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        String jsonReturn = '';
        
        JSONGenerator jsonGen = JSON.createGenerator(true);
        //Start writting Json Object
        jsonGen.writeStartObject();
        
        /***Generation Definition****/
        jsonGen.writeFieldName('definition');
        
        //Build ColumnDefinitions
        buildJsonColumnDefinitions(jsonGen);
 
        /***Fields Values****/
        jsonGen.writeFieldName('fields');
        jsonGen.writeStartObject();
        jsonGen.writeEndObject();
        
        /***UserInput Fields Values****/
        jsonGen.writeFieldName('userInputfields');
        jsonGen.writeStartObject();
        jsonGen.writeEndObject();
        
        /***Row Values****/
        jsonGen.writeFieldName('rows');
        
        //Define all rows to be imported in a Json Array
        jsonGen.writeStartArray();
        
        //Loop through all CPT line item to write them into Json Import
        Integer count  = 0;
        For(Contract_Pricing_Terms__c cpt : cpts){
            //Import CPT at the Department Group level
            count++;
            buildJsonRowValues_InheritedPerDeptGrp(jsonGen, count, cpt,customerNbs,customerNames,contractAccountLevels,contractNbs);
            
            //Import as well CPT lines at the department level
            List<Map<String,Object>> deptLevelCpts = expandCPTAtDeptLevel(cpt);
            
            for(Map<String,Object> deptLevelCpt : deptLevelCpts){
                count++;
                buildJsonRowValues_InheritedPerDept(jsonGen, count, deptLevelCpt,customerNbs,customerNames,contractAccountLevels,contractNbs);
            }
        }
        //buildJsonRowValues(jsonGen, 1, null);
        
        jsonGen.writeEndArray();
        //END : Row Array
        
        jsonGen.writeEndObject();
        //END  : Json Object
        
        jsonReturn = jsonGen.getAsString();
        System.debug('FINAL JSON : ' + jsonReturn);
        
        //Close JsonGenerator instance
        jsonGen.close();
        
        return jsonReturn;        
    }
    
    public static void buildJsonColumnDefinitions(JSONGenerator jsonGen){
        
        jsonGen.writeStartObject();
        // 1 - columnDefinitions
        jsonGen.writeFieldName('columnDefinitions');
        
        //Define all columns to be imported in a Json Array
        jsonGen.writeStartArray();
        
        //Name
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_ITEM');
        jsonGen.writeStringField('translation', 'Name'); 
        jsonGen.writeStringField('type', 'BUSINESS'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Row Type
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_TYPE');
        jsonGen.writeStringField('translation', 'Row type'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Row Template
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_TEMPLATE');
        jsonGen.writeStringField('translation', 'Row template'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        
        //Comp_Effective_date_of_this_language
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Effective_date_of_this_language');
        jsonGen.writeStringField('translation', 'First Column'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Department Group
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Department_Group');
        jsonGen.writeStringField('translation', 'Department Group'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Price Lock
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Initial_Freeze_Period');
        jsonGen.writeStringField('translation', 'Price Lock'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Addition communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Addition_Communication_req');
        jsonGen.writeStringField('translation', 'Addition communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Deletion communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Deletion_Communication_req');
        jsonGen.writeStringField('translation', 'Deletion communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Alternate restrictions
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Alternate_Restrictions');
        jsonGen.writeStringField('translation', 'Alternate restrictions'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //DISCO communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_DISCO_Communication_req');
        jsonGen.writeStringField('translation', 'DISCO communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Additional DISCO action
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Additional_Disco_act');
        jsonGen.writeStringField('translation', 'Additional DISCO action'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Are Price increase capped?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Is_Price_Increase_Capped');
        jsonGen.writeStringField('translation', 'Are Price increase capped?'); 
        jsonGen.writeStringField('type', 'BOOLEAN'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Cap Type
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Cap_Type');
        jsonGen.writeStringField('translation', 'Cap Type'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
         //Cap percentage
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Cap_Perc');
        jsonGen.writeStringField('translation', 'Cap percentage'); 
        jsonGen.writeStringField('type', 'PERCENTAGE'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Required Timing of CC Updates
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Req_Timing_CC_Updates');
        jsonGen.writeStringField('translation', 'Required Timing of CC Updates'); 
        jsonGen.writeStringField('type', 'INTEGER'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Vendor letter required for core increase?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Vendor_Letter_Req');
        jsonGen.writeStringField('translation', 'Vendor letter required for core increase?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
         //Vendor letter required for core increase?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Vendor_Letter_Req');
        jsonGen.writeStringField('translation', 'Vendor letter required for core increase?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Price Change Notice (in days)
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_CC_Price_Change_Reqd');
        jsonGen.writeStringField('translation', 'Price Change Notice (in days)'); 
        jsonGen.writeStringField('type', 'BOOLEAN'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Communication Req'd for Price Changes?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Is_Comm_Reqd');
        jsonGen.writeStringField('translation', 'Communication Req\'d for Price Changes?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
                                 
        //Decrease communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Decrease_Communication_req');
        jsonGen.writeStringField('translation', 'Decrease communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();

        jsonGen.writeEndArray();
        //END : Define all columns to be imported in a Json Array
        
        jsonGen.writeEndObject();
        //END  : 1 - columnDefinitions
    }
    
    public static void buildJsonRowValues_InheritedPerDeptGrp(JSONGenerator jsonGen, Integer count, Contract_Pricing_Terms__c cpt,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        Date effDate = null;
        
        //Write Row Value in Object        
        jsonGen.writeStartObject();
        
        //Write Header values
        jsonGen.writeStringField('rowId', String.valueOf(count));
        jsonGen.writeStringField('lineItemTemplateId', 'InheritedComplianceLT'); 
        jsonGen.writeStringField('rowParentId', '0'); 

        //Write Cells Values
        jsonGen.writeFieldName('cells');
        jsonGen.writeStartObject();
        
        //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', cpt.Name);
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', cpt.Name); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedComplianceLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', ((cpt.Price_Incr_Cap_Amt__c != null && cpt.Price_Incr_Cap_Type_Unit__c=='%' ) ? cpt.Price_Incr_Cap_Amt__c/100 : 0));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if(cpt.Department_Groups__c != null && cpt.Department_Groups__c != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '' );       
            jsonGen.writeEndObject(); 
        }
        //END - Comp_Department_Group

        //Comp_Department
        if(cpt.Departments__c != null && cpt.Departments__c != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            //if(cpt.Departments__c != null && cpt.Departments__c.length() >= 254){
            //   jsonGen.writeStringField('string', cpt.Departments__c.substring(0,254));      
            //}else{
               jsonGen.writeStringField('string', cpt.Departments__c != null ? cpt.Departments__c : '' );      
            //}              
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.In_days__c != null ? cpt.In_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		if (cpt.Price_Incr_Cap_App_Level__c != null &&  !cpt.Price_Incr_Cap_App_Level__c.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');       
			jsonGen.writeEndObject();
		}

        //END - Cap Level

        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get(cpt.Contract__c) != null ? contractAccountLevels.get(cpt.Contract__c) : '');       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get(cpt.Contract__c));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get(cpt.Contract__c));         
        jsonGen.writeEndObject();        
        //END - Contract Nb
        
        //Effective Date of this language
        if(cpt.Effective_Date_of_this_language__c!= null){
            effDate = cpt.Effective_Date_of_this_language__c;
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        } 

        
        //END - Write Cells Values
        jsonGen.writeEndObject();
        
        //UserInputCells
        jsonGen.writeFieldName('userInputCells');
        jsonGen.writeStartObject();  
        
                //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', cpt.Name);
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', cpt.Name); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedComplianceLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', ((cpt.Price_Incr_Cap_Amt__c != null && cpt.Price_Incr_Cap_Type_Unit__c=='%') ? cpt.Price_Incr_Cap_Amt__c/100 : 0));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if(cpt.Department_Groups__c != null && cpt.Department_Groups__c != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '' );       
            jsonGen.writeEndObject(); 
        }
        //END - Comp_Department_Group

        //Comp_Department
        if(cpt.Departments__c != null && cpt.Departments__c != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            //if(cpt.Departments__c != null && cpt.Departments__c.length() >= 254){
            //   jsonGen.writeStringField('string', cpt.Departments__c.substring(0,254));      
            //}else{
               jsonGen.writeStringField('string', cpt.Departments__c != null ? cpt.Departments__c : '' );      
            //}
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
                
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.In_days__c != null ? cpt.In_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		if (cpt.Price_Incr_Cap_App_Level__c != null &&  !cpt.Price_Incr_Cap_App_Level__c.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get(cpt.Contract__c) != null ? contractAccountLevels.get(cpt.Contract__c) : '');       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get(cpt.Contract__c));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(cpt.Effective_Date_of_this_language__c!= null){
            effDate = cpt.Effective_Date_of_this_language__c;
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        } 
        
         //END - Write User Input Cells Values
        jsonGen.writeEndObject();    
        
        //Grid Row Type
        jsonGen.writeStringField('gridRowType', 'SPECIFIC');

        
        //END - Write Row Value in Object
        jsonGen.writeEndObject();
    }
    
    public static void buildJsonRowValues_InheritedPerDept(JSONGenerator jsonGen, Integer count, Map<String,Object> mapDeptCpt,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        Date effDate = null;
        
        //Write Row Value in Object        
        jsonGen.writeStartObject();
        
        //Write Header values
        jsonGen.writeStringField('rowId', String.valueOf(count));
        jsonGen.writeStringField('lineItemTemplateId', 'InheritedCompliancePerDeptLT'); 
        jsonGen.writeStringField('rowParentId', '0'); 

        //Write Cells Values
        jsonGen.writeFieldName('cells');
        jsonGen.writeStartObject();
        
        //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', (String)mapDeptCpt.get('Name'));
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', (String)mapDeptCpt.get('Name')); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedCompliancePerDeptLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', (DECIMAL)mapDeptCpt.get('Comp_Cap_Perc'));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Initial_Freeze_Period'));       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if((String)mapDeptCpt.get('Comp_Department_Group') != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department_Group'));       
            jsonGen.writeEndObject();   
        }
        //END - Comp_Department_Group

        //Comp_Department
        if((String)mapDeptCpt.get('Comp_Department') != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department'));       
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Freq_Price_Increases'));       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_CC_Price_Change_Reqd'));       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Is_Comm_Reqd'));       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Addition_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Deletion_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Vendor_Letter_Req'));       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', (Boolean)mapDeptCpt.get('Comp_Is_Price_Increase_Capped'));       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		String capLevel = (String)mapDeptCpt.get('Comp_Cap_Level');
		if (capLevel != null &&  !capLevel.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', capLevel);       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(mapDeptCpt.get('Effective_Date_of_this_language')!= null){
            effDate = (Date)mapDeptCpt.get('Effective_Date_of_this_language');
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        }
        
        //END - Write Cells Values
        jsonGen.writeEndObject();
        
        //UserInputCells
        jsonGen.writeFieldName('userInputCells');
        jsonGen.writeStartObject();  
        
                 //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', (String)mapDeptCpt.get('Name'));
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', (String)mapDeptCpt.get('Name')); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedCompliancePerDeptLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', (DECIMAL)mapDeptCpt.get('Comp_Cap_Perc'));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Initial_Freeze_Period'));       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if((String)mapDeptCpt.get('Comp_Department_Group') != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department_Group'));       
            jsonGen.writeEndObject();   
        }
        //END - Comp_Department_Group

        //Comp_Department
        if((String)mapDeptCpt.get('Comp_Department') != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department'));       
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Freq_Price_Increases'));       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_CC_Price_Change_Reqd'));       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Is_Comm_Reqd'));       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Addition_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Deletion_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Vendor_Letter_Req'));       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', (Boolean)mapDeptCpt.get('Comp_Is_Price_Increase_Capped'));       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		capLevel = (String)mapDeptCpt.get('Comp_Cap_Level');
		if (capLevel != null &&  !capLevel.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', capLevel);       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(mapDeptCpt.get('Effective_Date_of_this_language')!= null){
            effDate = (Date)mapDeptCpt.get('Effective_Date_of_this_language');
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        }
        
         //END - Write User Input Cells Values
        jsonGen.writeEndObject();    
        
        //Grid Row Type
        jsonGen.writeStringField('gridRowType', 'SPECIFIC');

        
        //END - Write Row Value in Object
        jsonGen.writeEndObject();
    }
    
    public static List<Map<String,Object>> expandCPTAtDeptLevel(Contract_Pricing_Terms__c cpt){
        List<Map<String,Object>> deptLevelCpts = new List<Map<String,Object>>();
        String[] departments;
        String departmentCode;
        
        //Generate a Map for each department in the CPT that will contain all CPT information then return Map as result
        if(cpt.Departments__c != null){
            departments = cpt.Departments__c.split(';');
            for(String department : departments){
                //Get Department Code Ex: 89
                departmentCode = department.split(' - ')[0];
                //Add prefix to match CPQ data : DP - 89
                departmentCode = 'DP - ' + departmentCode;
                //Convert 2 characters one digit code into 1 character one digit code (Ex: DP - 01 ==> DP - 1)
                departmentCode = departmentCode.replaceFirst('DP - 0', 'DP - ');
                
                Map<String,Object> deptLevelCpt = new Map<String,Object>();
                
                //Populate Map with current CPT info
                deptLevelCpt.put('Name', cpt.Name);
                deptLevelCpt.put('Comp_Department', departmentCode);
                deptLevelCpt.put('Comp_Department_Group', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '');
                deptLevelCpt.put('Comp_Initial_Freeze_Period', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_Freq_Price_Increases', cpt.In_days__c != null ? cpt.In_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_CC_Price_Change_Reqd', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_Is_Comm_Reqd', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');
                deptLevelCpt.put('Comp_Vendor_Letter_Req', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');
                deptLevelCpt.put('Comp_Addition_Communication_req', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');
                deptLevelCpt.put('Comp_Deletion_Communication_req', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');
                deptLevelCpt.put('Comp_Is_Price_Increase_Capped', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);
                deptLevelCpt.put('Comp_Cap_Type', 'Other');
                deptLevelCpt.put('Comp_Cap_Perc', ((cpt.Price_Incr_Cap_Amt__c != null  && cpt.Price_Incr_Cap_Type_Unit__c=='%')? cpt.Price_Incr_Cap_Amt__c/100 : 0));
                deptLevelCpt.put('Comp_Cap_Level', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');
                //deptLevelCpt.put('Comp_Account_Level', cpt.Account_Level__c != null ? cpt.Account_Level__c : '');
                deptLevelCpt.put('ContractId', cpt.Contract__c);
                deptLevelCpt.put('Effective_Date_of_this_language', cpt.Effective_Date_of_this_language__c);
                
                //Add Department CPT Map to List
                deptLevelCpts.add(deptLevelCpt);
                
            }
        }
        return deptLevelCpts;
    }
    
    
    public static string buildJsonFormatDeletion(CameleonCPQ__QxQuote__c quote){
        
        //Build Deletion JSON Import on those Row Ids
        String jsonReturn = '';
        //Substring to remove from External Line Id to retrieve Row Id
        String subStrToRemove = quote.Id + '-';
        
        //Get list of Inherited CPTs from quote
        List<CameleonCPQ__QxQuoteLine__c> inheritedCPTs = [SELECT Id, Name,CameleonCPQ__ExternalLineId__c,CameleonCPQ__LineTemplateId__c,Comp_Department__c,CameleonCPQ__ItemName__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c =: quote.Id AND CameleonCPQ__LineTemplateId__c LIKE '%Inherited%'];
        
        //If the current quote does not have an account hierarchy with active CPTs, we query its parents CPTs in the case that the quote is a clone to attempt to remove those CPTs as well
        if(inheritedCPTs.size()<=0 && quote.Clone_Parent__c != null){
            List<CameleonCPQ__QxQuoteLine__c> cloneInheritedCPTs = [SELECT Id, Name,CameleonCPQ__ExternalLineId__c,CameleonCPQ__LineTemplateId__c,Comp_Department__c,CameleonCPQ__ItemName__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c =: quote.Clone_Parent__c AND CameleonCPQ__LineTemplateId__c LIKE '%Inherited%'];
			inheritedCPTs.addAll(cloneInheritedCPTs);
            
            subStrToRemove = quote.Clone_Parent__c + '-';
        }
        //Extract Set of CPQ row ids from Inherited CPT List
        Set<String> rowIdSet = new Set<String>();
        Map<String,String> lTperRowId = new Map<String,String>();
        Map<String,String> depPerRowId = new Map<String,String>();
        Map<String,String> namePerRowId = new Map<String,String>();
        Map<String,String> descrPerRowId = new Map<String,String>();
        
        for(CameleonCPQ__QxQuoteLine__c inheritedCPT : inheritedCPTs){
            rowIdSet.add(inheritedCPT.CameleonCPQ__ExternalLineId__c.remove(subStrToRemove));
            
            lTperRowId.put(inheritedCPT.CameleonCPQ__ExternalLineId__c.remove(subStrToRemove),inheritedCPT.CameleonCPQ__LineTemplateId__c);
            depPerRowId.put(inheritedCPT.CameleonCPQ__ExternalLineId__c.remove(subStrToRemove),inheritedCPT.Comp_Department__c);
            namePerRowId.put(inheritedCPT.CameleonCPQ__ExternalLineId__c.remove(subStrToRemove),inheritedCPT.CameleonCPQ__ItemName__c);
            descrPerRowId.put(inheritedCPT.CameleonCPQ__ExternalLineId__c.remove(subStrToRemove),inheritedCPT.Name);
        }
        
		//ONly build Json if there are rows to delete
        if(!rowIdSet.isEmpty()){
            JSONGenerator jsonGen = JSON.createGenerator(true);
            //Start writting Json Object
            jsonGen.writeStartObject();
            
            /***Generation Definition****/
            jsonGen.writeFieldName('definition');
            jsonGen.writeStartObject();
            jsonGen.writeEndObject();
            
            /***Fields Values****/
            jsonGen.writeFieldName('fields');
            jsonGen.writeStartObject();
            jsonGen.writeEndObject();
            
            /***UserInput Fields Values****/
            jsonGen.writeFieldName('userInputfields');
            jsonGen.writeStartObject();
            jsonGen.writeEndObject();
            
            /***Row Values****/
            jsonGen.writeFieldName('rows');
            
            //Define all rows to be imported in a Json Array
            jsonGen.writeStartArray();
            
            //Loop through all CPT line item to write them into Json Import
            Integer count  = 0;
            for(String rowId : rowIdSet){
                //Write Row Value in Object        
                jsonGen.writeStartObject();
                
                //Write Header values
                jsonGen.writeStringField('rowId', rowId);
                jsonGen.writeStringField('lineItemTemplateId', lTperRowId.get(rowId)); 
                jsonGen.writeStringField('rowParentId', '0'); 
                
                //Write Cells Values
                jsonGen.writeFieldName('cells');
                jsonGen.writeStartObject();
                
                //Row Template
                jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
                jsonGen.writeStartObject();
                jsonGen.writeStringField('string', lTperRowId.get(rowId));       
                jsonGen.writeEndObject();
                //END - Row Template
                
                //Row Template
                jsonGen.writeFieldName('_SYS_ROW_CHANGE_MARK');
                jsonGen.writeStartObject();
                jsonGen.writeStringField('string', 'DELETED');       
                jsonGen.writeEndObject();
                //END - Row Template
                
                //Row Type
                jsonGen.writeFieldName('_SYS_ROW_TYPE');
                jsonGen.writeStartObject();
                jsonGen.writeStringField('string', 'SPECIFIC');       
                jsonGen.writeEndObject();
                //END - Row Type
                
                //Name        
                jsonGen.writeFieldName('_SYS_ROW_ITEM');
                jsonGen.writeStartObject();
                
                jsonGen.writeFieldName('business');
                jsonGen.writeStartObject();
                jsonGen.writeStringField('name', namePerRowId.get(rowId));
                jsonGen.writeStringField('type', 'SPECIFIC'); 
                jsonGen.writeStringField('description', descrPerRowId.get(rowId)); 
                jsonGen.writeEndObject();
                
                jsonGen.writeEndObject();
                //END - Name
                
                //Department (Primary Key)
                jsonGen.writeFieldName('Comp_Department');
                jsonGen.writeStartObject();
                jsonGen.writeStringField('string', depPerRowId.get(rowId));       
                jsonGen.writeEndObject();
                
                
                //END - Write Cells Values
                jsonGen.writeEndObject();
                
                //Write UserInput Cells Values
                jsonGen.writeFieldName('userInputCells');
                jsonGen.writeStartObject();
                //END - Write UserInputCells Values
                jsonGen.writeEndObject();
                
                //Grid Row Type
                jsonGen.writeStringField('gridRowType', 'SPECIFIC');
                
                //END - Write Row Values
                jsonGen.writeEndObject();
            }
            //buildJsonRowValues(jsonGen, 1, null);
            
            jsonGen.writeEndArray();
            //END : Row Array
            
            jsonGen.writeEndObject();
            //END  : Json Object
            
            jsonReturn = jsonGen.getAsString();
            System.debug('FINAL DELETION JSON : ' + jsonReturn);
            
            //Close JsonGenerator instance
            jsonGen.close();
        }

        return jsonReturn;        
    }    
    
    
    /**
     * Exception class.
     */
    public class QxImportQuoteDataException extends Exception {}

}