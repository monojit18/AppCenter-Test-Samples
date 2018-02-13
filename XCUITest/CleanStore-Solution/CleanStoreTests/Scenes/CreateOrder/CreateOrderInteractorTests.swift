//
//  CreateOrderInteractorTests.swift
//  CleanStore
//
//  Created by Raymond Law on 09/07/15.
//  Copyright (c) 2015 Raymond Law. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CleanStore
import UIKit
import XCTest

class CreateOrderInteractorTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: CreateOrderInteractor!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupCreateOrderInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupCreateOrderInteractor()
  {
    sut = CreateOrderInteractor()
  }
  
  // MARK: - Test doubles
  
  class CreateOrderPresentationLogicSpy: CreateOrderPresentationLogic
  {
    // MARK: Method call expectations
    
    var presentExpirationDateCalled = false
    var presentCreatedOrderCalled = false
    var presentOrderToEditCalled = false
    var presentUpdatedOrderCalled = false
    
    // MARK: Spied methods
    
    func presentExpirationDate(response: CreateOrder.FormatExpirationDate.Response)
    {
      presentExpirationDateCalled = true
    }
    
    func presentCreatedOrder(response: CreateOrder.CreateOrder.Response)
    {
      presentCreatedOrderCalled = true
    }
    
    func presentOrderToEdit(response: CreateOrder.EditOrder.Response) {
      presentOrderToEditCalled = true
    }
    
    func presentUpdatedOrder(response: CreateOrder.UpdateOrder.Response)
    {
      presentUpdatedOrderCalled = true
    }
  }
  
  class OrdersWorkerSpy: OrdersWorker
  {
    // MARK: Method call expectations
    
    var createOrderCalled = false
    var updateOrderCalled = false
    
    // MARK: Spied methods
    
    override func createOrder(orderToCreate: Order, completionHandler: @escaping (Order?) -> Void)
    {
      createOrderCalled = true
      completionHandler(Seeds.Orders.amy)
    }
    
    override func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order?) -> Void)
    {
      updateOrderCalled = true
      completionHandler(Seeds.Orders.amy)
    }
  }
  
  // MARK: - Test expiration date
  
  func testFormatExpirationDateShouldAskPresenterToFormatExpirationDate()
  {
    // Given
    let createOrderPresentationLogicSpy = CreateOrderPresentationLogicSpy()
    sut.presenter = createOrderPresentationLogicSpy
    let request = CreateOrder.FormatExpirationDate.Request(date: Date())
    
    // When
    sut.formatExpirationDate(request: request)
    
    // Then
    XCTAssert(createOrderPresentationLogicSpy.presentExpirationDateCalled, "Formatting an expiration date should ask presenter to do it")
  }
  
  // MARK: - Test shipping methods
  
  func testShippingMethodsShouldReturnAllAvailableShippingMethods()
  {
    // Given
    let allAvailableShippingMethods = [
      "Standard Shipping",
      "One-Day Shipping",
      "Two-Day Shipping"
    ]
    
    // When
    let returnedShippingMethods = sut.shippingMethods
    
    // Then
    XCTAssertEqual(returnedShippingMethods, allAvailableShippingMethods, "Shipping Methods should list all available shipping methods")
  }
  
  // MARK: - Test creating a new order
  
  func testCreateOrderShouldAskOrdersWorkerToCreateTheNewOrderAndPresenterToFormatIt()
  {
    // Given
    let createOrderPresentationLogicSpy = CreateOrderPresentationLogicSpy()
    sut.presenter = createOrderPresentationLogicSpy
    let ordersWorkerSpy = OrdersWorkerSpy(ordersStore: OrdersMemStore())
    sut.ordersWorker = ordersWorkerSpy
    
    // When
    let request = CreateOrder.CreateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: "", lastName: "", phone: "", email: "", billingAddressStreet1: "", billingAddressStreet2: "", billingAddressCity: "", billingAddressState: "", billingAddressZIP: "", paymentMethodCreditCardNumber: "", paymentMethodCVV: "", paymentMethodExpirationDate: Date(), paymentMethodExpirationDateString: "", shipmentAddressStreet1: "", shipmentAddressStreet2: "", shipmentAddressCity: "", shipmentAddressState: "", shipmentAddressZIP: "", shipmentMethodSpeed: 0, shipmentMethodSpeedString: "", id: "some id", date: Date(), total: NSDecimalNumber(string: "9.99")))
    sut.createOrder(request: request)
    
    // Then
    XCTAssert(ordersWorkerSpy.createOrderCalled, "CreateOrder() should ask OrdersWorker to create the new order")
    XCTAssert(createOrderPresentationLogicSpy.presentCreatedOrderCalled, "CreateOrder() should ask presenter to format the newly created order")
  }
  
  // MARK: - Test editing an order
  
  func testShowOrderToEditShouldAskPresenterToFormatTheExistingOrder()
  {
    // Given
    let createOrderPresentationLogicSpy = CreateOrderPresentationLogicSpy()
    sut.presenter = createOrderPresentationLogicSpy
    
    sut.orderToEdit = Seeds.Orders.amy
    
    let request = CreateOrder.EditOrder.Request()
    
    // When
    sut.showOrderToEdit(request: request)
    
    // Then
    XCTAssert(createOrderPresentationLogicSpy.presentOrderToEditCalled, "ShowOrderToEdit() should ask presenter to format the existing order")
  }
  
  func testShowOrderToEditShouldNotAskPresenterToFormatIfThereIsNoExistingOrder()
  {
    // Given
    let createOrderPresentationLogicSpy = CreateOrderPresentationLogicSpy()
    sut.presenter = createOrderPresentationLogicSpy
    
    sut.orderToEdit = nil
    
    let request = CreateOrder.EditOrder.Request()
    
    // When
    sut.showOrderToEdit(request: request)
    
    // Then
    XCTAssertFalse(createOrderPresentationLogicSpy.presentOrderToEditCalled, "ShowOrderToEdit() should not ask presenter to format if there is no existing order")
  }
  
  func testUpdateOrderShouldAskOrdersWorkerToUpdateTheExistingOrderAndPresenterToFormatIt()
  {
    // Given
    let createOrderPresentationLogicSpy = CreateOrderPresentationLogicSpy()
    sut.presenter = createOrderPresentationLogicSpy
    let ordersWorkerSpy = OrdersWorkerSpy(ordersStore: OrdersMemStore())
    sut.ordersWorker = ordersWorkerSpy
    
    // When
    let request = CreateOrder.UpdateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: "", lastName: "", phone: "", email: "", billingAddressStreet1: "", billingAddressStreet2: "", billingAddressCity: "", billingAddressState: "", billingAddressZIP: "", paymentMethodCreditCardNumber: "", paymentMethodCVV: "", paymentMethodExpirationDate: Date(), paymentMethodExpirationDateString: "", shipmentAddressStreet1: "", shipmentAddressStreet2: "", shipmentAddressCity: "", shipmentAddressState: "", shipmentAddressZIP: "", shipmentMethodSpeed: 0, shipmentMethodSpeedString: "", id: "some id", date: Date(), total: NSDecimalNumber(string: "9.99")))
    sut.updateOrder(request: request)
    
    // Then
    XCTAssert(ordersWorkerSpy.updateOrderCalled, "UpdateOrder() should ask OrdersWorker to update the existing order")
    XCTAssert(createOrderPresentationLogicSpy.presentUpdatedOrderCalled, "UpdateOrder() should ask presenter to format the updated order")
  }
}
