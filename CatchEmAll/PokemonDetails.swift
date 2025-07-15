import Foundation

@Observable
class PokemonDetails {
    
    var URLString = ""
    var height = 0.0
    var weight = 0.0
    var imageURLString: String = ""
    
    func getData() async {
        print("🕸️ We are accessing the url \(URLString)")
        
            // Create a URL
        guard let url = URL(string: URLString) else {
            print("🚨 ERROR: Could not create a URL from \(URLString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
                // Decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(ReturnedPokemon.self, from: data) else {
                print("🚨 JSON ERROR: Could not decode returned JSON data")
                return
            }
            self.height = returned.height
            self.weight = returned.weight
            self.imageURLString = returned.sprites.other.officialArtwork.front_default ?? "N/A"
        
        } catch {
            print("🚨 ERROR: Could not get data from \(URLString)")
        }
    }
}
