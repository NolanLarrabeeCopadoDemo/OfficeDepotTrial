/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QxAuraQuoteProcessController {
    global QxAuraQuoteProcessController() {

    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteProcessController.GetSyncStatusResponse getSyncStatus(String crmQuoteId) {
        return null;
    }
    @AuraEnabled
    @Deprecated
    global static CameleonCPQ.QxAuraQuoteProcessController.GetUIContentResponse getUIContent(String qxSessionCtx, String stepId) {
        return null;
    }
    @AuraEnabled
    global static Boolean isWaitScreenRequired(String crmQuoteId) {
        return null;
    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteProcessController.OpenQuoteResponse openQuote(Id crmQuoteId) {
        return null;
    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteProcessController.OpenQuoteResponse openQuoteWithSharing(String qxSharedCtxStr) {
        return null;
    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteProcessController.RefreshContextResponse refreshContext(String qxSessionCtx, String editedFields) {
        return null;
    }
global class GetSyncStatusResponse {
    global String status {
        get;
    }
    global GetSyncStatusResponse() {

    }
}
global class GetUIContentRequest {
    global String htmlContent {
        get;
    }
    global String initUrl {
        get;
    }
    global GetUIContentRequest() {

    }
}
global class GetUIContentResponse {
    global String htmlContent {
        get;
    }
    global String initUrl {
        get;
    }
    global GetUIContentResponse() {

    }
}
global class OpenQuoteResponse {
    global String htmlContent {
        get;
    }
    global CameleonCPQ.QxSessionContext qxSessionContext {
        get;
    }
    global List<CameleonCPQ.QxQuoteStep> steps {
        get;
    }
    global Boolean success {
        get;
    }
    global OpenQuoteResponse() {

    }
}
global class RefreshContextResponse {
    global List<CameleonCPQ.QxQuoteStep> steps {
        get;
    }
    global Boolean success {
        get;
    }
    global RefreshContextResponse() {

    }
}
}
