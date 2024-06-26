import SwiftUI

struct ListMovieCard: View {
    let movie: Movie
    
    var body: some View {
        ZStack {
            Color(red: 40/255.0, green: 51/255.0, blue: 76/255.0)
                .edgesIgnoringSafeArea(.all)
            HStack {
                AsyncImage(url: movie.posterUrl) { phase in
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
                    
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Text(movie.release_date?.prefix(4) ?? "N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        HStack {
                            Image("star")
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
                            Text(String(format: "%.2f", movie.vote_average))
                                .font(.subheadline)
                                .foregroundColor(.white)
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
