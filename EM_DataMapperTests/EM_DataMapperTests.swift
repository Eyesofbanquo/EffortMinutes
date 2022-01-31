//
//  EM_DataMapperTests.swift
//  EM_DataMapperTests
//
//  Created by Markim Shaw on 1/30/22.
//

import XCTest
@testable import EM_DataMapper
import EffortModel
import RealmSwift

class EM_DataMapperTests: XCTestCase {
  
  var realm: Realm!
  var sut: DataMapper!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    let config = Realm.Configuration(inMemoryIdentifier: "Blah")
    realm = try! Realm.init(configuration: config)
    sut = DataMapper(realm: realm)
  }
  
  override func tearDownWithError() throws {
    
    realm = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func testAddingNewCategory() {
    let newCategory = EMCategory(name: "Reading", effortMinutes: 0)
    try? sut.addCategory(newCategory)
    
    let categories = realm.objects(EMCategoryRO.self)
    let incrementer = realm.objects(IncrementerRO.self).first
    
    XCTAssertNotNil(incrementer)
    XCTAssertEqual(categories.count, 1)
  }
  
  func testIncrementer() {
    let incrementer = realm.objects(IncrementerRO.self).first
    
    XCTAssertEqual(incrementer?.currentIncrement, 0)

    let newCategory = EMCategory(name: "Reading", effortMinutes: 0)
    try? sut.addCategory(newCategory)
    
    XCTAssertEqual(incrementer?.currentIncrement, 1)
    
    let newCategorys = EMCategory(name: "Readings", effortMinutes: 0)
    try? sut.addCategory(newCategorys)
    
    XCTAssertEqual(incrementer?.currentIncrement, 2)
  }
  
}
