import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    
    @State private var pokemonDetail = PokemonDetails()

    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(pokemon.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            // Adding a line to the heading
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .padding(.bottom)
            
            HStack {
                pokemonImageView
                
                VStack (alignment: .leading) {
                    HStack (alignment: .top) {
                        Text("Height: ")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", pokemonDetail.height))
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    HStack (alignment: .top) {
                        Text("Weight: ")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", pokemonDetail.weight))
                            .font(.largeTitle)
                            .bold()
                    }
                }

            }
            
            Spacer()
        }
        .padding()
        .task {
            // URL passed over to get Pokemon Details
            pokemonDetail.URLString = pokemon.url
            await pokemonDetail.getData()
        }
    }
}

// SwiftUI Extensions
extension PokemonDetailView {
    var pokemonImageView: some View {
        AsyncImage(url: URL(string: pokemonDetail.imageURLString)) { phase in
            if let image = phase.image { // We have a vaild image
                image
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
            } else if phase.error != nil { // we have an error
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
            } else { // Use placeholder -- image loading
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
            }
        }
        .frame(width: 96, height: 96)
        .padding(.trailing)
    }
}

#Preview {
    PokemonDetailView(pokemon: Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
