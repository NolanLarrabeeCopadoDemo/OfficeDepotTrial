/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CPQParser {
    global CameleonCPQ.CPQParser.Quote quo;
    global CPQParser(Blob quoteXML) {

    }
    global CameleonCPQ.CPQParser.Quote getQuote() {
        return null;
    }
global class Quote {
    global Quote() {

    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getAllLines() {
        return null;
    }
    global List<CameleonCPQ.CPQParser.QuoteDocument> getDocuments() {
        return null;
    }
    global String getDomain() {
        return null;
    }
    global String getField(String fieldName) {
        return null;
    }
    global Map<String,String> getFieldsWithoutTab() {
        return null;
    }
    global Map<String,String> getFields() {
        return null;
    }
    global String getId() {
        return null;
    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getLines(Integer level) {
        return null;
    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getLines(List<Integer> levels, List<String> types) {
        return null;
    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getLines(String type) {
        return null;
    }
    global String getRelease() {
        return null;
    }
}
global class QuoteDocument {
    global QuoteDocument() {

    }
    global String getId() {
        return null;
    }
    global String getName() {
        return null;
    }
    global String getUrl() {
        return null;
    }
}
global class QuoteLine {
    global QuoteLine() {

    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getAllLines(List<CameleonCPQ.CPQParser.QuoteLine> lines) {
        return null;
    }
    global String getColumnValue(String colName) {
        return null;
    }
    global Map<String,String> getColumns() {
        return null;
    }
    global String getId() {
        return null;
    }
    global Boolean getIsSubline() {
        return null;
    }
    global Integer getLevel() {
        return null;
    }
    global String getLineType() {
        return null;
    }
    global String getSeqNum() {
        return null;
    }
    global List<CameleonCPQ.CPQParser.QuoteLine> getSublines() {
        return null;
    }
    global Boolean hasSublines() {
        return null;
    }
}
}
