public with sharing class AccountDemoHelper {
    /**
     * Appends today's date to the Account name
     * @param accounts List of Account records being inserted
     */
    public static void appendDateToAccountNames(List<Account> accounts) {
        String todayDate = System.today().format();
        
        for (Account acc : accounts) {
            if (acc.Name != null) {
                acc.Name = acc.Name + ' - ' + todayDate;
            }
        }
    }
    
    /**
     * Creates greeting cases for new Accounts
     * @param accounts List of newly inserted Account records
     */
    public static void createGreetingCases(List<Account> accounts) {
        List<Case> casesToInsert = new List<Case>();
        
        for (Account acc : accounts) {
            Case newCase = new Case(
                Subject = 'Welcome ' + acc.Name,
                Description = 'Please reach out to this new account to welcome them.',
                Status = 'New',
                Origin = 'Automated Process',
                AccountId = acc.Id,
                Priority = 'Normal'
            );
            casesToInsert.add(newCase);
        }
        
        if (!casesToInsert.isEmpty()) {
            insert casesToInsert;
        }
    }
}