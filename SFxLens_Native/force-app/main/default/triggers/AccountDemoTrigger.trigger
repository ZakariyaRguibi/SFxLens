trigger AccountDemoTrigger on Account (before insert, after insert) {
    // Before insert: append today's date to the account name
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountDemoHelper.appendDateToAccountNames(Trigger.new);
    }
    
    // After insert: create a case to greet the new account
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountDemoHelper.createGreetingCases(Trigger.new);
    }
}