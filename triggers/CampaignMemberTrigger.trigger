trigger CampaignMemberTrigger on CampaignMember (after Insert, before delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //CampaignMemberHelper.updateSourceCampaigns((List<CampaignMember>) Trigger.old, (List<CampaignMember>) Trigger.new);
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
          CampaignMemberToScribe.setUpCAlloutData(Trigger.old);
        }
    }

}