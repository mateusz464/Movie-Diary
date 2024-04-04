//
//  Movie_DiaryApp.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 22/12/2023.
//

import SwiftUI

@main
struct MovieDiary: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ContentView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image("home") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    FavouritesView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image("heart") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    WatchedView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image("eye") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    WantToWatchView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image("film") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
            }
        }
    }
}
