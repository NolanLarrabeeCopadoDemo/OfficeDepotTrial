/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQQuotePanel_VFCtrl {
    @RemoteAction
    global static CameleonCPQ.CPQQuotePanel_VFCtrl.CPQInfo callCPQ(String quoId, String selectedTab) {
        return null;
    }
    @RemoteAction
    global static Id cloneQuote(String quoId, String activeRelease) {
        return null;
    }
    @RemoteAction
    global static CameleonCPQ.CPQQuotePanel_VFCtrl.CPQInfo cloneQuoteContent(String srcQuoId, String targetQuoId, String activeRelease, Boolean refresh) {
        return null;
    }
    @RemoteAction
    global static CameleonCPQ.CPQCLM_Utils.CLMInfo createContractFromQuote(CameleonCPQ.CPQCLM_Utils.ContractFromQuoteParameters cFqParams) {
        return null;
    }
    @RemoteAction
    global static CameleonCPQ.CPQCLM_Utils.ContractFromQuoteParameters getNewOptions() {
        return null;
    }
    @RemoteAction
    global static Boolean getSynchronized(String quoId) {
        return null;
    }
    @RemoteAction
    global static void setSynchronized(String quoId, Boolean synced) {

    }
global class CPQInfo {
    global String cpqErr {
        get;
        set;
    }
    global String cpqStatus {
        get;
        set;
    }
    global String cpqUrl {
        get;
        set;
    }
    global String objectId {
        get;
        set;
    }
    global CPQInfo() {

    }
}
}
