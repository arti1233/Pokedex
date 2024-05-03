import Foundation
import Alamofire
import Combine

protocol AlamofireServiceProtocol {
    func getAllPokemonList() -> AnyPublisher<PokemonList, AFError>
    func getPokemonInfo(url: URL) -> AnyPublisher<PokemonInfo, AFError>
}

class AlamofireService: AlamofireServiceProtocol {
    
    static let shared: AlamofireServiceProtocol = AlamofireService()
    let mainUrl = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1025"
    
    
    func getAllPokemonList() -> AnyPublisher<PokemonList, AFError> {
        AF.request(mainUrl, method: .get).publishDecodable(type: PokemonList.self).value()
    }
    
    func getPokemonInfo(url: URL) -> AnyPublisher<PokemonInfo, AFError> {
        AF.request(url, method: .get).publishDecodable(type: PokemonInfo.self).value()
    }
}
