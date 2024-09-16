import SwiftUI

class CatalogViewModel: ObservableObject {

}

struct CatalogView: View {
    @StateObject var catalog: CatalogViewModel = CatalogViewModel()

    var body: some View {
        Text("")
    }
}
