trigger CaseTrigger on Case (
    before insert, after insert,
    before update, after update,
    before delete, after delete) {

        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
/*
                CaseSerialInfoCapture csic = new CaseSerialInfoCapture(Trigger.oldMap, Trigger.newMap, Trigger.new);
                csic.getSerialInfoForCases();
*/
                CaseAutoAssign caa = new CaseAutoAssign(Trigger.new);
                caa.AssignCases();
            }
            if (Trigger.isUpdate) {
                CaseAutoAssign caa = new CaseAutoAssign(Trigger.oldMap, Trigger.newMap);
                caa.AssignCases();
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }

        if (Trigger.IsAfter) {
            if (Trigger.isInsert) {
                // Call class logic here!

                CaseSerialInfoCapture csic = new CaseSerialInfoCapture(Trigger.oldMap, Trigger.newMap, Trigger.new);
                csic.getSerialInfoForCases();

                CaseReviewCapture crc = new CaseReviewCapture(Trigger.oldMap, Trigger.newMap);
                crc.RecordReview();
            }
            if (Trigger.isUpdate) {
                // Call class logic here!

                CaseSerialInfoCapture csic = new CaseSerialInfoCapture(Trigger.oldMap, Trigger.newMap, Trigger.new);
                //csic.getSerialInfoForCases();

                CaseReviewCapture crc = new CaseReviewCapture(Trigger.oldMap, Trigger.newMap);
                crc.RecordReview();
            }
            if (Trigger.isDelete) {
                // Call class logic here!
            }
        }
    }