//
//  FavouritesView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 03/04/2024.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "is_favourite == %@", NSNumber(value: true))
    ) var favouriteFilms: FetchedResults<Film>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(favouriteFilms, id: \.self) { film in
                    ListMovieCard(movie: film)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
                }
            }
        }
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))

    }
}
