//
//  MovieDetails.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 01/04/2024.
//

import SwiftUI

struct MovieDetails: View {
    let movieId: Int
    @State private var movieInfo: MovieInformation?
    @State private var movieCredits: MovieCredits?
    @State private var showingCastOrCrew: String = "Cast"
    @State private var isPopupVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: movieInfo?.backdrop_url) { image in
                        image.image?
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(height: 100)
                    }
                    
                    Button(action: {
                        isPopupVisible = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.bottom, 35)
                    .padding(.trailing)
                }
                
                
                HStack {
                    Text(movieInfo?.title ?? "Title")
                        .fontWeight(.heavy)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Spacer()
                    Text(movieInfo?.release_date.prefix(4) ?? "N/A")
                        .fontWeight(.medium)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .padding(.top, -20)
                
                HStack {
                    Text(movieCredits?.directorName ?? "Director")
                        .fontWeight(.medium)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    Spacer()
                    Text(String(movieInfo?.runtime ?? 0) + " mins")
                        .fontWeight(.medium)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    Spacer()
                    HStack {
                        Image("star")
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIFont.preferredFont(forTextStyle: .title3).pointSize)
                        Text(String(format: "%.2f", movieInfo?.vote_average ?? 0))
                            .fontWeight(.medium)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }
                }
                
                Text(movieInfo?.tagline ?? "N/A")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Text(movieInfo?.overview ?? "N/A")
                    .padding(.horizontal)
                
                Picker("Select", selection: $showingCastOrCrew) {
                    Text("Cast").tag("Cast")
                    Text("Crew").tag("Crew")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    if showingCastOrCrew == "Cast" {
                        ForEach(movieCredits?.cast ?? [], id: \.id) { castMember in
                            Text("\(castMember.name) as \(castMember.character)")
                                .foregroundColor(.white)
                                .padding([.top, .bottom], 2)
                        }
                    } else {
                        ForEach(movieCredits?.crew ?? [], id: \.id) { crewMember in
                            Text("\(crewMember.name) - \(crewMember.job)")
                                .foregroundColor(.white)
                                .padding([.top, .bottom], 2)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()

                
            }
        }
        .onAppear {
            fetchMovieDetails()
            fetchMovieCredits()
        }
        .sheet(isPresented: $isPopupVisible) {
            PopupSheetView()
        }
    }
    
    private func fetchMovieDetails() {
        Task {
            guard let url = URL(string: "\(TMDB_API)/3/movie/\(movieId)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                }
                
                let details = try JSONDecoder().decode(MovieInformation.self, from: data)
                
                movieInfo = details
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMovieCredits() {
        Task {
            guard let url = URL(string: "\(TMDB_API)/3/movie/\(movieId)/credits") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                }
                
                let details = try JSONDecoder().decode(MovieCredits.self, from: data)
                
                movieCredits = details
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct MovieInformation: Decodable {
    let backdrop_path: String
    let title: String
    let overview: String
    let release_date: String
    let runtime: Int
    let tagline: String
    let vote_average: Float
    
    var backdrop_url: URL {
        let base = URL(string: "https://image.tmdb.org/t/p/w500")
        return base!.appending(path: backdrop_path)
    }
}

struct MovieCredits: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    var directorName: String? {
        return crew.first { $0.job == "Director" }?.name
    }
}

struct Cast: Decodable {
    let id: Int
    let name: String
    let character: String
}

struct Crew: Decodable {
    let id: Int
    let name: String
    let job: String
}

struct PopupSheetView: View {
    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Button(action: { print("Eye Tapped") }) {
                    HStack {
                        Image("eye")
                        Text("Watched")
                    }
                }
                .frame(width: 200, height: 100)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button(action: { print("Heart Tapped") }) {
                    HStack {
                        Image("heart")
                        Text("Favourite")
                    }
                }
                .frame(width: 200, height: 100)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button(action: { print("Film Tapped") }) {
                    HStack {
                        Image("film")
                        Text("Want to Watch")
                    }
                }
                .frame(width: 200, height: 100)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }

            .padding()
            .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
            .cornerRadius(20)
            .frame(width: 450)
            .shadow(radius: 10)
        }
    }
}

