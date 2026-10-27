trigger LeadRatingAutomation on Lead (before insert) {
LeadHandler.beforeInsert(Trigger.New);
}