public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [
            SELECT Id, LeadSource
            FROM Lead
            WHERE LeadSource = NULL
        ];
        List<Lead> newLeads = new List<Lead>();
        for (Lead lead : leads) {
            lead.LeadSource = 'Dreamforce';
            newLeads.add(lead);
        }
        update newLeads;
    }
}