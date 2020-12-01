/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQRequestFormatter {
    global CPQRequestFormatter() {

    }
    webService static List<String> executeCPQAction(Id entityId, String release, String operationType, String actionName, String soapUrl) {
        return null;
    }
    global static void printAndAttachQuoteDocument(Id quoteId) {

    }
    global static void refreshQuoteContent(Id quoteId) {

    }
    @Future(callout=true)
    global static void sendCPQRequest_asynchronous(Id entityId, Id newEntityId, String release, String operationType, String soapUrl) {

    }
    global static List<String> sendCPQRequest(CameleonCPQ.CPQRequestFormatter.ExecutionContext ec) {
        return null;
    }
    webService static List<String> sendCPQRequest(Id entityId, Id newEntityId, String release, String operationType, String soapUrl) {
        return null;
    }
global class CPQRequestException extends Exception {
}
global class CPQSessionSettings {
    global CPQSessionSettings() {

    }
    global String getBackAction() {
        return null;
    }
    global String getChannel() {
        return null;
    }
    global String getInitAction() {
        return null;
    }
    global String getMappingSetName() {
        return null;
    }
    global String getProposalUILayout() {
        return null;
    }
    global String getQuoteModelName() {
        return null;
    }
    global Integer getQuoteModelRelease() {
        return null;
    }
    global String getTheme() {
        return null;
    }
    global String getUILayout() {
        return null;
    }
    global Integer getUserGroupPolicy() {
        return null;
    }
    global void setBackAction(String backAction) {

    }
    global void setChannel(String channel) {

    }
    global void setInitAction(String initAction) {

    }
    global void setMappingSetName(String mappingSetName) {

    }
    global void setProposalUILayout(String proposalUILayout) {

    }
    global void setQuoteModelName(String quoteModelName) {

    }
    global void setQuoteModelRelease(Integer quoteModelRelease) {

    }
    global void setTheme(String theme) {

    }
    global void setUILayout(String UILayout) {

    }
    global void setUserGroupPolicy(Integer userGroupPolicy) {

    }
}
global class ExecutionContext {
    global ExecutionContext() {

    }
    global String getActionName() {
        return null;
    }
    global String getContentType() {
        return null;
    }
    global Id getEntityId() {
        return null;
    }
    global Id getNewEntityId() {
        return null;
    }
    global String getOperationType() {
        return null;
    }
    global String getRelease() {
        return null;
    }
    global String getSoapUrl() {
        return null;
    }
    global void setActionName(String actionName) {

    }
    global void setContentType(String contentType) {

    }
    global void setEntityId(Id entityId) {

    }
    global void setNewEntityId(Id newEntityId) {

    }
    global void setOperationType(String operationType) {

    }
    global void setRelease(String release) {

    }
    global void setSoapUrl(String soapUrl) {

    }
}
global interface IMappingIN {
    List<CameleonCPQ.CPQRequestFormatter.Tuple> getCPQCustomSettings(Id param0);
}
global interface IMappingIN_Ext1 extends CameleonCPQ.CPQRequestFormatter.IMappingIN {
    CameleonCPQ.CPQRequestFormatter.CPQSessionSettings getCPQSessionSettings(Id param0, CameleonCPQ.CPQRequestFormatter.CPQSessionSettings param1);
}
global class Tuple {
    global Tuple(String key, String value) {

    }
    global String getKey() {
        return null;
    }
    global String getValue() {
        return null;
    }
}
}
