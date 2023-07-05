public with sharing class OpptyController {
    String searchString = '';
    Integer currentPage = 0;
    Integer offsetVal = 10;
    Integer pageSize = 5;
    @AuraEnabled
    public static List<Opportunity> getOpptyLists(
        String searchKeyword,
        String stageName,
        Integer offsetVal,
        Integer pageSize
    ) {
        String queryString = 'SELECT Id, Name, StageName, Amount, CreatedDate, CloseDate ' + ' FROM Opportunity';

        if ((searchKeyword != null && searchKeyword != '') || (stageName != null && stageName != '')) {
            queryString += ' WHERE ';
            if (searchKeyword != null && searchKeyword != '') {
                String searchNameString = '\'%' + searchKeyword + '%\'';
                queryString += ' Name LIKE ' + searchNameString;
                if (stageName != null && stageName != '') {
                    queryString += ' AND ';
                }
            }
            if (stageName != null && stageName != '') {
                String searchStageString = '\'%' + stageName + '%\'';
                queryString += ' StageName LIKE ' + searchStageString;
            }
        }

        queryString += ' ORDER BY CreatedDate DESC, Name ASC ';
        if (offsetVal != null && pageSize != null) {
            System.debug(pageSize);
            queryString += 'LIMIT ' + pageSize + ' OFFSET ' + offsetVal;
        }
        try {
            System.debug(queryString);
            List<Opportunity> opptyList = Database.query(queryString);
            return opptyList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getTotalOpty(String searchKeyword, String stageName) {
        String queryString = 'SELECT COUNT(Id)cnt FROM Opportunity';
        try {
            if (
                (searchKeyword != null && searchKeyword != '') || (stageName != null && stageName != '' && stageName != ' ')
            ) {
                queryString += ' WHERE ';
                if (searchKeyword != null && searchKeyword != '') {
                    String searchNameString = '\'%' + searchKeyword + '%\'';
                    queryString += ' Name LIKE ' + searchNameString;
                    if (stageName != null && stageName != '' && stageName != ' ') {
                        queryString += ' AND ';
                    }
                }
                if (stageName != null && stageName != '' && stageName != ' ') {
                    String searchStageString = '\'%' + stageName + '%\'';
                    queryString += ' StageName LIKE ' + searchStageString;
                }
            }
            AggregateResult aggrOpty = Database.query(queryString);
            System.debug(Integer.valueOf(aggrOpty.get('cnt')));
            return Integer.valueOf(aggrOpty.get('cnt'));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getNext(Integer offsetVal, Integer pageSize) {
        System.debug(offsetVal + ' ::: ' + pageSize);
        offsetVal += pageSize;
        return offsetVal;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPrevious(Integer offsetVal, Integer pageSize) {
        if (offsetVal > 0)
            offsetVal -= pageSize;
        return offsetVal;
    }

    @AuraEnabled
    public static string updateOppties(Object data) {
        System.debug(data);

        List<Opportunity> opptiesForUpdate = (List<Opportunity>) JSON.deserialize(
            JSON.serialize(data).replaceAll('T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}Z', ''),
            List<Opportunity>.class
        );
        System.debug(opptiesForUpdate);
        try {
            update opptiesForUpdate;
            return 'Success: oppty updated successfully';
        } catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }
}