global class MyBatchableClass implements Database.Batchable<sObject>, Database.Stateful {
    // 총 Account 수
    global Integer numOfRecs = 0;
    // 처음 한번 호출
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    // 총 개수/배치사이즈 만큼 실행 (default batch size : 200)
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            numOfRecs = numOfRecs + 1;
        }
    }
    // 배치 끝날때 실행
    global void finish(Database.BatchableContext bc) {
        EmailManager.sendMail(
            'rainforest@trestle.co.kr',
            numOfRecs + ' Accounts were processed!',
            'Meet me at the bar for drinks to celebrate'
        );
    }
}