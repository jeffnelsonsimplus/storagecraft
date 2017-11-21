/**
  \file         BatchUpdateAccountPartnerLevels.cls
  \brief        This class implements scheduled Accounts jobs.
  \details      SSF-400
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         24 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
	1.1				2017-08-16	Matt Thompson-Moltzen		Send an email when job finishes.
																								Add LIMIT operand to query.
  1.2       2017-08-24  Matt Thompson-Moltzen   Added trigger disablement prior to the update call.
*/
global class BatchUpdateAccountPartnerLevels implements Database.Batchable<SObject>
{
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		String query = 'SELECT Id, Partner_Level__c, Partner_Level_atQuarter__c FROM Account';

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<Account> accts)
	{
		for (Account a : accts) {
			a.Partner_Level_atQuarter__c = a.Partner_Level__c;
		}

    AccountTriggerHandler.disableTrigger();

		try {
			update accts;
		}
		catch (DmlException e) {
			System.debug(LoggingLevel.ERROR, 'BatchUpdateAccountPartnerLevels::execute() failed: ' + e.getMessage());
		}

    AccountTriggerHandler.enableTrigger();
	}

	global void finish(Database.BatchableContext bc)
	{
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];

		System.debug(LoggingLevel.INFO, 'BatchUpdateAccountPartnerLevels::finish() Status=' + a.Status + ' TotalJobItems=' + a.TotalJobItems + ' JobItemsProcessed=' + a.JobItemsProcessed + ' NumberOfErrors= ' + a.NumberOfErrors);

		// send an email to the Apex job's submitter notifying them of job completion.
		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

		List<String> toAddresses = new List<String>();

		toAddresses.add(a.CreatedBy.Email);

		String subject = 'APEX BATCH: BatchUpdateAccountPartnerLevels finished processing with status: ' + a.Status;
		String body		 = 'The Apex batch job BatchUpdateAccountPartnerLevels finished processing.\r\n\r\n';

		body += '    Job status:       ' + a.Status + '\r\n';
		body += '    Total batches:    ' + a.TotalJobItems + '\r\n';
		body += '    Items processed:  ' + a.JobItemsProcessed + '\r\n';
		body += '    Number of errors: ' + a.NumberOfErrors + '\r\n\r\n';

		List<OrgWideEmailAddress> owea = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'crm@storagecraft.com'];

		if (owea.size() > 0) { message.setOrgWideEmailAddressId(owea.get(0).Id); }

		message.setToAddresses(toAddresses);
		message.setSubject(subject);
		message.setPlainTextBody(body);

		messages.add(message);

		if (messages.size() > 0) {
			List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult>();

			try {
				results = Messaging.sendEmail(messages);
			}
			catch (Exception e) {
				System.debug(LoggingLevel.ERROR, 'BatchUpdateAccountPartnerLevels::finish() exception: ' + e.getMessage());

				return;
			}

			Integer i = 0;

			for (i = 0; i < results.size(); i++) {
				if (results[i].IsSuccess() == false) {
					System.debug(LoggingLevel.ERROR, 'BatchUpdateAccountPartnerLevels::finish() failed: ' + results[i].errors[0].message);
				}
			}
		}

	}

}