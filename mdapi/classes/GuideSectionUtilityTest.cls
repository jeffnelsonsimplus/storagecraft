/**
  \file
  \brief        Test Apex controller GuideSectionUtility
  \details
  \author       Sean Oldoryd
  \version      1.0
  \date         14 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
 */
@IsTest(SeeAllData=true)
public class GuideSectionUtilityTest {
    private static Id saProfileIdd = [select id, name from profile where name = 'System Administrator'].Id;
    private static User admin = [select id, name from user where profileid = :saProfileIdd  AND IsActive = true LIMIT 1];
    private static List<User_Guide__kav> ugkList = new List<User_Guide__kav>();
    private static User_Guide__kav ugkObj;
    private static User_Guide__kav ugkObjDiffSection;

    static void setUpData(){
        String ugkGuideIString = [SELECT Guide__c from User_Guide__kav LIMIT 1].Guide__c;
        User_Guide__kav ugk = new User_Guide__kav(Title='TestIem', Guide__c = ugkGuideIString , Language='en_US', Section__c = '1', urlName = 'testUrlGUID', Landing_Page__c = true);
        User_Guide__kav ugkDiffSection = new User_Guide__kav(Title='TestIem', Guide__c = ugkGuideIString, Language='en_US', Section__c = '2', urlName = 'testUrlGUID2', Landing_Page__c = true);
        test.startTest();
        insert ugk;
        insert ugkDiffSection;
        test.stopTest();
        ugkList.add(ugk);
        ugkObj = ugk;
        ugkObjDiffSection = ugkDiffSection;
    }

    @IsTest public static void testsortGuideSections() {
        System.runAs(admin){setUpData();}
        List<User_Guide__kav> ugk = GuideSectionUtility.sortGuideSections(ugkList);
        System.assert(ugk != null);

    }

    @IsTest public static void testCompareTo() {
        System.runAs(admin){setUpData();}
        GuideSectionUtility.GuideSectionWrapper wrapper = new GuideSectionUtility.GuideSectionWrapper(ugkObj);
        GuideSectionUtility.GuideSectionWrapper wrapperDiffSection = new GuideSectionUtility.GuideSectionWrapper(ugkObjDiffSection);

        Integer a = wrapper.compareTo(wrapper);
        System.assert(a != null);
        Integer aDiffSection = wrapper.compareTo(wrapperDiffSection);
        System.assert(aDiffSection != null);



    }

}