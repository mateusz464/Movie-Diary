import SwiftUI

struct WatchedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedSort: SortOption = .highestRating

    @FetchRequest(
        entity: Film.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "watched == %@", NSNumber(value: true))
    ) var watchedFilms: FetchedResults<Film>
    
    var body: some View {
        VStack {
            HStack {
                Text("Watched Movies")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.horizontal, .top])
                
                Spacer()
                
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            selectedSort = option
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                .padding([.top, .horizontal])
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sortedFilms(), id: \.self) { film in
                        NavigationLink(destination: MovieDetails(movieId: Int(film.id))) {
                            ListFilmCard(movie: film)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .background(Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0))
    }
    
    private func sortedFilms() -> [Film] {
        switch selectedSort {
            case .highestRating:
                return watchedFilms.sorted { $0.vote_average > $1.vote_average }
            case .lowestRating:
                return watchedFilms.sorted { $0.vote_average < $1.vote_average }
            case .newest:
                return watchedFilms.sorted { $0.release_date ?? "" > $1.release_date ?? "" }
            case .oldest:
                return watchedFilms.sorted { $0.release_date ?? "" < $1.release_date ?? "" }
            }
    }
}

