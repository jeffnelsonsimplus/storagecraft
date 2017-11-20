/**
  \file
  \brief        Test Apex controller GuideAsPDFController
  \details
  \author       Sean Oldoryd
  \version      1.0
  \date         14 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
 */
@IsTest(SeeAllData=true)
public class GuideAsPDFControllerTest {

    private static Id saProfileIdd = [select id, name from profile where name = 'System Administrator'].Id;
    private static User admin = [select id, name from user where profileid = :saProfileIdd  AND IsActive = true LIMIT 1];
    private static Id ugkId;

    static void setUpData(){
        String ugkGuideIString = [SELECT Guide__c from User_Guide__kav LIMIT 1].Guide__c;
        User_Guide__kav ugk = new User_Guide__kav(Title='TestIem', Guide__c = ugkGuideIString, Language='en_US', Section__c = '1', urlName = 'testUrlGUID');
        test.startTest();
        insert ugk;
        test.stopTest();

        ugkId = ugk.Id;
    }

    @IsTest public static void testGetNextArticle() {
        System.runAs(admin){setUpData();}

        String guideId = String.valueOf(ugkId);
        String lang = 'en_US';
        User_Guide__kav ugk = GuideAsPDFController.getNextArticle(guideId);

        System.assert(ugk != null);

    }

}