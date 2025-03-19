//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Артем Солодовников on 19.03.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }

    enum testData {
        static let login: String = "test@test.ru"       // почта тестового пользователя
        static let password: String = "password"        // пароль тестового пользователя
        static let name: String = "Артем"     // Имя, nickname и описание из профиля
        static let nickname: String = "@nickname"       // у логина пользователя первым символом идет @
        static let description: String = "Ура! Финиш!"
    }
    
    func testAuth() throws {
        // Нажать кнопку авторизации
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 3))
        authButton.tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "webview не загрузился")
        
        // Ввести данные в форму
        //заполнение логина
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        loginTextField.tap()
        for character in testData.login {
            loginTextField.typeText(String(character))
        }
        
        //заполнение пароля
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        sleep(1)
        webView.swipeUp()
        
        UIPasteboard.general.string = testData.password

        passwordTextField.press(forDuration: 1.5)
        XCTAssertTrue(app.menuItems["Paste"].waitForExistence(timeout: 5))
        app.menuItems["Paste"].tap()

        // Нажать кнопку логина
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        loginButton.tap()
        
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 7))
    }
    
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        
        //получили первую ячейку таблицы
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        // Поставить лайк в ячейке верхней картинки
        let likeButton = firstCell.buttons["likeButton"]
        XCTAssertTrue(likeButton.exists)
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 2))
        
        // Отменить лайк в ячейке верхней картинки
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 2))
        
        // Нажать на верхнюю ячейку
        firstCell.tap()
        
        // Подождать, пока картинка открывается на весь экран
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 3))
        
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
        XCTAssertTrue(image.waitForExistence(timeout: 1))
        
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        XCTAssertTrue(image.waitForExistence(timeout: 1))
        
        // Вернуться на экран ленты
        let backButton = app.buttons["backButton"]
        backButton.tap()
        
        // Сделать жест «смахивания» вверх по экрану для его скролла
        tablesQuery.element.swipeUp()
        XCTAssertTrue(app.tables.element.waitForExistence(timeout: 3))
        tablesQuery.element.swipeDown()
        XCTAssertTrue(app.tables.element.waitForExistence(timeout: 3))

    }
    
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        // Перейти на экран профиля
        let profileTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileTab.exists)
        profileTab.tap()
        
        // Проверить, что на нём отображаются ваши персональные данные
        let nameLabel = app.staticTexts[testData.name]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 3))
                
        let loginLabel = app.staticTexts[testData.nickname]
        XCTAssertTrue(loginLabel.waitForExistence(timeout: 3))
                
        let descriptionLabel = app.staticTexts[testData.description]
        XCTAssertTrue(descriptionLabel.waitForExistence(timeout: 3))
        
        // Нажать кнопку логаута
        let logoutButton = app.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists)
        logoutButton.tap()
        
        // Проверить, что открылся экран авторизации
        let logoutAlert = app.alerts["Пока, пока!"]
        XCTAssertTrue(logoutAlert.waitForExistence(timeout: 3))
        
        let yesButton = logoutAlert.buttons["Да"]
        XCTAssertTrue(yesButton.exists)
        yesButton.tap()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }
}
