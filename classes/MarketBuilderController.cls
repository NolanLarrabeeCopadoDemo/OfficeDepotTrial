global class MarketBuilderController {
public string status{get;set;}
public string token ='';
Datetime expDateTime =  System.now().addMinutes(5);
DateTime dt=Datetime.now();
//System.Debug(dt);
//System.Debug(expDateTime);

 public MarketBuilderController(){
}

public PageReference onMBButton()
{
        List<TechDepotSetting__c> tech = [Select Id,Crypto_key__C from TechDepotSetting__c where name ='Key'];
        Blob cryptoKey =EncodingUtil.base64Decode(tech[0].Crypto_key__c);
        //Blob cryptoKey = Crypto.generateAesKey(256);

// Generate the data to be encrypted.
    User u = [select id,MB_Expiration_Date__c,OD_Employee_ID__c,Token_Market_Builder__c from user where id =:UserInfo.getUserId()];
    token = EncodingUtil.convertToHex(Crypto.generateDigest('MD5',Blob.valueOf('U' + Crypto.getRandomInteger())));  
    System.Debug('token chk'+token);
     if(u.MB_Expiration_Date__c !=  null )
    {    
    if(System.now() <= u.MB_Expiration_Date__c)
        {
           token = u.Token_Market_Builder__c; 
        }  
    } 
    
      
    u.Token_Market_Builder__c = token; 
    u.MB_Expiration_Date__c = expDateTime;
    try{
    update u;
    if(u.Token_Market_Builder__c == token && u.Token_Market_Builder__c != NULL)
    status = 'Token has been generated successfully';
    }
    catch(Exception e)
    {
    } 
    system.debug('Exp  ' +expDateTime );
    system.debug('Token ' +token);

    token = u.OD_Employee_ID__c+'@'+u.Token_Market_Builder__c; 
   // token = u.OD_Employee_ID__c;
Blob data = Blob.valueOf(token);
// Encrypt the data and have Salesforce.com generate the initialization vector
Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
// Decrypt the data - the first 16 bytes contain the initialization vector
system.debug('encryptedData ' +encryptedData );
Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
// Decode the decrypted data for subsequent use
String decryptedDataString = decryptedData.toString();

system.debug('decryptedDataString ' +decryptedDataString );

            System.Debug('Check' +token);
            token =EncodingUtil.base64Encode(encryptedData);
            System.Debug('Check1' +token);
            
            
system.debug('encryptedtoken ' +token );
 token= EncodingUtil.URLENCODE(token,'UTF-8');
            //u.Token_Market_Builder__c = token;
           // update u;
            PageReference pageRef = new PageReference('http://www.odmarketbuilder.com/'+'?pid='+token);
            
            return pageRef;
        

}
}