import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case highestRating = "Highest Rating"
    case lowestRating = "Lowest Rating"
    case newest = "Newest"
    case oldest = "Oldest"
    
    var id: String { self.rawValue }
}
