/*
*************************************************************************
Apex Class Name    : NPSCalloutService
Created Date       : December 2, 2023
@description       : This class is used for processing the orders
					 and then sends it to NPS callout class.
@author            : Mekhala Sengupta
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2023   Mekhala Sengupta                    Initial Version
************************************************************************* 
*/
public with sharing class NPSCalloutService{
/*
*************************************************************************
@Method Name    : sendPostRequestToNPS
@author         : Mekhala Sengupta
@description    : This method is used to send order
				  details to NPS service.
@param          : Map of Order Details
@return         : Void
*************************************************************************
*/
    public static void sendPostRequestToNPS(Map<Id,Order> orderDetails) 
    	{
			//Variables for enabling conditions where it takes only 30 records and sends to NPS for survey mails to be triggered
        	Integer count=1;//Variable that keeps a check maximum on number of records 
            Integer size=1; //Variable to check if the loop has iterated till the end of Map
            List<Order> orderDet = new List<Order>();
            //The below iteration ensures that only 30 order detail records are sent to the NPS callout
        	for(Id orderID : orderDetails.keySet())
        	{
                if(count < 30 && count<(orderDetails.size()))
            	{
                	orderDet.add(orderDetails.get(orderID));
                	count+=1;
                    if(size == orderDetails.size()) //This checks if the last order record is added to list
                    {
                        callNPScallout(orderDet); //Then calls the NPS callout method
                        break;
                    }
            	}
                
                else
            	{
                    //Stores the Last Order ID in the list
                    orderDet.add(orderDetails.get(orderID));
					//Sends HTTP request to NPS
					callNPScallout(orderDet);
                    //Checks if the order count is 30
                    if(count == 30)
                    {
                    	orderDet = new List<Order>();
                    	count = 1;
                    }
            	}
                size+=1;
        	}
    	}
 /*
************************************************************
@Method Name    : callNPScallout
@author         : Mekhala Sengupta
@description    : This method is used to convert orders
				  to String and then sends order details to 
				  NPS service.
@param          : List of Order Details
@return         : Void
************************************************************
*/
    public static void callNPScallout(List<Order> orderDet)
    	{
        	String orderDet2; 
        	for(Order o : orderDet)
        	{
            	orderDet2 += convertOrderToJSON(o);//Calls method to convert order to String
        	}
            if(!Test.isRunningTest())
            {
        		makeNPSCallout.calloutNPS(orderDet2);//Sends NPS callout
            }
    	}
/*
************************************************************
@Method Name    : convertOrderToJSON
@author         : Mekhala Sengupta
@description    : This method is used to convert orders
				  to String.
@param          : Order record.
@return         : Void
************************************************************
*/
    public static String convertOrderToJSON(Order orders)
    	{
        	return JSON.serialize(orders);//Converts order to String        
    	}
}