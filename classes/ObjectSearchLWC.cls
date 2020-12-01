public with sharing class ObjectSearchLWC {

    class SearchException extends Exception{}

    // Supported HTML Types
    // checkbox, date, datetime, time, email, file, password, search, tel, url, number, radio, toggle, text
    static Map<Schema.DisplayType, String> field_type_to_input_type = new Map<Schema.DisplayType, String>{
        Schema.DisplayType.ADDRESS=>'text',
        Schema.DisplayType.ANYTYPE=>'text',
        Schema.DisplayType.BASE64=>'text',
        Schema.DisplayType.DATACATEGORYGROUPREFERENCE=>'text',
        Schema.DisplayType.ENCRYPTEDSTRING=>'password',
        Schema.DisplayType.COMBOBOX=>'text',
        Schema.DisplayType.BOOLEAN=>'checkbox',
        Schema.DisplayType.DATE=>'date',
        Schema.DisplayType.DATETIME=>'datetime',
        Schema.DisplayType.CURRENCY=>'number',
        Schema.DisplayType.DOUBLE=>'number',
        Schema.DisplayType.EMAIL=>'email',
        Schema.DisplayType.INTEGER=>'number',
        Schema.DisplayType.LONG=>'number',
        Schema.DisplayType.MULTIPICKLIST=>'text',
        Schema.DisplayType.PERCENT=>'number',
        Schema.DisplayType.PHONE=>'tel',
        Schema.DisplayType.PICKLIST=>'text',
        Schema.DisplayType.REFERENCE=>'text',
        Schema.DisplayType.STRING=>'text',
        Schema.DisplayType.TEXTAREA=>'text',
        Schema.DisplayType.TIME=>'time',
        Schema.DisplayType.URL=>'url'
    };

    public class Field{
        @AuraEnabled public String field_name;
        @AuraEnabled public String field_label;
        @AuraEnabled public String field_type;
        @AuraEnabled public String value = '';

        public Field(String field_name, String field_type, String field_label){
            this.field_name = field_name;
            this.field_type = field_type;
            this.field_label = field_label;
        }
    }


    @AuraEnabled
    public static List<Field> getObjectFields(String object_api_name, List<String> field_list){
        Schema.DescribeSObjectResult object_describe = Schema.getGlobalDescribe().get(object_api_name).getDescribe();
        Map<String, Schema.SObjectField> field_map = object_describe.fields.getMap();

        for(String field_name: field_list){
            field_name = field_name.toLowerCase();
            if(! field_map.keySet().contains(field_name)){
                throw new AuraHandledException('The requested field ' + field_name + ' is not present or accessible on ' + object_api_name);
            }
        }
                
        List<Field> my_search_fields = new List<Field>();

        for(String field_name : field_list)
        {
            Schema.SObjectField field = field_map.get(field_name);
            Schema.DescribeFieldResult field_describe = field.getDescribe();
            my_search_fields.add(new Field(field_name, field_type_to_input_type.get(field_describe.getType()), field_describe.label));
        }

        return my_search_fields;
    }

    @TestVisible
    static List<String> fieldListToFieldNames(List<Field> my_query_fields){
        List<String> field_api_names = new List<String>();
        for(Field fld: my_query_fields)
            field_api_names.add(fld.field_name);
        return field_api_names;
    }

    public static List<Query.Condition> generateConditions(String filter){
        List<String> base_conditions = filter.split(',');
        List<Query.Condition> conditions = new List<Query.Condition>();
        for(String condition_line: base_conditions){
            List<String> condt = condition_line.split(':');
            if(condt.size() != 3)
                throw new SearchException('Invalid Condition: ' + condition_line);
            
            switch on condt[1] {
                when 'Eq' {
                    conditions.add(Query.ConditionEq(condt[0], condt[2])); 
                }
                when else {
                    throw new SearchException('Condition not implimented: ' + condition_line);
                }
            }
        }

        return conditions;
    }

    @AuraEnabled
    public static List<SObject> runSOQLSearch(String object_api_name, String query_fields, String filter){
        System.debug(LoggingLevel.INFO, object_api_name);
        System.debug(LoggingLevel.INFO, query_fields);
        List<Field> my_query_fields = (List<Field>) JSON.deserialize(query_fields, List<Field>.class);

        List<String> fields_to_query = fieldListToFieldNames(my_query_fields);
        Query my_query = new Query(object_api_name).selectFields(fields_to_query);
        for(Field fld: my_query_fields){
            if(! String.isBlank(fld.value) && fld.field_type == 'text'){
                my_query.addConditionLike(fld.field_name, fld.value + '%');
            }
        }

        if(String.isNotBlank(filter)){
            for (Query.Condition cond: generateConditions(filter))
                my_query.addCondition(cond);
        }

        List<SObject> results = my_query.setLimit(50).run();

        return results;
    }


}