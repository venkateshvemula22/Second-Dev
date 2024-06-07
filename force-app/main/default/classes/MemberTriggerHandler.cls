public class MemberTriggerHandler {
    
    public static void handleAfterInsert(list<Member__c> triggerNew)
    {
        set<string> FamilyIds = new set<string>();
        for(Member__c famId : triggerNew){
            FamilyIds.add(famId.Family__c);
        }
        list<Family__c> Family = [select Id from Family__c where Id IN : FamilyIds];
        for(Member__c person : triggerNew)
        {
            for(Family__c fam : Family) {
                if(person.Relationship__c == 'Father' && person.Family__c == fam.Id){
                    fam.Father__c = person.Name;
                }
                if(person.Relationship__c == 'Mother' && person.Family__c == fam.Id){
                    fam.Mother__c = person.Name;
                }
                if(person.Relationship__c == 'First Son' && person.Family__c == fam.Id){
                    fam.First_Son__c = person.Name;
                }
                if(person.Relationship__c == 'Second Son' && person.Family__c == fam.Id){
                    fam.Second_Son__c = person.Name;
                }
                if(person.Relationship__c == 'First Daughter' && person.Family__c == fam.Id){
                    fam.First_Daughter__c = person.Name;
                }
                if(person.Relationship__c == 'Second daughter' && person.Family__c == fam.Id){
                    fam.Second_Daughter__c = person.Name;
                }
                if(person.Relationship__c == 'Grand Father' && person.Family__c == fam.Id){
                    fam.Grand_Father__c = person.Name;
                }
                if(person.Relationship__c == 'Grand Mother' && person.Family__c == fam.Id){
                    fam.Grand_Mother__c = person.Name;
                }
                if(person.Relationship__c == 'Grand Son' && person.Family__c == fam.Id){
                    fam.Grand_Son__c = person.Name;
                }
                if(person.Relationship__c == 'Grand Daughter' && person.Family__c == fam.Id){
                    fam.Grand_Daughter__c = person.Name;
                }
                if(person.Relationship__c == 'Son' && person.Family__c == fam.Id){
                    fam.Son__c = person.Name;
                }
                if(person.Relationship__c == 'daughter' && person.Family__c == fam.Id){
                    fam.Daughter__c = person.Name;
                }
                if(person.Relationship__c == 'Daughter In Law' && person.Family__c == fam.Id){
                    fam.Daughter_In_Law__c	 = person.Name;
                }
                
                update fam;
            }
        }
    }
    
    public static void handleBeforeDelete(list<Member__c> triggerNew)
    {
        set<string> FamilyIds = new set<string>();
        for(Member__c famId : triggerNew){
            FamilyIds.add(famId.Family__c);
        }
        
        list<Family__c> Famil = [select Id, Father__c, Mother__c, First_Son__c, Second_Son__c, First_Daughter__c, Second_Daughter__c,
                                 Grand_Father__c, Grand_Mother__c, Grand_Son__c, Grand_Daughter__c, Son__c, Daughter__c, Daughter_In_Law__c
                                 from Family__c where Id IN : FamilyIds];
        
        for(Member__c per : triggerNew)
        {
            for(Family__c fa : Famil) {
                if(per.Relationship__c == 'Father' && fa.Father__c != '') {
                    fa.Father__c = '';
                }
                if(per.Relationship__c == 'Mother' && fa.Mother__c != '') {
                    fa.Mother__c = '';
                }
                if(per.Relationship__c == 'First Son' && fa.First_Son__c != '') {
                    fa.First_Son__c = '';
                }
                if(per.Relationship__c == 'Second Son' && fa.Second_Son__c != '') {
                    fa.Second_Son__c = '';
                }
                if(per.Relationship__c == 'First Daughter' && fa.First_Daughter__c != '') {
                    fa.First_Daughter__c = '';
                }
                if(per.Relationship__c == 'Second daughter' && fa.Second_Daughter__c != '') {
                    fa.Second_Daughter__c = '';
                }
                if(per.Relationship__c == 'Grand Father' && fa.Grand_Father__c != '') {
                    fa.Grand_Father__c = '';
                }
                if(per.Relationship__c == 'Grand Mother' && fa.Grand_Mother__c != '') {
                    fa.Grand_Mother__c = '';
                }
                if(per.Relationship__c == 'Grand Son' && fa.Grand_Son__c != '') {
                    fa.Grand_Son__c = '';
                }
                if(per.Relationship__c == 'Grand Daughter' && fa.Grand_Daughter__c != '') {
                    fa.Grand_Daughter__c = '';
                }
                if(per.Relationship__c == 'Son' && fa.Son__c != '') {
                    fa.Son__c = '';
                }
                if(per.Relationship__c == 'daughter' && fa.Daughter__c != '') {
                    fa.Daughter__c = '';
                }
                if(per.Relationship__c == 'Daughter In Law' && fa.Daughter_In_Law__c != '') {
                    fa.Daughter_In_Law__c = '';
                }
                
                update fa;
            }
        }
    }

}