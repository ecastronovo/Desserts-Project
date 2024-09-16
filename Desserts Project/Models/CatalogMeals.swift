extension CatalogViewModel {
    struct Meals: Decodable {
        let meals: [Meal]
    }

    struct Meal: Decodable {
        let strMeal: String?
        let strMealThumb: String?
        let idMeal: String?
    }
}

