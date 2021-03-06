//Generated by wsdl2apex

public class directconnectauthServicecontracts {
    public class MarketViewAuthenticationResponse {
        public String SignOnKey;
        public String Message;
        private String[] SignOnKey_type_info = new String[]{'SignOnKey','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'SignOnKey','Message'};
    }
    public class SeatInfo {
        public Integer AccountId;
        public Integer SeatId;
        public String SeatEmail;
        public String ClientId;
        private String[] AccountId_type_info = new String[]{'AccountId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] SeatId_type_info = new String[]{'SeatId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] SeatEmail_type_info = new String[]{'SeatEmail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ClientId_type_info = new String[]{'ClientId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'AccountId','SeatId','SeatEmail','ClientId'};
    }
    public class MarketViewSeatValidateResponse {
        public Boolean Success;
        public String Message;
        private String[] Success_type_info = new String[]{'Success','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'Success','Message'};
    }
    public class UserAuthenticationService {
        public String endpoint_x = 'http://apps.schooldata.com/DirectConnectAuth/UserAuthenticationService.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public AuthHeader AuthHeader;
        public String AuthHeader_hns = 'AuthHeader=http://DirectConnectAuth.ServiceContracts';
        public String[] ns_map_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts', 'directconnectauthServicecontracts'};
        public directconnectauthServicecontracts.MarketViewSeatValidateResponse SeatValidation(directconnectauthServicecontracts.SeatInfo SeatInfo) {
            directconnectauthServicecontracts.MarketViewSeatValidateRequest request_x = new directconnectauthServicecontracts.MarketViewSeatValidateRequest();
            directconnectauthServicecontracts.MarketViewSeatValidateResponse response_x;
            request_x.SeatInfo = SeatInfo;
            Map<String, directconnectauthServicecontracts.MarketViewSeatValidateResponse> response_map_x = new Map<String, directconnectauthServicecontracts.MarketViewSeatValidateResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://DirectConnectAuth.ServiceContracts/SeatValidation',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewSeatValidateRequest',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewSeatValidateResponse',
              'directconnectauthServicecontracts.MarketViewSeatValidateResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public directconnectauthServicecontracts.MarketViewAuthenticationResponse AccessMarketViewAuthentication(directconnectauthServicecontracts.UserAuthSignOn UserSignOn) {
            directconnectauthServicecontracts.AccessMarketViewAuthenticationRequest request_x = new directconnectauthServicecontracts.AccessMarketViewAuthenticationRequest();
            directconnectauthServicecontracts.MarketViewAuthenticationResponse response_x;
            request_x.UserSignOn = UserSignOn;
            Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse> response_map_x = new Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://DirectConnectAuth.ServiceContracts/AccessMarketViewAuthentication',
              'http://DirectConnectAuth.ServiceContracts',
              'AccessMarketViewAuthenticationRequest',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewAuthenticationResponse',
              'directconnectauthServicecontracts.MarketViewAuthenticationResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
            
        }
        public directconnectauthServicecontracts.MarketViewAuthenticationResponse UserAuthentication(directconnectauthServicecontracts.UserAuthSignOn UserSignOn) {
            directconnectauthServicecontracts.MarketViewAuthenticationRequest request_x = new directconnectauthServicecontracts.MarketViewAuthenticationRequest();
            directconnectauthServicecontracts.MarketViewAuthenticationResponse response_x;
            request_x.UserSignOn = UserSignOn;
            Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse> response_map_x = new Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://DirectConnectAuth.ServiceContracts/UserAuthentication',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewAuthenticationRequest',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewAuthenticationResponse',
              'directconnectauthServicecontracts.MarketViewAuthenticationResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }

        public directconnectauthServicecontracts.MarketViewAuthenticationResponse MarketViewAutoLogin(directconnectauthServicecontracts.AuthSignOn UserSignOn) {
            directconnectauthServicecontracts.MarketViewAutoLoginRequest request_x = new directconnectauthServicecontracts.MarketViewAutoLoginRequest();
            directconnectauthServicecontracts.MarketViewAuthenticationResponse response_x;
            request_x.UserSignOn = UserSignOn;
            Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse> response_map_x = new Map<String, directconnectauthServicecontracts.MarketViewAuthenticationResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://DirectConnectAuth.ServiceContracts/MarketViewAutoLogin',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewAutoLoginRequest',
              'http://DirectConnectAuth.ServiceContracts',
              'MarketViewAuthenticationResponse',
              'directconnectauthServicecontracts.MarketViewAuthenticationResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    public class MarketViewAuthenticationRequest {
        public directconnectauthServicecontracts.UserAuthSignOn UserSignOn;
        private String[] UserSignOn_type_info = new String[]{'UserSignOn','http://DirectConnectAuth.ServiceContracts','UserAuthSignOn','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'UserSignOn'};
    }
    public class MarketViewSeatValidateRequest {
        public directconnectauthServicecontracts.SeatInfo SeatInfo;
        private String[] SeatInfo_type_info = new String[]{'SeatInfo','http://DirectConnectAuth.ServiceContracts','SeatInfo','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'SeatInfo'};
    }
    public class AuthHeader {
        public String UserId;
        public String Password;
        public String UserSite;
        private String[] UserId_type_info = new String[]{'UserId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] UserSite_type_info = new String[]{'UserSite','http://DirectConnectAuth.ServiceContracts','EUserSite','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'UserId','Password','UserSite'};
    }
    public class UserAuthSignOn {
        public String HashValue;
        public String Email;
        public String FirstName;
        public String LastName;
        public String IpAddress;
        public DateTime RequestTime;
        public String CompanyId;
        private String[] HashValue_type_info = new String[]{'HashValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IpAddress_type_info = new String[]{'IpAddress','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RequestTime_type_info = new String[]{'RequestTime','http://www.w3.org/2001/XMLSchema','DateTime ','1','1','false'};
        private String[] CompanyId_type_info = new String[]{'CompanyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'HashValue','Email','FirstName','LastName','IpAddress','RequestTime','CompanyId'};
    }
    public class AuthSignOn {
        public String HashValue;
        public String Email;
        public String IpAddress;
        public DateTime RequestTime;
        private String[] HashValue_type_info = new String[]{'HashValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IpAddress_type_info = new String[]{'IpAddress','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RequestTime_type_info = new String[]{'RequestTime','http://www.w3.org/2001/XMLSchema','DateTime ','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'HashValue','Email','IpAddress','RequestTime'};
    }
    public class AccessMarketViewAuthenticationRequest {
        public directconnectauthServicecontracts.UserAuthSignOn UserSignOn;
        private String[] UserSignOn_type_info = new String[]{'UserSignOn','http://DirectConnectAuth.ServiceContracts','UserAuthSignOn','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'UserSignOn'};
    }
    public class MarketViewAutoLoginRequest {
        public directconnectauthServicecontracts.AuthSignOn UserSignOn;
        private String[] UserSignOn_type_info = new String[]{'UserSignOn','http://DirectConnectAuth.ServiceContracts','AuthSignOn','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://DirectConnectAuth.ServiceContracts','true','false'};
        private String[] field_order_type_info = new String[]{'UserSignOn'};
    }
}