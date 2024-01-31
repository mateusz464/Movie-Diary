//
//  TrendingCard.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 31/01/2024.
//

import SwiftUI

struct TrendingCard: View {
    let trendingMovies: TrendingMovies
    
    var body: some View {
        VStack {
            AsyncImage(url: trendingMovies.posterUrl) { image in
                image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 200)
            }
            .cornerRadius(10)

//            Text(trendingMovies.title)
//                .fontWeight(.bold)
//                .lineLimit(1)
//                .truncationMode(.tail)
//                .foregroundStyle(.white)
//                .frame(width: 100)
//
//            HStack {
//                Image(systemName: "hand.thumbsup.fill")
//                Text(String(format: "%.2f", trendingMovies.vote_average))
//            }
//            .foregroundColor(.yellow)
//            .padding(.vertical, 5)
        }
        .background(Color(red: 0.341, green: 0.38, blue: 0.49))
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
    
    var posterUrl: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: poster_path)
    }
}
