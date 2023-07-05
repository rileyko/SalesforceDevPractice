@isTest
private class LeadProcessorTest {
    @TestSetup
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName = 'Test', Company = 'Test'));
        }
        insert leads;
    }
    @isTest
    static void test() {
        Test.startTest();
        LeadProcessor batchTest = new LeadProcessor();
        Id batchId = Database.executeBatch(batchTest);
        Test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }
}