trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    set<Id> accIds = new set<Id>();
    
    Switch on trigger.operationType {
        
        when BEFORE_UPDATE 
        {
            
        }
        
        when  AFTER_INSERT
        {
            for(account acc : trigger.new)
            {
                accIds.add(acc.Id);
                AccountRestApiCreateInFirstOrg.createAccountInFirstOrg(accIds);
            }
        }    }

}