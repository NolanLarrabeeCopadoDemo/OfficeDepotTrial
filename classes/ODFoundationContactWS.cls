global class ODFoundationContactWS {
    webService static Id addContact(String lastName,String firstName, String email,String Phone) {
    // default Account for all Foundation Contacts
    String acname='OD FOUNDATION - 001M000000T3Hv';
   
    Account ac= [select id from account where name = 'OD FOUNDATION - 001M000000T3Hv' limit 1];
    system.debug('  ac' + ac.id);
    
     Boolean flag =false;
      Contact ec;
    try{
    ec = [select id from Contact where email=:email limit 1];
    flag =true;
    }
    catch (System.QueryException e) {
   flag =false;
}
    if(flag ){
    	ec.lastName = lastName;
      ec.firstname =firstName;
       ec.phone = Phone;
      return ec.id;
    }
      else
      {
        Contact c = new Contact(lastName = lastName);
       c.firstname =firstName;
       c.email=email;
       c.phone = Phone;
       c.Accountid =ac.id;
        insert c;
        return c.id;
        }
    }
}