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
                ContentView()
                    .preferredColorScheme(.dark)
                    .tabItem { Image("home") }
                ContentView()
                    .preferredColorScheme(.dark)
                    .tabItem { Image("heart") }
                ContentView()
                    .preferredColorScheme(.dark)
                    .tabItem { Image("eye") }
                ContentView()
                    .preferredColorScheme(.dark)
                    .tabItem { Image("film") }
            }
        }
    }
}

