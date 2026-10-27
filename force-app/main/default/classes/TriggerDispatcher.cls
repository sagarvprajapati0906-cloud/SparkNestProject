public class TriggerDispatcher {

    public static void run() {
        EnquiryTriggerHandler handler = new EnquiryTriggerHandler();

        if (Trigger.isBefore && Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.beforeUpdate(
                Trigger.new,
                (Map<Id, Enquiry__c>) Trigger.oldMap
            );
        }
    }
}