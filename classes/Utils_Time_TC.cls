@isTest
private class Utils_Time_TC {

    static testMethod void testGetTimeDifference() {
        DateTime time1 = DateTime.newInstance(2018, 12, 3, 10, 5, 32); // Monday December 3rd, 2018 at 10:05:32 AM
        DateTime time2 = DateTime.newInstance(2018, 11, 22, 8, 24, 53); // Thursday November 22nd, 2018 at 8:24:53 AM
        
        Integer response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(7, response, 'Business days between Dec. 3 and Nov. 22 should be 7.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(11, response, 'Days between Dec. 3 and Nov. 22 should be 11.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.HOURS, time1, time2);
        System.assertEquals(265, response, 'Hours between Dec. 3 and Nov. 22 should be 265.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.MINUTES, time1, time2);
        System.assertEquals(15940, response, 'Minutes between Dec. 3 and Nov. 22 should be 15940.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.SECONDS, time1, time2);
        System.assertEquals(956439, response, 'Seconds between Dec. 3 and Nov. 22 should be 956439.');
        
        // Change up the DateTimes.
        time1 = DateTime.newInstance(2018, 12, 3, 10, 5, 32); // Monday December 3rd, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 12, 2, 12, 10, 15); // Sunday December 2nd, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(0, response, 'Business days between Dec. 3 and Dec. 2 should be 0.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(1, response, 'Days between Dec. 3 and Dec. 2 should be 1.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 3, 10, 5, 32); // Monday December 3rd, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 12, 1, 12, 10, 15); // Saturday December 1st, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(0, response, 'Business days between Dec. 3 and Dec. 1 should be 0.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(2, response, 'Days between De. 3 and Dec. 1 should be 2.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 2, 10, 5, 32); // Sunday December 2nd, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 12, 2, 12, 10, 15); // Sunday December 2nd, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(0, response, 'Business days between Dec. 2 and Dec. 2 should be 0.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(0, response, 'Days between Dec. 2 and Dec. 2 should be 0.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 2, 10, 5, 32); // Sunday December 2nd, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 12, 1, 12, 10, 15); // Saturday December 1st, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(0, response, 'Business days between Dec. 2 and Dec. 1 should be 0.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(1, response, 'Days between Dec. 2 and Dec. 1 should be 1.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 2, 10, 5, 32); // Sunday December 2nd, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 11, 30, 12, 10, 15); // Friday November 30th, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(1, response, 'Business days between Dec. 2 and Nov. 30 should be 1.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(2, response, 'Days between Dec. 2 and Nov. 30 should be 2.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 1, 10, 5, 32); // Saturday December 1st, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 11, 30, 12, 10, 15); // Friday November 30th, 2018 at 12:10:15 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(1, response, 'Business days between Dec. 1 and Nov. 30 should be 1.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(1, response, 'Days between Dec. 1 and Nov. 30 should be 1.');
        
        // Change up the DateTimes again.
        time1 = DateTime.newInstance(2018, 12, 1, 10, 5, 32); // Saturday December 1st, 2018 at 10:05:32 AM
        time2 = DateTime.newInstance(2018, 11, 25, 8, 24, 53); // Saturday November 25th, 2018 at 8:24:53 AM
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.BUSINESS_DAYS, time1, time2);
        System.assertEquals(5, response, 'Business days between Dec. 1 and Nov. 25 should be 5.');
        
        response = Utils_Time.getTimeDifference(Utils_Time.TimeUnit.DAYS, time1, time2);
        System.assertEquals(6, response, 'Days between Dec. 1 and Nov. 25 should be 6.');
    }
    
    static testMethod void testAddBusinessDays() {
        DateTime dt = DateTime.newInstance(2018, 11, 23, 10, 5, 32); // Friday November 23rd, 2018 at 10:05:32 AM
        
        DateTime result1 = Utils_Time.addBusinessDays(dt, 1);
        System.assertEquals(11, result1.month(), 'Adding 1 day should give month 11.');
        System.assertEquals(26, result1.day(), 'Adding 1 day should give day 26.');
        System.assertEquals(2018, result1.year(), 'Adding 1 day should give year 2018.');
        
        DateTime result2 = Utils_Time.addBusinessDays(dt, 2);
        System.assertEquals(11, result2.month(), 'Adding 2 days should give month 11.');
        System.assertEquals(27, result2.day(), 'Adding 2 days should give day 27.');
        System.assertEquals(2018, result2.year(), 'Adding 2 days should give year 2018.');
        
        DateTime result3 = Utils_Time.addBusinessDays(dt, 6);
        System.assertEquals(12, result3.month(), 'Adding 6 days should give month 12.');
        System.assertEquals(3, result3.day(), 'Adding 6 days should give day 3.');
        System.assertEquals(2018, result3.year(), 'Adding 6 days should give year 2018.');
    }
    
    static testMethod void testSubtractBusinessDays() {
        DateTime dt = DateTime.newInstance(2018, 12, 3, 10, 5, 32); // Monday December 3rd, 2018 at 10:05:32 AM
        
        DateTime result1 = Utils_Time.subtractBusinessDays(dt, 1);
        System.assertEquals(11, result1.month(), 'Subtracting 1 day should give month 11.');
        System.assertEquals(30, result1.day(), 'Subtracting 1 day should give day 30.');
        System.assertEquals(2018, result1.year(), 'Subtracting 1 day should give year 2018.');
        
        DateTime result2 = Utils_Time.subtractBusinessDays(dt, 2);
        System.assertEquals(11, result2.month(), 'Subtracting 2 days should give month 11.');
        System.assertEquals(29, result2.day(), 'Subtracting 2 days should give day 29.');
        System.assertEquals(2018, result2.year(), 'Subtracting 2 days should give year 2018.');
        
        DateTime result3 = Utils_Time.subtractBusinessDays(dt, 6);
        System.assertEquals(11, result3.month(), 'Subtracting 6 days should give month 11.');
        System.assertEquals(23, result3.day(), 'Subtracting 6 days should give day 23.');
        System.assertEquals(2018, result3.year(), 'Subtracting 6 days should give year 2018.');
    }
}