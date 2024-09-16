import SwiftUI

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
                                NavigationLink(destination: ReceipeView(mealId: meal.mealId)) {
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
