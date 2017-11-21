global class ReassignAfterHours implements Schedulable {
    public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    public static String prefix = 'ReassignAfterHoursSched';
    public static void scheduleMe(){
        CaseEmergencyScheduled c = new CaseEmergencyScheduled();
        List<CronTrigger> crons = [select CronJobDetail.Name from CronTrigger where CronJobDetail.Name = :prefix];
        if(crons.isEmpty()){
            String sch = '0 5 6 ? * MON-FRI';
        	System.schedule(prefix, sch, c);   
        }
    }
    
    global void execute(SchedulableContext sc)
    {
        Type targettype = Type.forName('ReassignAfterHoursImpl');   
        if(targettype!=null) {
            IScheduleDispatched obj = (IScheduleDispatched)targettype.NewInstance();
            obj.execute(sc);   
        } 
    }
}