public with sharing class AccountTriggerHandler {
    public static void CreateAccounts(List<Account> accts) {
        // before 트리거에는 DML 없움
        for (Account a : accts) {
            if (a.ShippingState != a.BillingState) {
                a.ShippingState = a.BillingState;
            }
        }
    }
}