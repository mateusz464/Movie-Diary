import SwiftUI

struct PopupSheetView: View {
    @Binding var isWatched: Bool
    @Binding var isFavourite: Bool
    @Binding var isWantToWatch: Bool
    @Binding var userRating: Int
    var handleWatched: () -> Void
    var toggleFavourite: () -> Void
    var handleWantToWatch: () -> Void
    var handleRating: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
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
                
                Spacer()
                
                Text("Add a rating!")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack(spacing: 5) {
                    ForEach(1...10, id: \.self) { number in
                        Image(systemName: userRating >= number ? "star.fill" : "star")
                            .foregroundColor(userRating >= number ? .yellow : .gray)
                            .opacity(isWatched ? 1 : 0.5)
                            .onTapGesture {
                                userRating = number
                                handleRating()
                            }
                    }
                }
                .frame(maxWidth: 300)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .disabled(!isWatched)
                
                Spacer()

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

struct DottedLine: View {
    var color: Color = .white
    var lineWidth: CGFloat = 1
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: [5]))
            .foregroundColor(color)
        }
        .frame(height: lineWidth)
    }
}
