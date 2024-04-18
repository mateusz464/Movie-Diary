import SwiftUI

struct GenreListView: View {
    let genre: Genre
    @State private var movies: [Movie] = []
    
    var body: some View {
        VStack {
            Text("\(genre.name) Movies")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding([.horizontal, .top])
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: SearchMovieDetails(movieId: Int(movie.id))) {
                            ListMovieCard(movie: movie)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
                        }
                    }
                }
            }
        }
        .padding(.vertical, -60)
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
        .onAppear {
            fetchMovies()
        }
    }
    
    private func fetchMovies() {
        Task {
            guard let url = URL(string: "\(TMDB_API)/3/discover/movie?with_genres=\(genre.id)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(TMDB_API_KEY!)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if !(200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? 0) {
                    print("Error getting data")
                    return
                }
                
                let details = try JSONDecoder().decode(MovieListData.self, from: data)
                
                DispatchQueue.main.async {
                    self.movies = details.results
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
