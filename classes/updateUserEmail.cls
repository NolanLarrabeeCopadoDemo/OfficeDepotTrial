public class updateUserEmail {
    @invocablemethod
    public static void updateEmail(list<id> userid) {
        
        Map<String, User> contactIdUserMap = new Map<String, User>();
        list<user> listUser = new List<user>();
        //Fetch the profile Id for Partner profile
        Profile userProfile = [select id from profile where name = :Label.Partner_Community_User_Custom limit 1];
        listUser = [select id, profileid, email, contactid from user where id in: userid];
        
        for(User u :listUser) {
            if (userProfile != null && u.profileid == userProfile.id) {
                contactIdUserMap.put(u.contactId, u);
            } 
        }
        
        if(contactIdUserMap != null && contactIdUserMap.size() > 0) {
            List<Contact> contactList = [SELECT Id FROM Contact WHERE id in: contactIdUserMap.keySet()];
            for (Contact userContact : contactList) {
            	userContact.Email = contactIdUserMap.get(userContact.id).Email;
            }
            update contactList;
        }     
    }
}