/**
  \file         ScheduleBatchUpdateAccountPartnerLevels.cls
  \brief        This class implements the scheduler class for BatchUpdateAccountPartnerLevels.
  \details      SSF-400
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         1 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
*/
global class ScheduleBatchUpdateAccountPartnerLevels implements Schedulable
{
    global static String jobSchedule = '0 0 4 3 JAN,APR,JUL,OCT ?';             // run on the 3rd day of the month, every quarter

    global static String scheduleJob() {
      ScheduleBatchUpdateAccountPartnerLevels sbuapl = new ScheduleBatchUpdateAccountPartnerLevels();

      String cronId = '';

      try {
        cronId = System.schedule('Update Account Partner Level', jobSchedule, sbuapl);

        CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :cronId];

        System.debug(LoggingLevel.INFO, 'cron job: ' + ' \'Update Account Partner Level\' (' + cronId + ') scheduled - next run time is ' + ct.NextFireTime);
      }
      catch (exception e) {
        System.debug(LoggingLevel.ERROR, 'schedule of cron job: \'Update Account Partner Level\' failed: ' + e.getMessage());
      }

      return cronId;
    }

    global static void cancelJob()
    {
      Boolean hasCancelledJob = false;

      List<CronJobDetail> cronJobs = [SELECT Id, Name FROM CronJobDetail WHERE Name = 'Update Account Partner Level'];

      for (CronJobDetail cj : cronJobs) {
      	CronTrigger ct = [SELECT Id FROM CronTrigger WHERE CronJobDetailId = :cj.Id];

        if (ct.Id != null) {
          try {
            System.abortJob(ct.Id);
            System.debug(LoggingLevel.INFO, 'cancelled cron job: \'Update Account Partner Level\' (' + ct.Id + ')');

            hasCancelledJob = true;
          }
          catch (exception e) {
            System.debug(LoggingLevel.ERROR, 'cancel of cron job: \'Update Account Partner Level\' (' + ct.Id + ') failed: ' + e.getMessage());
          }
        }
      }

      if (hasCancelledJob == false) {
        System.debug(LoggingLevel.WARN, 'cron job: \'Update Account Partner Level\' does not exist');
      }

    }

    global void execute(SchedulableContext sc) {
        BatchUpdateAccountPartnerLevels buapl = new BatchUpdateAccountPartnerLevels();

        Database.executeBatch(buapl);
    }
}