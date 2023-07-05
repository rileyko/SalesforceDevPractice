public class AccountProcessor {
    @future
    public static void countContacts(Set<Id> setId) {
        List<Account> lstAccount = [
            SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts)
            FROM account
            WHERE Id IN :setId
        ];
        System.debug(lstAccount);
        for (Account acc : lstAccount) {
            List<Contact> lstCont = acc.contacts;
            acc.Number_of_Contacts__c = lstCont.size();
        }
        update lstAccount;
    }
}