/* 
   auther         : venkatesh vemula

   Description    : Creates the person record from the createPersonLWC component.

   LastModifiedBy : venkatesh vemula

 */
public with sharing class CreateMemberCntrl {
    
    
	// this method is to get the payload from lwc and create Person record in the database then return success or error message.
	// used 2 return types string and map. one should be commented when testing other return type.
    @AuraEnabled
    public static Map<string, string> createMemberFromLWC(string payload) 
    {
        system.debug('payload ==> ' + payload);
        MemberWrapper pr = (MemberWrapper) system.JSON.deserialize(payload,MemberWrapper.class);
        system.debug('person ==> ' + pr);
        String Message;
        Map<string, string> msg = new Map<string, string>();
        
        list<Member__c> memberList = new list<Member__c>();
        Member__c mem = new Member__c();
        
        mem.Name = pr.Name;
        mem.Mobile_Number__c = pr.Mobile_Number;
        mem.Voter_Id__c = pr.Voter_Id;
        mem.Email__c = pr.Email;
        mem.Date_Of_Birth__c = pr.DOB;
        mem.Relationship__c = pr.Relationship;
        memberList.add(mem);
        
        /*
         // string returntype code..
        if(!personList.isEmpty())
        {
            try {
                system.debug('personList ==> ' + personList[0]);
                insert personList;
                Message = 'Person Record Created Successfully....! With Name = '+ personList[0].Name;
                system.debug('Message ==> ' + Message);
            }
            Catch(exception ex) 
            {
                Message = 'Error => ' + ex.getMessage();
                system.debug('Error Message ==> ' + Message);
            }
            
        }
		*/
        // Map returntype code..
        if(!memberList.isEmpty())
        {
            try {
                system.debug('memberList ==> ' + memberList[0]);
                insert memberList;
                msg.put('Success', 'Name = ' + memberList[0].Name);
                system.debug('msg ==> ' + msg);
                //sendEmail(memberList[0]);
            }
            Catch(exception ex) 
            {
                msg.put('Error', ex.getMessage());
                system.debug('Error Message ==> ' + msg);
            }
    	}
        return msg;
   }
    /*
    public static string sendEmail(Person__c person)
    {
        string message;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.toAddresses = new String[] {person.Email__c};
		email.Subject =  person.Name + ' - Created Record for You';
        email.plainTextBody  = 'Hi ' + person.Name + ',\n' + 'Your Details Recorded in our DataBase Successfully....!';

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        } 
        
        return message;
    }
    */

    public class MemberWrapper
    {
        @AuraEnabled public String Name;
        @AuraEnabled public String AdharNumber;
        @AuraEnabled public String Voter_Id;
        @AuraEnabled public String Mobile_Number;
        @AuraEnabled public String Relationship;
        @AuraEnabled public String Email;
        @AuraEnabled public Date DOB;

    }
}