import Foundation


struct Returned: Codable {
    var count: Int
    var next: String? // using an [Optional] to handle possible null value
    var results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}

struct ReturnedPokemon: Codable {
    var height: Double
    var weight: Double
    var sprites: Sprites
}

struct Sprites: Codable {
    var other: Other
}

struct Other: Codable {
    var officialArtwork: OfficialArtwork
    
    // map JSON parameter name to Swift variables\
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    var front_default: String?
}
