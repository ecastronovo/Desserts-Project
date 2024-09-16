import SwiftUI

protocol CatalogViewModelInterface: ObservableObject {
    func getMeals() async
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

    func getMeals() async {
        await MainActor.run {
            isLoading = true
        }

        let fetchedMeals = await networkManager.getMeals()
        
        guard let meals = fetchedMeals else {
            await MainActor.run {
                isLoading = false
            }
            return
        }
        
        let sortedMeals = meals.meals.sorted(by: { firstMeal, secondMeal in
            return firstMeal.strMeal ?? "" < secondMeal.strMeal ?? ""
        })

        let viewProperties: [CatalogView.Meal] = sortedMeals.compactMap { meal in
            guard let name = meal.strMeal,
                  let id = meal.idMeal,
                  let urlString = meal.strMealThumb
            else {
                return nil
            }
            return CatalogView.Meal(mealName: name,
                                    mealImageString: urlString,
                                    mealId: id)
        }
        
        await MainActor.run {
            isLoading = false
            catalogViewProperties = CatalogView.Properties(catalogMeals: viewProperties)
        }
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
                if let meals = catalogViewModel.catalogViewProperties?.catalogMeals {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(spacing: 8), GridItem(spacing: 8)],
                            spacing: 8
                        ) {
                            ForEach(meals, id: \.mealId) { meal in
                                NavigationLink(destination: Text("Next View")) {
                                    VStack {
                                        Text("\(meal.mealName)")
                                        AsyncImage(url: URL(string: meal.mealImageString)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 80, height: 80)
                                    }
                                }
                                .frame(width: 140, height: 120)
                                .padding(8)
                                .border(.separator, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await catalogViewModel.getMeals()
            }
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
