public class EnquiryTriggerHandler {

    public void beforeInsert(List<Enquiry__c> newRecords) {
        EnquiryService.beforeInsert(newRecords);
    }

    public void afterInsert(List<Enquiry__c> newRecords) {
        EnquiryService.afterInsert(newRecords);
    }

    public void beforeUpdate(
        List<Enquiry__c> newRecords,
        Map<Id, Enquiry__c> oldMap
    ) {
        EnquiryService.beforeUpdate(newRecords, oldMap);
    }
}