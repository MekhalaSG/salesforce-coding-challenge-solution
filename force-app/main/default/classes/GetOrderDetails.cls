/*
*************************************************************************
Apex Class Name    : GetOrderDetails
Created Date       : December 2, 2023
@description       : This class is used as Apex invocation
					 from flow 'Order - After Update' for 
					 fetching the Order details which have a
					 status of 'Fulfilled'. Then it sends it
					 to the NPS server for storing the data and 
					 sending customer surveys via email.
@author            : Mekhala Sengupta
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2023   Mekhala Sengupta                    Initial Version
************************************************************************* 
*/
public with sharing class GetOrderDetails {
/*
*********************************************************
@Method Name    : getOrderInformation
@author         : Mekhala Sengupta
@description    : This method is used to fetch order
				  information and send to NPS service.
@param          : Collection of Order Ids
@return         : Collection of Orders
********************************************************
*/
    @InvocableMethod(label='Get Order Details' description='Get Order information - Contact email and Order number')
    public static List<List<Order>> getOrderInformation(List<List<Id>> orderids)
    {
        //Get Order Id list from Flow collection variable
        List<Id> oids = new List<Id> ();
        List<Id> temp = new List<Id> ();
        //Storing Ids from List<List<Id>> to List<Id> variable for further processing
        for(Integer i=0; i<orderids.size() ;i++)
        {
			temp = orderids.get(i);
        	oids.add(temp.get(0)); 
        }
        List<Order> returnMessage = new List<Order> ();
		//Query to retrieve Contact email and Order number from Orders for the above ids in 'oids'
        List<Order> orderDetails = [SELECT Id, BillToContact.email, OrderNumber FROM Order WHERE Id in :oids ];
        //Map of Id and Order details for API call
        Map<Id,Order> orderDet = new Map<Id,Order>();
        //Return varibale List<List<Order>> declaration for successful flow execution
        List<List<Order>> returnMesg = new List<List<Order>>();
        //Adding Order details from SOQL query for further processing
        for(Order o : orderDetails)
        {	
        	orderDet.put(o.Id,o);
            returnMessage.add(o);
            returnMesg.add(returnMessage);
        }
        //Calling NPSCalloutService to send the order details to NPS server
        NPSCalloutService.sendPostRequestToNPS(orderDet);
        //return List of response/error messages
        return returnMesg;
    }

}