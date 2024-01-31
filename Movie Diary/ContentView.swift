//
//  ContentView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 22/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MovieDiaryViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Trending Movies")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)

                ScrollView {
                    if viewModel.trending.isEmpty {
                        Text("No results")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.trending) { trendingMovie in
                                    TrendingCard(trendingMovies: trendingMovie)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onAppear {
                    viewModel.loadTrending()
                }
            }
        }
    }
}

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

#Preview {
    ContentView()
}
