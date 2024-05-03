import Foundation

class PokemonList: Decodable {
    let results: [Results]
}

class Results: Decodable {
    let name: String
    let url: URL
}

class PokemonInfo: Decodable {
    let height: Int
    let id: Int
    let name: String
    let sprites: Sprites
    let stats: [Stats]
    let types: [TypeElement]
    let weight: Int
}

class Sprites: Decodable {
    let other: OtherSprites
}

class OtherSprites: Decodable {
    let officialArtwork: PokemonSprites
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

class PokemonSprites: Decodable {
    let frontDefault: URL
    let frontShiny: URL
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

class TypeElement: Decodable {
    let slot: Int
    let type: Stat
}

class Stat: Decodable {
    let name: String
    let url: URL
}

class Stats: Decodable {
    let baseStat: Int
    let stat: Stat

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
