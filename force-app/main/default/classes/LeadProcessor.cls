public class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource ' + 'FROM Lead');
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> newLeads = new List<Lead>();
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            newLeads.add(l);
        }
        update newLeads;
    }
    public void finish(Database.BatchableContext bc) {
    }
}