public with sharing class AccountUtils {
    public static List<Account> accountsByState(String streetAlias) {
        List<Account> acctList = new List<Account>([SELECT Id, Name FROM Account WHERE billingState = :streetAlias]);
        if (acctList.size() > 0) {
            System.debug(acctList);
        } else {
            System.debug('No Result!');
        }
        return acctList;
    }
}