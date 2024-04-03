//
//  SortOption.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 04/04/2024.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case highestRating = "Highest Rating"
    case lowestRating = "Lowest Rating"
    case newest = "Newest"
    case oldest = "Oldest"
    
    var id: String { self.rawValue }
}
