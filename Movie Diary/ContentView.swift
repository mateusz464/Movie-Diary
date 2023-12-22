//
//  ContentView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 22/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MovieDiaryViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

class MovieDiaryViewModel: ObservableObject {
    @Published var homeScreen: []
}

struct TrendingMovies: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let poster_path: String
    let title: String
    let vote_average: Float
}

#Preview {
    ContentView()
}
