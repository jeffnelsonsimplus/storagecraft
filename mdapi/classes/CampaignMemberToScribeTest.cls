@isTest
private class CampaignMemberToScribeTest {

	public static Campaign createCampaign(Boolean isInsert){
		Campaign campObj = new Campaign();
		campObj.Name='Test Campaign';
		if(isInsert == true){
			insert campObj;
		}
		return campObj;
	}

	public static List<Lead> createLead(Boolean isInsert,Integer noOfRecords){

		List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        Country_ISO_Map__c countryObj = [SELECT Id, Name, alpha2Code__c, alpha3Code__c FROM Country_ISO_Map__c
                                          WHERE alpha2Code__c='AF' AND Id IN : lstCountry LIMIT 1];

		List<Lead> tobeInsertedList = new List<Lead>();
		for(Integer i = 0; i<noOfRecords; i++){
			tobeInsertedList.add(new Lead(
				LastName='US',
		        Email='us.convert@storagecraft.com',
		        Company='Lead Convert Test',
		        Status='Inquiry',
		        Country='US',
		        State='NY',
		        PostalCode='10005',
		        LeadSource = 'Web'));
		}
		if(isInsert == true && !tobeInsertedList.isEmpty()){
				insert tobeInsertedList;
		}

		return tobeInsertedList;
	}

	public static List<CampaignMember> createCampaignMember(Boolean isInsert,ID campaignID,Id leadID,Integer noOfRecords){

		List<CampaignMember> tobeInsertedList = new List<CampaignMember>();
		for(Integer i = 0; i<noOfRecords; i++){
		tobeInsertedList.add(new CampaignMember(LeadId = leadID,
												Status='Sent',
												Campaignid = campaignID));
		}
		if(isInsert == true){
			insert tobeInsertedList;
		}
		return tobeInsertedList;
	}

	public static testMethod void  testPostCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CampaignMemberToScribeHttpCalloutMock());
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        Campaign campInstance = createCampaign(true);
		List<Lead> leadInstance = createLead(true,1);

        if(leadInstance[0].id != null && campInstance.id != null){
        	List<CampaignMember> insertedCampaignMember = createCampaignMember(true,campInstance.id,leadInstance[0].id,1);
        }
        CampaignMember getCampaignMem = [Select Id From CampaignMember where Campaignid =:campInstance.id];
		System.Test.startTest();
        if(getCampaignMem.id != null){
            delete getCampaignMem;
        }
		System.Test.stopTest();
        // Verify that the response received contains fake values
        System.assertEquals(200, CampaignMemberToScribe.HttpRepsonseCode);
        System.assertEquals('OK', CampaignMemberToScribe.HttpRepsonseStatus);
	    String responseBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
								  '<notifications xmlns="http://soap.sforce.com/2005/09/outbound">'+
								  '<Ack>Success</Ack>'+
								  '</notifications>'+
								  '</soapenv:Body>'+
								  '</soapenv:Envelope>';
	    System.assertEquals(responseBody,CampaignMemberToScribe.HttpRepsonseBody);
	}
  	public static testMethod void  testPostCalloutBulkCampaignMember() {
		  // Set mock callout class
		  Test.setMock(HttpCalloutMock.class, new CampaignMemberToScribeHttpCalloutMock());
		  // This causes a fake response to be sent
		  // from the class that implements HttpCalloutMock.
		  Campaign campInstance = createCampaign(true);
		  List<Lead> leadInstance = createLead(true,20);

		  if(!leadInstance.isEmpty() && campInstance.id != null){

				for(Lead leadObj :leadInstance ){
			 	List<CampaignMember> insertedCampaignMember = createCampaignMember(true,campInstance.id,leadObj.id,1);
				}
		  }
		  List<CampaignMember> getCampaignMem = [Select Id From CampaignMember where Campaignid =:campInstance.id];
		  System.Test.startTest();
		  		if (!getCampaignMem.isEmpty() ){
					delete getCampaignMem;
				}
		  System.Test.stopTest();
		  // Verify that the response received contains fake values
		  System.assertEquals(200, CampaignMemberToScribe.HttpRepsonseCode);
		  System.assertEquals('OK', CampaignMemberToScribe.HttpRepsonseStatus);
		  String responseBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
									'<notifications xmlns="http://soap.sforce.com/2005/09/outbound">'+
									'<Ack>Success</Ack>'+
									'</notifications>'+
									'</soapenv:Body>'+
									'</soapenv:Envelope>';
		  System.assertEquals(responseBody,CampaignMemberToScribe.HttpRepsonseBody);
	}
	
}