public without sharing class CaseMessageDispatch extends Dispatch {
    String header = '<?xml version="1.0" encoding="UTF-8"?>'+
                            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                            +
                            '<soapenv:Body>' +
                            '<notifications xmlns="http://soap.sforce.com/2005/09/outbound">' +
                            '<OrganizationId>' + UserInfo.getOrganizationId() +'</OrganizationId>' +
                            '<SessionId></SessionId>' +
                            '<EnterpriseUrl>' + URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/c/46.0/' + UserInfo.getOrganizationId() + '</EnterpriseUrl>' +
                            '<PartnerUrl>' + URL.getOrgDomainUrl().toExternalForm() +
                            '/services/Soap/u/46.0/' + UserInfo.getOrganizationId() + '</PartnerUrl>'+
                            '<Notification>';
    
    String footer = '</sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';

    @TestVisible
    String get_xml_payload(SObject payload) {
        String xml_payload = '<sObject xsi:type="sf:' + payload.getSObjectType() +
                            '" xmlns:sf="urn:sobject.enterprise.soap.sforce.com">';
        for (String field_name: payload.getPopulatedFieldsAsMap().keySet()) {
            xml_payload = xml_payload + '<sf:' + field_name + '>' + payload.get(field_name) + '</sf:' +
                        field_name +
                        '>';
        }
        return header + xml_payload + footer;
    }
    String xml_base(SObject payload){
        return get_xml_payload(payload);
    }
}