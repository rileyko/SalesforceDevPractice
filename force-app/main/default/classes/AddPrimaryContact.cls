public with sharing class AddPrimaryContact implements Queueable {
    private Contact cont;
    private String state;
    public AddPrimaryContact(Contact cont, String state) {
        this.cont = cont;
        this.state = state;
    }
    public void execute(QueueableContext context) {
        List<Account> accts = [
            SELECT ID, Name, (SELECT id, FirstName, LastName FROM contacts)
            FROM ACCOUNT
            WHERE BillingState = :state
            LIMIT 200
        ];
        List<Contact> conts = new List<Contact>();
        for (Account acct : accts) {
            Contact cont = cont.clone(false, false, false, false);
            cont.AccountId = acct.Id;
            conts.add(cont);
        }
        if (conts.size() > 0) {
            insert conts;
        }
    }
}