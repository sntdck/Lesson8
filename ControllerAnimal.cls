public with sharing class ControllerAnimal {

    @AuraEnabled(cacheable=true)
    public static List<Animal__c> getAnimal(Integer startId, Integer endId) {
        List<Integer> externalId = new List<Integer>();
        for(Integer i = startId; i < endId; i++) {
            externalId.add(i);
        }
        return makeCallToApi(externalId);
    }

    @AuraEnabled(cacheable=false)
    public static String saveAnimal(String jsonInput) {
        List<Animal__c> insertAnimal = getSaveAnimal(jsonInput);
        Database.SaveResult[] inList =  Database.insert(insertAnimal);
        List<Id> insertedAnimalsId = new List<Id>();
        for (Database.SaveResult sr : inList) {
            insertedAnimalsId.add(sr.getId());
        }
        sendEmail(insertedAnimalsId);
        String resultMessage = 'Insert success ' + insertedAnimalsId.size() + ' animal!'; 
        return resultMessage;
    }

    private static List<Animal__c> getSaveAnimal(String jsonInput) {
        List<Animal__c> result = new List<Animal__c>();
        SelectedAnimals response = SelectedAnimals.parse(jsonInput);
        for (SelectedAnimals.Data data: response.data) {
            Animal__c animal = new Animal__c();
            animal.Name = data.Name;
            animal.Eats__c = data.Eats;
            animal.Says__c = data.Says;
            animal.ExternalId__c = data.ExternalId;
            result.add(animal);
        }
        return result;
    }

    private static void sendEmail(List<Id> insertedAnimals) {
        List<Animal__c> insertedAnimals = [SELECT Id, Name, Eats__c, Says__c, External_Id__c FROM Animal__c WHERE Id IN : insertedAnimals];
        if (insertedAnimals != null && insertedAnimals.size() > 0) {
            String str = 'Insert success ' + insertedAnimals.size() + ' animal ' + insertedAnimals;
            String subject = 'Animal insert';
            String body = str.replaceAll('Animal__c', '');
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            email.setSubject( subject );
            email.setToAddresses( new String[] {UserInfo.getUserEmail()} );
            email.setPlainTextBody( body );
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        }
    }


    private static List<Animal__c> makeCallToApi(List<Integer> externalId) {
        Map<Integer,Animal__c> resultMap = AnimalRESTCallout.getAnimals(externalId);
        List<Animal__c> result = new List<Animal__c>();
        for(Integer exId : resultMap.keySet()) {
            Animal__c animal = resultMap.get(exId);
            if (animal.Eats__c.length() != 0 && animal.Says__c.length() != 0 && animal.name.length() != 0) {
                animal.External_Id__c = exId;
                result.add(animal);
            }
        }
        return result;
    }
}