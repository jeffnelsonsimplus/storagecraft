public class CaseReviewCapture {
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Case> oldMap;
    Map<Id, Case> newMap;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public CaseReviewCapture(
        Map<Id, Case> oldTrigger, 
        Map<Id, Case> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
        }
    
    // The one method your master trigger will call
    public void RecordReview() {
        // Logic
        List<Case_Review__c> crs = new List<Case_Review__c>();
        List<Case> casesToUpdate = new List<Case>();
        for(Case c: newMap.values()){
            if(caseReviewPerformed(c)){
                crs.add(createReview(c));
                casesToUpdate.add(cleanReview(c));
            }
        }
        
        if(!crs.isEmpty())
            Insert crs;
        
        if(!casesToUpdate.isEmpty())
            Update casesToUpdate;
    }
    
    public Case cleanReview(Case c){
        Case cse = c.clone(true, true, true, true);
        cse.Case_Review_Comments__c = null;
        cse.Case_Review_Contact__c = false;
        cse.Case_Review_Escalation__c = false;
        cse.Case_Review_General__c = false;
        cse.Case_Review_Information__c = false;
        cse.Case_Review_Product__c = false;
        cse.Case_Review_Serial__c = false;
        return cse;
    }
    
    public Case_Review__c createReview(Case c){
        Case_Review__c cr = new Case_Review__c(
            Comments__c = c.Case_Review_Comments__c,
            Contact__c = c.Case_Review_Contact__c,
            Escalation__c = c.Case_Review_Escalation__c,
            General__c = c.Case_Review_General__c,
            Information__c = c.Case_Review_Information__c,
            Product__c = c.Case_Review_Product__c,
            Serial__c = c.Case_Review_Serial__c,
            Case__c = c.Id,
            Status__c = c.Status
        );
        
        // Have to handle when case is owned by queue
        // If owned by queue the don't set owner id
        if(c.OwnerId.getSobjectType() == Schema.User.getSobjectType())
            cr.OwnerId = c.OwnerId;
        return cr;
    }
    
    public Boolean caseReviewPerformed(Case c){
        if(c.Case_Review_Comments__c != null)
            return true;
        if(c.Case_Review_Contact__c)
            return true;
        if(c.Case_Review_Escalation__c)
            return true;
        if(c.Case_Review_General__c)
            return true;
        if(c.Case_Review_Information__c)
            return true;
        if(c.Case_Review_Product__c)
            return true;
        if(c.Case_Review_Serial__c)
            return true;
        // Guess nobody reviewed the case today, moving on with our lives
        return false;
    }
}