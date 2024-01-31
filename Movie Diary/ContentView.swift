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
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Trending")
                    .fontWeight(.heavy)
                    .font(.title)
                    .foregroundColor(.white)

                ScrollView {
                    if viewModel.trending.isEmpty {
                        Text("No results")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.trending) { trendingMovie in
                                    TrendingCard(trendingMovies: trendingMovie)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onAppear {
                    viewModel.loadTrending()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
