public class ContactSearch {
    public static List<Contact> searchForContacts(String nameStr, String postalCodeStr) {
        List<Contact> contList = [
            SELECT Id, Name
            FROM Contact
            WHERE LastName = :nameStr AND MailingPostalCode = :postalCodeStr
        ];
        return contList;
    }
}