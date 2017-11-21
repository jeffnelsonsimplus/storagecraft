/**
  \file
  \brief        Test Apex controller GuidePDFExtension
  \details
  \author       Sean Oldoryd
  \version      1.0
  \date         14 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
 */
@IsTest(SeeAllData=true)
public class GuidePDFExtensionTest {

    @IsTest public static void testGuidePDFExtension() {
        Guide__c conv = new Guide__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(conv);

        GuidePDFExtension gpdfe = new GuidePDFExtension(sc);

        System.assert(gpdfe != null);

    }
}