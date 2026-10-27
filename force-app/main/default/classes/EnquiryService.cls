public class EnquiryService {

    public static void beforeInsert(List<Enquiry__c> records) {
        for (Enquiry__c e : records) {
            if (String.isBlank(e.Status__c)) {
                e.Status__c = 'New';
            }

            if (e.Customer_Budget__c != null &&
                e.Customer_Budget__c < 1000) {
                e.Customer_Budget__c.addError(
                    'Customer budget must be at least ₹1,000'
                );
            }
        }
    }

    public static void afterInsert(List<Enquiry__c> records) {
        List<Task> tasksToInsert = new List<Task>();

        for (Enquiry__c e : records) {
            Task t = new Task();
            t.Subject = 'Follow up: ' + e.Subject__c;
            t.OwnerId = e.OwnerId;
            t.WhatId = e.Id;
            t.ActivityDate = Date.today().addDays(3);
            t.Status = 'Not Started';
            t.Priority = 'Normal';
            tasksToInsert.add(t);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public static void beforeUpdate(
        List<Enquiry__c> newRecords,
        Map<Id, Enquiry__c> oldMap
    ) {
        for (Enquiry__c e : newRecords) {
            Enquiry__c oldRecord = oldMap.get(e.Id);

            if (e.Status__c == 'Closed' &&
                oldRecord.Status__c != 'Closed') {
                e.Closed_Date__c = Date.today();
            }
        }
    }
}