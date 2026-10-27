trigger CasePriorityAutomationTrigger on Case (before insert) {
CasePriorityHandler.BeforeInsert(Trigger.New);
}