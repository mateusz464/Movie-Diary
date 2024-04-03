//
//  FavouritesView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 03/04/2024.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedSort: SortOption = .highestRating

    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "is_favourite == %@", NSNumber(value: true))
    ) var favouriteFilms: FetchedResults<Film>
    
    var body: some View {
        VStack {
            HStack {
                Text("Favourite Movies")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding([.horizontal, .top])
                
                Spacer()
                
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            selectedSort = option
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                .padding([.top, .horizontal])
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sortedFilms(), id: \.self) { film in
                        ListMovieCard(movie: film)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
                    }
                }
            }
        }
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
    }
    
    private func sortedFilms() -> [Film] {
        switch selectedSort {
            case .highestRating:
                return favouriteFilms.sorted { $0.vote_average > $1.vote_average }
            case .lowestRating:
                return favouriteFilms.sorted { $0.vote_average < $1.vote_average }
            case .newest:
                return favouriteFilms.sorted { $0.release_date ?? "" > $1.release_date ?? "" }
            case .oldest:
                return favouriteFilms.sorted { $0.release_date ?? "" < $1.release_date ?? "" }
            }
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case highestRating = "Highest Rating"
    case lowestRating = "Lowest Rating"
    case newest = "Newest"
    case oldest = "Oldest"
    
    var id: String { self.rawValue }
}
