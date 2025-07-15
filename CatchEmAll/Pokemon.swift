import Foundation

@Observable
class Pokemons {
    
    var count: Int = 0
    var URLString = "https://pokeapi.co/api/v2/pokemon/"
    var pokemonArray: [Pokemon] = []
    var isLoading: Bool = false
    let HTTP_VALUE = "http"
    
    func getData() async {
        print("🕸️ We are accessing the url \(URLString)")
        isLoading = true
        
        // Create a URL
        guard let url = URL(string: URLString) else {
            print("🚨 ERROR: Could not create a URL from \(URLString)")
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("🚨 JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            
            // Pushing the updating logic to the main thread
            // Is this a bad practice??
            Task { @MainActor in
                self.count = returned.count
                // using nil-coersil operator
                self.URLString = returned.next ?? ""
                self.pokemonArray += returned.results
                isLoading = false
            }
            
        } catch {
            print("🚨 ERROR: Could not get data from \(URLString)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(pokemon: Pokemon) async {
        guard let lastPokemon = pokemonArray.last else { return }
            // Check if we have loaded the last available pokemon and the [next] parameter is valid
        if pokemon.id == lastPokemon.id && URLString.hasPrefix(HTTP_VALUE) {
            await getData()
        }
    }
    
    // Recursive Function
    func loadAllPokemons() async {
        Task { @MainActor in
                // condition to stop the recursion
            guard URLString.hasPrefix(HTTP_VALUE) else { return }
            // get the next page of Pokemons
            await getData()
            // call the function again until the base case is true
            await loadAllPokemons()
        }
        
    }
}
