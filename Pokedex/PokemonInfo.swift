import SwiftUI
import Kingfisher

fileprivate enum DescriptionStat: CaseIterable {
    case hp
    case atk
    case def
    case spd
    case exp
    
    var color: Color {
        switch self {
        case .hp:
            .red
        case .atk:
            .orange
        case .def:
            .blue
        case .spd:
            .purple
        case .exp:
            .green
        }
    }
}

fileprivate enum DescriptionType: String, CaseIterable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
    
    var color: Color {
        switch self {
        case .normal:
            .teal
        case .fighting:
            .black
        case .flying:
            .blue
        case .poison:
            .purple
        case .ground:
            .brown
        case .rock:
            .gray
        case .bug:
            .gray
        case .ghost:
            .mint
        case .steel:
            .gray
        case .fire:
            .red
        case .water:
            .blue
        case .grass:
            .green
        case .electric:
            .yellow
        case .psychic:
            .pink
        case .ice:
            .blue
        case .dragon:
            .orange
        case .dark:
            .black
        case .fairy:
            .indigo
        case .unknown:
            .brown
        case .shadow:
            .gray
        }
    }
}

struct PokemonInfoView: View {
    
    var pokemonInfo: PokemonInfo
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .clipShape(.rect(bottomLeadingRadius: 50, bottomTrailingRadius: 50))
                    .ignoresSafeArea()
                    .foregroundColor(.green)
            
                KFImage(pokemonInfo.sprites.other.officialArtwork.frontDefault)
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 150)
        
            
            Text(pokemonInfo.name)
                .font(.largeTitle)
                .bold()
            
            TypeBar(types: pokemonInfo.types)
                .padding([.trailing, .leading], 8)
            
            HStack(spacing: 65) {
                VStack {
                    Text("\(pokemonInfo.weight) KG")
                        .font(.title)
                        .bold()
                    Text("Weight")
                }
                
                VStack {
                    Text("\(NSString(format:"%.2f", (Double(pokemonInfo.height) * 0.1))) M")
                        .font(.title)
                        .bold()
                    Text("Height")
                }
            }
            
            Spacer()
            
            VStack {
                Text("Base Stats")
                    .font(.title)
                    .bold()
                
                StatsBar()
            }
            
            Spacer()
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatsBar: View {
    
    private func calculatedStatsWidht() {
        
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                ForEach(DescriptionStat.allCases, id: \.self) { item in
                    Text("\(item)")
                        .font(.title2)
                        .frame(height: 20)
                        .padding(.top, 8)
                }
            }
            
            
            GeometryReader(content: { geometry in
                VStack {
                    ForEach(DescriptionStat.allCases, id: \.self) { item in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray)
                                    .frame(height: 20)
                                
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(item.color)
                                    .frame(width: 100 ,height: 20)
                                    
                                
                                Text("50/3000")
                                    .lineLimit(1)
                                    .frame(width: 90, alignment: .trailing)
                            }
                            .padding(.top, 8)
                        }
                    }
            })
        }
        .padding([.leading, .trailing], 16)
    }
}

struct TypeBar: View {
    
    var types: [TypeElement]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(types, id: \.slot) { type in
                    ZStack {
                        Text(type.type.name)
                            .font(.title3)
                            .bold()
                            .padding(.all, 8)
                            .background(DescriptionType(rawValue: type.type.name)?.color ?? .accentColor)
                            .cornerRadius(15)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonInfoView(pokemonInfo: loadJSON(filename: "response"))
}

func loadJSON(filename: String) -> PokemonInfo {
    let url = Bundle.main.url(forResource: filename, withExtension: "json")

    do {
        let data = try Data(contentsOf: url!)
        let decoder = JSONDecoder()
        let model = try decoder.decode(PokemonInfo.self, from: data)
        return model
    } catch {
       fatalError()
    }
}
