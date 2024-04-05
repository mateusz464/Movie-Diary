//
//  Structures.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 05/04/2024.
//

import Foundation

struct MovieResults: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let poster_path: String?
    let title: String
    let vote_average: Float
    let backdrop_path: String?
    let release_date: String?
    
    var posterUrl: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
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

struct MovieListData: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
