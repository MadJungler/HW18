//
//  APIService.swift
//  HW15
//
//  Created by Павел on 28.02.2023.
//

import Foundation

enum APIServise {
    private static let apiURL = "https://imdb-api.com"
    private static let apiPath = "/API/Search/"
    private static let apiKey = "k_359n223k"
    
    static func getData(bySearch string: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let url = URL(string: apiURL + apiPath + apiKey + "/" + string) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json["results"] as? [[String: Any]] ?? [] ))
            }
        })
        task.resume()
    }
}
