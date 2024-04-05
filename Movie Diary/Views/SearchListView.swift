//
//  SearchListView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 05/04/2024.
//

import SwiftUI

struct SearchListView: View {
    let apiCallType: APICallType
    @State private var selectedSort: SortOption = .highestRating
    @State private var movies: [Movie] = []
    
    var title: String {
            switch apiCallType {
            case .popular:
                return "Popular Movies"
            case .topRated:
                return "Top Rated Movies"
            case .upcoming:
                return "Upcoming Movies"
            }
        }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding([.horizontal, .top])
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: SearchMovieDetails(movieId: Int(movie.id))) {
                            ListMovieCard(movie: movie)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
                        }
                    }
                }
            }
        }
        .padding(.vertical, -60)
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
        .onAppear {
            fetchMovies()
        }
    }
    
    private func fetchMovies() {
        let endpoint: String
        switch apiCallType {
        case .popular:
            endpoint = "popular"
        case .topRated:
            endpoint = "top_rated"
        case .upcoming:
            endpoint = "upcoming"
        }

        fetchMoviesFromAPI(endpoint: endpoint)
    }

    private func fetchMoviesFromAPI(endpoint: String) {
        Task {
            guard let url = URL(string: "\(TMDB_API)/3/movie/\(endpoint)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                    return
                }
                
                let details = try JSONDecoder().decode(MovieListData.self, from: data)
                
                DispatchQueue.main.async {
                    self.movies = details.results
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

enum APICallType {
    case popular
    case topRated
    case upcoming
}
