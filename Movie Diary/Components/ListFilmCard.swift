//
//  ListMovieCard.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 03/04/2024.
//

import SwiftUI

struct ListFilmCard: View {
    let movie: Film
    
    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)
            HStack {
                AsyncImage(url: movie.poster_url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        Color.blue
                    }
                }
                .frame(width: 70, height: 100)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    HStack {
                        Text(movie.title ?? "Title")
                            .font(.headline)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if movie.is_favourite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    if (movie.user_rating > 0) {
                        HStack {
                            Text(movie.release_date?.prefix(4) ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.yellow)
                                    .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
                                Text(String(movie.user_rating))
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
                                Text(String(format: "%.2f", movie.vote_average))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        HStack {
                            Text(movie.release_date?.prefix(4) ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
                                Text(String(format: "%.2f", movie.vote_average))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    
                    Spacer()
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.all, 10)
        }
    }
}
