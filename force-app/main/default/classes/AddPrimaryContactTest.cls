@isTest
public class AddPrimaryContactTest {
    @TestSetup
    static void setup() {
        // Account 데이터 생성
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accts.add(new Account(BillingState = 'CA', name = 'Acct' + i));
        }
        for (Integer i = 0; i < 50; i++) {
            accts.add(new Account(BillingState = 'NY', name = 'Acct' + i));
        }
        insert accts;
    }
    @isTest
    static void test() {
        // Contact 데이터
        Contact cont = new Contact();
        cont.FirstName = 'Woodeem';
        cont.LastName = 'Ko';
        insert cont;
        String state = 'CA';
        // 배치 인스턴스 생성 및 실행
        AddPrimaryContact apc = new AddPrimaryContact(cont, state);
        Test.startTest();
        System.enqueueJob(apc);
        Test.stopTest();
        // Validation
        System.assertEquals(
            50,
            [SELECT COUNT() FROM Contact WHERE accountId IN (SELECT Id FROM Account WHERE BillingState = :state)]
        );
    }
}