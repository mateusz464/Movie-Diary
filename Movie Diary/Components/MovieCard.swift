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
