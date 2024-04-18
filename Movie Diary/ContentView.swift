import SwiftUI
import CoreData
	
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = MovieDiaryViewModel()
    @State var searchText = ""
    @State var recommendedMovies: [Movie] = []

    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Movie Diary")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("Trending")
                    .fontWeight(.heavy)
                    .font(.title3)
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
                                        MovieCard(movies: trendingMovie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .clipped()
                        }
                    }
                }
                
                Text("Recommended")
                    .fontWeight(.heavy)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ScrollView {
                    if recommendedMovies.isEmpty {
                        Text("No recommendations yet")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(recommendedMovies) { recommendedMovie in
                                    NavigationLink(destination: MovieDetails(movieId: recommendedMovie.id)) {
                                        MovieCard(movies: recommendedMovie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .clipped()
                        }
                    }
                }
                
                Spacer()
                
                Text("In Cinemas")
                    .fontWeight(.heavy)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ScrollView {
                    if viewModel.upcoming.isEmpty {
                        Text("No results")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.upcoming) { upcomingMovie in
                                    NavigationLink(destination: MovieDetails(movieId: upcomingMovie.id)) {
                                        MovieCard(movies: upcomingMovie)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .clipped()
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.loadTrending()
                viewModel.loadUpcoming()
                if !recommendedMoviesRan {
                    Task {
                        await getRecommendations()
                    }
                }
            }
        }
    }
    
    private func getRecommendations() async {
        do {
            let favouriteMovies = try fetchRandomFavouriteMovies()
            let movies = try await fetchRecommendations(forMovies: favouriteMovies)
            self.recommendedMovies = movies
            recommendedMoviesRan = true
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func fetchRecommendations(forMovies movies: [Film]) async throws -> [Movie] {
        var allMovies = [Movie]()
        var seenMovieIDs = Set<Int>()

        for movie in movies {
            let movieId = Int(movie.id)
            guard let url = URL(string: "\(TMDB_API)/3/movie/\(movieId)/recommendations") else {
                print("Invalid URL for movie ID: \(movie.id)")
                continue
            }

            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error with the response, unexpected status code: \(response)")
                continue
            }
            
            let decoder = JSONDecoder()
            let movieResults = try decoder.decode(MovieResults.self, from: data)

            let uniqueMovies = movieResults.results.filter { seenMovieIDs.insert($0.id).inserted }
            allMovies.append(contentsOf: uniqueMovies)
        }
        
        return allMovies.shuffled().prefix(20).map { $0 }
    }
    
    private func fetchRandomFavouriteMovies() throws -> [Film] {
        let request: NSFetchRequest<Film> = Film.fetchRequest()
        request.predicate = NSPredicate(format: "is_favourite == %@", NSNumber(value: true))
        let totalFavourites = try viewContext.count(for: request)
        
        guard totalFavourites > 0 else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No favourite movies found."])
        }
        
        let fetchLimit = min(3, totalFavourites)
        let randomOffsets = (0..<totalFavourites).shuffled().prefix(fetchLimit)
        var randomMovies: [Film] = []
        
        for offset in randomOffsets {
            request.fetchOffset = offset
            request.fetchLimit = 1
            let movies = try viewContext.fetch(request)
            if let movie = movies.first {
                randomMovies.append(movie)
            }
        }
        
        return randomMovies
    }
}

#Preview {
    ContentView()
}
