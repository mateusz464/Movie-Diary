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
                        Spacer()
                        
                        NavigationLink(destination: SearchListView(apiCallType: .popular)) {
                            Text("Popular")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 50)


                        NavigationLink(destination: SearchListView(apiCallType: .topRated)) {
                            Text("Top Rated")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 50)

                        NavigationLink(destination: SearchListView(apiCallType: .upcoming)) {
                            Text("Upcoming")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 50)
                        
                        Menu {
                            ForEach(genres.reversed()) { genre in
                                NavigationLink(destination: GenreListView(genre: genre)) {
                                    Text(genre.name)
                                }
                            }
                        } label: {
                            HStack {
                                Text("Genres")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 50)
        
                        Spacer()
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            Spacer(minLength: 20)
                            
                            ForEach(viewModel.searchResults.prefix(10)) { item in
                                NavigationLink(destination: SearchMovieDetails(movieId: item.id)) {
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

let genres: [Genre] = [
    Genre(id: 28, name: "Action"),
    Genre(id: 12, name: "Adventure"),
    Genre(id: 16, name: "Animation"),
    Genre(id: 35, name: "Comedy"),
    Genre(id: 80, name: "Crime"),
    Genre(id: 99, name: "Documentary"),
    Genre(id: 18, name: "Drama"),
    Genre(id: 10751, name: "Family"),
    Genre(id: 14, name: "Fantasy"),
    Genre(id: 36, name: "History"),
    Genre(id: 27, name: "Horror"),
    Genre(id: 10402, name: "Music"),
    Genre(id: 9648, name: "Mystery"),
    Genre(id: 10749, name: "Romance"),
    Genre(id: 878, name: "Science Fiction"),
    Genre(id: 53, name: "Thriller"),
    Genre(id: 10752, name: "War"),
    Genre(id: 37, name: "Western")
]

#Preview {
    SearchView()
}
