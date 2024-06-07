public class SobjectListCntrl {

    @AuraEnabled(Cacheable=true)
    public static Map<String,String> getObjects(){
        list<String> ObjNames = new list<String>{'Account', 'Contact', 'Opportunity', 'Case', 'Lead', 'Person__c', 'Student__c','Stage_Duration__c'};
        Map<String,String> objectMap = new Map<String,String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
           String name = objTyp.getDescribe().getName();
           String label = objTyp.getDescribe().getLabel();
           if( ObjNames.contains(name) 
                && objTyp.getDescribe().isCreateable() && objTyp.getDescribe().isAccessible() 
                && objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                objectMap.put(name,label);
           }
        }
		System.debug(objectMap);
        if(objectMap != null && objectMap.size() > 0){
            system.debug('objectMap => ' + objectMap);
        	return objectMap;   
        }else{
            return null;
        }
    }

    @AuraEnabled
    public static list<Sobject> getObjectRecords(string objectName, list<string> fieldsList, integer recordsLimit){             
        
        String fields = String.join(fieldsList, ',');
        system.debug('fields => '+ fields);
        string queryString = 'SELECT Id, ' + fields + ' FROM ' + objectName + ' LIMIT ' + recordsLimit;
        system.debug('queryString => '+ queryString);
        return Database.query(queryString);
    }

}