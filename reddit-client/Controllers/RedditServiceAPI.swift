//
//  RedditServiceAPI.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/17/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

public enum ServiceAPIError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

public enum Endpoint: String, CustomStringConvertible, CaseIterable {
    public var description: String {
        return self.rawValue
    }
    case top = "top.json"
}

class RedditServiceAPI {

    public static let shared = RedditServiceAPI()

    private init() {}

    let baseURL = URL(string: "https://www.reddit.com/")!

    private let urlSession = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    // MARK: - Public Methods

    func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, ServiceAPIError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.jsonDecoder.dateDecodingStrategy = .secondsSince1970
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }

}
