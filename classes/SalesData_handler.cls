public class SalesData_handler {
    // Functionality  Sales Data
    public static void SaleDataAfter(list<Sales_Data__c> SalesDatalist)
    {
        Map<Id,Id> Mapinsert= new Map<Id,Id>();
        List<Org__c> OrgUpdate= new List<Org__c>();
        for(Sales_Data__c   rec :SalesDatalist){
        
          if( rec.Org__c!=null &&  rec.account_type__C=='Org' ){
             if(!(Mapinsert.containskey(rec.Org__c)))
              Mapinsert.put(rec.Org__c,rec.Id);
          }
        }
          System.debug('&&&&&Mapinsert'+Mapinsert);
          for( Id key: Mapinsert.keyset()){
               Org__C rec1= new Org__C (Id=key);
               rec1.sales_data__C= Mapinsert.get(key);
               OrgUpdate.add(rec1);
               }
            System.debug('&&&&&OrgUpdate'+OrgUpdate);
       
          if(OrgUpdate.size()>0)
          update OrgUpdate;
       
    }
    
}