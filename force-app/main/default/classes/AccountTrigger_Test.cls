@isTest
private class AccountTrigger_Test {
    @isTest
    static void TestCreateNewAccountInBulk() {
        // 테스트 데이터 지정
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account acct = new Account(Name = 'Test Account ' + i);
            accts.add(acct); // 200개 Account 생성
        }
        // 테스트 실행
        Test.startTest(); // 테스트 시작
        insert accts;
        Test.stopTest(); // 테스트 종료
        // Acct, Oppty 둘다 200개씩 잘 삽입되었는지 확인
        List<Account> verifyAccts = [SELECT Id FROM Account];
        System.assertEquals(200, verifyAccts.size());
        List<Opportunity> verifyOpps = [SELECT Id FROM Opportunity];
        System.assertEquals(200, verifyOpps.size());
    }
}