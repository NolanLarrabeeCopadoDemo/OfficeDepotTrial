public without sharing class OrgManagement {
    class OrgException extends Exception{}

    public static List<Org__c> getPotentialBandsTrigg(
        List<Org__c> my_org_list
    ){
        Set<String> my_potential_band_keys = new Set<String>();
        for(Org__c an_org: my_org_list){
            // TODO: Find a way to clean this up, after tests
            if (an_org.Global_Ultimate_Employee_Count__c == null || an_org.High_Level_Industry__c == null || an_org.GLOBAL_ULTIMATE_SALES_AMT__c == null ){
                continue;
            }
            an_org.Banding_Key__c = PotentialBandManagment.getBandingKey(
                an_org.High_Level_Industry__c,
                PotentialBandManagment.getEmployeeCountBand(Integer.valueOf(an_org.Global_Ultimate_Employee_Count__c)),
                PotentialBandManagment.getRevenueBand(Integer.valueOf(an_org.GLOBAL_ULTIMATE_SALES_AMT__c))
            );
            my_potential_band_keys.add(an_org.Banding_Key__c);
        }

        List<Potential_Band__c> potential_banding_keys = [
            SELECT
                Id,
                Banding_Key__c
            FROM Potential_Band__c
            WHERE Banding_Key__c IN :my_potential_band_keys];

        return getPotentialBands(my_org_list, potential_banding_keys);
    }

    // TODO: Look into Null Key Values
    @TestVisible
    private static List<Org__c> getPotentialBands(
        List<Org__c> my_org_list, List<Potential_Band__c> potential_banding_keys
    ){
        Map<String, Id> keys_to_ids = new Map<String, Id>();
        for(Potential_Band__c band: potential_banding_keys)
                keys_to_ids.put(band.Banding_Key__c, band.Id);

        for(Org__c an_org: my_org_list)
            if(keys_to_ids.keySet().contains(an_org.Banding_Key__c))
                an_org.Potential_Band__c = keys_to_ids.get(an_org.Banding_Key__c);

        return my_org_list;
    }

    // TODO: Look into Null Key Values
    @TestVisible
    private static List<Org__c> mapLowLevelToHighLevelIndustry(
        List<Org__c> my_org_list, List<Industry_Rollup__c> my_industry_rollup_list
    ){
        Map<String, String> low_level_to_high_level = new Map<String, String>();
        for(Industry_Rollup__c roll: my_industry_rollup_list)
            low_level_to_high_level.put(roll.Low_Level_Industry__c, roll.High_Level_Industry__c);

        for(Org__c an_org: my_org_list)
            if(an_org.LOB__c != null && low_level_to_high_level.keySet().contains(an_org.LOB__c))
                an_org.High_Level_Industry__c = low_level_to_high_level.get(an_org.LOB__c);

        return my_org_list;
    }

    // TODO: Look into Null Key Values
    public static List<Org__c> mapLowLevelToHighLevelIndustryTrigg(
        List<Org__c> my_org_list
    ){
        Set<String> lob_values = new Set<String>();

        // Get Target LOBs
        for(Org__c an_org: my_org_list)
            lob_values.add(an_org.LOB__c);

        // Retrieve Industry Rollups containing lobs. 
        List<Industry_Rollup__c> my_industry_rollup_list = [
            SELECT
                Low_Level_Industry__c,
                High_Level_Industry__c
            FROM Industry_Rollup__c WHERE Low_Level_Industry__c IN :lob_values
        ];
        
        return mapLowLevelToHighLevelIndustry(my_org_list, my_industry_rollup_list);
    }

}