global class CloseStaleEnquiriesBatch
    implements Database.Batchable<SObject> {
@TestVisible
private static Datetime testCutoffDate;
    global Database.QueryLocator start(
        Database.BatchableContext bc
    ) {
        
        
        
        DateTime cutoffDate = Test.isRunningTest() &&
    testCutoffDate != null
    ? testCutoffDate
    : System.now().addDays(-30);

        return Database.getQueryLocator([
            SELECT Id, Status__c, LastModifiedDate
            FROM Enquiry__c
            WHERE Status__c = 'In Progress'
            AND LastModifiedDate < :cutoffDate
            
        ]);
    }

    global void execute(
        Database.BatchableContext bc,
        List<Enquiry__c> records
    ) {
        for (Enquiry__c enquiry : records) {
            enquiry.Status__c = 'Closed';
        }

        if (!records.isEmpty()) {
            update records;
        }
    }

    global void finish(Database.BatchableContext bc) {
        // Batch processing completed.
    }
}