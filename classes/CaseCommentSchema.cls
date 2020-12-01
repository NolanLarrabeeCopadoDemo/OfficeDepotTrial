public with sharing class CaseCommentSchema {

    public class CaseCommentValidationException extends Exception{}

    public String case_id;
    public Integer freshdesk_id;
    public Integer oraclecx_id;
    public String comment_payload_base64;

    public CaseCommentSchema(){
        this.case_id = 'OPTIONAL_SALESFORCE_CASE_ID_ONLY_ONE_ID_PARAMATER_MAY_BE_SPECIFIED_IN_EACH_REQUEST_OBJECT';
        this.freshdesk_id = -1;
        this.oraclecx_id = -1;
        this.comment_payload_base64 = 'REQUIRED_COMMENT_BODY_IN_BASE64';
    }

    public CaseCommentSchema(String xml_data){
        System.debug('XML Data: ' + xml_data);
        this.case_id = xml_data.substringBetween('<case_id>', '</case_id>');
        if (String.isNotBlank(xml_data.substringBetween('<freshdesk_id>', '</freshdesk_id>')))
            this.freshdesk_id = Integer.valueOf(xml_data.substringBetween('<freshdesk_id>', '</freshdesk_id>'));
        
        if (String.isNotBlank(xml_data.substringBetween('<oraclecx_id>', '</oraclecx_id>')))
            this.oraclecx_id = Integer.valueOf(xml_data.substringBetween('<oraclecx_id>', '</oraclecx_id>'));

        this.comment_payload_base64 = xml_data.substringBetween('<comment_payload_base64>', '</comment_payload_base64>');
        // Remove HTML tags from the payload. 
        Blob my_blob = EncodingUtil.base64Decode(this.comment_payload_base64);
        String stripped_comment = my_blob.toString();
        String stripped_content_lower = stripped_comment.toLowerCase();
        if (stripped_content_lower.toLowerCase().contains('<br>') && !stripped_content_lower.toLowerCase().contains('<html>'))
            stripped_comment = '<html>' + stripped_comment + '</html>';
        stripped_comment = stripped_comment.stripHtmlTags();

        this.comment_payload_base64 = EncodingUtil.base64Encode(Blob.valueOf(stripped_comment));
    }

    public String toXML(){
        return '<?xml version="1.0" encoding="UTF-8"?>' + 
                '<CaseComment>' + 
                    '<case_id>' + this.case_id + '</case_id>' +
                    '<freshdesk_id>' + this.freshdesk_id + '</freshdesk_id>' +
                    '<oraclecx_id>' + this.oraclecx_id + '</oraclecx_id>' +
                    '<comment_payload_base64>' + this.comment_payload_base64 + '</comment_payload_base64>' +
                '</CaseComment>';
    }

    public String toJSON(){
        return JSON.serialize(this);
    }

    
    public void validate(){
        if(Test.isRunningTest())
            System.debug('CaseCommentSchema: ' + this);
            
        boolean has_single_id = false;
        if(this.oraclecx_id == null && this.freshdesk_id == null && String.isBlank(this.case_id))
            throw new CaseCommentSchema.CaseCommentValidationException('Both Freshdesk Id and Oracle CX Id are null.');

        if( this.oraclecx_id != null)
            has_single_id = true;
        if( this.freshdesk_id != null && has_single_id == true){
            throw new CaseCommentSchema.CaseCommentValidationException('Only one id paramater may be specified.');
        }
        if( !String.isBlank(this.case_id) && has_single_id == true){
            throw new CaseCommentSchema.CaseCommentValidationException('Only one id paramater may be specified.');
        }else {
            has_single_id = true;
        }

        if(String.isBlank(this.comment_payload_base64))
            throw new CaseCommentSchema.CaseCommentValidationException('comment_payload_base64 cannot be null or blank.');
    }
}