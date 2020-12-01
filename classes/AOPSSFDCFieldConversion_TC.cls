@IsTest
public class AOPSSFDCFieldConversion_TC {
    
    @IsTest
    static void convertTimestamp() {
        String ts = '2020-03-30-01.03.14.3151';
        Datetime dt = AOPSSFDCFieldConversion.convertTimestamp(ts);

        System.assertEquals(2020, dt.year());
        System.assertEquals(3, dt.month());
        System.assertEquals(30, dt.day());
        System.assertEquals(1, dt.hour());
        System.assertEquals(3, dt.minute());
        System.assertEquals(14, dt.second());
        System.assertEquals(3, dt.millisecond());
    }

}