public with sharing class AccountHandler {
    public static void CreateNewOpportunity(List<Account> accts) {
        // Bulk Patterns : DML 문은 루프문 안에 XXXXX!!
        List<Opportunity> opps = new List<Opportunity>(); // insert 시킬 빈 oppty 리스트 준비
        for (Account a : accts) {
            Opportunity opp = new Opportunity();
            opp.Name = a.Name + ' Opportunity';
            opp.AccountId = a.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today().addMonths(1);
            opps.add(opp); // 빈 리스트에 밀어넣기
        }
        if (opps.size() > 0) {
            insert opps; // 리스트 안비어있으면 insert 수행
        }
    }
    public static Account insertNewAccount(String acctName) {
        Account acct = new Account();
        try {
            acct.Name = acctName;
            insert acct;
        } catch (DmlException err) {
            System.debug(err.getMessage());
            return null;
        }
        return acct;
    }
}