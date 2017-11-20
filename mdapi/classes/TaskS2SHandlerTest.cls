@isTest
private class TaskS2SHandlerTest {

    static testMethod void insertTaskForExablox() {
            System.Test.startTest();

            Lead objlead = createLeadUS('Business User', 'Partner', true);
            System.assertNotEquals(null,objlead.ID);
            List<PartnerNetworkRecordConnection> leadcon = createForLeadConnection('Exablox',objlead.Id);
            Task taskToInsert = createTaskRecords(objlead.Id);
			List<PartnerNetworkRecordConnection> taskcon = createForTaskConnection('Exablox',taskToInsert);

			System.Test.stopTest();

            List<PartnerNetworkRecordConnection> chkLeadConList = [SELECT Id, Status, ConnectionId, LocalRecordId
                                                                   FROM PartnerNetworkRecordConnection
                                                                   WHERE LocalRecordId =: objlead.Id limit 1];
            System.assertEquals(objlead.Id, chkLeadConList[0].LocalRecordId);
            System.assertEquals('Invite', chkLeadConList[0].Status);
            System.assertNotEquals('Converted', objlead.Status);
    }

    static testMethod void insertTaskForAUPartial() {
            System.Test.startTest();

            Lead objlead = createLeadUS('Business User', 'Partner', true);
            System.assertNotEquals(null,objlead.ID);
            List<PartnerNetworkRecordConnection> leadcon = createForLeadConnection('StorageCraft Indo-Pacific',objlead.Id);
            Task taskToInsert = createTaskRecords(objlead.Id);
		    List<PartnerNetworkRecordConnection> taskcon = createForTaskConnection('StorageCraft Indo-Pacific',taskToInsert);
            System.Test.stopTest();

            List<PartnerNetworkRecordConnection> chkLeadConList = [SELECT Id, Status, ConnectionId, LocalRecordId
                                                                    FROM PartnerNetworkRecordConnection
                                                                    WHERE LocalRecordId =: objlead.Id limit 1];
            System.assertEquals(objlead.Id, chkLeadConList[0].LocalRecordId);
            System.assertEquals('Invite', chkLeadConList[0].Status);
            System.assertNotEquals('Converted', objlead.Status);
    }

    private static Lead createLeadUS(string utype, string rtype, boolean accepted) {
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
                                 RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:rtype LIMIT 1],
                                 VAR_Agreement_Accepted__c=accepted);
            insert lead;
            return lead;
    }

    private static List<PartnerNetworkRecordConnection> createForLeadConnection(String connectionName,Id keyLeadId){
            List<PartnerNetworkConnection> partnerNetConList =
                [SELECT Id, CreatedById FROM PartnerNetworkConnection WHERE connectionStatus = 'Accepted' AND connectionName = :connectionName];

            List<PartnerNetworkRecordConnection> LeadConnections =  new  List<PartnerNetworkRecordConnection>();
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
            insert LeadConnections;
            return LeadConnections;
    }

        public static Task createTaskRecords(String leadId) {
            List<Task> taskList = new List<Task>();
        //  for(Integer i=0; i<5; i++) {
                Task taskObj = new Task();
                taskObj.WhoId = leadId;
                taskObj.Subject = 'Test';
                taskObj.RecurrenceRegeneratedType = '';
                //taskObj.IsRecurrence = false;
                taskObj.Type = 'Call';
                //taskList.add(taskObj);
        //  }
            insert taskObj;
            return taskObj;
    }

    public static List<PartnerNetworkRecordConnection> createForTaskConnection(String connectionName,Task newTask){
            List<PartnerNetworkConnection> partnerNetConList =
                [SELECT Id, CreatedById FROM PartnerNetworkConnection WHERE connectionStatus =: 'Invalid' AND connectionName = :connectionName];

            List<PartnerNetworkRecordConnection> LeadConnections =  new  List<PartnerNetworkRecordConnection>();
            for(PartnerNetworkConnection objPNC: partnerNetConList) {
                PartnerNetworkRecordConnection newConnection =
                                                new PartnerNetworkRecordConnection(
                                                        ConnectionId = objPNC.Id,
                                                        LocalRecordId = newTask.Id,
                                                        SendClosedTasks = false,
                                                        SendOpenTasks = false,
                                                        SendEmails = false ,
                                                        ParentRecordId = newTask.WhoId);
                LeadConnections.add(newConnection);
            }
            insert LeadConnections;
            return LeadConnections;
    }

}