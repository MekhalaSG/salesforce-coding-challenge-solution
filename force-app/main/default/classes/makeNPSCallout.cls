/*
*************************************************************************
Apex Class Name    : makeNPSCallout
Created Date       : December 2, 2023
@description       : This class is used to make callout to
					 NPS server. It creates and sends the
					 http request to external endpoint as 
					 provided for Thermondo Tech Challenge.
@author            : Mekhala Sengupta
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2023   Mekhala Sengupta                    Initial Version
************************************************************************* 
*/
public class makeNPSCallout{
/*
***********************************************************
@Method Name    : calloutNPS
@author         : Mekhala Sengupta
@description    : This future method runs asynchronously
				  to send the orders in JSON format to
				  NPS service.
@param          : String of Order Details
@return         : Void
***********************************************************
*/
    @future(callout=true)
    public static void calloutNPS(String orderDet2) { 
        String errorDetails;
    	//Creating Http Request
        HttpRequest request = new HttpRequest();
        //Using named credential and external credential for setting Basic authenication header
        request.setEndpoint('callout:NPSCalloutEndpointAPI/orders');
		request.setMethod('POST');
        //Creating Http request
        Http http = new Http();
        //Adding Orders to request payload
        request.setBody(orderDet2);
        try
          {
        	HttpResponse response = http.send(request);
            //Processing response and checking response code
			switch on response.getStatusCode() 
            {
    			when 200 {		
        			errorDetails = 'SUCCESS';
    				}	
    			when 400 {		
        			errorDetails = 'BAD PAYLOAD';
    				}
    			when 500 {		
        			errorDetails = 'SERVER ERROR';
    				}
    			when else {		  
        			errorDetails = 'RESOURCE NOT FOUND';
    				}
			}
            } catch(System.CalloutException e)
            {
                errorDetails += e;
            }
        	System.debug(errorDetails);
        	//TODO - Handle Http response error handling - create a platform event for returning error message back to flow for admins to handle it.
    }
}