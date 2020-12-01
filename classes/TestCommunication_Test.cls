/**********************************************************
Class: TestCommunication_Test 
Author : Mike Keller
Date:    10/27/2011
Details : To test communication stub 
***********************************************************/
@isTest
public with sharing class TestCommunication_Test {
  @isTest
  static void testCommService(){
  	String result = testCommunication.communicate('Hello World');
  	System.assertEquals(result,'dlroW olleH');
  	
  	String emptyRes = testCommunication.communicate('');
  	System.assertEquals(emptyRes,'');
  }
}