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
