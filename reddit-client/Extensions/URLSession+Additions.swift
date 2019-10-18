//
//  URLSession+Additions.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/17/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

extension URLSession {

    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }

}
