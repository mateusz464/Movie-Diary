//
//  ContentView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 22/12/2023.
//

import SwiftUI
	
struct ContentView: View {
    
    @StateObject var viewModel = MovieDiaryViewModel()
    @State var searchText = ""

    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Trending")
                    .fontWeight(.heavy)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ScrollView {
                    if viewModel.trending.isEmpty {
                        Text("No results")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.trending) { trendingMovie in
                                    NavigationLink(destination: MovieDetails(movieId: trendingMovie.id)) {
                                        MovieCard(trendingMovies: trendingMovie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .clipped()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadTrending()
            }
        }
    }
}

#Preview {
    ContentView()
}
