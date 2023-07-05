public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(String param) {
        List<List<sObject>> findResult = [
            FIND :param
            IN ALL FIELDS
            RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)
        ];
        return findResult;
    }
}