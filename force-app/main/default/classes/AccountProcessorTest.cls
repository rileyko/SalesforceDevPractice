@isTest
private class AccountProcessorTest {
    @isTest
    private static void AccountProcessorTest() {
        // Test 데이터 생성
        Account acct = new Account(Name = 'Test Acct');
        insert acct;
        Contact cont = new Contact(FirstName = 'Cont', LastName = 'Test', AccountId = acct.Id);
        insert cont;
        // 파라미터로 전달할 Id 집합
        Set<Id> setAcctId = new Set<Id>();
        setAcctId.add(acct.Id);
        // 테스트
        Test.startTest();
        AccountProcessor.countContacts(setAcctId);
        Test.stopTest();
        // 개수 체크
        Account checkingAcct = [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acct.Id LIMIT 1];
        System.assertEquals(Integer.valueOf(checkingAcct.Number_of_Contacts__c), 1);
    }
}