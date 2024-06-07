public class UpdateFamilyStatusCntrl {
    
    public static void updateFamStatus(list<Member__c> triggerNew)
    {
        list<Family__c> FamList = new list<Family__c>();
        set<string> FamIds = new set<string>();
        set<string> compFamIds = new set<string>();
        for(Member__c me : triggerNew) {
            FamIds.add(me.Family__c);
        }
        system.debug('FamList ==> ' + FamList);
        list<Member__c> totalMembersList = [Select Id, Name, Family__c, Profile_Status__c From Member__c  Where Family__c =: FamIds];
        system.debug('totalMembersList size ==> ' +  totalMembersList.size());
        list<Member__c> completedMembersList = [Select Id, Name, Family__c, Profile_Status__c From Member__c Where Profile_Status__c = 'Completed' AND Family__c =: FamIds];
        system.debug('completedMembersList size ==> ' +  completedMembersList.size());
            for(Member__c m : completedMembersList) {
            		compFamIds.add(m.Family__c);
        	}
        FamList = [Select Id, Name, Status__c From Family__c Where Id IN :compFamIds];
        if(totalMembersList.size() == completedMembersList.size())
        {
            
            system.debug('FamList ==> ' + FamList);
            if(!FamList.isEmpty() || FamList.size()>0) {
                for(Family__c f : FamList) {
                    f.Status__c = 'Completed';
                }
                update FamList;
        	} 
        }
        else {
            system.debug('FamList ==> ' + FamList);
            for(Family__c f : FamList) {
                f.Status__c = 'Not Yet Completed';
            }
            update FamList;
        }
    }

}