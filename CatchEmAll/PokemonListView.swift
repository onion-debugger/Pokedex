import SwiftUI

struct PokemonListView: View {
    @State var pokemons = Pokemons()
    @State var searchValue: String = ""
    
    var body: some View {
        NavigationStack {
            // used for layering UI on top of each other
            // first child is placed at the bottom
            ZStack {
                    // List is good for [view-only] data
                List(searchedResults) { pokemon in
                    LazyVStack {
                        NavigationLink {
                            PokemonDetailView(pokemon: pokemon)
                        } label: {
                            Text("\(indexOfPokemon(of: pokemon)). \(pokemon.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        await pokemons.loadNextIfNeeded(pokemon: pokemon)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemons")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            // for currency
                            Task {
                                await pokemons.loadAllPokemons()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .status) {
                        Text("\(pokemons.pokemonArray.count) of \(pokemons.count) Pokemons")
                    }
                }
                .searchable(text: $searchValue)
                
                if pokemons.isLoading {
                    ProgressView()
                        .tint(.accentColor)
                        .scaleEffect(4.5)
                }
            }
        }
        .task {
            await pokemons.getData()
        }
    }
    
    var searchedResults: [Pokemon] {
        if searchValue.isEmpty {
            return pokemons.pokemonArray
        } else {
            return pokemons.pokemonArray.filter {
                $0.name.capitalized.contains(searchValue)
            }
        }
    }
    
    func indexOfPokemon(of pokemon: Pokemon) -> Int {
        guard let index = pokemons.pokemonArray.firstIndex(where: {
            $0.id == pokemon.id}) else { return 0 }
        return index + 1
    }
}

#Preview {
    PokemonListView()
}
