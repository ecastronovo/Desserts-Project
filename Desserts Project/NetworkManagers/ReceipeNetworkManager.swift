import Foundation

protocol ReceipeNetworkManagerInterface {
    func fetchReceipe(id: String) async -> ReceipeViewModel.Meals?
    
}

final class ReceipeNetworkManager: ReceipeNetworkManagerInterface {
    private let baseURL: String = "https://themealdb.com/api/json/v1/1/lookup.php?i="
   
    func fetchReceipe(id: String) async -> ReceipeViewModel.Meals? {
        if let url = URL(string: baseURL + id) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let jsonDecoder = JSONDecoder()
                let decodedMeal = try jsonDecoder.decode(ReceipeViewModel.Meals.self, from: data)
                return decodedMeal
            }
            catch {
                print(error)
                return nil
            }
        }
        else {
            return nil
        }
    }
}
