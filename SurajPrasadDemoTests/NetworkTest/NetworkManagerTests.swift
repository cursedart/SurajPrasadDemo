//
//  NetworkManagerTests.swift
//  SurajPrasadDemoTests
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import XCTest
import Combine
@testable import SurajPrasadDemo

struct MockResponse: Decodable {
    let name: String
    let price: Int
}


final class NetworkManagerTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        cancellables = []

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        networkManager = NetworkManager(session: session)
    }

    override func tearDown() {
        cancellables = nil
        networkManager = nil
        super.tearDown()
    }

    func test_getData_success_returnsDecodedResponse() {
        // GIVEN
        let json = """
        {
            "name": "Apple",
            "price": 150
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockData = json
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com/mock")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.mockError = nil

        let expectation = expectation(description: "Success response")

        // WHEN
        networkManager.getData(endpoint: .portfolio, type: MockResponse.self)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Expected success")
                }
            } receiveValue: { response in
                XCTAssertEqual(response.name, "Apple")
                XCTAssertEqual(response.price, 150)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // THEN
        wait(for: [expectation], timeout: 1.0)
    }
}
