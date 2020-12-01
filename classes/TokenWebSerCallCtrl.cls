public class TokenWebSerCallCtrl {

    public String ManagerEmpid { get; set; }

    public String Token1 { get; set; }
    Public String cid {get;set;}
    Public String eid {get;set;}
    Public String splt {get;set;}
    Public String Token {get;set;}
    Public String Name{get;set;}
    public String Manager{get;set;}
    public String Emp_Id{get;set;}
    public String Status{get;set;}
    Public Boolean Render{get;set;}
    Public Boolean Button {get; set ;}
    public String Emp_FName{get;set;}
    public String Emp_LName{get;set;}
    public String mngr_FName{get;set;}
    public String mngr_Lname{get;set;}
    public String mngr_Email{get;set;}
    public String Emp_Email{get;set;}
        public String Company{get;set;}
    public String UserRole{get;set;}
    
    public boolean TokenWebSerCallCtrl(){  
        
        Render = true;
        return button;    
    }
    
    
      
        
    soapTokenwebserCall webCall= new soapTokenwebserCall();
    soapTokenwebserCall.TokenWebSerCallInput inpt= new soapTokenwebserCall.TokenWebSerCallInput();
    @TestVisible soapTokenwebserCall.TokenWebSerCallResponse rspnsFlds = new soapTokenwebserCall.TokenWebSerCallResponse();
    partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
    public void decodeu()
    {
        token1= EncodingUtil.URLDECODE(token,'UTF-8');
   system.debug(token);
    }
    
      public void decryptu()
    {
    
      Blob DecoDeToken = EncodingUtil.base64Decode(token1);
        List<TechDepotSetting__c> tech = [Select Id,Crypto_key__C from TechDepotSetting__c where name ='Key'];
            Blob cryptoKey =EncodingUtil.base64Decode(tech[0].Crypto_key__c);
                        //Status = rspnsFlds.Crypto_key;
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, DecoDeToken);
            splt= decryptedData.toString();
            system.debug('XXYY' +splt);
            List<String> splitString = splt.split('@',2);
            eid=splitString[0];
            system.debug('eid ' +eid);
            cid=splitString[1];
            system.debug('cid ' +cid);
    }
    public void CallWebSerMethod(){

         
        try{
            partnerSoapSforceCom.LoginResult loginResult = sp.login('market.builder@officedepot.com', 'market9999agKZ76DWG88L5FwutCjzfqpB');
            //partnerSoapSforceCom.LoginResult loginResult = sp.login('market.builder@officedepot.com.uat', 'mb1234563aUsWdSPVxjMiA4330Haq0nQ');
            
            soapTokenwebserCall.SessionHeader_element sessionHeader = new soapTokenwebserCall.SessionHeader_element();
            sessionHeader.sessionId = loginResult.sessionId;
            soapTokenwebserCall.TokenWebSerCall apexWebSvc = new soapTokenwebserCall.TokenWebSerCall();
            apexWebSvc.timeout_x = 120000;
            apexWebSvc.SessionHeader = SessionHeader;
            inpt.TOKEN = cid;
            inpt.EMPID = eid;
            rspnsFlds = apexWebSvc.methodCall(inpt);
            }catch (Exception e) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
           
            }
            System.Debug('Fld Check'+rspnsFlds);
            if(rspnsFlds.Name != Null){
                Emp_Id = rspnsFlds.Emp_Id;
                Name=rspnsFlds.Name;
                Emp_FName = rspnsFlds.Emp_F_Name;
                Emp_LName = rspnsFlds.Emp_L_Name;
                Emp_Email = rspnsFlds.Emp_Email;
                Manager = rspnsFlds.Manager;
                mngr_FName = rspnsFlds.Mngr_F_Name;
                mngr_Lname = rspnsFlds.Mngr_L_Name;
                mngr_Email = rspnsFlds.Manager_Email;
                ManagerEmpid  = rspnsFlds.ManagerEmpid;
                Status = rspnsFlds.Status;
                 UserRole= rspnsFlds.UserRole;
        Company =rspnsFlds.Company;
            }
            else{
            Status = 'User not found';
            }
            render= True;
             //}catch (Exception e) {
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
             //}
           
        }
        
        
        
}