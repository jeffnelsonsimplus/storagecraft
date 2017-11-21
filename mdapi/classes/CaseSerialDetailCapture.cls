global class CaseSerialDetailCapture implements Queueable, Database.AllowsCallouts {

    public Case cse;

    public CaseSerialDetailCapture(Case c){
        cse = c;
    }

    public void execute(QueueableContext context) {
    	updateLicenseDetails(cse.Id);
    }

    webservice static void updateLicenseDetails(Id cid){
        Case c = [select Id, Serial_Number__c from Case where Id = :cid];
        if(c.Serial_Number__c != null){
            c.Serial_Number_Details__c = SerialNumberSupportInfo.getSNInfo(c.Serial_Number__c);
            System.debug('Details:'+c.Serial_Number_Details__c);
            if(c.Serial_Number_Details__c != null)
            	update c;
        }
    }
}