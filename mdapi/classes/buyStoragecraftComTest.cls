@isTest
public class buyStoragecraftComTest{

    private static final DateTime nowDateTime = DateTime.now();

    public static testmethod void testArrayOfLineItem(){
        buyStoragecraftCom.ArrayOfLineItem objArrayOfLineItem = new buyStoragecraftCom.ArrayOfLineItem();

        buyStoragecraftCom.LineItem objLineItem = new buyStoragecraftCom.LineItem();
        objLineItem.Name = 'testLIName';
        objLineItem.Sku = '54ad-87sa-24gh-99po';
        objLineItem.Quantity = 2;

        objArrayOfLineItem.LineItem = new List<buyStoragecraftCom.LineItem>{objLineItem};
        System.assertEquals('testLIName', objArrayOfLineItem.LineItem[0].Name);
        System.assertEquals('54ad-87sa-24gh-99po', objArrayOfLineItem.LineItem[0].Sku);
        System.assertEquals(2, objArrayOfLineItem.LineItem[0].Quantity);
    }

    public static testmethod void testSerial(){
        buyStoragecraftCom.Serial objSerial = new buyStoragecraftCom.Serial();
        objSerial.SerialNumber = '1111-1111-1111-1111';
        objSerial.Source = 'testSource';
        objSerial.DigitalGoodName = 'testDigitalGoodName';

        System.assertEquals('1111-1111-1111-1111', objSerial.SerialNumber);
        System.assertEquals('testSource', objSerial.Source);
        System.assertEquals('testDigitalGoodName', objSerial.DigitalGoodName);
    }

    public static testmethod void testMaintenanceRecord(){
        buyStoragecraftCom.MaintenanceRecord objMaintenanceRecord = new buyStoragecraftCom.MaintenanceRecord();

        objMaintenanceRecord.ExpirationDate = nowDateTime;
        objMaintenanceRecord.PremiumSupport = true;

        System.assertEquals(nowDateTime, objMaintenanceRecord.ExpirationDate);
        System.assertEquals(true, objMaintenanceRecord.PremiumSupport);
    }

    public static testmethod void testImageManagerJobs_Wrapper(){
        buyStoragecraftCom.ImageManagerJobs_Wrapper objImageManagerJobs_Wrapper = new buyStoragecraftCom.ImageManagerJobs_Wrapper();

        objImageManagerJobs_Wrapper.IFTP_Jobs = 1;
        objImageManagerJobs_Wrapper.HSR_Jobs = 2;
        objImageManagerJobs_Wrapper.SST_Jobs = 3;

        System.assertEquals(1, objImageManagerJobs_Wrapper.IFTP_Jobs);
        System.assertEquals(2, objImageManagerJobs_Wrapper.HSR_Jobs);
        System.assertEquals(3, objImageManagerJobs_Wrapper.SST_Jobs);
    }

    public static testmethod void testArrayOfSerial(){
        buyStoragecraftCom.ArrayOfSerial objArrayOfSerial = new buyStoragecraftCom.ArrayOfSerial();

        buyStoragecraftCom.Serial objSerial = new buyStoragecraftCom.Serial();
        objSerial.SerialNumber = '1111-1111-1111-1111';
        objSerial.Source = 'testSource';
        objSerial.DigitalGoodName = 'testDigitalGoodName';

        objArrayOfSerial.Serial = new List<buyStoragecraftCom.Serial>{objSerial};

        System.assertEquals('1111-1111-1111-1111', objArrayOfSerial.Serial[0].SerialNumber);
        System.assertEquals('testSource', objArrayOfSerial.Serial[0].Source);
        System.assertEquals('testDigitalGoodName', objArrayOfSerial.Serial[0].DigitalGoodName);
    }

    public static testmethod void testArrayOfString(){
        buyStoragecraftCom.ArrayOfString objArrayOfString = new buyStoragecraftCom.ArrayOfString();
        objArrayOfString.string_x = new List<String>{'teststring_x'};
        System.assertEquals('teststring_x', objArrayOfString.string_x[0]);
    }

