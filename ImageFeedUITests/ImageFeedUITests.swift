import XCTest

final class ImageFeedUITests: XCTestCase {
  let app = XCUIApplication()
  func testAuth() throws {
    app.launch()
    sleep(10)
    app.buttons["Authenticate"].tap()
    sleep(10)
    let webView = app.webViews["UnsplashWebView"]
    sleep(10)
    XCTAssertTrue(webView.waitForExistence(timeout: 5))
    
    let loginTextField = webView.descendants(matching: .textField).element
    XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
    sleep(10)
    loginTextField.tap()
    loginTextField.typeText("omabrirdu@yandex.ru")
    webView.swipeUp()
    sleep(10)
    let passwordTextField = webView.descendants(matching: .secureTextField).element
    XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
    sleep(10)
    passwordTextField.tap()
    passwordTextField.typeText("Abnulator_2002")
    webView.swipeUp()
    sleep(10)
    webView.buttons["Login"].tap()
    sleep(10)
    let tablesQuery = app.tables
    let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
    
    XCTAssertTrue(cell.waitForExistence(timeout: 5))
  }
  
  func testFeed() throws {
    app.launch()
      let tablesQuery = app.tables
      
      let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
      cell.swipeUp()
      
      sleep(10)
      
      let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
      
      cellToLike.buttons["like button"].tap()
      cellToLike.buttons["like button"].tap()
      
      sleep(10)
      
      cellToLike.tap()
      
      sleep(10)
      
      let image = app.scrollViews.images.element(boundBy: 0)
      // Zoom in
      image.pinch(withScale: 3, velocity: 1) // zoom in
      // Zoom out
      image.pinch(withScale: 0.5, velocity: -1)
      
      let navBackButtonWhiteButton = app.buttons["nav back button white"]
      navBackButtonWhiteButton.tap()
  }
  func testProfile() throws {
    app.launch()
      sleep(10)
      app.tabBars.buttons.element(boundBy: 1).tap()
    sleep(10)
      XCTAssertTrue(app.staticTexts["andre nobu"].exists)
      XCTAssertTrue(app.staticTexts["@omabrirdu"].exists)
      
      app.buttons["square.stack.fill'"].tap()
      
      app.alerts["Вы уверены?"].scrollViews.otherElements.buttons["Да"].tap()
    let authButton = app.buttons["Authenticate"]
    XCTAssertTrue(authButton.waitForExistence(timeout: 10))
  }
}
