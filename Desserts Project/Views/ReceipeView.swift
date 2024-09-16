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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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

