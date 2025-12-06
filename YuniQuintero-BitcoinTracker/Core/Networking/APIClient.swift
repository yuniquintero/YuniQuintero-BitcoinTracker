//
//  APIClient.swift
//  YuniQuintero-BitcoinTracker
//
//  Created by Yuni Quintero on 5/12/25.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(url: URL, params: [String: String]) async throws -> T
}

struct APIClient: APIClientProtocol {
    func get<T: Decodable>(url: URL, params: [String: String]) async throws -> T {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value)}

        guard let requestURL = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("CG-GqKt4zohw1h46q6mFvcxEv5n", forHTTPHeaderField: "x-cg-demo-api-ke")

        let(data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
