public with sharing class licenseManagerController {
	public account a {get;set;}
	public license__c l {get;set;}

	public list<license__c> als {get;set;}
	public list<license__c> ils {get;set;}
	public list<license__c> pls {get;set;}

	Public boolean issueing {get;set;}
	Public boolean modifying {get;set;}

	public integer quantity {get;set;}

	public void goPage(){
		try{
			a = [Select Name,BillingCity,BillingState,BillingStreet,BillingPostalCode,Website From Account Where Id=:apexpages.currentPage().getParameters().get('id')];
		}
		catch(exception noAccount){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There was an error finding the correct account account. Please go back to the account and try again.'));
		}
		als = [select class__c, Activation__c, Edit__c, Replaced_by_License_Number__c,Account__c,Type__c,Language__c,LastModifiedDate,Name,Id,Status__c,Expiration__c,Linux__c,Replaced_By__c,Termination_Date__c from License__c where account__c = :a.id and status__c = 'Active'];
		ils = [select class__c, Activation__c, Replaced_by_License_Number__c,Account__c,Type__c,Language__c,LastModifiedDate,Name,Id,Status__c,Expiration__c,Linux__c,Replaced_By__c,Termination_Date__c from License__c where account__c = :a.id and status__c != 'Active'];
	}
	public void issueLicenses(){
		issueing = true;
		createLicense();
		quantity = 1;
	}
	public void createLicense(){
		l = new license__c(account__c = a.id, class__c = 'NFR', Origin__c = 'License Manager', Expiration__c = date.today().addMonths(12), status__c = 'Active', type__c = 'Desktop', language__c = 'English', Activation__c = date.today());
	}
	public void addToRequest(){
		if(l.Expiration__c <= date.today()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Expiration must be greater than today.'));
		}
		else if(quantity == null || quantity <= 0){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Quanity must be greater than 0.'));
		}
		else{
			if(pls == null){
				pls = new list<license__c>();
			}
			for(Integer i=0;i<quantity;i++){
				license__c thisLicense = new license__c(class__c = l.class__c, Activation__c = l.Activation__c, Account__c = l.Account__c,Type__c = l.Type__c,Language__c = l.Language__c,Status__c = l.Status__c,Expiration__c = l.Expiration__c, Origin__c = 'License Manager');
				pls.add(thisLicense);
			}
			createLicense();
		}
	}
	public void modifyLicenses(){
		modifying = true;
	}
	public PageReference confirmRequest(){
		return sendRequest('New');
	}
	public PageReference extend(){
		return sendRequest('Extend');
	}
	public PageReference replace(){
		return sendRequest('Replace');
	}
	public PageReference terminate(){
		return sendRequest('Terminate');
	}
	public PageReference sendRequest(string requestType){
		NFRKeyCallout callout = new NFRKeyCallout();
		list<license__c> rls;
		map<id,string> licenseIDToReplacedByLicense = new map<id,string>();
		if(requestType != 'New'){
			for(license__c al:als){
				if(!ApexPages.hasMessages()){
					if(al.edit__c){
						al.edit__c = false;
						boolean isLinux = false;
						if(al.type__c == 'SPX Linux'){
							isLinux = true;
						}
						string response;
						// if(test.isrunningtest()){
						// 	response = '7204-A252-0C39-BE02';
						// }
						// else{
							response = callout.makeCall(requestType,al.Name,al.Expiration__c,languageNumFromName(al.Language__c),getTypeNum(al.Type__c),isLinux,al.account__c,al.Language__c,al.Type__c);
						//}
						if(response.contains('fail')){
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'There was an error with your '+requestType+' please contact your administrator.'));
						}
						else{
							if(requestType == 'Replace'){
								if(rls == null){
									rls = new list<license__c>();
								}
								l = new license__c(class__c = al.class__c, Activation__c = al.Activation__c, Account__c = al.Account__c,Type__c = al.Type__c,Language__c = al.Language__c,Status__c = al.Status__c,Expiration__c = al.Expiration__c, name = response, Origin__c = 'License Manager');
								rls.add(l);
								licenseIDToReplacedByLicense.put(al.id,response);
							}
							if(requestType == 'Terminate'){
								al.Status__c = 'Terminated';
								al.Termination_Date__c = date.today();
							}
						}
					}
				}
			}
			if(!ApexPages.hasMessages()){
				map<string,id> replacedStringToNewLicenseID = new map<string,id>();
				if(rls != null && rls.size() > 0){
					insert rls;
					for(license__c rl:rls){
						replacedStringToNewLicenseID.put(rl.name,rl.id);
					}
				}
				if(replacedStringToNewLicenseID.size() > 0){
					for(license__c al:als){
						if(licenseIDToReplacedByLicense.containsKey(al.id)){
							al.Replaced_By__c = replacedStringToNewLicenseID.get(licenseIDToReplacedByLicense.get(al.id));
							al.status__c = 'Replaced';
						}
					}
				}
				update als;
			}
		}
		else{
			for(license__c pl:pls){
				if(!ApexPages.hasMessages()){
					boolean isLinux = false;
					if(pl.type__c == 'SPX Linux'){
						isLinux = true;
					}
					string response;
					// if(test.isrunningtest()){
					// 	response = '7204-A252-0C39-BE02';
					// }
					// else{
						response = callout.makeCall(requestType,pl.Name,pl.Expiration__c,languageNumFromName(pl.Language__c),getTypeNum(pl.Type__c),isLinux,pl.account__c,pl.Language__c,pl.Type__c);
					//}
					if(response.contains('fail')){
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'There was an error with your '+requestType+' please contact your administrator.'));
					}
					else{
						pl.name = response;
					}
				}
			}
			if(!ApexPages.hasMessages()){
				insert pls;
			}
		}
		if(!ApexPages.hasMessages()){
			PageReference ref = new PageReference('/apex/LicenseManager?id='+a.id);
			ref.setRedirect(true);
			return ref;
		}
		return null;
	}
	public PageReference returnToAccount(){
		PageReference page = new PageReference('/'+a.id);
		page.setRedirect(true);
		return page;
	}
	public Integer languageNumFromName(String Lang){
		for(Languages__c l : Languages__c.getAll().values()){
			if(l.Name == lang){
				return (Integer)l.Number__c;
			}
		}
		return 0;
	}
	public Integer getTypeNum(String typeName){
		if(typeName == 'Desktop')return 1;
		if(typeName == 'SPX Linux')return 2;
		if(typeName == 'Image Manager')return 7;
		if(typeName == 'Server')return 2;
		return null;
	}
}