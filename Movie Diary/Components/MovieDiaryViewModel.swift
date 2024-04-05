//
//  MovieDiaryViewModel.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 31/01/2024.
//

import Foundation
import SwiftUI

@MainActor
class MovieDiaryViewModel: ObservableObject {
    @Published var trending: [Movie] = []
    @Published var searchResults: [Movie] = []
    
    func loadTrending() {
        Task {
            guard let url = URL(string: "\(TMDB_API)/3/trending/movie/week?language=en-US") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                }
                
                let trendingResponse = try JSONDecoder().decode(MovieResults.self, from: data)
                
                trending = trendingResponse.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func search(query: String) {
        Task {
            var components = URLComponents(string: "\(TMDB_API)/3/search/movie")

            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)

            components?.queryItems = [
                URLQueryItem(name: "query", value: encodedQuery),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1")
            ]
                    
            guard let url = components?.url else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                }
                
                let searchResponse = try JSONDecoder().decode(MovieResults.self, from: data)
                
                searchResults = searchResponse.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
