import SwiftUI

@main
struct MovieDiary: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ContentView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image(systemName: "house.fill") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    SearchView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image(systemName: "magnifyingglass")}
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    FavouritesView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image(systemName: "heart.fill") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    WatchedView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image(systemName: "eye.fill") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
                
                NavigationView {
                    WantToWatchView()
                        .preferredColorScheme(.dark)
                }
                .tabItem { Image(systemName: "film.fill") }
                .environment(\.managedObjectContext, MovieDataProvider.shared.viewContext)
            }
            .accentColor(.white)
        }
    }
}
