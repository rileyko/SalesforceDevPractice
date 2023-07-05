public class MyFutureClass {
    @future(callout=true)
    static void myFutureMethod(Set<ID> ids) {
        List<Contact> contacts = [SELECT Id, LastName, FirstName, Email FROM Contact WHERE Id IN :ids];
        for (Contact con : contacts) {
            String response = anotherClass.callout(con.Id, con.FirstName, con.LastName, con.Email);
        }
    }
}