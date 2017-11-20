public class SerialNumberSupportInfo {
    class AccountData
    {
        public Boolean Valid = false;
        public String Name = 'unknown';
    }
    private static final String DateFormat = 'yyyy-MM-dd';

    public static String getSNInfo(String serialNumber){

        serialNumber = formatSerial(serialNumber);
        System.debug('GetSerialNumberInformation for ' + serialNumber);

        string t = '';
        try{
            serviceStoragecraftCom.STCSerialNumberWSPort sscService = new serviceStoragecraftCom.STCSerialNumberWSPort();
            serviceStoragecraftCom.serialNumberInformationResponse r = sscService.getSerialNumberInformation('STCWebstoreWSAccess', 'vk3423#kck.,*', 'STCWebstoreWSAccess', serialNumber);
            System.debug('--r-'+r);
            if (r == null)
            {
                // Success.Set(activityContext, Constants.FAILURE);
                // Message.Set(activityContext, String.Format('Serial Number {0} not found.', serialNumber));
                return t;
            }

            t = BuildString(r.serialNumberInformation);
            System.debug(t);
            /*
            Message.Set(activityContext, t);
            Success.Set(activityContext, Constants.SUCCESS);
            */
            System.debug('Exiting IssueNewSerialNumbers');
        }
        catch (Exception ex)
        {
            /*
            Message.Set(activityContext, 'Serial Number not verified');
            Success.Set(activityContext, Constants.FAILURE);
            */
            System.debug(ex);
        }

        return t;
    }

    public static string ProductType(String product)
    {
        if(product == 'SPAny')
            return 'MSP';
        if(product == 'SPDesktop')
            return 'Desktop';
        if(product == 'SPServer')
            return 'Server';
        if(product == 'SPSBS')
            return 'Small Business Server';
        if(product == 'SPIT')
            return 'IT Edition';
        if(product == 'SPSBSPremium')
            return 'Small Business Server Premium';
        if(product == 'SPGRE')
            return 'Granular Recovery for Exchange';
        if(product == 'SPIME')
            return 'ImageManager';

        return 'unknown';
    }

    public static string BuildString(serviceStoragecraftCom.serialNumberInformation info)
    {
        if (info == null)
        {
            return '';
        }

        Boolean maintenanceExpired = false;
        String maintenanceEndDate = 'N/A';
        if (info.maintenanceEndDate != null)
        {
            maintenanceEndDate = info.maintenanceEndDate.format(DateFormat);

            DateTime today = DateTime.now();
            DateTime stopDay = DateTime.newInstance(info.maintenanceEndDate.Year(), info.maintenanceEndDate.Month(), info.maintenanceEndDate.Day());

            if (stopDay < today && !stopDay.isSameDay(today))
            {
                maintenanceExpired = true;
            }
        }
        string premiumSupport = info.premiumSupport ? 'Yes' : 'No';
        string version = String.valueOf(info.version);
        string upgrade = (0 == info.upgrade) ? 'None' : String.valueOf(info.upgrade);
        string product = (info.productType != null) ? ProductType(info.productType) : ProductType('UNKNOWN');
        string expiration = (info.expirationDate != null) ? info.expirationDate.format(DateFormat) : 'None';
        string licenses = (info.numberOfLicenses < 0) ? 'Unlimited' : String.valueOf(info.numberOfLicenses);
        string region = (info.mspInformation == null) ? '' : info.mspInformation.region;
        string mspName = (info.mspInformation == null) ? '' : info.mspInformation.companyName;
        string licenseType = info.virtual_x ? 'Virtual' : 'Standard';

        String result = '';

        if ('MSP'.Equals(product) || info.isMSPLicense)
        {
            result += 'Region:  '+region+'\n';
            result += 'Product:  MSP\n';
            result += 'MSP Name:  '+mspName+'\n';

            if (info.legacyMSPLicense)
            {
                result += 'Legacy MSP License:  Yes\n';
            }
        }
        else if ('Granular Recovery for Exchange'.Equals(product))
        {
            // Test Serial Numbers:  4F8F-6444-9CD9-E000    25A5-38E2-80A5-91D1
            result += 'Expiration Date:  '+expiration+ '\n';
            result += 'Product:  '+product+'\n';
            result += 'Version:  '+version+'\n';
            result += 'Upgrade:  '+upgrade+'\n';
            result += 'License Type:  '+licenseType+'\n';
            result += 'Premium:  '+premiumSupport+'\n';
            result += 'Licenses:  '+licenses+'\n';
            result += 'SP Mount Required:  '+(info.SPMountRequired ? 'Yes' : 'No')+'\n';

            if (info.GRELicensedServers != null)
            {
                for (serviceStoragecraftCom.greLicensedServer server : info.GRELicensedServers)
                {
                    result += '\n';
                    result += 'Server Name:  '+server.serverName+'\n';
                    if (server.entryDate != null)
                    {
                        result += 'Entry Date:  '+server.entryDate.format(DateFormat)+'\n';
                    }
                }
            }
        }
        else if ('IT Edition'.Equals(product))
        {
            // Test Serial Number:  7798-12E5-7189-F9EE    4747-9415-40BA-2E0E
            result += 'Product:  '+product+'\n';
            result += 'Version:  '+version+'\n';
            result += 'Upgrade:  '+upgrade+'\n';
            result += 'License Type:  '+licenseType+'\n';
            result += 'Premium:  '+premiumSupport+'\n';
            result += 'IT Pro:  '+(info.ITPro ? 'Yes' : 'No')+'\n';
            result += 'IT Date Issued:  '+(info.ITDateIssued != null ? info.ITDateIssued.format(DateFormat) : 'N/A')+'\n';
            result += 'IT Date Activated:  '+(info.ITDateActivated != null ? info.ITDateActivated.format(DateFormat) : 'N/A')+'\n';
            result += 'IT Date Expires:  '+(info.ITDateExpires != null ? info.ITDateExpires.format(DateFormat) : 'N/A')+'\n';
        }
        else
        {
            // Test Serial Numbers:
            //    SP Desktop:  F1AD-CD59-BA50-A661
            //    SP Server:  BF39-4C41-90A4-77E8
            //    SP ImageManager:  372E-4941-663A-759B
            //    SP Small Business Server:  0D3A-01F0-919A-5298
            //    SP Small Business Server Premium:  380D-765F-EDD9-1881
            if (maintenanceExpired)
            {
                result += '** Expired **'+'\n';
            }
            result += 'Maintenance Expiration Date:  '+maintenanceEndDate+'\n';
            result += 'Product:  '+product+'\n';
            result += 'Version:  '+version+'\n';
            result += 'Upgrade:  '+upgrade+'\n';
            result += 'Premium:  '+premiumSupport+'\n';
        }

        return result;
    }

    public static String formatSerial(String serial){
        serial = serial.replaceAll('-','');
        serial = serial.capitalize();
        serial = serial.mid(0, 4)+'-'+serial.mid(4, 4)+'-'+serial.mid(8, 4)+'-'+serial.mid(12, 4);
        return serial;
    }

}