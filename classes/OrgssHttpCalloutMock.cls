@isTest
global class OrgssHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
           String json = '{'+
        '    \"transactionDetail\": {'+
        '        \"transactionID\": \"rrt-0ededba0d72b58103-b-se-22227-1329804-1\",'+
        '        \"transactionTimestamp\": \"2019-12-19T15:09:15.097Z\",'+
        '        \"inLanguage\": \"en-US\",'+
        '        \"serviceVersion\": \"1\"'+
        '    },'+
        '    \"inquiryDetail\": {'+
        '        \"postalCode\": \"80401\",'+
        '        \"primaryName\": \"PUBLIC SAFETY, COLORADO DEPARTMENT OF\",'+
        '        \"addressRegion\": \"Co\",'+
        '        \"streetAddressLine1\": \"15075 S GOLDEN RD\"'+
        '    },'+
        '    \"candidatesReturnedQuantity\": 1,'+
        '    \"candidatesMatchedQuantity\": 1,'+
        '    \"searchCandidates\": ['+
        '        {'+
        '            \"displaySequence\": 1,'+
        '            \"organization\": {'+
        '                \"duns\": \"177014425\",'+
        '                \"dunsControlStatus\": {'+
        '                    \"isOutOfBusiness\": false,'+
        '                    \"isMarketable\": true,'+
        '                    \"isTelephoneDisconnected\": false,'+
        '                    \"isMailUndeliverable\": false,'+
        '                    \"isDelisted\": false'+
        '                },'+
        '                \"primaryName\": \"Colorado Department of Public Safety\",'+
        '                \"tradeStyleNames\": ['+
        '                    {'+
        '                        \"name\": \"Motor Carrier Safety\",'+
        '                        \"priority\": 1'+
        '                    }'+
        '                ],'+
        '                \"primaryAddress\": {'+
        '                    \"addressCountry\": {'+
        '                        \"isoAlpha2Code\": \"US\",'+
        '                        \"name\": \"United States\"'+
        '                    },'+
        '                    \"addressLocality\": {'+
        '                        \"name\": \"Golden\"'+
        '                    },'+
        '                    \"addressRegion\": {'+
        '                        \"name\": \"Colorado\",'+
        '                        \"abbreviatedName\": \"CO\"'+
        '                    },'+
        '                    \"postalCode\": \"80401-3990\",'+
        '                    \"streetAddress\": {'+
        '                        \"line1\": \"15075 S Golden Rd\"'+
        '                    },'+
        '                    \"latitude\": 39.734073,'+
        '                    \"longitude\": -105.168332'+
        '                },'+
        '                \"primaryIndustryCodes\": ['+
        '                    {'+
        '                        \"usSicV4\": \"9229\",'+
        '                        \"usSicV4Description\": \"Public order/safety\"'+
        '                    }'+
        '                ],'+
        '                \"corporateLinkage\": {'+
        '                    \"isBranch\": true,'+
        '                    \"familytreeRolesPlayed\": ['+
        '                        {'+
        '                            \"description\": \"Branch/Division\",'+
        '                            \"dnbCode\": 9140'+
        '                        }'+
        '                    ],'+
        '                    \"globalUltimateFamilyTreeMembersCount\": 1305,'+
        '                    \"globalUltimate\": {'+
        '                        \"duns\": \"076438621\",'+
        '                        \"primaryName\": \"State of Colorado\"'+
        '                    },'+
        '                    \"headQuarter\": {'+
        '                        \"duns\": \"878046747\",'+
        '                        \"primaryName\": \"Colorado Department of Public Safety\"'+
        '                    }'+
        '                },'+
        '                \"numberOfEmployees\": ['+
        '                    {'+
        '                        \"value\": 25,'+
        '                        \"informationScopeDescription\": \"Individual\",'+
        '                        \"informationScopeDnBCode\": 9066,'+
        '                        \"reliabilityDescription\": \"Actual\",'+
        '                        \"reliabilityDnBCode\": 9092'+
        '                    },'+
        '                    {'+
        '                        \"value\": 25,'+
        '                        \"informationScopeDescription\": \"Individual\",'+
        '                        \"informationScopeDnBCode\": 9066,'+
        '                        \"reliabilityDescription\": \"Actual\",'+
        '                        \"reliabilityDnBCode\": 9092'+
        '                    }'+
        '                ],'+
        '                \"industryCodes\": ['+
        '                    {'+
        '                        \"code\": \"922190\",'+
        '                        \"description\": \"Other Justice, Public Order, and Safety Activities\",'+
        '                        \"typeDescription\": \"North American Industry Classification System 2017\",'+
        '                        \"typeDnbCode\": 30832,'+
        '                        \"priority\": 1'+
        '                    },'+
        '                    {'+
        '                        \"code\": \"1693\",'+
        '                        \"description\": \"Government Sector\",'+
        '                        \"typeDescription\": \"D&B Hoovers Industry Code\",'+
        '                        \"typeDnbCode\": 25838,'+
        '                        \"priority\": 1'+
        '                    },'+
        '                    {'+
        '                        \"code\": \"92299903\",'+
        '                        \"description\": \"Public safety bureau, government\",'+
        '                        \"typeDescription\": \"D&B Standard Industry Code\",'+
        '                        \"typeDnbCode\": 3599,'+
        '                        \"priority\": 1'+
        '                    }'+
        '                ],'+
        '                \"telephone\": ['+
        '                    {'+
        '                        \"telephoneNumber\": \"3032731875\",'+
        '                        \"isdCode\": \"1\"'+
        '                    }'+
        '                ],'+
        '                \"domain\": \"co1000.com\",'+
        '                \"isStandalone\": false,'+
        '                \"isFortune1000Listed\": false'+
        '            }'+
        '        }'+
        '    ]'+
        '}';
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        Address_Search__c Orglist = Address_Search__c.getvalues('URL');
        String endpointUrl = Orglist.EndPointUrl__c;    
        if(request.getEndpoint() ==endpointUrl)
        //if(request.getEndpoint() =='https://api.avention.com/api/v1/company/match?api_key=aa0a9e7c-b8f4-4cb1-95a4-e1545bf06e45')
           response.setBody('{"size":1,"consumedCredits":0,"consumedBusinessContactCredits":0,"resultType":"company","result":[{"resultType":"company","id":"f92891a2-cbea-3071-82f1-98a6c043bd61","keyId":176946487,"companyName":"4wt Media, LLC","primaryUrl":"http://www.4wtmedia.com","sales":348600.0,"salesUsd":348600.0,"salesEur":308766.19,"salesGbp":270590.60000000003,"numEmployees":5,"directMarketingStatus":"Has Not Opted Out of Direct Marketing","addresses":[{"addressType":"primary","city":"Los Angeles","state":{"id":"5d3ce39b-0a1c-3804-a38a-ddd8166ab9a2","name":"California","abbreviation":"CA"},"country":{"id":"8f8578d9-7195-3d4d-a85f-65eadf168209","name":"United States","iso2":"US"}}],"primaryIndustry":{"id":"115e9083-6c17-309c-9af6-408cda8f737e","shortDescription":"Movies"},"entityType":{"id":"9d808686-0d01-3391-ba6a-a1d415ce0769","name":"Independent"},"ownershipType":{"id":"b5bab43a-c8fb-3a04-8b53-a3f97e569fcf","name":"Partnership"},"matchDetails":{"matchScore":60,"nameMatchQuality":"STRICT","nameMatchConfidence":978,"addressMatchQuality":"LOOSE","addressMatchConfidence":3860}}]}');
        else
          response.setBody(json );

        response.setStatusCode(200);
        return response; 
        
        
    }
    
    
}