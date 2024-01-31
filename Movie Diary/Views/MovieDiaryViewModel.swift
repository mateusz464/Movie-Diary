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
    @Published var trending: [TrendingMovies] = []
    static let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"]
    
    func loadTrending() {
        Task {
            guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?language=en-US") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(MovieDiaryViewModel.apiKey!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                }
                
                let trendingResponse = try JSONDecoder().decode(TrendingResults.self, from: data)
                
                trending = trendingResponse.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
