//
//  TrendingCard.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 31/01/2024.
//

import SwiftUI

struct MovieCard: View {
    let trendingMovies: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: trendingMovies.posterUrl) { image in
                image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 200)
            }
            .cornerRadius(10)
        }
        .background(Color(red: 0.341, green: 0.38, blue: 0.49))
        .cornerRadius(10)
    }
}

struct MovieResults: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let poster_path: String
    let title: String
    let vote_average: Float
    let backdrop_path: String
    
    var posterUrl: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: poster_path)
    }
}

struct MovieInformation: Decodable {
    let backdrop_path: String
    let title: String
    let overview: String
    let release_date: String
    let runtime: Int
    let tagline: String
    let vote_average: Float
    let poster_path: String
    
    var backdrop_url: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: backdrop_path)
    }
    
    var poster_url: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: poster_path)
    }
}

struct MovieCredits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    var directorName: String? {
        return crew.first { $0.job == "Director" }?.name
    }
}

struct Cast: Decodable {
    let id: Int
    let name: String
    let character: String
}

struct Crew: Decodable {
    let id: Int
    let name: String
    let job: String
}
