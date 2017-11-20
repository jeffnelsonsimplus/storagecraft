public class LicenseCheckConstants {
/*
    #if CRM_USA
#warning Running CRM_USA
        public static final string ENDPOINT_URL = 'https://msp.storagecraft.com:443/STCWebServices/STCSerialNumberManagementWS';
        public static final string SN_ENDPOINT_URL = 'https://msp.storagecraft.com:443/STCWebServices/STCSerialNumberWS?wsdl';
        public static final string SN_LOGIN = 'STCWebstoreWSAccess';
        public static final string SN_PASSWORD = 'vk3423#kck.,*';
        public static final string SN_USERNAME = 'STCWebstoreWSAccess';
        public static readonly Guid SYSTEM_USER_ID = new Guid('E58B8441-F145-E011-84F6-0050569B6710');
        public static string STC_WEB_SERVICE = 'USA';
#elif CRM_IRELAND
#warning Running CRM_IRELAND
        public static final string ENDPOINT_URL = 'https://eu.storagecraft.com:443/STCWebServices/STCSerialNumberManagementWS';
        public static final string SN_ENDPOINT_URL = 'https://eu.storagecraft.com:443/STCWebServices/STCSerialNumberWS?wsdl';
        public static final string SN_LOGIN = 'STCWebstoreWSAccess';
        public static final string SN_PASSWORD = 'vk3423#kck.,*';
        public static final string SN_USERNAME = 'STCWebstoreWSAccess';
        public static readonly Guid SYSTEM_USER_ID = new Guid('0D3FBC9E-1B47-E311-B567-0050569B6710');
        public static string STC_WEB_SERVICE = 'EUROPE';
#elif CRM_DEBUG
#warning Running CRM_DEBUG
        public static final string ENDPOINT_URL = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberManagementWS';
        public static final string SN_ENDPOINT_URL = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberWS?wsdl';
        public static final string SN_LOGIN = 'STCWebstoreWSAccessTEST';
        public static final string SN_PASSWORD = 'vk3423#kck.,*TEST';
        public static final string SN_USERNAME = 'STCWebstoreWSAccessTEST';
        public static readonly Guid SYSTEM_USER_ID = new Guid('E58B8441-F145-E011-84F6-0050569B6710');
        public static string STC_WEB_SERVICE = 'DEBUG';
#else
        // ERROR!!! Must set one of them
#endif
        public static string SN_PASSPHRASE = @'23lkcoSl2#$l_3492! d#452 )dkkladf';

        public string EndPointUrl(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'https://msp.storagecraft.com:443/STCWebServices/STCSerialNumberManagementWS';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'https://eu.storagecraft.com:443/STCWebServices/STCSerialNumberManagementWS';
            }
            else
            {
                return 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberManagementWS';
            }
        }

        public string SNEndPointUrl(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'https://msp.storagecraft.com:443/STCWebServices/STCSerialNumberWS?wsdl';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'https://eu.storagecraft.com:443/STCWebServices/STCSerialNumberWS?wsdl';
            }
            else
            {
                return 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberWS?wsdl';
            }
        }

        public string SNLogin(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'STCWebstoreWSAccess';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'STCWebstoreWSAccess';
            }
            else
            {
                return 'STCWebstoreWSAccessTEST';
            }
        }

        public string SNPassword(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'vk3423#kck.,*';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'vk3423#kck.,*';
            }
            else
            {
                return 'vk3423#kck.,*TEST';
            }
        }

        public string SNUsername(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'STCWebstoreWSAccess';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'STCWebstoreWSAccess';
            }
            else
            {
                return 'STCWebstoreWSAccessTEST';
            }
        }

        public Guid SystemUserId(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return new Guid('E58B8441-F145-E011-84F6-0050569B6710');
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return new Guid('0D3FBC9E-1B47-E311-B567-0050569B6710');
            }
            else
            {
                return new Guid('E58B8441-F145-E011-84F6-0050569B6710');
            }
        }

        public string STCWebService(IExecutionContext context)
        {
            if ('CRM'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'USA';
            }
            else if ('CRM-IE'.Equals(context.OrganizationName, StringComparison.OrdinalIgnoreCase))
            {
                return 'EUROPE';
            }
            else
            {
                return 'DEBUG';
            }
        }

        public static final string PASS_PHRASE = 'Svdklk$#2345.dsfknL|~';

        public static final string SUCCESS = 'Success';
        public static final string FAILURE = 'Failure';
*/
    /*
        // Security Roles
#if CRM_USA
        public static final string SECURITYROLE_NFR = 'StorageCraft NFR';
        public static final string SECURITYROLE_NFR_BUSINESS_SYSTEMS = 'StorageCraft NFR Business Systems';
        public static final string SECURITYROLE_NFR_SUPPORT = 'StorageCraft NFR Support';
#elif CRM_IRELAND
        public static final string SECURITYROLE_NFR = 'STC - NFR';
        public static final string SECURITYROLE_NFR_BUSINESS_SYSTEMS = 'STC - NFR Business Systems';
        public static final string SECURITYROLE_NFR_SUPPORT = 'STC - NFR Support';
#elif CRM_DEBUG
        public static final string SECURITYROLE_NFR = 'StorageCraft NFR';
        public static final string SECURITYROLE_NFR_BUSINESS_SYSTEMS = 'StorageCraft NFR Business Systems';
        public static final string SECURITYROLE_NFR_SUPPORT = 'StorageCraft NFR Support';
#endif
*/
        // Products
        public static final Integer SHADOWPROTECT_DESKTOP = 1;
        public static final Integer SHADOWPROTECT_SERVER = 2;
        public static final Integer SHADOWPROTECT_SMALL_BUSINESS = 3;
        public static final Integer SHADOWPROTECT_IT_EDITION = 4;
        public static final Integer SHADOWPROTECT_PREMIUM = 5;
        public static final Integer SHADOWPROTECT_GRE = 6;
        public static final Integer SHADOWPROTECT_IMAGEMANAGER = 7;

        // Entities
        public static final string ENTITY_ACCOUNT = 'account';
        public static final string ENTITY_SERIALNUMBER = 'new_serialnumbers';

        // Account Fields
        public static final string ACCOUNT_NFR_SERVER_SERIAL = 'new_nfrshadowprotectserverserial';
        public static final string ACCOUNT_NFR_IMAGEMANAGER_SERIAL = 'new_nfrshadowprotectimagemanagerserial';
        public static final string ACCOUNT_NFR_DESKTOP_SERIAL = 'new_nfrshadowprotectdesktopserial';
        public static final string ACCOUNT_NFR_SPXLINUX_SERIAL = 'new_nfrshadowprotectspxlinux';

        // SerialNumber Fields
        public static final string SERIALNUMBER_ACCOUNTID = 'new_accountid';
        public static final string SERIALNUMBER_ACCOUNTIDNAME = 'new_accountidname';
        public static final string SERIALNUMBER_ADDITIONAL_NOTE = 'new_additionalnote';
        public static final string SERIALNUMBER_BASE_NFR = 'new_basenfr';
        public static final string SERIALNUMBER_EXPIRATION_DATE = 'new_expirationdate';
        public static final string SERIALNUMBER_FTP_JOBS = 'new_ftpjob';
        public static final string SERIALNUMBER_GRE7_SERVER_COUNT = 'new_gre7servercount';
        public static final string SERIALNUMBER_HSR_JOBS = 'new_hsrjob';
        public static final string SERIALNUMBER_IM4_JOBS = 'new_im4jobs';
        public static final string SERIALNUMBER_IS_MSP = 'new_ismsp';
        public static final string SERIALNUMBER_IS_NFR = 'new_isnfr';
        public static final string SERIALNUMBER_ISSUED_BY = 'new_issusedby';
        public static final string SERIALNUMBER_IS_VIRTUAL = 'new_isvirtual';
        public static final string SERIALNUMBER_LANGUAGE = 'new_language';
        public static final string SERIALNUMBER_LICENSE_COUNT = 'new_licensecount';
        public static final string SERIALNUMBER_NAME = 'new_name';
        public static final string SERIALNUMBER_PRODUCT = 'new_product';
        public static final string SERIALNUMBER_SST_JOBS = 'new_sstjob';
        public static final string SERIALNUMBER_TERMINATED_BY_MANAGMENT = 'new_terminatedbymanagement';
        public static final string SERIALNUMBER_VERSION = 'new_version';
        public static final string SERIALNUMBER_LINUX = 'new_islinux';

    /*
        /// <summary>
        /// Language converst the language identifier into a string.
        /// </summary>
        /// <param name='languageId'>Identifier</param>
        /// <returns>Name of language</returns>
        public static string Language(int languageId)
        {
            switch (languageId)
            {
                case 0: return 'English';             // ProductLanguage.EN
                case 8: return 'Japanese';            // ProductLanguage.JA
                case 16: return 'French';              // ProductLanguage.FR
                case 24: return 'German';              // ProductLanguage.DE
                case 32: return 'Russian';             // ProductLanguage.RU
                case 40: return 'Spanish';             // ProductLanguage.ES
                case 48: return 'Italian';             // ProductLanguage.IT
                case 56: return 'Portuguese Portugal'; // ProductLanguage.PT
                case 64: return 'Turkish';             // ProductLanguage.TR
                case 72: return 'Portuguese Brazil';   // ProductLanguage.PB
                case 80: return 'Ukranian';            // ProductLanguage.UK
                case 88: return 'Korean';              // ProductLanguage.KO
                case 96: return 'Chinese Simplified';  // ProductLanguage.ZS
                case 104: return 'Chinese Traditional'; // ProductLanguage.ZH
                case 112: return 'Czech';               // ProductLanguage.CZ
                case 120: return 'Polish';              // ProductLanguage.PO
            }

            return 'unknown';
        }

        /// <summary>
        /// Language converst the language identifier into a string.
        /// </summary>
        /// <param name='languageId'>Identifier</param>
        /// <returns>Name of language</returns>
        public static int Language(string language)
        {
            if (language.Equals('English', StringComparison.OrdinalIgnoreCase))   return 0;
            if (language.Equals('Japanese', StringComparison.OrdinalIgnoreCase))   return 8;
            if (language.Equals('French', StringComparison.OrdinalIgnoreCase))   return 16;
            if (language.Equals('German', StringComparison.OrdinalIgnoreCase))   return 24;
            if (language.Equals('Russian', StringComparison.OrdinalIgnoreCase))   return 32;
            if (language.Equals('Spanish', StringComparison.OrdinalIgnoreCase))   return 40;
            if (language.Equals('Italian', StringComparison.OrdinalIgnoreCase))   return 48;
            if (language.Equals('Portuguese Portugal', StringComparison.OrdinalIgnoreCase))   return 560;
            if (language.Equals('Turkish', StringComparison.OrdinalIgnoreCase))   return 64;
            if (language.Equals('Portuguese Brazil', StringComparison.OrdinalIgnoreCase))   return 72;
            if (language.Equals('Ukranian', StringComparison.OrdinalIgnoreCase))   return 80;
            if (language.Equals('Korean', StringComparison.OrdinalIgnoreCase))   return 88;
            if (language.Equals('Chinese Simplified', StringComparison.OrdinalIgnoreCase))   return 96;
            if (language.Equals('Chinese Traditional', StringComparison.OrdinalIgnoreCase))   return 104;
            if (language.Equals('Czech', StringComparison.OrdinalIgnoreCase))   return 112;
            if (language.Equals('Polish', StringComparison.OrdinalIgnoreCase))   return 120;

            return -1;
        }

        /// <summary>
        /// ToProductId changes a string the value of the product
        /// </summary>
        /// <param name='product'>Product name</param>
        /// <returns>The product number</returns>
        /// <exception>When not found</exceptio>
        public static int ToProductId(string product)
        {
            string lowerProduct = product.ToLower();

            if (lowerProduct.StartsWith('shadowproduct')) {
                lowerProduct = lowerProduct.Substring('shadowproduct'.Length);
            }

            lowerProduct = lowerProduct.Trim();
            
            if (lowerProduct == 'desktop') 
            {
                return 1;
            }
            
            if (lowerProduct == 'server') {
                return 2;
            }            

            if (lowerProduct == 'small business')
            {
                return 3;
            }

            if (lowerProduct == 'it edition')
            {
                return 4;
            }

            if (lowerProduct == 'premium')
            {
                return 5;
            }

            if (lowerProduct == 'granular recovery for exchange'
                || lowerProduct == 'gre')
            {
                return 6;
            }

            if (lowerProduct == 'imagemanager')
            {
                return 7;
            }

            throw new Exception('Unexpected Product Name: ' + product);
        }
    }
*/
}