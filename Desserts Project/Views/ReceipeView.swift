import SwiftUI

protocol ReceipeViewModelInterface: ObservableObject {
    
}

class ReceipeViewModel: ReceipeViewModelInterface {
    @Published var receipeProperties: ReceipeView.Properties?
    @Published public var isLoading: Bool = false
    private let networkManager: ReceipeNetworkManagerInterface
    
    public init(receipeProperties:  ReceipeView.Properties? = nil,
                isLoading: Bool = false,
                networkManager: ReceipeNetworkManagerInterface = ReceipeNetworkManager()) {
        self.receipeProperties = receipeProperties
        self.isLoading = isLoading
        self.networkManager = networkManager
    }
}

struct ReceipeView: View {
    let mealId: String

    var body: some View {
        VStack {
            if receipeViewModel.isLoading {
                ProgressView()
            }
            else {
                if let viewProperties = receipeViewModel.receipeProperties {
                    VStack {
                        Text(viewProperties.mealName)
                            .padding(20)
                            .font(.title)
                        
                        Text("Receipe:")
                            .padding(20)
                        ScrollView {
                            ForEach(viewProperties.ingredients) { ingredient in
                                HStack {
                                    Text(ingredient.ingredientName)
                                    Text(ingredient.measurements)
                                }
                            }
                        }
                    }
                }
                else {
                    Text("Not a valid item ID")
                }
                
                
            }
        }.onAppear {
        }
    }

    struct Properties: Equatable {
        let mealName: String
        let ingredients: [Ingredient]
    }

    struct Ingredient: Equatable, Identifiable {
        let id = UUID()
        
        let measurements: String
        let ingredientName: String
    }
}

