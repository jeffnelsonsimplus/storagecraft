/**
  \file
  \brief        Test Apex controller GuideIndexController
  \details
  \author       Sean Oldoryd
  \version      1.0
  \date         14 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
 */
@IsTest(SeeAllData=true)
public class GuideIndexControllerTest {

    private static Id saProfileIdd = [select id, name from profile where name = 'System Administrator'].Id;
    private static User admin = [select id, name from user where profileid = :saProfileIdd  AND IsActive = true LIMIT 1];

    static void setUpData(){
        String ugkGuideIString = [SELECT Guide__c from User_Guide__kav LIMIT 1].Guide__c;
        User_Guide__kav ugk = new User_Guide__kav(Title='TestIem', Guide__c = ugkGuideIString, Language='en_US', Section__c = '1', urlName = 'testUrlGUID', Landing_Page__c = true);
        test.startTest();
        insert ugk;
        test.stopTest();
    }

    @IsTest public static void testFindAllLandingPages() {
        System.runAs(admin){setUpData();}
        String lang = 'en_US';
        List<User_Guide__kav> ugk = GuideIndexController.findAllLandingPages(lang);

        System.assert(ugk != null);

    }

    @IsTest public static void testGetFieldLabels() {
        System.runAs(admin){setUpData();}
        
        Map<String,String> ugk = GuideIndexController.getFieldLabels();

        System.assert(ugk != null);

    }

}