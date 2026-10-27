global class CloseStaleEnquiriesScheduler
    implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(
            new CloseStaleEnquiriesBatch(), 200
        );
    }
}

/*String jobName = 'Close Stale Enquiries Nightly';

// Avoid creating a duplicate scheduled job
for (CronTrigger job : [
    SELECT Id, CronJobDetail.Name
    FROM CronTrigger
    WHERE CronJobDetail.Name = :jobName
]) {
    System.abortJob(job.Id);
}

chedule every day at 2:00 AM
String cronExpression = '0 0 2 * * ?';

System.schedule(
    jobName,
    cronExpression,
    new CloseStaleEnquiriesScheduler()
); */