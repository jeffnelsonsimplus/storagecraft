//Generated by wsdl2apex

public class AsyncServiceStoragecraftCom {

    public static string MOCK_RESPONSE;

    public class cancelIncidentResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.wsResponse getValue() {
            //serviceStoragecraftCom.cancelIncidentResponse response = (serviceStoragecraftCom.cancelIncidentResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.cancelIncidentResponse response =
            (serviceStoragecraftCom.cancelIncidentResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, (serviceStoragecraftCom.cancelIncidentResponse.class))) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getIncidentLicenseInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.incidentPackInformationResponse getValue() {
            //serviceStoragecraftCom.getIncidentLicenseInformationResponse response = (serviceStoragecraftCom.getIncidentLicenseInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getIncidentLicenseInformationResponse response = (serviceStoragecraftCom.getIncidentLicenseInformationResponse) (Test.isRunningTest() ? (JSON.deserialize(MOCK_RESPONSE, (serviceStoragecraftCom.getIncidentLicenseInformationResponse.class))) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class serialNumberDeactivationForSupportResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberDeactivationSupportResponse getValue() {
            //serviceStoragecraftCom.serialNumberDeactivationForSupportResponse response = (serviceStoragecraftCom.serialNumberDeactivationForSupportResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.serialNumberDeactivationForSupportResponse response =
            (serviceStoragecraftCom.serialNumberDeactivationForSupportResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, (serviceStoragecraftCom.serialNumberDeactivationForSupportResponse.class))) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class addIncidentToIncidentLicenseResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.wsResponse getValue() {
            //serviceStoragecraftCom.addIncidentToIncidentLicenseResponse response = (serviceStoragecraftCom.addIncidentToIncidentLicenseResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.addIncidentToIncidentLicenseResponse response =
            (serviceStoragecraftCom.addIncidentToIncidentLicenseResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.addIncidentToIncidentLicenseResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getSerialNumberInformationV2ResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberInformationListResponse getValue() {
            //serviceStoragecraftCom.getSerialNumberInformationV2Response response = (serviceStoragecraftCom.getSerialNumberInformationV2Response)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getSerialNumberInformationV2Response response =
            (serviceStoragecraftCom.getSerialNumberInformationV2Response)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getSerialNumberInformationV2Response.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getSerialNumberInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberInformationResponse getValue() {
            //serviceStoragecraftCom.getSerialNumberInformationResponse response = (serviceStoragecraftCom.getSerialNumberInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getSerialNumberInformationResponse response =
            (serviceStoragecraftCom.getSerialNumberInformationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getSerialNumberInformationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getListOfUpdatedSerialNumbersResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.updatedSerialNumbersResponse getValue() {
            //serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse response = (serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse response =
            (serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE,serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getSerialNumberInformationForListOfSerialNumbersResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberInformationListResponse getValue() {
            //serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse response = (serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse response =
            (serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE,serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse.class)): (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class deactivateSerialNumberActivationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.deactivateResponse getValue() {
            //serviceStoragecraftCom.deactivateSerialNumberActivationResponse response = (serviceStoragecraftCom.deactivateSerialNumberActivationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.deactivateSerialNumberActivationResponse response =
            (serviceStoragecraftCom.deactivateSerialNumberActivationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE,serviceStoragecraftCom.deactivateSerialNumberActivationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getSerialNumberActivationsSupportInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberActivationsSupportInformationResponse getValue() {
            //serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse response = (serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse response =
            (serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getSerialNumberSupportInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberSupportInformationResponse getValue() {
            //serviceStoragecraftCom.getSerialNumberSupportInformationResponse response = (serviceStoragecraftCom.getSerialNumberSupportInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getSerialNumberSupportInformationResponse response =
            (serviceStoragecraftCom.getSerialNumberSupportInformationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getSerialNumberSupportInformationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class setSerialNumberInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.serialNumberInformationResponse getValue() {
            //serviceStoragecraftCom.setSerialNumberInformationResponse response = (serviceStoragecraftCom.setSerialNumberInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.setSerialNumberInformationResponse response =
            (serviceStoragecraftCom.setSerialNumberInformationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.setSerialNumberInformationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class GetWebstoreOrdersForSerialNumbersResponseFuture extends System.WebServiceCalloutFuture {
        public buyStoragecraftCom.SerialSearchResult[] getValue() {
            //serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse response = (serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse response =
            (serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getListOfUpdatedSerialNumbersInDateRangeResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.updatedSerialNumbersResponse getValue() {
            //serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse response = (serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse response =
            (serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class updateIncidentLicenseInformationResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.wsResponse getValue() {
            //serviceStoragecraftCom.updateIncidentLicenseInformationResponse response = (serviceStoragecraftCom.updateIncidentLicenseInformationResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.updateIncidentLicenseInformationResponse response =
            (serviceStoragecraftCom.updateIncidentLicenseInformationResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.updateIncidentLicenseInformationResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class getNewWebstoreOrdersResponseFuture extends System.WebServiceCalloutFuture {
        public buyStoragecraftCom.ArrayOfOrderExportInformation getValue() {
            //serviceStoragecraftCom.getNewWebstoreOrdersResponse response = (serviceStoragecraftCom.getNewWebstoreOrdersResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getNewWebstoreOrdersResponse response =
            (serviceStoragecraftCom.getNewWebstoreOrdersResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getNewWebstoreOrdersResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class closeIncidentResponseFuture extends System.WebServiceCalloutFuture {
        public serviceStoragecraftCom.wsResponse getValue() {
            //serviceStoragecraftCom.closeIncidentResponse response = (serviceStoragecraftCom.closeIncidentResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.closeIncidentResponse response =
            (serviceStoragecraftCom.closeIncidentResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.closeIncidentResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }

    public class getWebstoreOrdersInRangeResponseFuture extends System.WebServiceCalloutFuture {
        public buyStoragecraftCom.ArrayOfOrderExportInformation getValue() {
            //serviceStoragecraftCom.getWebstoreOrdersInRangeResponse response = (serviceStoragecraftCom.getWebstoreOrdersInRangeResponse)System.WebServiceCallout.endInvoke(this);
            serviceStoragecraftCom.getWebstoreOrdersInRangeResponse response =
            (serviceStoragecraftCom.getWebstoreOrdersInRangeResponse)
            (Test.isRunningTest() ?
            (JSON.deserialize(MOCK_RESPONSE, serviceStoragecraftCom.getWebstoreOrdersInRangeResponse.class)) : (System.WebServiceCallout.endInvoke(this)));
            return response.return_x;
        }
    }
    public class AsyncSTCSerialNumberWSPort {
        public String endpoint_x = 'http://msp.storagecraft.com:80/STCWebServices/STCSerialNumberWS';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'https://buy.storagecraft.com/', 'buyStoragecraftCom', 'http://service.storagecraft.com/', 'serviceStoragecraftCom'};
        public AsyncServiceStoragecraftCom.cancelIncidentResponseFuture beginCancelIncident(System.Continuation continuation,String login,String password,String userName,Long incidentUseId) {
            serviceStoragecraftCom.cancelIncident request_x = new serviceStoragecraftCom.cancelIncident();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.incidentUseId = incidentUseId;
            return (AsyncServiceStoragecraftCom.cancelIncidentResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.cancelIncidentResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'cancelIncident',
              'http://service.storagecraft.com/',
              'cancelIncidentResponse',
              'serviceStoragecraftCom.cancelIncidentResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getIncidentLicenseInformationResponseFuture beginGetIncidentLicenseInformation(System.Continuation continuation,String login,String password,String userName,String[] incidentPackList) {
            serviceStoragecraftCom.getIncidentLicenseInformation request_x = new serviceStoragecraftCom.getIncidentLicenseInformation();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.incidentPackList = incidentPackList;
            return (AsyncServiceStoragecraftCom.getIncidentLicenseInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getIncidentLicenseInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getIncidentLicenseInformation',
              'http://service.storagecraft.com/',
              'getIncidentLicenseInformationResponse',
              'serviceStoragecraftCom.getIncidentLicenseInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.serialNumberDeactivationForSupportResponseFuture beginSerialNumberDeactivationForSupport(System.Continuation continuation,String passphrase,String serialNumber,Integer activationId) {
            serviceStoragecraftCom.serialNumberDeactivationForSupport request_x = new serviceStoragecraftCom.serialNumberDeactivationForSupport();
            request_x.passphrase = passphrase;
            request_x.serialNumber = serialNumber;
            request_x.activationId = activationId;
            return (AsyncServiceStoragecraftCom.serialNumberDeactivationForSupportResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.serialNumberDeactivationForSupportResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'serialNumberDeactivationForSupport',
              'http://service.storagecraft.com/',
              'serialNumberDeactivationForSupportResponse',
              'serviceStoragecraftCom.serialNumberDeactivationForSupportResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.addIncidentToIncidentLicenseResponseFuture beginAddIncidentToIncidentLicense(System.Continuation continuation,String login,String password,String userName,String incidentLicense,String internalTrackingId,String technician) {
            serviceStoragecraftCom.addIncidentToIncidentLicense request_x = new serviceStoragecraftCom.addIncidentToIncidentLicense();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.incidentLicense = incidentLicense;
            request_x.internalTrackingId = internalTrackingId;
            request_x.technician = technician;
            return (AsyncServiceStoragecraftCom.addIncidentToIncidentLicenseResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.addIncidentToIncidentLicenseResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'addIncidentToIncidentLicense',
              'http://service.storagecraft.com/',
              'addIncidentToIncidentLicenseResponse',
              'serviceStoragecraftCom.addIncidentToIncidentLicenseResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getSerialNumberInformationV2ResponseFuture beginGetSerialNumberInformationV2(System.Continuation continuation,String passphrase,String[] serialNumbers) {
            serviceStoragecraftCom.getSerialNumberInformationV2 request_x = new serviceStoragecraftCom.getSerialNumberInformationV2();
            request_x.passphrase = passphrase;
            request_x.serialNumbers = serialNumbers;
            return (AsyncServiceStoragecraftCom.getSerialNumberInformationV2ResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getSerialNumberInformationV2ResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getSerialNumberInformationV2',
              'http://service.storagecraft.com/',
              'getSerialNumberInformationV2Response',
              'serviceStoragecraftCom.getSerialNumberInformationV2Response'}
            );
        }
        public AsyncServiceStoragecraftCom.getSerialNumberInformationResponseFuture beginGetSerialNumberInformation(System.Continuation continuation,String login,String password,String userName,String serialNumber) {
            serviceStoragecraftCom.getSerialNumberInformation request_x = new serviceStoragecraftCom.getSerialNumberInformation();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.serialNumber = serialNumber;
            return (AsyncServiceStoragecraftCom.getSerialNumberInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getSerialNumberInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getSerialNumberInformation',
              'http://service.storagecraft.com/',
              'getSerialNumberInformationResponse',
              'serviceStoragecraftCom.getSerialNumberInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersResponseFuture beginGetListOfUpdatedSerialNumbers(System.Continuation continuation,String login,String password,String usrName) {
            serviceStoragecraftCom.getListOfUpdatedSerialNumbers request_x = new serviceStoragecraftCom.getListOfUpdatedSerialNumbers();
            request_x.login = login;
            request_x.password = password;
            request_x.usrName = usrName;
            return (AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getListOfUpdatedSerialNumbers',
              'http://service.storagecraft.com/',
              'getListOfUpdatedSerialNumbersResponse',
              'serviceStoragecraftCom.getListOfUpdatedSerialNumbersResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponseFuture beginGetSerialNumberInformationForListOfSerialNumbers(System.Continuation continuation,String login,String password,String userName,String[] serialNumbers) {
            serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbers request_x = new serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbers();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.serialNumbers = serialNumbers;
            return (AsyncServiceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getSerialNumberInformationForListOfSerialNumbers',
              'http://service.storagecraft.com/',
              'getSerialNumberInformationForListOfSerialNumbersResponse',
              'serviceStoragecraftCom.getSerialNumberInformationForListOfSerialNumbersResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.deactivateSerialNumberActivationResponseFuture beginDeactivateSerialNumberActivation(System.Continuation continuation,String login,String password,String userName,String serialNumber,String activationId,Boolean isLegacy) {
            serviceStoragecraftCom.deactivateSerialNumberActivation request_x = new serviceStoragecraftCom.deactivateSerialNumberActivation();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.serialNumber = serialNumber;
            request_x.activationId = activationId;
            request_x.isLegacy = isLegacy;
            return (AsyncServiceStoragecraftCom.deactivateSerialNumberActivationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.deactivateSerialNumberActivationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'deactivateSerialNumberActivation',
              'http://service.storagecraft.com/',
              'deactivateSerialNumberActivationResponse',
              'serviceStoragecraftCom.deactivateSerialNumberActivationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getSerialNumberActivationsSupportInformationResponseFuture beginGetSerialNumberActivationsSupportInformation(System.Continuation continuation,String passphrase,String serialNumber) {
            serviceStoragecraftCom.getSerialNumberActivationsSupportInformation request_x = new serviceStoragecraftCom.getSerialNumberActivationsSupportInformation();
            request_x.passphrase = passphrase;
            request_x.serialNumber = serialNumber;
            return (AsyncServiceStoragecraftCom.getSerialNumberActivationsSupportInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getSerialNumberActivationsSupportInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getSerialNumberActivationsSupportInformation',
              'http://service.storagecraft.com/',
              'getSerialNumberActivationsSupportInformationResponse',
              'serviceStoragecraftCom.getSerialNumberActivationsSupportInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getSerialNumberSupportInformationResponseFuture beginGetSerialNumberSupportInformation(System.Continuation continuation,String passphrase,String serialNumber) {
            serviceStoragecraftCom.getSerialNumberSupportInformation request_x = new serviceStoragecraftCom.getSerialNumberSupportInformation();
            request_x.passphrase = passphrase;
            request_x.serialNumber = serialNumber;
            return (AsyncServiceStoragecraftCom.getSerialNumberSupportInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getSerialNumberSupportInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getSerialNumberSupportInformation',
              'http://service.storagecraft.com/',
              'getSerialNumberSupportInformationResponse',
              'serviceStoragecraftCom.getSerialNumberSupportInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.setSerialNumberInformationResponseFuture beginSetSerialNumberInformation(System.Continuation continuation,String login,String password,String userName,serviceStoragecraftCom.serialNumberInformation serialNumber) {
            serviceStoragecraftCom.setSerialNumberInformation request_x = new serviceStoragecraftCom.setSerialNumberInformation();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.serialNumber = serialNumber;
            return (AsyncServiceStoragecraftCom.setSerialNumberInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.setSerialNumberInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'setSerialNumberInformation',
              'http://service.storagecraft.com/',
              'setSerialNumberInformationResponse',
              'serviceStoragecraftCom.setSerialNumberInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponseFuture beginGetWebstoreOrdersForSerialNumbers(System.Continuation continuation,String username,String password,String[] serialNumbers) {
            serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbers request_x = new serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbers();
            request_x.username = username;
            request_x.password = password;
            request_x.serialNumbers = serialNumbers;
            return (AsyncServiceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'GetWebstoreOrdersForSerialNumbers',
              'http://service.storagecraft.com/',
              'GetWebstoreOrdersForSerialNumbersResponse',
              'serviceStoragecraftCom.GetWebstoreOrdersForSerialNumbersResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponseFuture beginGetListOfUpdatedSerialNumbersInDateRange(System.Continuation continuation,String login,String password,String userName,DateTime startDate,DateTime endDate) {
            serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRange request_x = new serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRange();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            return (AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getListOfUpdatedSerialNumbersInDateRange',
              'http://service.storagecraft.com/',
              'getListOfUpdatedSerialNumbersInDateRangeResponse',
              'serviceStoragecraftCom.getListOfUpdatedSerialNumbersInDateRangeResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.updateIncidentLicenseInformationResponseFuture beginUpdateIncidentLicenseInformation(System.Continuation continuation,String login,String password,String userName,String incidentLicense,String issuedName,String issuedEmail) {
            serviceStoragecraftCom.updateIncidentLicenseInformation request_x = new serviceStoragecraftCom.updateIncidentLicenseInformation();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.incidentLicense = incidentLicense;
            request_x.issuedName = issuedName;
            request_x.issuedEmail = issuedEmail;
            return (AsyncServiceStoragecraftCom.updateIncidentLicenseInformationResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.updateIncidentLicenseInformationResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'updateIncidentLicenseInformation',
              'http://service.storagecraft.com/',
              'updateIncidentLicenseInformationResponse',
              'serviceStoragecraftCom.updateIncidentLicenseInformationResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.getNewWebstoreOrdersResponseFuture beginGetNewWebstoreOrders(System.Continuation continuation,String username,String password) {
            serviceStoragecraftCom.getNewWebstoreOrders request_x = new serviceStoragecraftCom.getNewWebstoreOrders();
            request_x.username = username;
            request_x.password = password;
            return (AsyncServiceStoragecraftCom.getNewWebstoreOrdersResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getNewWebstoreOrdersResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getNewWebstoreOrders',
              'http://service.storagecraft.com/',
              'getNewWebstoreOrdersResponse',
              'serviceStoragecraftCom.getNewWebstoreOrdersResponse'}
            );
        }
        public AsyncServiceStoragecraftCom.closeIncidentResponseFuture beginCloseIncident(System.Continuation continuation,String login,String password,String userName,Long incidentUseId) {
            serviceStoragecraftCom.closeIncident request_x = new serviceStoragecraftCom.closeIncident();
            request_x.login = login;
            request_x.password = password;
            request_x.userName = userName;
            request_x.incidentUseId = incidentUseId;
            return (AsyncServiceStoragecraftCom.closeIncidentResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.closeIncidentResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'closeIncident',
              'http://service.storagecraft.com/',
              'closeIncidentResponse',
              'serviceStoragecraftCom.closeIncidentResponse'}
            );
        }
            serviceStoragecraftCom.getWebstoreOrdersInRange request_x = new serviceStoragecraftCom.getWebstoreOrdersInRange();
            public AsyncServiceStoragecraftCom.getWebstoreOrdersInRangeResponseFuture beginGetWebstoreOrdersInRange(System.Continuation continuation,String username,String password,DateTime startDate,DateTime endDate) {
            request_x.username = username;
            request_x.password = password;
            request_x.startDate = startDate;
            request_x.endDate = endDate;
            return (AsyncServiceStoragecraftCom.getWebstoreOrdersInRangeResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncServiceStoragecraftCom.getWebstoreOrdersInRangeResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://service.storagecraft.com/',
              'getWebstoreOrdersInRange',
              'http://service.storagecraft.com/',
              'getWebstoreOrdersInRangeResponse',
              'serviceStoragecraftCom.getWebstoreOrdersInRangeResponse'}
            );
        }
    }
}