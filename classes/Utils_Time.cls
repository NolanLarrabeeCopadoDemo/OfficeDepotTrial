public class Utils_Time {
    
    public enum TimeUnit { BUSINESS_DAYS, DAYS, HOURS, MINUTES, SECONDS }
    
    /*
	 * @description Returns the absolute value of the difference between two times in the units specified.
	 * @author Ryan Tocco
	 * @datecreated 2018-12-6
	 *
	 * @changes Log any modifications here...
	 */
    public static Integer getTimeDifference(TimeUnit unit, DateTime time1, DateTime time2) {
        DateTime laterTime = time1 > time2 ? time1 : time2;
        DateTime earlierTime = time1 > time2 ? time2 : time1;
        Integer milliseconds = (laterTime.getTime() - earlierTime.getTime()).intValue();
        
        switch on unit {
            when BUSINESS_DAYS {
                // We start at the earlier date and go up to the later date, keeping track of how many business days we pass.
                Integer days = 0;
                DateTime track = earlierTime;
                // While track does is not the same day as laterTime.
                while(track.month() != laterTime.month() || track.day() != laterTime.day() || track.year() != laterTime.year()) {
                    // If track is a business day.
                    if(track.format('E') != 'Sat' && track.format('E') != 'Sun') {
                        days++;
                    }
                    track = track.addDays(1);
                }
                return days;
            }
            when DAYS {
                Integer days = milliseconds / 1000 / 60 / 60 / 24;
                // Since the above calculation will round down, we sometimes need to add a day.
                if(laterTime.time() < earlierTime.time()) {
                    days += 1;
                }
                return days;
            }
            when HOURS {
                return milliseconds / 1000 / 60 / 60;
            }
            when MINUTES {
                return milliseconds / 1000 / 60;
            }
            when SECONDS {
                return milliseconds / 1000;
            }
            when else {
                return 0;
            }
        }
    }
    
    /*
	 * @description Adds the specified number of business days to the DateTime dt and returns the result.
	 * @author Ryan Tocco
	 * @datecreated 2018-12-6
	 *
	 * @changes Log any modifications here...
	 */
    public static DateTime addBusinessDays(DateTime dt, Integer days) {
        while(days > 0) {
            dt = dt.addDays(1);
            // If dt is Saturday, we move to Monday.
            if(dt.format('E') == 'Sat') {
                dt = dt.addDays(2);
            }
            days--;
        }
        return dt;
    }
    
    /*
	 * @description Subtracts the specified number of business days to the DateTime dt and returns the result.
	 * @author Ryan Tocco
	 * @datecreated 2018-12-6
	 *
	 * @changes Log any modifications here...
	 */
    public static DateTime subtractBusinessDays(DateTime dt, Integer days) {
        while(days > 0) {
            dt = dt.addDays(-1);
            // If dt is Sunday, we move to Friday.
            if(dt.format('E') == 'Sun') {
                dt = dt.addDays(-2);
            }
            days--;
        }
        return dt;
    }
}