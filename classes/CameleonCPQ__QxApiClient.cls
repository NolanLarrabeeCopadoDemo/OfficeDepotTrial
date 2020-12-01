/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QxApiClient {
    global QxApiClient() {

    }
    global static CameleonCPQ.QxApiClient.ActivateQuoteResponse activateQuote(CameleonCPQ.QxApiClient.ActivateQuoteRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.ChangeQuoteStatusResponse changeQuoteStatus(CameleonCPQ.QxApiClient.ChangeQuoteStatusRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.CloneQuoteResponse cloneQuote(CameleonCPQ.QxApiClient.CloneQuoteRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.CloseSessionResponse closeSession(CameleonCPQ.QxApiClient.CloseSessionRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.CreateQuoteResponse createQuote(CameleonCPQ.QxApiClient.CreateQuoteRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.ExecuteQuoteActionResponse executeQuoteAction(CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GenerateQuoteReportResponse generateQuoteReport(CameleonCPQ.QxApiClient.GenerateQuoteReportRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetCommandStatusResponse getCommandStatus(CameleonCPQ.QxApiClient.GetCommandStatusRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.PushContextRequest getCrmContextRequest(Id entityId, CameleonCPQ.QxApiClient.QxSetup qSetup) {
        return null;
    }
    @Deprecated
    global static CameleonCPQ.QxApiClient.PushContextRequest getCrmContextRequest(Id entityId, String mappingSetName) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.PushContextRequest getCrmContextRequest(Id entityId, CameleonCPQ.QxApiClient.QxSetup qSetup, List<String> contextKeys) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.PullExportResponse getExportTrunk(CameleonCPQ.QxApiClient.PullExportRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteActionsResponse getQuoteActions(CameleonCPQ.QxApiClient.GetQuoteActionsRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteExportStatusResponse getQuoteExportStatus(CameleonCPQ.QxApiClient.GetQuoteExportStatusRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteReportResponse getQuoteReport(CameleonCPQ.QxApiClient.GetQuoteReportRequest request) {
        return null;
    }
    @Deprecated
    global static CameleonCPQ.QxApiClient.GetQuoteReportActionsResponse getQuoteReportActions(CameleonCPQ.QxApiClient.GetQuoteReportActionsRequest wrappedRequest) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteReportStatusResponse getQuoteReportStatus(CameleonCPQ.QxApiClient.GetQuoteReportStatusRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteStateResponse getQuoteState(CameleonCPQ.QxApiClient.GetQuoteStateRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.QxApiException getQxException(String qxException) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.QxSetup getQxSetup(String crmQuoteId) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.QxSetup getQxSetup(String crmQuoteId, String recordTypeId) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetStepsResponse getSteps(CameleonCPQ.QxApiClient.GetStepsRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.GetQuoteUIContentResponse getUIContent(CameleonCPQ.QxApiClient.GetQuoteUIContentRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.ImportQuoteResponse importQuote(CameleonCPQ.QxApiClient.ImportQuoteRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.InitSessionResponse initSession(CameleonCPQ.QxApiClient.InitSessionRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.LogDependenciesResponse logDependencies(CameleonCPQ.QxApiClient.LogDependenciesRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.LogMessageResponse logMessage(CameleonCPQ.QxApiClient.LogMessageRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.OpenQuoteResponse openQuote(CameleonCPQ.QxApiClient.OpenQuoteRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.PushDataResponse pushData(CameleonCPQ.QxApiClient.PushDataRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.RefreshContextResponse refreshContext(CameleonCPQ.QxApiClient.RefreshContextRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.SetQuoteFieldResponse setQuoteField(CameleonCPQ.QxApiClient.SetQuoteFieldRequest request) {
        return null;
    }
    global static CameleonCPQ.QxApiClient.UpdateFrozenFlagResponse updateFrozenFlag(CameleonCPQ.QxApiClient.UpdateFrozenFlagRequest request) {
        return null;
    }
global class ActivateQuoteRequest extends CameleonCPQ.QxApiClient.QxRequest {
    global ActivateQuoteRequest() {

    }
}
global class ActivateQuoteResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String status {
        get;
    }
    global ActivateQuoteResponse() {

    }
}
global class AppPortalAuthToken {
    global AppPortalAuthToken() {

    }
    global AppPortalAuthToken(CameleonCPQ.QxApiClient.QxApiClientSettings settings) {

    }
    global String create() {
        return null;
    }
}
global class ChangeQuoteStatusRequest extends CameleonCPQ.QxApiClient.QxRequest {
    global CameleonCPQ.QxApiClient.ChangeQuoteStatusRequestBody requestBody {
        get;
        set;
    }
    global ChangeQuoteStatusRequest() {

    }
}
global class ChangeQuoteStatusRequestBody {
    global String quoteStatusValue {
        get;
        set;
    }
    global ChangeQuoteStatusRequestBody() {

    }
}
global class ChangeQuoteStatusResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global ChangeQuoteStatusResponse() {

    }
}
global class CloneQuoteRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.CloneQuoteRequestBody requestBody {
        get;
        set;
    }
    global CloneQuoteRequest() {

    }
}
global class CloneQuoteRequestBody {
    global String description {
        get;
        set;
    }
    global CloneQuoteRequestBody() {

    }
}
global class CloneQuoteResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global CloneQuoteResponse() {

    }
}
global class CloseSessionRequest {
    global List<String> quoteIds {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global CloseSessionRequest() {

    }
}
global class CloseSessionResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global CloseSessionResponse() {

    }
}
global enum CommandStatus {Failed, InProgress, Ready}
global class ContextValue {
    global String key {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.value value {
        get;
        set;
    }
    global Object value_V830 {
        get;
        set;
    }
    global ContextValue(String key, CameleonCPQ.QxApiClient.value value) {

    }
    global ContextValue(String key, Object value) {

    }
}
global class CreateQuoteRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global Boolean updQxQuoteId {
        get;
        set;
    }
    global CreateQuoteRequest() {

    }
}
global class CreateQuoteResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global CreateQuoteResponse() {

    }
}
global class CrmObjectAttributes {
    global String currencyCode {
        get;
        set;
    }
    global String locale {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String qxModelId {
        get;
        set;
    }
    global String qxQuoteId {
        get;
        set;
    }
    global CrmObjectAttributes() {

    }
}
global class DebugFactory {
    global DebugFactory() {

    }
}
global enum DependencyTargetType {API, HTTP, SQL}
global class ExecuteQuoteActionRequest {
    global String actionName {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QuoteActionType actionType {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global ExecuteQuoteActionRequest() {

    }
}
global class ExecuteQuoteActionResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String qxApiResponse {
        get;
    }
    global ExecuteQuoteActionResponse() {

    }
}
global enum ExportStatus {Failed, InProgress, Ready}
global class GenerateQuoteReportBody {
    global String actionName {
        get;
        set;
    }
    global GenerateQuoteReportBody() {

    }
}
global class GenerateQuoteReportRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.GenerateQuoteReportBody requestBody {
        get;
        set;
    }
    global GenerateQuoteReportRequest() {

    }
}
global class GenerateQuoteReportResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String reportId {
        get;
    }
    global GenerateQuoteReportResponse() {

    }
}
global class GetCommandStatusRequest extends CameleonCPQ.QxApiClient.QxRequest {
    global String correlationId {
        get;
        set;
    }
    global GetCommandStatusRequest() {

    }
}
global class GetCommandStatusResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global Object additionalInfo {
        get;
    }
    global CameleonCPQ.QxApiClient.QxErrorMessage errorMessage {
        get;
    }
    global String status {
        get;
    }
    global String taskId {
        get;
    }
    global GetCommandStatusResponse() {

    }
}
global class GetQuoteActionsRequest {
    global CameleonCPQ.QxApiClient.QuoteActionType actionType {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global GetQuoteActionsRequest() {

    }
}
global class GetQuoteActionsResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global List<CameleonCPQ.QxApiClient.QuoteAction> actions {
        get;
    }
    global GetQuoteActionsResponse() {

    }
}
global class GetQuoteExportStatusRequest {
    global String exportId {
        get;
        set;
    }
    global Integer partNumber {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global GetQuoteExportStatusRequest() {

    }
}
global class GetQuoteExportStatusResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String status {
        get;
    }
    global GetQuoteExportStatusResponse() {

    }
}
global class GetQuoteReportActionsRequest {
    global String country {
        get;
        set;
    }
    global String language {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global GetQuoteReportActionsRequest() {

    }
}
global class GetQuoteReportActionsResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global List<CameleonCPQ.QxApiClient.QuoteReportAction> actions {
        get;
    }
    global GetQuoteReportActionsResponse() {

    }
}
global class GetQuoteReportRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global String reportId {
        get;
        set;
    }
    global GetQuoteReportRequest() {

    }
}
global class GetQuoteReportResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String fileType {
        get;
    }
    global Blob reportBody {
        get;
    }
    global GetQuoteReportResponse() {

    }
}
global class GetQuoteReportStatusRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global String reportId {
        get;
        set;
    }
    global GetQuoteReportStatusRequest() {

    }
}
global class GetQuoteReportStatusResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String status {
        get;
    }
    global GetQuoteReportStatusResponse() {

    }
}
global class GetQuoteStateRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global GetQuoteStateRequest() {

    }
}
global class GetQuoteStateResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String status {
        get;
    }
    global GetQuoteStateResponse() {

    }
}
global class GetQuoteUIContentRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global String returnUrl {
        get;
        set;
    }
    global String stepId {
        get;
        set;
    }
    global GetQuoteUIContentRequest() {

    }
}
global class GetQuoteUIContentResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String qxUIContent {
        get;
    }
    global GetQuoteUIContentResponse() {

    }
}
global class GetStepsRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global GetStepsRequest() {

    }
}
global class GetStepsResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String description {
        get;
    }
    global String quoteId {
        get;
    }
    global String quoteModelName {
        get;
    }
    global List<CameleonCPQ.QxApiClient.QuoteStep> steps {
        get;
    }
    global GetStepsResponse() {

    }
}
global interface IDebug {
    void debug(String param0);
    void debug(String param0, String param1);
    String getLoggingFileName(Id param0);
    String getLoggingLevel();
}
global interface IDebugV829 extends CameleonCPQ.QxApiClient.IDebug {
    void logMessage(CameleonCPQ.QxApiClient.QxRequestContext param0, CameleonCPQ.QxApiClient.LogLevel param1, String param2);
}
global class ImportQuoteRequest {
    global String country {
        get;
        set;
    }
    global String dataProviderName {
        get;
        set;
    }
    global String defaultFolderRowTemplate {
        get;
        set;
    }
    global String defaultSpecificRowTemplate {
        get;
        set;
    }
    global String defaultWorkspace {
        get;
        set;
    }
    global Blob fileContent {
        get;
        set;
    }
    global String fileMimeType {
        get;
        set;
    }
    global String fileName {
        get;
        set;
    }
    global String insertPoint {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QuoteImportPosition insertPosition {
        get;
        set;
    }
    global String language {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QuoteImportReplacementType replacementType {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QuoteImportUpdatePolicy updatePolicy {
        get;
        set;
    }
    global ImportQuoteRequest() {

    }
}
global class ImportQuoteResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global ImportQuoteResponse() {

    }
}
global class InitSessionRequest {
    global CameleonCPQ.QxApiClient.QxApiClientOverride apiClientOverride {
        set;
    }
    global InitSessionRequest() {

    }
}
global class InitSessionResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String authToken {
        get;
        set;
    }
    global String sessionId {
        get;
        set;
    }
    global InitSessionResponse() {

    }
}
global class LogDependenciesRequest {
    global CameleonCPQ.QxApiClient.QxLogDependenciesRequest qxLogDependenciesRequest {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global LogDependenciesRequest() {

    }
}
global class LogDependenciesResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global LogDependenciesResponse() {

    }
}
global enum LogLevel {ERROR, INFO, WARN}
global class LogMessageRequest {
    global CameleonCPQ.QxApiClient.QxLogMessageRequest qxLogMsgRequest {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global LogMessageRequest() {

    }
}
global class LogMessageResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global LogMessageResponse() {

    }
}
global class OpenQuoteRequest {
    global String processId {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global Integer timeout {
        get;
        set;
    }
    global Boolean updQxModelId {
        get;
        set;
    }
    global OpenQuoteRequest() {

    }
}
global class OpenQuoteResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String errorCorrelationId {
        get;
    }
    global String errorMessage {
        get;
    }
    global String modelId {
        get;
    }
    global String processId {
        get;
    }
    global String state {
        get;
    }
    global OpenQuoteResponse() {

    }
}
global enum OpenQuoteState {ERROR, INITIALIZED, INITIALIZING, MIGRATING, OPENING, SUCCESS}
global class PullExportRequest {
    global String exportId {
        get;
        set;
    }
    global Integer partNumber {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global PullExportRequest() {

    }
}
global class PullExportResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global Map<String,Object> spreadsheetExport {
        get;
    }
    global PullExportResponse() {

    }
}
global class PushContextRequest {
    global List<CameleonCPQ.QxApiClient.ContextValue> context {
        get;
        set;
    }
    global String dataProviderName {
        get;
        set;
    }
    global String modelName {
        get;
        set;
    }
    global String quoteId {
        get;
        set;
    }
    global Boolean refreshContext {
        get;
        set;
    }
    global PushContextRequest() {

    }
}
global class PushDataRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global PushDataRequest() {

    }
}
global class PushDataResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global PushDataResponse() {

    }
}
global class QuoteAction {
    global String label {
        get;
    }
    global String name {
        get;
        set;
    }
    global QuoteAction() {

    }
}
global enum QuoteActionType {REFRESH, REPORT, SYNCHRONIZE}
global enum QuoteImportPosition {AFTER, BEFORE, INSIDE_BOTTOM, INSIDE_TOP}
global enum QuoteImportReplacementType {FORCE, NONE, REPLACE}
global enum QuoteImportUpdatePolicy {CLEAN, KEEP, MERG}
global class QuoteReportAction {
    global String label {
        get;
    }
    global String name {
        get;
        set;
    }
}
global enum QuoteStatus {Failed, InProgress, Ready}
global class QuoteStep {
    global String description {
        get;
    }
    global String id {
        get;
    }
    global QuoteStep() {

    }
}
global class QxApiClientException extends Exception {
}
global virtual class QxApiClientOverride {
    global QxApiClientOverride() {

    }
    global virtual CameleonCPQ.QxApiClient.CrmObjectAttributes getCrmObjectAttributes(Id crmObjId) {
        return null;
    }
    global virtual CameleonCPQ.QxApiClient.QxApiClientSettings getSettings() {
        return null;
    }
}
global class QxApiClientSettings {
    global String appPortalAccountId {
        get;
        set;
    }
    global String appPortalCertificateName {
        get;
        set;
    }
    global String appPortalCPQxAppId {
        get;
        set;
    }
    global String appPortalIDP {
        get;
        set;
    }
    global String appPortalURL {
        get;
        set;
    }
    global String environmentId {
        get;
        set;
    }
    global Integer maxNbSfdcJobs {
        get;
        set;
    }
    global String qxBaseURL {
        get;
        set;
    }
    global String tenantId {
        get;
        set;
    }
    global Boolean tracing {
        get;
        set;
    }
    global QxApiClientSettings() {

    }
}
global class QxApiException extends Exception {
    global Integer code {
        get;
    }
    global Integer logId {
        get;
    }
    global String message {
        get;
    }
    global String operationId {
        get;
    }
    global String serviceName {
        get;
    }
    global String toString() {
        return null;
    }
}
global class QxCloseSessionRequest {
    global List<String> quoteIds {
        get;
        set;
    }
    global QxCloseSessionRequest() {

    }
}
global class QxCreateQuoteRequest {
    global String country {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global String language {
        get;
        set;
    }
    global String modelName {
        get;
        set;
    }
    global String qxCurrency {
        get;
        set;
    }
    global QxCreateQuoteRequest() {

    }
}
global class QxErrorMessage {
    global Integer code {
        get;
    }
    global String logCorrelationId {
        get;
    }
    global String message {
        get;
    }
    global QxErrorMessage() {

    }
}
global class QxExecuteActionRequest {
    global String actionName {
        get;
        set;
    }
    global QxExecuteActionRequest() {

    }
}
global class QxLogDependenciesRequest {
    global QxLogDependenciesRequest() {

    }
    global void addDependency(CameleonCPQ.QxApiClient.QxLogDependency dependency) {

    }
    global void addMessage(CameleonCPQ.QxApiClient.QxLogMessageRequest message) {

    }
}
global class QxLogDependency {
    global String commandDescription {
        get;
        set;
    }
    global String commandName {
        get;
        set;
    }
    global Integer duration {
        get;
        set;
    }
    global Integer resultCode {
        get;
        set;
    }
    global String startDate {
        get;
        set;
    }
    global Boolean success {
        get;
        set;
    }
    global String targetName {
        get;
        set;
    }
    global String targetType {
        get;
        set;
    }
    global QxLogDependency() {

    }
    global void formatStartDate(Datetime dt) {

    }
}
global class QxLogMessageRequest {
    global String logLevel {
        get;
        set;
    }
    global String message {
        get;
        set;
    }
    global QxLogMessageRequest() {

    }
}
global class QxOpenQuoteRequest {
    global String processId {
        get;
        set;
    }
    global Integer timeout {
        get;
        set;
    }
    global QxOpenQuoteRequest() {

    }
}
global abstract class QxRequest {
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global QxRequest() {

    }
}
global class QxRequestContext {
    global CameleonCPQ.QxApiClient.QxApiClientOverride apiClientOverride {
        set;
    }
    global String authToken {
        get;
        set;
    }
    global String crmQuoteId {
        get;
        set;
    }
    global String locale {
        get;
        set;
    }
    global String qxModelId {
        get;
        set;
    }
    global String qxQuoteId {
        get;
        set;
    }
    global String requestId {
        get;
        set;
    }
    global String sessionId {
        get;
        set;
    }
    global QxRequestContext() {

    }
}
global abstract class QxResponse {
    global CameleonCPQ.QxApiClient.QxApiException qxException {
        get;
    }
    global Integer statusCode {
        get;
    }
    global QxResponse() {

    }
}
global class QxSetup {
    global QxSetup() {

    }
}
global class RefreshContextRequest {
    global List<String> contextKeys {
        get;
        set;
    }
    global CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx {
        get;
        set;
    }
    global RefreshContextRequest() {

    }
}
global class RefreshContextResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global RefreshContextResponse() {

    }
}
global enum ReportStatus {Failed, InProgress, Ready}
global class SetQuoteFieldRequest extends CameleonCPQ.QxApiClient.QxRequest {
    global String fieldId {
        get;
        set;
    }
    global Object requestBody {
        get;
        set;
    }
    global SetQuoteFieldRequest() {

    }
}
global class SetQuoteFieldResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global SetQuoteFieldResponse() {

    }
}
global class UpdateFrozenFlagRequest extends CameleonCPQ.QxApiClient.QxRequest {
    global CameleonCPQ.QxApiClient.UpdateFrozenFlagRequestBody requestBody {
        get;
        set;
    }
    global UpdateFrozenFlagRequest() {

    }
}
global class UpdateFrozenFlagRequestBody {
    global Boolean frozen {
        get;
        set;
    }
    global UpdateFrozenFlagRequestBody() {

    }
}
global class UpdateFrozenFlagResponse extends CameleonCPQ.QxApiClient.QxResponse {
    global String id {
        get;
    }
    global UpdateFrozenFlagResponse() {

    }
}
global class value {
    global value(String value, String qxCurrency) {

    }
}
}
