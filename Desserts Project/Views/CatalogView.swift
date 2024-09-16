import SwiftUI

class CatalogViewModel: ObservableObject {
    @Published var CatalogViewProperties: CatalogView.Properties?
    @Published public var isLoading: Bool 
    private let networkManager: CatalogNetworkManagerInterface

    public init(CatalogViewProperties: CatalogView.Properties? = nil, 
                isLoading: Bool = false,
                networkManager: CatalogNetworkManagerInterface = CatalogNetworkManager()) {
        self.CatalogViewProperties = CatalogViewProperties
        self.isLoading = isLoading
        self.networkManager = networkManager
    }

}

struct CatalogView: View {
    @StateObject var catalog: CatalogViewModel = CatalogViewModel()

    var body: some View {
        Text("")
    }
}
