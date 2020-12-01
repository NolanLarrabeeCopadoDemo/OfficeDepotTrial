public class QxGenerateAuthToken {
    
    public static String generateAuthenticationToken(){
        // Get the symmetric key from a custom setting and convert it to its 
        // normal form 
        // Note 1: The symmetric key is stored as a Base64-encoded 
         ProsCustomSettings__c pcs = ProsCustomSettings__c.getInstance('CCORE'); 
		String authToken = '';
        if(pcs != null){
        Blob cryptoKey = EncodingUtil.base64Decode(pcs.Symmetric_Key__c);
        System.debug('Size :'+cryptoKey.size());
        // Construct the Second-Party Credentials XML document as a String     
        String credentials = ''
            + '<Credentials>'
            + '<TimeStamp>' + String.valueOf(datetime.now().getTime()) 
            + '</TimeStamp>'
            + '<UserID>' + pcs.User_Name__c + '</UserID>'    
            + '<Password>' + pcs.Password__c + '</Password>'
            + '</Credentials>';                     
        // Encrypt the Credentials XML document using the symmetric key
        // // Note 1: Only AES128 is supported 
        // // Note 2: The symmetric key is used for both the private key and  
        // // initialization vector input parameters.   
        // // DO NOT use encryptWithManagedIV. 
        
        Blob encryptedCredentials = Crypto.encrypt('AES128',cryptoKey,cryptoKey,Blob.valueOf(credentials));
        //Blob encryptedCredentials = Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(credentials));
        
        // Convert the Credentials Blob to a Base64-encoded String 
        String base64Credentials = EncodingUtil.base64Encode(encryptedCredentials);
        // Final AuthToken element as a String 
        authToken = ''    
            + '<AuthToken>'    
            + '<Key name="' 
            + 'cpq' + '"/>'    
            + '<Credentials>' 
            + base64Credentials
            + '</Credentials>'    
            + '</AuthToken>'; 
        }
        return authToken;
        
    }
}