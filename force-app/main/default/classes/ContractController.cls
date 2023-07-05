public with sharing class ContractController {
    @AuraEnabled(cacheable=true)
    public static Contract getContractStage(String recordId){
        try { 
            return [
                SELECT Id, ContractNumber, Status, StatusCode, ActivatedDate, LastModifiedDate 
                FROM Contract 
                WHERE AccountId = :recordId 
                ORDER BY ActivatedDate DESC  
                LIMIT 1];

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}