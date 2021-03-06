//
// Coronalert
//
// Devside and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import XCTest

class BEENAUITests: XCTestCase {
	var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		setupSnapshot(app)
		app.setDefaults()
		app.launchArguments.append(contentsOf: ["-isOnboarded", "YES"])
	}

	func testGetKeyWithoutSymptoms() throws {
		app.launch()

		// only run if home screen is present
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))

		app.swipeUp()
		
		XCTAssertTrue(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: 5.0))
		app.buttons["AppStrings.Home.submitCardButton"].tap()
		// todo: need accessibility for Next
		XCTAssertTrue(app.buttons["AppStrings.ExposureSubmission.continueText"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_001")
		app.buttons["AppStrings.ExposureSubmission.continueText"].tap()
		XCTAssertTrue(app.alerts.firstMatch.exists)
		snapshot("ScreenShot_\(#function)_002")

		// tap NO
		app.alerts.buttons.element(boundBy: 1).tap()

		XCTAssertTrue(app.buttons["BEAppStrings.BEMobileTestId.save"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_003")

		app.buttons["BEAppStrings.BEMobileTestId.save"].tap()

		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_004")
	}
	
	func testGetKeyWithSymptoms() throws {
		app.launch()

		// only run if home screen is present
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))
		app.swipeUp()
		
		XCTAssertTrue(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: 5.0))
		app.buttons["AppStrings.Home.submitCardButton"].tap()
		// todo: need accessibility for Next
		XCTAssertTrue(app.buttons["AppStrings.ExposureSubmission.continueText"].waitForExistence(timeout: 5.0))
		app.buttons["AppStrings.ExposureSubmission.continueText"].tap()
		XCTAssertTrue(app.alerts.firstMatch.exists)
		
		// tap YES
		app.alerts.buttons.firstMatch.tap()

		XCTAssertTrue(app.buttons["BEAppStrings.BESelectSymptomsDate.next"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_001")
		app.buttons["BEAppStrings.BESelectSymptomsDate.next"].tap()
		XCTAssertTrue(app.buttons["BEAppStrings.BEMobileTestId.save"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_002")

		app.buttons["BEAppStrings.BEMobileTestId.save"].tap()

		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))
		app.swipeUp()

		let text = app.localized(AppStrings.Home.resultCardPendingDesc)
		
		XCTAssert(app.labelContains(text: text))		
	}
	
	func testSelectCountry() throws {
		app.launchArguments.append(contentsOf: ["-positiveResult", "YES"])
		app.launchArguments.append(contentsOf:[UITestingParameters.ExposureSubmission.useMock.rawValue])
		app.launch()

		XCTAssertTrue(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_001")
		app.swipeUp()
		app.buttons["AppStrings.Home.submitCardButton"].tap()

		XCTAssertTrue(app.buttons["BEAppStrings.BETestResult.next"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_002")
		app.buttons["BEAppStrings.BETestResult.next"].tap()

		XCTAssertTrue(app.buttons["BEAppStrings.BEWarnOthers.next"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_003")
		app.buttons["BEAppStrings.BEWarnOthers.next"].tap()

		XCTAssertTrue(app.buttons["BEAppStrings.BESelectKeyCountries.shareIds"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_004")

		app.tables.cells.element(boundBy: 0).tap()
		sleep(1)
		snapshot("ScreenShot_\(#function)_005")
		app.tables.cells.element(boundBy: 0).tap()
		sleep(1)
		snapshot("ScreenShot_\(#function)_006")
	}
	
	func testIncreasedRisk() throws {
		app.launchArguments.append(contentsOf: ["-isAtRisk", "YES"])
		app.launch()

		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))
		XCTAssertTrue(app.buttons["RiskLevelCollectionViewCell.topContainer"].waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_001")
		app.buttons["RiskLevelCollectionViewCell.topContainer"].tap()
		XCTAssertTrue(app.navigationBars.buttons.element(boundBy: 0).waitForExistence(timeout: 5.0))
		snapshot("ScreenShot_\(#function)_002")
		app.swipeUp()
		snapshot("ScreenShot_\(#function)_003")
	}

}
