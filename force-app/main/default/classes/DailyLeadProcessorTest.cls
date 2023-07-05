@isTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    @isTest
    static void testScheduledJob() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead(LastName = 'woodeem', Company = 'waterdeer');
            leads.add(l);
        }
        insert leads;

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();
        List<Lead> leadList = new List<Lead>();
        leadList = [
            SELECT Id
            FROM Lead
            WHERE LeadSource = 'Dreamforce'
        ];

        System.assertEquals(200, leadList.size());
    }
}