global class ReassignAfterHoursImpl implements ReassignAfterHours.IScheduleDispatched {
    public void execute(SchedulableContext sc){
        // get the queue id for after hours
        Group g;
        try {
        	g = [Select Id from Group where DeveloperName = 'US_Afterhours'];
        } catch (Exception e){
            System.Debug(LoggingLevel.ERROR, 'No queue named US_Afterhours');
            return;
        }
        // get the membership for after hours
        List<GroupMember> gms = [Select Id, UserOrGroupId from GroupMember where GroupId = :g.Id];
        Set<Id> ownerIds = new Set<Id>();
        ownerIds.add(g.Id);
        for(GroupMember gm : gms){
            ownerIds.add(gm.UserOrGroupId);
        }
        // get the cases owned by those groups
        List<Case> cases = [Select id from Case where OwnerId IN :ownerIds AND IsClosed = false];
        Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule = True;
        for(Case c : cases){
            c.setOptions(dmo);
        }
        // reprocess cases to clear auto-assigned
        Update cases;
    }
}