@RestResource(urlMapping='/v1/CaseCommentWebService/*')
global with sharing class CaseCommentWebService {

    @HttpGet
    global static void doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        

        CaseCommentSchema my_example = new CaseCommentSchema();

        
        res.statusCode = 200;
        
        if (req.headers.containsKey('Accept') && req.headers.get('Accept') == 'application/xml') {
            res.addHeader('Content-Type', 'application/xml');
            res.responseBody = Blob.valueOf(my_example.toXML());
        } else {
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(my_example.toJSON());
        }
        
        return;
        
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        CaseCommentSchema my_comment;

        if(req.headers.containsKey('Content-Type'))
            switch on req.headers.get('Content-Type') {
                when 'application/json' {
                    my_comment = (CaseCommentSchema) JSON.deserialize(req.requestBody.toString(), CaseCommentSchema.class);
                }
                when 'application/xml' {
                    my_comment = new CaseCommentSchema(req.requestBody.toString());
                }
                when else {
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf('bad request, accepted content types include application/json and application/xml');
                    return;
                }
            }


        try{
            my_comment.validate();
        } catch (Exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Error Occured. ' + e.getMessage());
            return;
        }

        List<CaseComment> case_comments_list = SingleTicketingCaseManagement.update_case_comments_with_external_ids(new List<CaseCommentSchema>{my_comment});
        
        if(case_comments_list.isEmpty()){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Error Occured. No case comments were created.');
            return;
        }

        System.debug(case_comments_list);

        try{
            insert case_comments_list;
        } catch (Exception e){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Error Occured. ' + e.getMessage());
        }

        res.statusCode = 201;
        if(req.headers.containsKey('Accept'))
            switch on req.headers.get('Accept') {
                when 'application/json' {
                    res.addHeader('Content-Type', 'application/json');
                    //my_comment = (CaseCommentSchema) JSON.deserialize(req.requestBody.toString(), CaseCommentSchema.class);
                    System.debug('Request Content: ' + case_comments_list );
                    //res.responseBody = Blob.valueOf(my_comment.toJSON());
                    res.responseBody = Blob.valueOf(JSON.serialize(case_comments_list));
                }
                when 'application/xml' {
                    res.addHeader('Content-Type', 'application/xml');
                    //my_comment = new CaseCommentSchema(req.requestBody.toString());
                    System.debug('Request Content: ' + my_comment );
                    res.responseBody = Blob.valueOf(my_comment.toXML());
                }
                when else {
                    res.statusCode = 204;
                    return;
                }
            }

        return;
    }
}