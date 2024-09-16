import Foundation

protocol CatalogNetworkManagerInterface {
    func getMeals() async -> CatalogViewModel.Meals?
}

final class CatalogNetworkManager: CatalogNetworkManagerInterface {
    let baseURLString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    func getMeals() async -> CatalogViewModel.Meals? {
        
        guard  let url = URL(string: baseURLString) else { return nil }
        
        do {
            // can be improved to look at response for error handling
            let (data, _) = try await URLSession.shared.data(from: url)
            let jsonDecoder = JSONDecoder()
            
            let mealsResponse = try jsonDecoder.decode(CatalogViewModel.Meals.self, from: data)
            
            return mealsResponse
        }
        catch {
            return nil
        }
    }
}

