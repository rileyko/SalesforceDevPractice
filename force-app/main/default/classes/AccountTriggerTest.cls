@isTest
private class AccountTriggerTest {
    @isTest
    static void AccountTriggerTest() {
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account acct = new Account(Name = 'Test Account ' + i, BillingState = 'CA');
            accts.add(acct);
        }
        Test.startTest();
        insert accts;
        Test.stopTest();
        List<Account> lstAccount = [SELECT ShippingState FROM Account];
        for (Account a : lstAccount) {
            System.assertEquals('CA', a.ShippingState, 'ERROR');
        }
    }
}