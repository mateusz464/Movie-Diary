import SwiftUI

struct MovieCard: View {
    let movies: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: movies.posterUrl) { image in
                image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 160)
            }
            .cornerRadius(10)
        }
        .background(Color(red: 0.341, green: 0.38, blue: 0.49))
        .cornerRadius(10)
    }
}
