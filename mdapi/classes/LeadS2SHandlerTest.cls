@isTest
private class LeadS2SHandlerTest {
    static testMethod void InsertForExabloxLead() {
        System.Test.startTest();

        Lead objlead1 = createLeadUS('Business User', 'Partner', true, null,'Exablox');
        system.assertNotEquals(null,objlead1.ID);
        List<PartnerNetworkRecordConnection> leadcon = createConnection('Exablox',objlead1.Id);
        System.Test.stopTest();

        List<PartnerNetworkRecordConnection> chkLeadConList = [SELECT Id, Status, ConnectionId, LocalRecordId
                                                               FROM PartnerNetworkRecordConnection
                                                               WHERE LocalRecordId =: objlead1.Id limit 1];

        System.assertEquals(objlead1.Id, chkLeadConList[0].LocalRecordId);
        System.assertEquals('Invite', chkLeadConList[0].Status);
        System.assertNotEquals('Converted', objlead1.Status);
    }

    static testMethod void InsertForAUMigraLead() {
        System.Test.startTest();

        Lead objlead = createLeadUS('Business User', 'Partner', true, 'APAC','4312');
        system.assertNotEquals(null,objlead.ID);
        List<PartnerNetworkRecordConnection> leadcon1 = createConnection('StorageCraft Indo-Pacific',objlead.Id);
        System.Test.stopTest();

        List<PartnerNetworkRecordConnection> chkLeadConList = [SELECT Id, Status, ConnectionId, LocalRecordId
                                                            FROM PartnerNetworkRecordConnection
                                                            WHERE LocalRecordId =: objlead.Id limit 1];
        System.assertEquals(objlead.Id, chkLeadConList[0].LocalRecordId);
        System.assertEquals('Invite', chkLeadConList[0].Status);
        System.assertNotEquals('Converted', objlead.Status);
    }

    private static Lead createLeadUS(string utype, string rtype, boolean accepted,String regionValue,String productInterestedValue) {

        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        Country_ISO_Map__c countryObj = [SELECT Id, Name, alpha2Code__c, alpha3Code__c FROM Country_ISO_Map__c
                                          WHERE alpha2Code__c='AF' AND Id IN : lstCountry LIMIT 1];

        Lead lead = new Lead(LastName='US',
                             FirstName='Convert',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Web',
                             UserType__c=utype,
                             Region__c = regionValue,
                             Product_interested_in__c = productInterestedValue,
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:rtype LIMIT 1],
                             VAR_Agreement_Accepted__c=accepted);
        insert lead;
        return lead;
    }

    private static List<PartnerNetworkRecordConnection> createConnection(String connectionName,Id keyLeadId){
        List<PartnerNetworkConnection> partnerNetConList =
          [SELECT Id, CreatedById FROM PartnerNetworkConnection WHERE connectionStatus = 'Accepted' AND connectionName = :connectionName];

        List<PartnerNetworkRecordConnection> LeadConnections =  new  List<PartnerNetworkRecordConnection>();
        if(partnerNetConList.size() > 0){
            for(PartnerNetworkConnection objPNC: partnerNetConList) {
              PartnerNetworkRecordConnection newConnection =
                              new PartnerNetworkRecordConnection(
                                  ConnectionId = objPNC.Id,
                                  LocalRecordId = keyLeadId,
                                  SendClosedTasks = false,
                                  SendOpenTasks = false,
                                  SendEmails = false );
              LeadConnections.add(newConnection);
            }
        }
        insert LeadConnections;
        return LeadConnections;
    }
}