import SwiftUI

struct RecipeItem: Identifiable {
    let id = UUID()
    let ingredients: [String]
    let steps: [String]
    let result: String
}

struct Recipe: View {
    
    let index: Int
    
    let covers: [String] = [
        "gThSIw", "BBaTCb", "DRkmct", "kdPsOv", "VQlXWb", "OtgYkW"
    ]
    
    let recipesData: [RecipeItem] = [
        RecipeItem(
            ingredients: ["FLOUR", "SUGAR", "EGGS", "BUTTER", "VANILLA", "MILK"],
            steps: [
                "CREAM BUTTER AND SUGAR.",
                "ADD EGGS AND VANILLA.",
                "MIX IN FLOUR AND MILK.",
                "PLACE ONE MINI MARSHMALLOW INSIDE EACH CUPCAKE LINER.",
                "BAKE FOR 20 MIN AT 180°C."
            ],
            result: "SOFT VANILLA CUPCAKES WITH A MELTING SURPRISE INSIDE."
        ),
        RecipeItem(
            ingredients: ["STRAWBERRIES", "HEAVY CREAM", "SUGAR"],
            steps: [
                "BLEND STRAWBERRIES INTO PUREE.",
                "WHIP COLD CREAM WITH SUGAR.",
                "FOLD PUREE INTO THE WHIPPED CREAM.",
                "CHILL FOR 1 HOUR."
            ],
            result: "LIGHT, FLUFFY, PINK STRAWBERRY MOUSSE."
        ),
        RecipeItem(
            ingredients: ["COCONUT FLAKES", "CONDENSED MILK", "VANILLA"],
            steps: [
                "MIX CONDENSED MILK WITH COCONUT FLAKES AND VANILLA.",
                "SHAPE INTO SMALL BALLS.",
                "ROLL IN EXTRA COCONUT.",
                "REFRIGERATE FOR 1 HOUR."
            ],
            result: "SWEET COCONUT SNOWBALLS WITH SOFT TEXTURE."
        ),
        RecipeItem(
            ingredients: ["BUTTER", "CHOCOLATE", "EGGS", "SUGAR", "FLOUR", "COCOA POWDER"],
            steps: [
                "MELT BUTTER AND CHOCOLATE TOGETHER.",
                "STIR IN SUGAR AND EGGS.",
                "ADD COCOA AND FLOUR.",
                "BAKE FOR 25 MIN AT 180°C."
            ],
            result: "RICH, GOOEY CHOCOLATE BROWNIES."
        ),
        RecipeItem(
            ingredients: ["LEMONS", "SUGAR", "EGGS", "BUTTER", "TART CRUST"],
            steps: [
                "WHISK LEMON JUICE, SUGAR, AND EGGS.",
                "COOK ON LOW HEAT UNTIL THICKENED.",
                "ADD BUTTER.",
                "POUR INTO A BAKED TART CRUST."
            ],
            result: "BRIGHT, REFRESHING LEMON TART."
        ),
        RecipeItem(
            ingredients: ["YOGURT", "BERRIES", "HONEY", "GRANOLA"],
            steps: [
                "LAYER YOGURT WITH MIXED BERRIES.",
                "DRIZZLE HONEY.",
                "TOP WITH GRANOLA."
            ],
            result: "FAST AND HEALTHY LAYERED DESSERT."
        )
    ]
    
    var body: some View {
        let recipe = recipesData[index]
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: 24){
                NavigationBar(title: "Recipes")
                
                Image(covers[index])
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(24)
                
                IngredientView(ingredients: recipe.ingredients)
                
                StepsView(steps: recipe.steps, result: recipe.result)
            }
            .padding()
        }
        .background {
            Color(hex: "#FEF8E5")
                .ignoresSafeArea()
        }
    }
}

struct IngredientView: View {
    let ingredients: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text("INGREDIENTS: ")
                .foregroundColor(Color(hex: "#1E518E")) +
            Text(ingredients.joined(separator: ", "))
                .foregroundColor(Color(hex: "#34C1FF")))
            .font(.londrina(.black, size: 24))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#D2F2FF"))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(hex: "#34C1FF"), lineWidth: 4)
        )
    }
}

struct StepsView: View {
    let steps: [String]
    let result: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("STEPS:")
                    .font(.londrina(.black, size: 24))
                    .foregroundColor(Color(hex: "#FF85C1"))
                    .padding(.bottom, 4)
                
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    Text("\(index + 1). \(step)")
                        .font(.londrina(.black, size: 24))
                        .foregroundColor(Color(hex: "#601436"))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                (Text("RESULT: ")
                    .foregroundColor(Color(hex: "#FF85C1")) +
                Text(result)
                    .foregroundColor(Color(hex: "#601436")))
                .font(.londrina(.black, size: 24))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#FFE5F2"))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(hex: "#FF85C1"), lineWidth: 4)
        )
    }
}

#Preview {
    Recipe(index: 0)
}
