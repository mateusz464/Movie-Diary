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
        NavigationStack {
            ZStack {
                Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                    .edgesIgnoringSafeArea(.all)
            
                if (searchText.isEmpty) {

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
                                                MovieCard(trendingMovies: trendingMovie)
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
                } else {
                    LazyVStack {
                        ForEach(viewModel.searchResults) { item in
                            HStack {
                                AsyncImage(url: item.posterUrl) { image in
                                        image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 120)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 80, height: 120)
                                }
                                .padding(.horizontal)
                                .clipped()
                                .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    HStack {
                                        Image(systemName: "hand.thumbsup.fill")
                                        Text(String(format: "%.2f", item.vote_average))
                                    }
                                    .foregroundColor(.yellow)
                                    .fontWeight(.heavy)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            if searchText.count > 2 {
                viewModel.search(query: searchText)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
