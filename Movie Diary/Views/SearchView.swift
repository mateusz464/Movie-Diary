//
//  SearchView.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 05/04/2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = MovieDiaryViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                    .edgesIgnoringSafeArea(.all)
                
                if (searchText.isEmpty) {
                    VStack {
                        Button("Popular") {
                                // Handle Popular button tap
                            }
                            .buttonStyle(SearchViewButtonStyle())

                            Button("Top Rated") {
                                // Handle Top Rated button tap
                            }
                            .buttonStyle(SearchViewButtonStyle())

                            Button("Upcoming") {
                                // Handle Upcoming button tap
                            }
                            .buttonStyle(SearchViewButtonStyle())

                            Button("Genres") {
                                // Handle Genres button tap
                            }
                            .buttonStyle(SearchViewButtonStyle())

                            Spacer()
                        }
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            Spacer(minLength: 20)
                            
                            ForEach(viewModel.searchResults.prefix(10)) { item in
                                NavigationLink(destination: HomeMovieDetails(movieId: item.id)) {
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
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

struct SearchViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
    }
}

#Preview {
    SearchView()
}
