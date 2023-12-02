/*
**************************************************************************
Apex Class Name    : MockHttpResponseGenerator
Created Date       : December 2, 2023
@description       : This is a test class to mock an HTTP Response. 
@author            : Mekhala Sengupta
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2023   Mekhala Sengupta                    Initial Version
**************************************************************************
*/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
/*
*********************************************************
@Method Name    : setupTestData
@author         : Mekhala Sengupta
@description    : This test method is used to create a
				  mock Https request and receive a mock
				  response from the external api for NPS.
@param          : HTTPResponse
@return         : HTTPRequest
********************************************************
*/
    global HTTPResponse respond(HTTPRequest req) {
        // Only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('callout:NPSCalloutEndpointAPI/orders', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"sfId":"8015E000003LfJXQA0","orderNumber":"007","customerEmail":"customerAddresses@example.com"}');
        res.setStatusCode(200);
        return res;
    }
}