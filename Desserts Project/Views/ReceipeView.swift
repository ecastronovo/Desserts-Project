import SwiftUI

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

