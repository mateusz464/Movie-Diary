//
//  MovieDetails.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 01/04/2024.
//

import SwiftUI

struct MovieDetails: View {
    let movieInfo: MovieInformation
    let movieCredits: MovieCredits
    
    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                AsyncImage(url: movieInfo.backdrop_url) { image in
                    image.image?
                        .resizable()
                        .scaledToFill()
//                        .frame(width: 120, height: 200)
                }
                
                Spacer()
                
                HStack {
                    Text(movieInfo.title)
                    Spacer()
                    Text(movieInfo.release_date)
                }
                
                Spacer()
                
                HStack {
                    Text(movieCredits.directorName ?? "Director")
                    Spacer()
                    Text(String(movieInfo.runtime))
                    Spacer()
                    Text(String(format: "%.2f", movieInfo.vote_average))
                }
                
                Spacer()
                
                Text(movieInfo.tagline)
                
                Spacer()
                
                Text(movieInfo.overview)
                
                Spacer()
                
            }
        }
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
    
    var backdrop_url: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: backdrop_path)
    }
}

struct MovieCredits: Decodable {
    let id: String
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
