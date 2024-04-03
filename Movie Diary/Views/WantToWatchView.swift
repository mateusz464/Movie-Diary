//
//  WantToWatchView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 04/04/2024.
//

import SwiftUI

struct WantToWatchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedSort: SortOption = .highestRating

    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "watched == %@", NSNumber(value: false))
    ) var wantToWatchFilms: FetchedResults<Film>
    
    var body: some View {
        VStack {
            HStack {
                Text("Want to Watch")
                    .font(.title)
                    .fontWeight(.bold)
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
                return wantToWatchFilms.sorted { $0.vote_average > $1.vote_average }
            case .lowestRating:
                return wantToWatchFilms.sorted { $0.vote_average < $1.vote_average }
            case .newest:
                return wantToWatchFilms.sorted { $0.release_date ?? "" > $1.release_date ?? "" }
            case .oldest:
                return wantToWatchFilms.sorted { $0.release_date ?? "" < $1.release_date ?? "" }
        }
    }
}

