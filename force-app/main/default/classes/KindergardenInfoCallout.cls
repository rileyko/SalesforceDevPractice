public with sharing class KindergardenInfoCallout {
    private static final Credential__mdt Credential = Credential__mdt.getInstance('eChild');

    @AuraEnabled
    public static Map<String, Object> makeCallout(String sidoCode, String sggCode) {
        Map<String, Object> responseMap = new Map<String, Object>();
        try {
            String url = 'https://e-childschoolinfo.moe.go.kr/api/notice/basicInfo.do?';
            String apikey = 'key=' + Credential.apiKey__c;
            String param = String.format('&sidoCode={0}&sggCode={1}', new List<String>{ sidoCode, sggCode });
            String endpoint = url + apikey + param;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setTimeout(120000);
            HttpResponse response = http.send(request);

            if (response.getStatusCode() != 200) {
                System.debug('Server Error');
            }
            String res = response.getBody();
            responseMap = (Map<String, Object>) JSON.deserializeUntyped(res);
            System.debug('Callout Result : ' + responseMap);
            //List<Object> result = (List<Object>) responseMap.get('kinderInfo');
        } catch (Exception err) {
            System.debug(err);
        }
        return responseMap;
    }
}