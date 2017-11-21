trigger AcademyCertificateTrigger on Academy_Certificate__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {            
            AcademyCertificateManager.setAccount((List<Academy_Certificate__c>)Trigger.new);
        }
        if (Trigger.isUpdate) {
            AcademyCertificateManager.setAccount((List<Academy_Certificate__c>)Trigger.new);
        }
    }
}