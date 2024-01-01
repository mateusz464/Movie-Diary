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
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                if viewModel.trending.isEmpty {
                    Text("No results")
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.trending) {trendingMovie in
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

struct TrendingCard: View {
    let trendingMovies: TrendingMovies
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: trendingMovies.backdropUrl) {
                image in image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 200)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Text(trendingMovies.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .frame(width: 300)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "hand.thumbsup.fill")
                    Text(String(format: "%.2f", trendingMovies.vote_average))
                    Spacer()
                }.foregroundColor(.yellow)
            }
            .padding(12)
            .background(Color(red: 0.341, green: 0.38, blue: 0.49))
        }
        .cornerRadius(10)
    }
}

struct TrendingResults: Decodable {
    let page: Int
    let results: [TrendingMovies]
    let total_pages: Int
    let total_results: Int
}

struct TrendingMovies: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let poster_path: String
    let title: String
    let vote_average: Float
    let backdrop_path: String
    
    var backdropUrl: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: backdrop_path)
    }
}

#Preview {
    ContentView()
}
