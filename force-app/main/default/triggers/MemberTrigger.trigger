trigger MemberTrigger on Member__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    switch on trigger.operationType
    {
        when BEFORE_INSERT {
            for(Member__c m : trigger.new) {
                if(m.Relationship__c == '' || m.Relationship__c == null){
                    m.addError('Relationship is required. Please select');
                }
            }
        }
        
        when AFTER_INSERT {
            MemberTriggerHandler.handleAfterInsert(trigger.new);
            UpdateFamilyStatusCntrl.updateFamStatus(trigger.new);
        }
        
        when AFTER_UPDATE {  
            UpdateFamilyStatusCntrl.updateFamStatus(trigger.new);
        }
        
        when BEFORE_DELETE {
            MemberTriggerHandler.handleBeforeDelete(trigger.old);
        }
    }

}