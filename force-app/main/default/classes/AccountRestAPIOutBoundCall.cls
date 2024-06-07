/*						****STEPS ****
1.getting token/sessionid from other org (1st org) 
2.call apex class using above sessionid/Token 
**/
public class AccountRestAPIOutBoundCall {
    
    public static void doApiCallout(list<Id> accIds)
    {
        string msg;
        //1.getting token/sessionid from other org (1st org) 
        string orgURL = 'https://vlrcom3-dev-ed.my.salesforce.com/services/oauth2/token';
        string endpointurl = orgURL;
        string userName = 'venkatesh.vemula@salesforce.com';
        string password = 'dev@2023t4OhiOUO9FdkEV4HmlxhseXU';
        string clientId = '3MVG9fe4g9fhX0E55L5gtHDU2ETrJI1S_7aKcXu0F11y5ASdo9zaVSP6vYXRum3FYVU69nBK_8U.vBQxT1fpc'; //3MVG9fe4g9fhX0E55L5gtHDU2EaUogi17CaYTl4nBLOpCu4wiEx_rLglA3SloFUvVJ1rozPd2ZYDJSvY8Lann
        string clientSecret = '7E77490EF8652CDB1781CE99264FE9D0CFBDCD4A9EF46A7E6DCB252E150184C7'; //479A56A9C07FAEC3A2108A3DC6FA56AAEC5413E8B313C4F8B5DAF8D466AAA42C
        
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
            
            for(Id accId : accIds)
            {
                string endPoint_URL = 'https://vlrcom3-dev-ed.my.salesforce.com/services/apexrest/v1/account/' + accId;   //https://test.salesforce.com
                system.debug('endPoint_URL => ' + endPoint_URL);
                string endpoint = endPointURL;
                
                http h = new http();
                httpRequest request = new httpRequest();
                
                request.setEndpoint(endpoint);
                request.setMethod('GET');
                request.setHeader('Accept', 'application/json');
                request.setHeader('Content-Type','application/json');
                request.setHeader('Authorization','Bearer ' + string.valueOf(respbody.access_token));
                HttpResponse response = h.send(request);
                system.debug('StatusCode => ' + response.getStatusCode());
                
                if(response.getStatusCode() == 200)
                {
                    try
                    {
                        List<AccountRestAPIOutBoundCallWrapper> pParser = new List<AccountRestAPIOutBoundCallWrapper>();
                        string str_response = response.getBody();
                        system.debug('str_response json==' + str_response);
                        
                        pParser  = (list<AccountRestAPIOutBoundCallWrapper>) system.JSON.deserialize(str_response, list<AccountRestAPIOutBoundCallWrapper>.class);
                        
                        
                        
                        msg = pParser[0].message; 
                        // Create Account record from the received response
                        account acc = new account();
                        acc.Name = pParser[0].ac.name;
                        acc.Rating = pParser[0].ac.rating;
                        acc.Rating = pParser[0].ac.industry;
                        acc.Rating = pParser[0].ac.phone;
                        acc.External_Id__c = pParser[0].ac.Id;
                        insert acc;
                        
                        // Create list of contact records from the received response
                        // 
                        if(pParser[0].contactlist != null) 
                        {
                            createContacts(pParser[0].contactlist, string.valueOf(acc.Id));
                        }
                        if(pParser[0].caselist != null) 
                        {
                            createCases(pParser[0].caselist, string.valueOf(acc.Id));
                        }
                    } catch(exception ex) {
                        system.debug('Error => ' + ex.getMessage());
                    }
                }else{
                    system.debug('responseBody => ' + response.getBody());
                }
            }
            
        }
        else{
            //capturing error response.
            system.debug('resp==' + resp);
        }        
        
    }
    
    public static void createContacts(list<AccountRestAPIOutBoundCallWrapper.contactlist> conts, string accId)
    {
        List<contact> con_list = new List<contact>();
        if(!conts.isEmpty() || conts != null)
        {
            for(AccountRestAPIOutBoundCallWrapper.contactlist c : conts)
            {
                contact con = new contact();
                con.LastName = c.name;
                con.Phone = c.phone;
                con.Email = c.email;
                con.AccountId = c.accountId;
                con.External_Id__c = c.Id;
                con_list.add(con);
            }
        }
        if(con_list.size()>0)
        {
            insert con_list;
        }
    }
    
    public static void createCases(list<AccountRestAPIOutBoundCallWrapper.caselist> cases, string accId)
    {
        List<case> case_list = new List<case>();
        if(!cases.isEmpty() || cases != null)
        {
            
            for(AccountRestAPIOutBoundCallWrapper.caselist ca : cases)
            {
                case cas = new case();
                cas.Subject = ca.subject;
                cas.Description = ca.description;
                cas.AccountId = ca.accountId;
                cas.External_Id__c = ca.Id;
                case_list.add(cas);
            }
        }
        if(case_list.size()>0)
        {
            insert case_list;
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