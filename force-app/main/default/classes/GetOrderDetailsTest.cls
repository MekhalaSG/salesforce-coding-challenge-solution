/*
**************************************************************************
Apex Class Name    : GetOrderDetailsTest
Created Date       : December 2, 2023
@description       : This is a test class of GetOrderDetails
					 class. It has unit test methods that ensure 
					 proper functioning of methods defined in 
					 GetOrderDetails and ensures code coverage
					 above 80%. 
@author            : Mekhala Sengupta
Modification Log:
Ver   Date         Author                               Modification
1.0   02-12-2023   Mekhala Sengupta                    Initial Version
**************************************************************************
*/
@isTest
public with sharing class GetOrderDetailsTest{
/*
*********************************************************
@Method Name    : setupTestData
@author         : Mekhala Sengupta
@description    : This test method is used to setup 
				  test data required for unit tests.				  
@param          : Void
@return         : Void
********************************************************
*/
    @TestSetup
    public static void setupTestData()
    {
        //TODO - To setup Object Factory class that creates data for Account, Contact, Contract and Orders
        //Creating test data - Account, Contact, Contract and Orders
        Account a = new Account(Name='Test Account for Thermondo');
        insert a;//Creates Account
        Contact conTest = new Contact(FirstName='John', LastName='Doe', AccountId=a.Id);
        insert conTest;//Creates Contact
        Contract c = new Contract(Status='Draft', StartDate=System.TODAY(),ContractTerm=24,AccountId=a.Id);
        insert c;//Creates Contract
        c.Status='Activated';//Activates the Contract created
        update c;
        Order o;
        List<Order> orderTestList = new List<Order>();
        for(Integer i=0; i < 35 ; i++)
        {
            o = new Order(ContractId=c.Id, AccountId = a.Id, EffectiveDate=System.TODAY()+i, Status='Draft',BillToContactId = conTest.Id);
            orderTestList.add(o);
        }
        insert orderTestList;//Creates List of Orders for the account created above
    }
/*
*********************************************************
@Method Name    : updateOrders
@author         : Mekhala Sengupta
@description    : This test method is used to update
				  order status to 'Fulfilled'.It ensures
				  code coverage for GetOrderDetails class.
@param          : Void
@return         : Void
********************************************************
*/
    @isTest
    static void updateOrders()
    {
        //Fetches Account and orders created in Test setup method : setupTestData()
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account for Thermondo'];
        List<Order> orderTestList = [SELECT Id, Status FROM Order WHERE AccountId =: acc.Id];
        List<Id> orderIdsToUpdate = new List<Id> ();
        List<List<Id>> ListOfListOfIds = new List<List<Id>>();
        List<List<Order>> ListOfListOfReturnOrders = new List<List<Order>>();
        for(Order ord:orderTestList)
        {
            ord.status = 'Fulfilled';//Updates all order status to Fulfilled
            orderIdsToUpdate.add(ord.Id);
            ListOfListOfIds.add(orderIdsToUpdate);
        }
        Test.startTest();
        ListOfListOfReturnOrders = GetOrderDetails.getOrderInformation(ListOfListOfIds);//For test coverage of GetOrderDetails class
        Test.stopTest();
        Assert.areNotEqual(0,ListOfListOfReturnOrders.size(),'Size of orders returned should not be 0');//Checks if the order records are returned 
    }
/*
**********************************************************************
@Method Name    : testNPSCalloutService
@author         : Mekhala Sengupta
@description    : This test method is used to call the
				  NPS service with 30 order records at a time.
				  It ensures code coverage for NPSCalloutService class.
@param          : Void
@return         : Void
**********************************************************************
*/
    @isTest
    static void testNPSCalloutService()
    {
        //Fetches Account and orders created in Test setup method : setupTestData()
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account for Thermondo'];
        List<Order> testOrderDetails = [SELECT Id, BillToContact.email, OrderNumber FROM Order WHERE AccountId =: acc.Id];
        //Creates a Map for the test
        Map<Id,Order> orderDetailsMap = new Map<Id,Order>();
        for(Order o : testOrderDetails)
        {	
        	orderDetailsMap.put(o.Id,o);
        }
        Test.startTest();
        NPSCalloutService.sendPostRequestToNPS(orderDetailsMap);//For test coverage of NPSCalloutService class
        Test.stopTest();
        Assert.areNotEqual(0,orderDetailsMap.size(),'Size of Order details Map should not be 0');//Checks if the map size is not zero
    }
/*
**********************************************************************
@Method Name    : testNPSCallout
@author         : Mekhala Sengupta
@description    : This test method is used to set up a mock HTTP
				  request for code coverage of NPSCalloutService class.
@param          : Void
@return         : Void
**********************************************************************
*/
    @isTest
    static void testNPSCallout()
    {
        //Fetches Account and order details from Test setup
        Account accnt = [SELECT Id FROM Account WHERE Name = 'Test Account for Thermondo'];
        Order o = [SELECT Id, BillToContact.email, OrderNumber FROM Order WHERE AccountId =: accnt.Id LIMIT 1];
        //Converts Order details to JSON String format
        String order = NPSCalloutService.convertOrderToJSON(o);
		//Sets mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        makeNPSCallout.calloutNPS(order);//For test coverage of makeNPSCallout class
        Test.stopTest();
        //TODO - To cover error handling in Test class
    }
}