import SwiftUI

protocol ReceipeViewModelInterface: ObservableObject {
    func fetchReceipe(id: String) async
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

    func fetchReceipe(id: String) async {

        await MainActor.run {
            isLoading = true
        }
        
        let mealResponse = await networkManager.fetchReceipe(id: id)
        if let meal = mealResponse {
            let viewProperties: ReceipeView.Properties? = getProperties(from: meal)
            
            await MainActor.run {
                self.receipeProperties = viewProperties
                isLoading = false
            }
        }
        else {
            await MainActor.run {
                isLoading = false
            }
        }
    }

    private func getProperties(from payload: Meals) -> ReceipeView.Properties? {
        guard let meal = payload.meals.first else { return nil }
        let mealName = meal.strMeal ?? ""
        var ingredients: [ReceipeView.Ingredient] = []
        let mirrorMeal = Mirror(reflecting: meal)
        
        var dictionary: [String: String] = [:]
        
        let measurementsAndIngredients = mirrorMeal.children.filter { child in
            (child.label?.contains("strMeasure") == true) || (child.label?.contains("strIngredient") == true)
        }
        
        for child in measurementsAndIngredients {
            guard let label = child.label?.description,
                  let valueString = child.value as? String else {
                continue
            }
            dictionary[label] = valueString
        }
        
        for i in (1...20) {
            let measurementKey = "strMeasure" + String(i)
            let ingredientKey = "strIngredient" + String(i)
            
            if let measurementValue = dictionary[measurementKey],
               let ingredientValue = dictionary[ingredientKey],
               measurementValue != "" &&
                ingredientValue != "" {
                ingredients.append(ReceipeView.Ingredient(measurements: measurementValue, ingredientName: ingredientValue))
            }
        }
        return .init(mealName: mealName, ingredients: ingredients)
    }
}

struct ReceipeView: View {
    @StateObject var receipeViewModel: ReceipeViewModel = ReceipeViewModel()
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
            Task {
                await receipeViewModel.fetchReceipe(id: mealId)
            }
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

