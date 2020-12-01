@isTest
private class FormatString_TC{
 static testMethod void FormatStringTest (){
 FormatString.preZeroFormat('123',8);
 FormatString.postZeroFormat('123',6);
 
 }
}