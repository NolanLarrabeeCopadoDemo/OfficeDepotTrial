@RestResource(urlMapping='/v1/GetBase64AttachmentWebService/*')
global with sharing class GetBase64AttachmentWebService {
    class CaseAttachment {
        String Id;
        String Body;
        String ParentId;
        String Name;
        String ContentType;
        Integer BodyLength;
        String Description;
        Boolean IsPrivate;

        CaseAttachment(
            String Id, 
            String Body, 
            String ParentId, 
            String Name, 
            String ContentType, 
            Integer BodyLength, 
            String Description,
            Boolean IsPrivate)
            {
            this.Id = id;
            this.Body = Body;
            this.ParentId = ParentId;
            this.Name = Name;
            this.ContentType = ContentType;
            this.BodyLength = BodyLength;
            this.Description = Description;
            this.IsPrivate = IsPrivate;
        }
    }

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String attachment_id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        if(String.isBlank(attachment_id)){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('An attachment id must be provided.');
            return;
        }
        try {
            Attachment result = [SELECT Id, Body, ParentId, Name, BodyLength, Description, IsPrivate, ContentType FROM Attachment WHERE Id = :attachment_id];

            if (req.headers.containsKey('Accept') && req.headers.get('Accept') == 'application/xml') {
                res.headers.put('Content-Type', 'application/xml');
                res.responseBody = Blob.valueOf(
                    '<?xml version="1.0" encoding="UTF-8"?>' + 
                    '<CaseAttachment>' + 
                        '<Id>' + result.Id + '</Id>' +
                        '<Body>' + EncodingUtil.base64Encode(result.Body) + '</Body>' +
                        '<ParentId>' + result.ParentId + '</ParentId>' +
                        '<Name>' + result.Name + '</Name>' +
                        '<ContentType>' + result.ContentType + '</ContentType>' +
                        '<BodyLength>' + String.valueOf(result.BodyLength) + '</BodyLength>' +
                        '<Description>' + result.Description + '</Description>' +
                        '<IsPrivate>' + String.valueOf(result.IsPrivate) + '</IsPrivate>' +
                    '</CaseAttachment>'
                );
                return;            
            }

            res.headers.put('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(
                JSON.serialize(
                    new CaseAttachment(
                        result.Id,
                        EncodingUtil.base64Encode(result.Body),
                        result.ParentId,
                        result.Name,
                        result.ContentType,
                        result.BodyLength,
                        result.Description,
                        result.IsPrivate
                    )
                )
            );
        } catch (QueryException e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('The requested resource was not found.');
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('An error has occured.');
        }
    }
}