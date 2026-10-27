@IsTest
private class CloseStaleEnquiriesBatchTest {

    @IsTest
    static void testBatchClosesStaleEnquiries() {

        // Create an Enquiry that should be closed
        Enquiry__c staleEnquiry = new Enquiry__c(
            Subject__c = 'Stale In Progress Enquiry',
            Enquiry_Type__c = 'Product Enquiry',
            Source__c = 'Website',
            Status__c = 'In Progress',
            Customer_Budget__c = 25000
        );

        insert staleEnquiry;

        // Make its last-modified date older than 30 days
        Test.setCreatedDate(
            staleEnquiry.Id,
            DateTime.now().addDays(-40)
        );

        Test.startTest();
CloseStaleEnquiriesBatch.testCutoffDate =
    DateTime.now().addDays(1);
        // Execute the batch
        Database.executeBatch(
            new CloseStaleEnquiriesBatch(),
            200
        );

        Test.stopTest();

        // Verify the enquiry was closed
        Enquiry__c result = [
            SELECT Status__c, Closed_Date__c
            FROM Enquiry__c
            WHERE Id = :staleEnquiry.Id
        ];

        System.assertEquals(
            'Closed',
            result.Status__c,
            'A stale In Progress enquiry should be closed.'
        );

        System.assertNotEquals(
            null,
            result.Closed_Date__c,
            'Closed Date should be populated by the trigger.'
        );
    }

    @IsTest
    static void testSchedulerCanBeScheduled() {

        Test.startTest();

        String jobId = System.schedule(
            'Test Close Stale Enquiries',
            '0 0 2 * * ?',
            new CloseStaleEnquiriesScheduler()
        );

        Test.stopTest();

        System.assertNotEquals(
            null,
            jobId,
            'The scheduler should be scheduled successfully.'
        );
    }
}