/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QxAuraQuoteBundleController {
    global QxAuraQuoteBundleController() {

    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteBundleController.GetSyncStatusResponse getSyncStatus(String crmQuoteId) {
        return null;
    }
    @AuraEnabled
    global static Boolean isWaitScreenRequired(String crmQuoteId) {
        return null;
    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteBundleController.CPQxInfo openQuote(Id crmQuoteId) {
        return null;
    }
    @AuraEnabled
    global static CameleonCPQ.QxAuraQuoteBundleController.CPQxInfo retryQxProcess(String qxSharedCtxStr, String processId) {
        return null;
    }
global class CPQxInfo {
    global CameleonCPQ.QxQuoteUtil.QxQuoteProcessMessage message {
        get;
        set;
    }
    global Boolean mustRetry {
        get;
        set;
    }
    global String processId {
        get;
        set;
    }
    global Object qxSharedCtx {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global CPQxInfo() {

    }
}
global class GetSyncStatusResponse {
    global String status {
        get;
    }
    global GetSyncStatusResponse() {

    }
}
}
