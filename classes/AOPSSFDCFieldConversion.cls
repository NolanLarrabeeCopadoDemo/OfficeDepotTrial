public with sharing class AOPSSFDCFieldConversion {
    
    /**
     * Converts a timestamp String with the AOPS format into an SFDC Datetime.
     */
    public static Datetime convertTimestamp(String aopsTimestamp) {
        if(aopsTimestamp == null || aopsTimestamp == '') return null;
        
        Integer year = Integer.valueOf(aopsTimestamp.split('-').get(0));
        Integer month = Integer.valueOf(aopsTimestamp.split('-').get(1));
        Integer day = Integer.valueOf(aopsTimestamp.split('-').get(2));
        Date d = Date.newInstance(year, month, day);

        Integer hour = Integer.valueOf(aopsTimestamp.split('-').get(3).split('\\.').get(0));
        Integer minute = Integer.valueOf(aopsTimestamp.split('\\.').get(1));
        Integer second = Integer.valueOf(aopsTimestamp.split('\\.').get(2));
        Integer microsecond = Integer.valueOf(aopsTimestamp.split('\\.').get(3));
        Integer millisecond = microsecond / 1000;
        Time t = Time.newInstance(hour, minute, second, millisecond);

        return Datetime.newInstance(d, t);
    }
}