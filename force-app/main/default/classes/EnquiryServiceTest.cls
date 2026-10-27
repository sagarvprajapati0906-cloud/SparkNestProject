@IsTest
private class EnquiryServiceTest {

    // Creates a Contact for test records
    private static Contact createTestContact() {
        Contact c = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'testcustomer' + System.now().getTime() + '@example.com'
        );
        insert c;
        return c;
    }

    // Creates a valid Enquiry
    private static Enquiry__c createTestEnquiry(Id contactId, String subject) {
        return new Enquiry__c(
            Subject__c = subject,
            Enquiry_Type__c = 'Product Enquiry',
            Contact__c = contactId,
            Source__c = 'Website',
            Customer_Budget__c = 25000,
            Priority__c = 'Medium'
        );
    }

    @IsTest
    static void testDefaultStatusAndTaskCreation() {
        Contact c = createTestContact();
        Enquiry__c e = createTestEnquiry(c.Id, 'Test Enquiry');

        // Leave Status blank to test the trigger default
        Test.startTest();
        insert e;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Status__c, OwnerId
            FROM Enquiry__c
            WHERE Id = :e.Id
        ];

        System.assertEquals('New', savedEnquiry.Status__c);

        Task followUp = [
            SELECT Subject, OwnerId, WhatId, ActivityDate
            FROM Task
            WHERE WhatId = :e.Id
            LIMIT 1
        ];

        System.assertEquals('Follow up: Test Enquiry', followUp.Subject);
        System.assertEquals(e.Id, followUp.WhatId);
        System.assertEquals(savedEnquiry.OwnerId, followUp.OwnerId);
        System.assertEquals(Date.today().addDays(3), followUp.ActivityDate);
    }

    @IsTest
    static void testBudgetValidation() {
        Contact c = createTestContact();
        Enquiry__c e = createTestEnquiry(c.Id, 'Low Budget Enquiry');
        e.Customer_Budget__c = 500;

        Test.startTest();
        Database.SaveResult result = Database.insert(e, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());

        Boolean foundBudgetError = false;
        for (Database.Error err : result.getErrors()) {
            if (err.getMessage().contains('Customer budget')) {
                foundBudgetError = true;
            }
        }

        System.assertEquals(true, foundBudgetError);
    }

    @IsTest
    static void testClosedDateStamp() {
        Contact c = createTestContact();
        Enquiry__c e = createTestEnquiry(c.Id, 'Close Date Test');
        insert e;

        Test.startTest();
        e.Status__c = 'Closed';
        update e;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Status__c, Closed_Date__c
            FROM Enquiry__c
            WHERE Id = :e.Id
        ];

        System.assertEquals('Closed', savedEnquiry.Status__c);
        System.assertEquals(Date.today(), savedEnquiry.Closed_Date__c);
    }

    @IsTest
    static void testBulkInsert200Enquiries() {
        Contact c = createTestContact();
        List<Enquiry__c> enquiries = new List<Enquiry__c>();

        for (Integer i = 0; i < 200; i++) {
            enquiries.add(
                createTestEnquiry(c.Id, 'Bulk Enquiry ' + i)
            );
        }

        Test.startTest();
        insert enquiries;
        Test.stopTest();

        System.assertEquals(200, [
            SELECT COUNT()
            FROM Enquiry__c
            WHERE Subject__c LIKE 'Bulk Enquiry %'
        ]);

        System.assertEquals(200, [
            SELECT COUNT()
            FROM Task
            WHERE WhatId IN :enquiries
        ]);
    }
}