    public static testmethod void testOrderExportInformation(){
        buyStoragecraftCom.OrderExportInformation objOrderExportInformation = new buyStoragecraftCom.OrderExportInformation();

        objOrderExportInformation.OrderNumber = 12345;
        objOrderExportInformation.OrderDate = nowDateTime;

        System.assertEquals(12345, objOrderExportInformation.OrderNumber);
        System.assertEquals(nowDateTime, objOrderExportInformation.OrderDate);
    }

    public static testmethod void testLineItem(){
        buyStoragecraftCom.LineItem objLineItem = new buyStoragecraftCom.LineItem();

        objLineItem.Name = 'testLIName';
        objLineItem.Sku = '54ad-87sa-24gh-99po';
        objLineItem.Quantity = 2;

        System.assertEquals('testLIName', objLineItem.Name);
        System.assertEquals('54ad-87sa-24gh-99po', objLineItem.Sku);
        System.assertEquals(2, objLineItem.Quantity);
    }

    public static testmethod void testSerialSearchResult(){
        buyStoragecraftCom.SerialSearchResult objSerialSearchResult = new buyStoragecraftCom.SerialSearchResult();

        objSerialSearchResult.OrderNumber = 5285;
        objSerialSearchResult.OrderDate = nowDateTime;
        objSerialSearchResult.CountryCode = '+56';

        System.assertEquals(5285, objSerialSearchResult.OrderNumber);
        System.assertEquals(nowDateTime, objSerialSearchResult.OrderDate);
        System.assertEquals('+56', objSerialSearchResult.CountryCode);
    }

    public static testmethod void testContactInformation(){
        buyStoragecraftCom.ContactInformation objContactInformation = new buyStoragecraftCom.ContactInformation();

        objContactInformation.Firstname = 'testFirstname';
        objContactInformation.Lastname = 'testLastname';
        objContactInformation.Company = 'testCompany';
        objContactInformation.Address1 = 'testAddress1';
        objContactInformation.Address2 = 'testAddress2';
        objContactInformation.City = 'testCity';
        objContactInformation.Province = 'testProvince';
        objContactInformation.PostalCode = '000000';
        objContactInformation.CountryCode = '+56';
        objContactInformation.Phone = '1252526969';
        objContactInformation.Fax = '898523624';
        objContactInformation.Email = 'test@test.com';

        System.assertEquals('testFirstname', objContactInformation.Firstname);
        System.assertEquals('testLastname', objContactInformation.Lastname);
        System.assertEquals('testCompany', objContactInformation.Company);
        System.assertEquals('testAddress1', objContactInformation.Address1);
        System.assertEquals('testAddress2', objContactInformation.Address2);
        System.assertEquals('testCity', objContactInformation.City);
        System.assertEquals('testProvince', objContactInformation.Province);
        System.assertEquals('000000', objContactInformation.PostalCode);
        System.assertEquals('+56', objContactInformation.CountryCode);
        System.assertEquals('1252526969', objContactInformation.Phone);
        System.assertEquals('898523624', objContactInformation.Fax);
        System.assertEquals('test@test.com', objContactInformation.Email);
    }

    public static testmethod void testArrayOfOrderExportInformation(){
        buyStoragecraftCom.ArrayOfOrderExportInformation objArrayOfOrderExportInformation = new buyStoragecraftCom.ArrayOfOrderExportInformation();

        buyStoragecraftCom.OrderExportInformation objOrderExportInformation = new buyStoragecraftCom.OrderExportInformation();
        objOrderExportInformation.OrderNumber = 12345;
        objOrderExportInformation.OrderDate = nowDateTime;

        objArrayOfOrderExportInformation.OrderExportInformation = new List<buyStoragecraftCom.OrderExportInformation>{objOrderExportInformation};

        System.assertEquals(12345,objArrayOfOrderExportInformation.OrderExportInformation[0].OrderNumber);
        System.assertEquals(nowDateTime, objArrayOfOrderExportInformation.OrderExportInformation[0].OrderDate);
    }
}