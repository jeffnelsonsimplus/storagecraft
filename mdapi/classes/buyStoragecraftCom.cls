//Generated by wsdl2apex

public class buyStoragecraftCom {
    public class ArrayOfLineItem {
        public buyStoragecraftCom.LineItem[] LineItem;
        private String[] LineItem_type_info = new String[]{'LineItem','https://buy.storagecraft.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'LineItem'};
    }
    public class Serial {
        public String SerialNumber;
        public String Source;
        public String DigitalGoodName;
        public buyStoragecraftCom.MaintenanceRecord MaintenanceRecord;
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Source_type_info = new String[]{'Source','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] DigitalGoodName_type_info = new String[]{'DigitalGoodName','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] MaintenanceRecord_type_info = new String[]{'MaintenanceRecord','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'SerialNumber','Source','DigitalGoodName','MaintenanceRecord'};
    }
    public class MaintenanceRecord {
        public DateTime ExpirationDate;
        public Boolean PremiumSupport;
        private String[] ExpirationDate_type_info = new String[]{'ExpirationDate','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] PremiumSupport_type_info = new String[]{'PremiumSupport','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'ExpirationDate','PremiumSupport'};
    }
    public class ImageManagerJobs_Wrapper {
        public Integer IFTP_Jobs;
        public Integer HSR_Jobs;
        public Integer SST_Jobs;
        private String[] IFTP_Jobs_type_info = new String[]{'IFTP_Jobs','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] HSR_Jobs_type_info = new String[]{'HSR_Jobs','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] SST_Jobs_type_info = new String[]{'SST_Jobs','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'IFTP_Jobs','HSR_Jobs','SST_Jobs'};
    }
    public class ArrayOfSerial {
        public buyStoragecraftCom.Serial[] Serial;
        private String[] Serial_type_info = new String[]{'Serial','https://buy.storagecraft.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'Serial'};
    }
    public class ArrayOfString {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','https://buy.storagecraft.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class OrderExportInformation {
        public Integer OrderNumber;
        public DateTime OrderDate;
        public buyStoragecraftCom.ArrayOfLineItem LineItems;
        public buyStoragecraftCom.ContactInformation BillToContact;
        public buyStoragecraftCom.ContactInformation EndUserContact;
        private String[] OrderNumber_type_info = new String[]{'OrderNumber','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] OrderDate_type_info = new String[]{'OrderDate','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] LineItems_type_info = new String[]{'LineItems','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] BillToContact_type_info = new String[]{'BillToContact','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] EndUserContact_type_info = new String[]{'EndUserContact','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'OrderNumber','OrderDate','LineItems','BillToContact','EndUserContact'};
    }
    public class LineItem {
        public String Name;
        public String Sku;
        public Integer Quantity;
        public buyStoragecraftCom.ArrayOfSerial Serials;
        public buyStoragecraftCom.ImageManagerJobs_Wrapper ImageManagerJobs;
        private String[] Name_type_info = new String[]{'Name','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Sku_type_info = new String[]{'Sku','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Quantity_type_info = new String[]{'Quantity','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] Serials_type_info = new String[]{'Serials','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] ImageManagerJobs_type_info = new String[]{'ImageManagerJobs','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Sku','Quantity','Serials','ImageManagerJobs'};
    }
    public class SerialSearchResult {
        public Integer OrderNumber;
        public DateTime OrderDate;
        public String CountryCode;
        public buyStoragecraftCom.ArrayOfString MatchedSerials;
        public buyStoragecraftCom.OrderExportInformation details;
        public String errorMessage;
        private String[] OrderNumber_type_info = new String[]{'OrderNumber','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] OrderDate_type_info = new String[]{'OrderDate','https://buy.storagecraft.com/',null,'1','1','false'};
        private String[] CountryCode_type_info = new String[]{'CountryCode','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] MatchedSerials_type_info = new String[]{'MatchedSerials','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] details_type_info = new String[]{'details','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'OrderNumber','OrderDate','CountryCode','MatchedSerials','details','errorMessage'};
    }
    public class ContactInformation {
        public String Firstname;
        public String Lastname;
        public String Company;
        public String Address1;
        public String Address2;
        public String City;
        public String Province;
        public String PostalCode;
        public String CountryCode;
        public String Phone;
        public String Fax;
        public String Email;
        private String[] Firstname_type_info = new String[]{'Firstname','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Lastname_type_info = new String[]{'Lastname','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Company_type_info = new String[]{'Company','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Address1_type_info = new String[]{'Address1','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Address2_type_info = new String[]{'Address2','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] City_type_info = new String[]{'City','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Province_type_info = new String[]{'Province','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] CountryCode_type_info = new String[]{'CountryCode','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Fax_type_info = new String[]{'Fax','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] Email_type_info = new String[]{'Email','https://buy.storagecraft.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'Firstname','Lastname','Company','Address1','Address2','City','Province','PostalCode','CountryCode','Phone','Fax','Email'};
    }
    public class ArrayOfOrderExportInformation {
        public buyStoragecraftCom.OrderExportInformation[] OrderExportInformation;
        private String[] OrderExportInformation_type_info = new String[]{'OrderExportInformation','https://buy.storagecraft.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'https://buy.storagecraft.com/','true','false'};
        private String[] field_order_type_info = new String[]{'OrderExportInformation'};
    }
}