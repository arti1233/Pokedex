import SwiftUI
import Combine
import Kingfisher

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State var searchQuery = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.searchPokemonList, id: \.id) { pokemon in
                            NavigationLink {
                                PokemonInfoView(pokemonInfo: pokemon)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.blue)
                                    
                                    VStack {
                                        KFImage(pokemon.sprites.other.officialArtwork.frontDefault)
                                            .resizable()
                                            .placeholder({
                                                Image(systemName: "photo.fill")
                                            })
                                            .cacheMemoryOnly()
                                        Text(pokemon.name)
                                            .tint(.black)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Poxedex")
            .searchable(text: $viewModel.pokemonSearch, placement: .navigationBarDrawer(displayMode: .always))
        }
        .tint(.white)
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var pokemonSearch: String = ""
    @Published var allPokemonInfo: [PokemonInfo] = []
    @Published var searchPokemonList: [PokemonInfo] = []
    private var cancellable: Set<AnyCancellable> = []
    private var alamofireService: AlamofireServiceProtocol
    
    init (alamofire: AlamofireServiceProtocol = AlamofireService.shared) {
        self.alamofireService = alamofire
        fetch()
        search()
    }
    
    private func search() {
        $pokemonSearch
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map { [unowned self] name in
                if name.isEmpty {
                    return allPokemonInfo
                } else {
                    return self.allPokemonInfo.filter { searchText in
                        searchText.name.lowercased().contains(pokemonSearch.lowercased())
                    }
                }
            }
            .assign(to: &$searchPokemonList)
    }
    
    private func fetch() {
        alamofireService.getAllPokemonList()
            .flatMap { pokemonList in
                Publishers.Sequence(sequence: pokemonList.results.map { self.alamofireService.getPokemonInfo(url: $0.url) })
                    .flatMap { $0 }
                    .collect()
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(_):
                    print(completion)
                }
            } receiveValue: { [unowned self] infoList in
                self.allPokemonInfo = infoList.sorted { $0.id < $1.id }
                self.searchPokemonList = allPokemonInfo
                print(allPokemonInfo.count)
            }
            .store(in: &cancellable)
    }
}


#Preview {
    ContentView()
}
