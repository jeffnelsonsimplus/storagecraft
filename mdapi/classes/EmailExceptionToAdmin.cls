public with sharing class EmailExceptionToAdmin {
 
    /*
        02/27/12 - This class will be used to email the primary contact 
        whenever an unhandled exception is encountered.
         
        Please note that this class is WITHOUT SHARING because the public site user
        is often the one that calls this class and that set of users does not have
        access to the user table.  So if this class were with sharing, it would fail.
    */
 
    public static void notify(string SourceLocation, Exception e, string ExtraInformation) {
         
        string ToEmailAddress;
         
        ToEmailAddress = Site.getAdminEmail();
        if(ToEmailAddress == null)
            ToEmailAddress = 'anthony.heber@simplus.com';
         
        if (ToEmailAddress != null) {
            try {
                
                // Make sure this transaction won't fail due to lack of daily capacity
                Messaging.reserveSingleEmailCapacity(1);
                
                // generate our new object
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                
                // build the Array string required to set the to address
                String[] toAddresses = new String[] {ToEmailAddress};
                    system.debug('ToEmailAddress = ' + ToEmailAddress);
                
                // Set our to address
                email.setToAddresses(toAddresses);
                
                // hide the salesforce name in the display
                email.setSenderDisplayName('SalesForce.com');
                
                // set the subject on the email
                email.setSubject('Unhandled Exception Information');
                
                String body = 'An unhandled Exception has been encountered from: ' + SourceLocation;
                if(e != null){
                    body += '<br/>' +
                        'Exception Type Name: ' + e.getTypeName() + '<br/>' +
                        'Exception Message: ' + e.getMessage() + '<br/>' +
                        'Exception Cause: ' + e.getCause() + '<br/>' +
                        'Exception LineNumber: ' + e.getLineNumber();
                }
                body += '<br/>Extra Information: ' + ExtraInformation;
                
                // set the body of the email
                email.setHTMLBody(body);
                
                // send our email by creating an array of emails and calling the send email method.
                Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
                    Messaging.SendEmailResult[] mres = Messaging.sendEmail(EmailsToSend);
                
                System.debug(mres);
            } catch(Exception ex){
                // Do nothing because it doesn't matter
                System.debug('Unable to send email at this time');
                System.debug(ex.getMessage());
            }
             
        } // check for null address
         
    } // constructor Method
    
} // end class