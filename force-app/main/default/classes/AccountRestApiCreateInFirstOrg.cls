public class AccountRestApiCreateInFirstOrg {
    
    @future(callout=true)
    public static void createAccountInFirstOrg(set<Id> accIds)
    {
        string msg;
        //1.getting token/sessionid from other org (1st org) 
        string orgURL = 'https://vlrcom3-dev-ed.my.salesforce.com/services/oauth2/token';
        string endpointurl = orgURL;
        string userName = 'venkatesh.vemula@salesforce.com';
        string password = 'Iceberg@2025vKHleWn57LD7Tgv8vibbmknX';
        string clientId = '3MVG9fe4g9fhX0E55L5gtHDU2EaUogi17CaYTl4nBLOpCu4wiEx_rLglA3SloFUvVJ1rozPd2ZYDJSvY8Lann'; //3MVG9fe4g9fhX0E55L5gtHDU2EaUogi17CaYTl4nBLOpCu4wiEx_rLglA3SloFUvVJ1rozPd2ZYDJSvY8Lann
        string clientSecret = '479A56A9C07FAEC3A2108A3DC6FA56AAEC5413E8B313C4F8B5DAF8D466AAA42C'; //479A56A9C07FAEC3A2108A3DC6FA56AAEC5413E8B313C4F8B5DAF8D466AAA42C
        
        //string clientId = '3MVG9fe4g9fhX0E55L5gtHDU2EaUogi17CaYTl4nBLOpCu4wiEx_rLglA3SloFUvVJ1rozPd2ZYDJSvY8Lann';
        //string clientSecret = '479A56A9C07FAEC3A2108A3DC6FA56AAEC5413E8B313C4F8B5DAF8D466AAA42C'; 
        string reqbody = 'grant_type=password&username=' + userName + '&password=' + password + '&client_id=' + clientId + '&client_secret=' + clientSecret;
        //String reqbody = 'grant_type=password' + '&client_id='+ clientId +'&client_secret='+ clientSecret + '&username='+ userName + '&password='+ password;
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setEndpoint(endpointurl);
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        
        http hp = new http();
        HttpResponse resp = hp.send(req);
        system.debug('resp getStatus==' + resp.getStatus());
        system.debug('resp getStatusCode==' + resp.getStatusCode());
        
        if(resp.getStatusCode() == 200)
        {
            String respbodystr = resp.getBody();
            system.debug('respbody json==' + respbodystr); 
            respbodywrap respbody = (respbodywrap) system.JSON.deserialize(respbodystr, respbodywrap.class);
            system.debug('respbody class==' + respbody);
            system.debug('access_token ==> ' + respbody.access_token); 
            
                //2.call apex class using above 'access_token'
                list<Account> accList = [SELECT Name, Type, Rating, Industry, AnnualRevenue,Phone FROM Account WHERE Id =:accIds];
                string JsonStr= system.JSON.serializePretty(accList,true);
            	system.debug('JsonStr => ' + JsonStr);
                string endPoint_URL = 'https://vlrcom3-dev-ed.my.salesforce.com/services/apexrest/v1/account/';   //https://test.salesforce.com
                system.debug('endPoint_URL => ' + endPoint_URL);
                string endpoint = endPointURL;
                
                http h = new http();
                httpRequest request = new httpRequest();
                
                request.setEndpoint(endpoint);
                request.setMethod('POST');
                request.setHeader('Accept', 'application/json');
                request.setHeader('Content-Type','application/json');
                request.setHeader('Authorization','Bearer ' + string.valueOf(respbody.access_token));
            	request.setBody(JsonStr);
                HttpResponse response = h.send(request);
                system.debug('StatusCode => ' + response.getStatusCode());
                
                if(response.getStatusCode() == 200)
                {
                   system.debug('str_response json==' + response.getBody());
                }else{
                    system.debug('responseBody => ' + response.getBody());
                }
        }
        else{
            //capturing error response.
            system.debug('resp==' + resp);
        }        
        
    }
    
        public class respbodywrap{
        public string access_token;
        public string instance_url;
        public string id;
        public string token_type;
        public string issued_at;
        public string refresh_token;
        public string signature;
    }

}