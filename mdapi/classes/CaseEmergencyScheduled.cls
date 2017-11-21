public class CaseEmergencyScheduled implements Schedulable {
    public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    public static String prefix = 'CaseEmergency';
    public static void scheduleMe(){
        CaseEmergencyScheduled c = new CaseEmergencyScheduled();
        String srch = prefix+':%';
        List<CronTrigger> crons = [select CronJobDetail.Name from CronTrigger where CronJobDetail.Name LIKE :srch];
        Set<String> cronNames = new Set<String>();
        for(CronTrigger ct : crons)
            cronNames.add(ct.CronJobDetail.Name);
        System.debug(cronNames);
        for(Integer i = 0; i< 60; i += 10){
            String sch = '0 '+i+' * * * ?';
            if(!cronNames.contains(prefix+':'+i))
            	System.schedule(prefix+':'+i, sch, c);   
        }
    }
    
    public void execute(SchedulableContext sc) 
    {
        Type targettype = Type.forName('CaseEmergencyTriggerEmail');   
        if(targettype!=null) {
            IScheduleDispatched obj = (IScheduleDispatched)targettype.NewInstance();
            obj.execute(sc);   
        } 
    }
}