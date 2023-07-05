public class MyQueueableClass implements Queueable {
    private List<Contact> contacts;
    public MyQueueableClass(List<Contact> myContacts) {
        contacts = myContacts;
    }
    public void execute(QueueableContext context) {
        for (Contacts con : contacts) {
            String response = anotherClass.calloutMethod(con.Id, con.FirstName, con.LastName, con.Email);
        }
    }
}