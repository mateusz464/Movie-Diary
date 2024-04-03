//
//  MovieDetails.swift
//  Movie Diary
//
//  Created by Mateusz Golebiowski on 01/04/2024.
//

import SwiftUI
import CoreData

struct MovieDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let movieId: Int
    @State private var movieInfo: MovieInformation?
    @State private var movieCredits: MovieCredits?
    @State private var showingCastOrCrew: String = "Cast"
    @State private var isPopupVisible: Bool = false
    @State private var isWatched: Bool = false
    @State private var isFavourite: Bool = false
    @State private var isWantToWatch: Bool = false
    
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
            updateMovieStatus()
        }
        .sheet(isPresented: $isPopupVisible) {
            PopupSheetView(isWatched: $isWatched, isFavourite: $isFavourite, isWantToWatch: $isWantToWatch, handleWatched: handleWatched, toggleFavourite: handleFavourite, handleWantToWatch: handleWantToWatch)
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
    
    private func updateMovieStatus() {
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let result = try viewContext.fetch(request)
            if let movie = result.first {
                isWatched = movie.watched
                isFavourite = movie.is_favourite
                isWantToWatch = !movie.watched && (result.count > 0)
            } else {
                isWatched = false
                isFavourite = false
                isWantToWatch = false
            }
        } catch {
            print("Error fetching movie status: \(error.localizedDescription)")
        }
    }
    
    private func handleWatched() {
        if isWatched {
            removeFilm(id: movieId)
        } else {
            addOrUpdateFilm(watched: true)
        }
    }
    
    private func handleFavourite() {
        if isWatched {
            addOrUpdateFilm(favourite: !isFavourite)
        }
    }
    
    private func handleWantToWatch() {
        if isWantToWatch {
            removeFilm(id: movieId)
        } else {
            addOrUpdateFilm(watched: false)
        }
    }
    
    private func addOrUpdateFilm(watched: Bool? = nil, favourite: Bool? = nil) {
        
        let request: NSFetchRequest<Film> = Film.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            
            do {
                let results = try viewContext.fetch(request)
                let film: Film
                
                if let existingFilm = results.first {
                    film = existingFilm
                } else {
                    film = Film(context: viewContext)
                    film.id = Int32(movieId)
                    film.title = movieInfo?.title ?? ""
                    film.poster_url = movieInfo?.poster_url
                    film.release_date = movieInfo?.release_date
                    film.vote_average = movieInfo?.vote_average ?? 0
                }
                
                if let watched = watched {
                    film.watched = watched
                    isWatched = watched
                    isWantToWatch = !watched
                }
                
                if let favourite = favourite {
                    film.is_favourite = favourite
                    isFavourite = favourite
                }
                
                try viewContext.save()
            } catch {
                print("Error saving or updating film: \(error.localizedDescription)")
            }
    }
    
    private func removeFilm(id: Int) {
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let films = try viewContext.fetch(request)
            for film in films {
                viewContext.delete(film)
            }
            try viewContext.save()
            isWatched = false
            isFavourite = false
            isWantToWatch = false
        } catch {
            print("Error removing film: \(error.localizedDescription)")
        }
    }
    
    private func toggleFavouriteStatus() {
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let movies = try viewContext.fetch(request)
            if let movie = movies.first {
                movie.is_favourite.toggle()
                try viewContext.save()
            }
        } catch {
            print("Error toggling favourite status: \(error.localizedDescription)")
        }
    }
}

struct PopupSheetView: View {
    @Binding var isWatched: Bool
    @Binding var isFavourite: Bool
    @Binding var isWantToWatch: Bool
    var handleWatched: () -> Void
    var toggleFavourite: () -> Void
    var handleWantToWatch: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button(action: {
                    handleWatched()
                }) {
                    HStack {
                        Image("eye")
                        Text("Watched")
                    }
                }
                .frame(width: 200, height: 100)
                .background(isWatched ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button(action: {
                    toggleFavourite()
                }) {
                    HStack {
                        Image("heart")
                        Text("Favourite")
                    }
                }
                .frame(width: 200, height: 100)
                .background(isFavourite ? Color.red : Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .disabled(!isWatched)
                .opacity(isWatched ? 1 : 0.5)
                
                Button(action: { handleWantToWatch() }) {
                    HStack {
                        Image("film")
                        Text("Want to Watch")
                    }
                }
                .frame(width: 200, height: 100)
                .background(isWantToWatch ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .disabled(isWatched)
                .opacity(!isWatched ? 1 : 0.5)
            }

            .padding()
            .cornerRadius(20)
            .frame(width: 450)
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
        .edgesIgnoringSafeArea(.all)
    }
}
