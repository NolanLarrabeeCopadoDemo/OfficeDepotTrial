public without sharing class PotentialBandManagment {
    public static List<Potential_Band__c> getBandingKeys(List<Potential_Band__c> bands){
        for(Potential_Band__c band: bands){
            band.Banding_Key__c = getBandingKey(
                band.High_Level_Industry__c,
                Integer.valueOf(band.Employee_Count_Band__c.round(System.RoundingMode.FLOOR)),
                Integer.valueOf(band.Revenue_Band__c)
            );
        }
        return bands;
    }

    public static String getBandingKey(
        String high_level_industry,
        Integer employee_count_band,
        Integer revenue_band
    ){
        return (
            high_level_industry +
            String.valueOf(employee_count_band) +
            String.valueOf(revenue_band)
        ).replaceAll('[^a-zA-Z0-9]', '').toLowerCase();
    }

    public static Integer getEmployeeCountBand(Integer employee_count){
        if (employee_count == null)
            return 0;
        if(employee_count > 50000)
            return 5;
        if (employee_count > 10000)
            return 4;
        if (employee_count > 5000)
            return 3;
        if (employee_count > 200)
            return 2;
        if (employee_count > 0)
            return 1;
        else {
            return 0;
        }
    }

    public static Integer getRevenueBand(Integer revenue){

        if (revenue == null)
            return 0;
        if(revenue > 1000000000.0)
            return 5;
        if (revenue > 500000000.0)
            return 4;
        if (revenue > 50000000.0)
            return 3;
        if (revenue > 10000000.0)
            return 2;
        if (revenue > 0.0)
            return 1;
        else {
            return 0;
        }
    }

    public static String getSegment(Integer total_potential){

        if (total_potential == null)
            return 'No Segment Assigned';
        if(total_potential > 2000000)
            return 'Strategic';
        if (total_potential >= 500000)
            return 'Key Accounts 1';
        if (total_potential >= 50000)
            return 'Key Accounts 2';
        else {
            return 'ISO Accounts';
        }
    }

    public static List<Potential_Band__c> setSegment(List<Potential_Band__c> bands){
        for(Potential_Band__c band: bands){
            band.Segment__c = getSegment(Integer.valueOf(band.Total_Industry_Potential__c.round(System.RoundingMode.FLOOR)));
        }
        return bands;
    }


}