import SwiftUI

class ReceipeViewModel: ObservableObject {
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
    }

    struct Properties {
        
    }
}

