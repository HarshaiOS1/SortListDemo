//
//  HexadDemoAssignmentTests.swift
//  HexadDemoAssignmentTests
//
//  Created by Harsha on 04/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import XCTest
@testable import HexadDemoAssignment
var viewContoller :ViewController?
class HexadDemoAssignmentTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        viewContoller = storyBoard.instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController
        viewContoller?.loadView()
        XCTAssertNotNil(viewContoller, "ViewContoller has failed to create instance")
        
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: viewContoller!)
        _ = viewContoller?.view
    }
    
    func testDropDownTable() {
        XCTAssertFalse(viewContoller?.isExpand ?? false, "Dropdown minimised initially")
        viewContoller?.dropDownButton.sendActions(for: .allTouchEvents)
        XCTAssertTrue(viewContoller?.isExpand ?? false, "Dropdown Button is tapped and expanded")
        viewContoller?.dropDownButton.sendActions(for: .allTouchEvents)
        XCTAssertFalse(viewContoller?.isExpand ?? false, "Dropdown Button is tapped Again and collapse")
    }
    
    
    func testDropDownselected() {
        viewContoller?.dropDownButton.sendActions(for: .allTouchEvents)
        viewContoller?.tableView(viewContoller?.tableView ?? UITableView(), didSelectRowAt: IndexPath.init(row: 1, section: 0))
        XCTAssertTrue((viewContoller?.currentlySelectedFilter == 1), "Currently Selected Filter is Z to A")
    }
    
    func testRandomRatingUpdate() {
        //initial Value
        viewContoller?.getListData()
        let value1 = viewContoller?.viewModel.model?.itemlist?.first?.rating
        
        viewContoller?.viewModel.generateRandomRating()
        
        let value2 = viewContoller?.viewModel.model?.itemlist?.first?.rating
        XCTAssertNotEqual(value1, value2)
    }
    
    func testFilterDropdownForNamingOrder() {
        viewContoller?.getListData()
        //Get initial Value
        let initVal = viewContoller?.viewModel.model?.itemlist?.first?.name
        viewContoller?.viewModel.filterData(dropDownRow: 0)
        
        let val2 = viewContoller?.viewModel.model?.itemlist?.first?.name
        XCTAssertNotEqual(initVal, val2)
        XCTAssertTrue(val2?.first == "A")
        
        viewContoller?.viewModel.filterData(dropDownRow: 1)
        let val3 = viewContoller?.viewModel.model?.itemlist?.first?.name
        XCTAssertNotEqual(initVal, val3)
        XCTAssertTrue(val3?.first != "A")
    }
    
    func testFilterDropDownForRatingOrder() {
        viewContoller?.getListData()
        viewContoller?.viewModel.generateRandomRating()
        
        viewContoller?.viewModel.filterData(dropDownRow: 2)
        
        XCTAssertTrue(((viewContoller?.viewModel.model?.itemlist?.first?.rating ?? 0.0) < (viewContoller?.viewModel.model?.itemlist?.last?.rating ?? 0.0)))
        
        viewContoller?.viewModel.filterData(dropDownRow: 3)
        
        XCTAssertTrue(((viewContoller?.viewModel.model?.itemlist?.first?.rating ?? 0.0) > (viewContoller?.viewModel.model?.itemlist?.last?.rating ?? 0.0)))
    }
    
    func testJSONResponseAsyncTest() {
        let expectation = self.expectation(description: "test json")
        var result: Bool?
        XCTAssertNil(viewContoller?.viewModel.model)
        viewContoller?.viewModel.getListData(completion: { (isSuccess, responseCode, message) in
            result = isSuccess
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10)
        
        XCTAssertNotNil(viewContoller?.viewModel.model)
        XCTAssertTrue(result ?? false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
