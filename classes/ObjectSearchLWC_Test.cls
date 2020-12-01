@isTest
public without sharing class ObjectSearchLWC_Test {

    @isTest
    public static void test_getObjectFields(){

        Test.startTest();
        List<ObjectSearchLWC.Field> fields = ObjectSearchLWC.getObjectFields('Account', new List<String>{'Name'});
        Test.stopTest();
        System.assertEquals(fields[0].field_name, 'Name');
        System.assertEquals(fields[0].field_label, 'Account Name');
        System.assertEquals(fields[0].field_type, 'text');
        System.assertEquals(fields[0].value, '');
    }

    @isTest
    public static void test_fieldListToFieldNames(){

        Test.startTest();
        List<ObjectSearchLWC.Field> fields = ObjectSearchLWC.getObjectFields('Account', new List<String>{'Name'});
        List<String> field_names = ObjectSearchLWC.fieldListToFieldNames(fields);
        Test.stopTest();
        System.assertEquals(field_names[0], 'Name');
    }

    @isTest
    public static void test_generateConditions(){

        Test.startTest();
        try{
            ObjectSearchLWC.generateConditions('Account:nEq:Foo');
        } catch(ObjectSearchLWC.SearchException e){}
        ObjectSearchLWC.generateConditions('Account:Eq:Foo');
        Test.stopTest();

    }

    @isTest
    public static void test_runSOQLSearch(){
        List<ObjectSearchLWC.Field> fields = ObjectSearchLWC.getObjectFields('Account', new List<String>{'Name'});
        fields[0].value = 'Foo';
        Test.startTest();
        ObjectSearchLWC.runSOQLSearch('Account', JSON.serialize(fields), 'Name:Eq:Foo');
        Test.stopTest();
    }


}