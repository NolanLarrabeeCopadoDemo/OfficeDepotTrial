/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQCLM_Utils {
    global static Map<CameleonCPQ.CPQCLM_Utils.ContractType,Integer> CONTRACT_TYPES_MAPPINGS;
    global static Map<CameleonCPQ.CPQCLM_Utils.RenewalType,Integer> RENEWAL_TYPES_MAPPINGS;
    global CPQCLM_Utils() {

    }
    global static CameleonCPQ.CPQCLM_Utils.CLMInfo createContractFromQuote(CameleonCPQ.CPQCLM_Utils.ContractFromQuoteParameters cFqParams, CameleonCPQ.CPQCLM_Utils.ContractType theContractType) {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.CLMInfo createQuoteFromContract_Part1(Id contractID, CameleonCPQ.CPQCLM_Utils.QuoteFromContractParameters qFcParams) {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.CLMInfo createQuoteFromContract_Part2(Id contractID, Id clonedQuoteID, CameleonCPQ.CPQCLM_Utils.QuoteFromContractParameters qFcParams) {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.ContractType getContractType(Integer cTypeInt) {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.ContractType getContractType(String cTypeString) {
        return null;
    }
    global static Map<String,String> getContractTypeLabels() {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.RenewalType getRenewalType(Integer rnTypeInt) {
        return null;
    }
    global static CameleonCPQ.CPQCLM_Utils.RenewalType getRenewalType(String rnTypeString) {
        return null;
    }
    global static Map<String,String> getRenewalTypeLabels() {
        return null;
    }
global class CLMInfo {
    global String errorMessage {
        get;
        set;
    }
    global Id objectId {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global CLMInfo() {

    }
}
global class ContractFromQuoteParameters {
    global Date contractEndDate {
        get;
        set;
    }
    global String contractEndDateString {
        get;
        set;
    }
    global Date contractStartDate {
        get;
        set;
    }
    global String contractStartDateString {
        get;
        set;
    }
    global String contractType {
        get;
        set;
    }
    global Id quoteID {
        get;
        set;
    }
    global ContractFromQuoteParameters() {

    }
}
global class ContractSyncException extends Exception {
}
global enum ContractType {AMENDMENT, CREATION, EXTENSION, RENEWAL, RETENTION}
global class QuoteFromContractException extends Exception {
}
global class QuoteFromContractParameters {
    global Date contractEndDate {
        get;
        set;
    }
    global Date contractStartDate {
        get;
        set;
    }
    global String contractType {
        get;
        set;
    }
    global Boolean refreshItems {
        get;
        set;
    }
    global String renewalType {
        get;
        set;
    }
    global Boolean replaceItems {
        get;
        set;
    }
    global QuoteFromContractParameters() {

    }
}
global enum RenewalType {AUTOMATIC, ONETIME}
}
