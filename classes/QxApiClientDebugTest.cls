/*
 * Copyright (c) 2018 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 *
 *
 *@author : Romain Derval
 */
@isTest
public class QxApiClientDebugTest {
    

    static TestMethod void test_debug(){
        
        Test.startTest(); 
        
        QxApiClientDebug cpqDebug = new QxApiClientDebug();
        
        cpqDebug.debug('FINER', 'This is a FINER debug message');
        cpqDebug.debug('FINEST', 'This is a FINEST debug message');
        cpqDebug.debug('This is a general message');
        String loggingLevel = cpqDebug.getLoggingLevel();
        System.assertNotEquals(null, loggingLevel, 'No Logging level found');
        String loggingFileName = cpqDebug.getLoggingFileName(null);
        System.assertEquals('MyApexDebug.log', loggingFileName, 'Wrong Filename');
        
        Test.stopTest();
    }

}