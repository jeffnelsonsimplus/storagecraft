/**
  \file         PartnerPortal.cls
  \brief        Makes a connection to the Partner Portal. Used to create new users in the portal.
  \details      JIRA ticket(s):
  \author       Loch MacLeod
  \version      1.4
  \date         2017-09-14
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.3       2017-09-14  Matt Thompson-Moltzen   Use Custom Settings to obtain the Partner Portal URLs instead of having the URLs hard-coded in the class (SSF-624).
  1.4       2017-09-26  Loch MacLeod            Update some of the return values
*/
public class PartnerPortal
{
    //
    // variables
    //
    private String usPartnerPortal;
    private String worldPartnerPortal;

    private Set<String> usPortalCountries;

    private static string UserNameAndPassword = 'salesforce:password';

    public Boolean Success = false;
    public String Error = '';
    public String UserName = '';
    public String Password = '********';
    public Boolean AccountExisted = false;

    //
    // constructor
    //
    public PartnerPortal()
    {
      partnerPortals__c pp1 = partnerPortals__c.getInstance('US Partner Portal');
      partnerPortals__c pp2 = partnerPortals__c.getInstance('World Partner Portal');

      if (pp1 != null) { usPartnerPortal    = pp1.partnerPortalUrl__c; }
      if (pp2 != null) { worldPartnerPortal = pp2.partnerPortalUrl__c; }

      System.debug('PartnerPortal::constructor() US Partner Portal URL: ' + usPartnerPortal);
      System.debug('PartnerPortal::constructor() World Partner Portal URL: ' + worldPartnerPortal);

      usPortalCountries = new Set<String>();

      usPortalCountries.add('US');
      usPortalCountries.add('CA');
      usPortalCountries.add('AU');
      usPortalCountries.add('NZ');

      System.assertEquals(4, usPortalCountries.size());
    }

    public Boolean newContact(string email, string first, string last, string company, string country, string state, string postalCode, string regionId, string userType, string accountId)
    {
        System.debug('newContact( ' + email + ', ' + first + ', ' + last + ', ' + company + ', ' + country + ', ' + state + ', ' + postalCode + ', ' + regionId + ', ' + userType + ', ' + accountId + ' )' );

        String endpoint = '';

        if (usPortalCountries.contains(country)) { 
            endpoint = usPartnerPortal + '/services/createUser'; 
        }
        else { 
            endpoint = worldPartnerPortal + '/services/createUser';
        }

        if (country.Equals('US') && postalcode != null && postalcode.Length() > 5) {
          postalcode = postalcode.SubString(0, 5);
        }

        if (state == null) {
            state = '';
        }

        if (postalCode == null) {
            postalCode = '';
        }
        
        Password = '';
        UserName = email;

        System.debug('EndPoint: ' + endpoint );

        JSONGenerator generator;
        generator = JSON.createGenerator(true);
        generator.writeStartObject();
        generator.writeStringField('requestType', 'CREATE_NEW_USER');
        generator.writeFieldName('userInfo');
        generator.writeStartObject();
        generator.writeStringField('email', email);
        generator.writeStringField('firstName', first);
        generator.writeStringField('lastName', last);
        generator.writeStringField('company', company);
        generator.writeStringField('country', country);
        generator.writeStringField('state', state);
        generator.writeStringField('zip', postalCode);
        generator.writeStringField('regionId', regionId);
        generator.writeStringField('userType', userType);
        generator.writeStringField('salesforceAccountId', accountId);
        generator.writeEndObject();
        generator.writeEndObject();

        String orders = generator.getAsString();
        // System.debug('jsonOrders: ' + orders);

        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + System.EncodingUtil.base64Encode(Blob.valueOf(UserNameAndPassword)));
        request.setBody(orders);

        if (System.Test.isRunningTest()) {
            return translate(PartnerPortalHttpCalloutMock.respond(request));
        } else {
            Http http = new Http();
            HTTPResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
              System.debug(LoggingLevel.INFO, 'PartnerPortal::newContact() call to Http::send() successful: (' + response.getStatusCode() + ') ' + response.getStatus());
              System.debug(LoggingLevel.INFO, 'PartnerPortal::newContact() response: ' + response.getBody());

              return translate(response);
            }
            else {
              System.debug(LoggingLevel.ERROR, 'PartnerPortal::newContact() call to Http::send() failed: (' + response.getStatusCode() + ') ' + response.getStatus());
            }
        }

        return Success;
    }

    private Boolean translate(HTTPResponse response) {
        if (response == null) {
            Success = false;
            Error = 'Partner Portal failed to respond.';
        }
        else {
            Success = true;
            String text;

            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String fieldName = parser.getText();

                    parser.nextToken();

                    if ('userName'.Equals(fieldName)) {
                        UserName = parser.getText();
                    } else if ('type'.Equals(fieldName)) {
                        AccountExisted = 'CONTACT'.Equals(parser.getText());
                    } else if ('password'.Equals(fieldName)) {
                        Password = parser.getText();
                    } else if ('error'.Equals(fieldName)) {
                        if (parser.getCurrentToken() == JSONTOKEN.START_ARRAY) {
                            System.debug('pwlc - found array');
                            while (parser.nextToken() != JSONTOKEN.END_ARRAY) {
                                parser.nextToken();
                                text = parser.getText();
                                if ('FAILED_USER'.Equals(text)) {
                                    Success = false;
                                    Error = 'Contact is assigned to a different account in the Partner Portal.';
                                    break;
                                }
                            }
                        }
                        else {
                            text = parser.getText();
                            if ('LOGIN_IN_USE'.Equals(text)) {
                                Success = true;
                                Error = 'Contact already has Partner Portal access with given email address.';
                                break;
                            }
                            else if('FAILED_PARTNER'.Equals(text)) {
                                Success = false;
                                Error = 'Partner Portal failed to create account and contact access.';
                                break;
                            }
                        }
                    }
                }
            }
        }

        if (''.equals(UserName) || '********'.equals(Password)) {
            Success = false;
        }

        return Success;
    }
}