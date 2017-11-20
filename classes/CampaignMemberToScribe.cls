public  class CampaignMemberToScribe{

    @TestVisible private static Integer HttpRepsonseCode ;
    @TestVisible private static String  HttpRepsonseStatus ;
    @TestVisible private static String  HttpRepsonseBody ;

    public static void setUpCAlloutData(List<CampaignMember> getCampaignMembers){
      Set<Id> IdOfToBeDeletedCMSet = new Set<Id>();
      Set<Id> ExtCaseCaseInsensitiveIdSet = new Set<Id>();
      String sessionId = UserInfo.getSessionId();
      for(CampaignMember campMemberObj : getCampaignMembers){
          IdOfToBeDeletedCMSet.add(campMemberObj.id);
          ExtCaseCaseInsensitiveIdSet.add(campMemberObj.Ext_Id_Value_Case_Insensitive__c);
      }
      toCalloutScribe(IdOfToBeDeletedCMSet,sessionId,ExtCaseCaseInsensitiveIdSet);

    }
    @Future(callout=true)
    public static void toCalloutScribe(Set<ID> IdOfToBeDeletedCM,String sessionId,Set<ID> ExtCaseCaseInsensitiveIdSet){
      HttpRequest req = new HttpRequest();
      //Set HTTPRequest Method
      req.setMethod('POST');
      req.setEndpoint(Label.Scribe_EndPoint_Url);
      req.setMethod('POST');
      req.setHeader('Content-Type', 'text/xml; charset=utf-8');
      String requestBody = '<?xml version="1.0" encoding="UTF-8"?>'+
                           '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                           '<soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound">'+
                           '<OrganizationId>'+Label.Scribe_OrganizationID+'</OrganizationId>'+
                           '<ActionId>'+Label.Scribe_Outbound_Message_ID+'</ActionId>'+
                           '<SessionId>'+sessionId+'</SessionId>'+
                           '<EnterpriseUrl>'+Label.Enterprise_Url+'</EnterpriseUrl>'+
                           '<PartnerUrl>'+Label.Partner_Url+'</PartnerUrl>'+
                           '<Notification><Id>'+Label.Scribe_Notification_ID+'</Id>'+
                           '<sObject xsi:type="sf:CampaignMember" xmlns:sf="urn:sobject.enterprise.soap.sforce.com">';
      String listOfIds ='';
      for(ID idKey : IdOfToBeDeletedCM){
          listOfIds = listOfIds + '<sf:Id>'+idKey+'</sf:Id>';
      }
      String listofExtIds = '';
      for(ID extIdKey : ExtCaseCaseInsensitiveIdSet){
          listofExtIds = listofExtIds + '<sf:Ext_Id_Value_Case_Insensitive__c>'+extIdKey +'</sf:Ext_Id_Value_Case_Insensitive__c>';
      }
      String finalRequestBody = requestBody+listOfIds+listofExtIds +'</sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
      req.setBody(finalRequestBody);
      Http http = new Http();
      try {
          HTTPResponse res = http.send(req);
          HttpRepsonseCode= res.getStatusCode();
          HttpRepsonseStatus = res.getStatus();
          HttpRepsonseBody = res.getBody();
      }catch(CalloutException ce){
          // @Developer : Add Error Handling Logic Here.
      }
  }
}