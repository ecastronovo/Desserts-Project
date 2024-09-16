import SwiftUI

protocol CatalogViewModelInterface: ObservableObject {
    func getMeals()
}

class CatalogViewModel: CatalogViewModelInterface {
    @Published var catalogViewProperties: CatalogView.Properties?
    @Published public var isLoading: Bool
    private let networkManager: CatalogNetworkManagerInterface

    public init(catalogViewProperties: CatalogView.Properties? = nil,
                isLoading: Bool = false,
                networkManager: CatalogNetworkManagerInterface = CatalogNetworkManager()) {
        self.catalogViewProperties = catalogViewProperties
        self.isLoading = isLoading
        self.networkManager = networkManager
    }

    func getMeals() {
    }
}

struct CatalogView: View {
    @StateObject var catalogViewModel: CatalogViewModel = CatalogViewModel()

    var body: some View {
        NavigationView {
            if catalogViewModel.isLoading {
                ProgressView()
            }
            else {
                
            }
        }
        .onAppear() {
            catalogViewModel.getMeals()
        }
    }

    struct Properties: Equatable {
        let catalogMeals: [Meal]
    }

    struct Meal: Equatable {
        let mealName: String
        let mealImageString: String
        let mealId: String
    }
}
