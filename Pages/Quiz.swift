import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctAnswer: String
}

enum QuizTopic: String, CaseIterable {
    case ingredients = "INGREDIENTS"
    case kitchenTools = "KITCHEN TOOLS"
    case baking = "BAKING"
    
    var questions: [QuizQuestion] {
        switch self {
        case .ingredients:
            return [
                QuizQuestion(text: "What ingredient makes dough sweet?", options: ["Pepper", "Sugar", "Salt", "Oil"], correctAnswer: "Sugar"),
                QuizQuestion(text: "What helps dough rise?", options: ["Water", "Lemon juice", "Baking powder", "Vanilla"], correctAnswer: "Baking powder"),
                QuizQuestion(text: "Which ingredient is liquid?", options: ["Flour", "Milk", "Cocoa powder", "Salt"], correctAnswer: "Milk"),
                QuizQuestion(text: "Which ingredient is used to thicken cream?", options: ["Vinegar", "Olive oil", "Cornstarch", "Water"], correctAnswer: "Cornstarch"),
                QuizQuestion(text: "What ingredient is used to make chocolate?", options: ["Cocoa", "Pepper", "Rice", "Garlic"], correctAnswer: "Cocoa"),
                QuizQuestion(text: "What is used to color frosting naturally?", options: ["Berries", "Potatoes", "Bread", "Cheese"], correctAnswer: "Berries"),
                QuizQuestion(text: "Which ingredient makes cookies crunchy?", options: ["Butter", "Tea", "Rice", "Yogurt"], correctAnswer: "Butter"),
                QuizQuestion(text: "What ingredient is NOT sweet?", options: ["Honey", "Caramel", "Mustard", "Chocolate"], correctAnswer: "Mustard"),
                QuizQuestion(text: "What do we add to dough for flavor?", options: ["Paper", "Vanilla", "Soap", "Pasta"], correctAnswer: "Vanilla"),
                QuizQuestion(text: "Which ingredient is used for decoration?", options: ["Sprinkles", "Pasta", "Salt", "Peas"], correctAnswer: "Sprinkles"),
                QuizQuestion(text: "What makes pancakes fluffy?", options: ["Pepper", "Baking soda", "Soy sauce", "Mustard"], correctAnswer: "Baking soda"),
                QuizQuestion(text: "Which ingredient is dairy?", options: ["Butter", "Sugar", "Flour", "Cocoa"], correctAnswer: "Butter"),
                QuizQuestion(text: "Which of these is a fruit ingredient?", options: ["Banana", "Bread", "Cheese", "Rice"], correctAnswer: "Banana"),
                QuizQuestion(text: "What ingredient is used to make caramel?", options: ["Sugar", "Salt", "Garlic", "Flour"], correctAnswer: "Sugar"),
                QuizQuestion(text: "What is used to decorate cupcakes?", options: ["Tomato slices", "Whipped cream", "Lettuce", "Fried onions"], correctAnswer: "Whipped cream")
            ]
        case .kitchenTools:
            return [
                QuizQuestion(text: "What tool is used to flatten dough?", options: ["Knife", "Rolling pin", "Spoon", "Tongs"], correctAnswer: "Rolling pin"),
                QuizQuestion(text: "Which tool mixes eggs quickly?", options: ["Peeler", "Whisk", "Grater", "Spatula"], correctAnswer: "Whisk"),
                QuizQuestion(text: "Which tool flips food in a pan?", options: ["Ladle", "Spatula", "Bowl", "Tray"], correctAnswer: "Spatula"),
                QuizQuestion(text: "What tool is used for cutting vegetables?", options: ["Spoon", "Knife", "Plate", "Scale"], correctAnswer: "Knife"),
                QuizQuestion(text: "What is a mixing bowl used for?", options: ["Frying", "Storing clothes", "Mixing ingredients", "Washing hands"], correctAnswer: "Mixing ingredients"),
                QuizQuestion(text: "Which item belongs in the kitchen?", options: ["Hammer", "Screwdriver", "Measuring cup", "Tape"], correctAnswer: "Measuring cup"),
                QuizQuestion(text: "What tool helps spread frosting?", options: ["Spatula", "Peeler", "Strainer", "Pan"], correctAnswer: "Spatula"),
                QuizQuestion(text: "Which tool is used for peeling fruits?", options: ["Fork", "Tray", "Peeler", "Mug"], correctAnswer: "Peeler"),
                QuizQuestion(text: "Which item does NOT belong in a baking set?", options: ["Whisk", "Rolling pin", "Wrench", "Baking tray"], correctAnswer: "Wrench"),
                QuizQuestion(text: "What is an oven mitt used for?", options: ["Cutting carrots", "Holding hot dishes", "Measuring sugar", "Stirring soup"], correctAnswer: "Holding hot dishes"),
                QuizQuestion(text: "Which tool is used to scoop liquid?", options: ["Knife", "Ladle", "Cutting board", "Spatula"], correctAnswer: "Ladle"),
                QuizQuestion(text: "Which item is used for measuring?", options: ["Tray", "Spoon", "Kitchen scale", "Pan"], correctAnswer: "Kitchen scale"),
                QuizQuestion(text: "Which tool helps grate cheese?", options: ["Spatula", "Grater", "Rolling pin", "Whisk"], correctAnswer: "Grater"),
                QuizQuestion(text: "Which tool is used for baking cookies?", options: ["Baking tray", "Pan lid", "Plate", "Cup"], correctAnswer: "Baking tray"),
                QuizQuestion(text: "What tool helps pour batter neatly?", options: ["Knife", "Fork", "Measuring cup", "Oven mitt"], correctAnswer: "Measuring cup")
            ]
        case .baking:
            return [
                QuizQuestion(text: "Which dessert is baked in the oven?", options: ["Smoothie", "Ice cream", "Cookies", "Milkshake"], correctAnswer: "Cookies"),
                QuizQuestion(text: "What dough is used for pizza?", options: ["Cake batter", "Yeast dough", "Pancake mix", "Brownie batter"], correctAnswer: "Yeast dough"),
                QuizQuestion(text: "Which dough is buttery and flaky?", options: ["Muffin batter", "Puff pastry", "Bread dough", "Waffle batter"], correctAnswer: "Puff pastry"),
                QuizQuestion(text: "How long do cupcakes usually bake?", options: ["2 minutes", "60 minutes", "About 20 minutes", "5 hours"], correctAnswer: "About 20 minutes"),
                QuizQuestion(text: "What is baked inside a pie?", options: ["Soup", "Meatballs", "Fruit filling", "Soda"], correctAnswer: "Fruit filling"),
                QuizQuestion(text: "Which one is NOT baked?", options: ["Brownies", "Ice cream", "Cake", "Muffins"], correctAnswer: "Ice cream"),
                QuizQuestion(text: "What makes a cake rise?", options: ["Oil", "Baking powder", "Salt", "Water"], correctAnswer: "Baking powder"),
                QuizQuestion(text: "What dessert is made from layered dough?", options: ["Muffins", "Croissants", "Pancakes", "Ice cream cones"], correctAnswer: "Croissants"),
                QuizQuestion(text: "What dessert is soft inside and crunchy outside?", options: ["Soup", "Salad", "Cookies", "Tea"], correctAnswer: "Cookies"),
                QuizQuestion(text: "How long does a simple cookie batch bake?", options: ["1 hour", "10–12 minutes", "40 minutes", "3 minutes"], correctAnswer: "10–12 minutes"),
                QuizQuestion(text: "What is often sprinkled on top of brownies?", options: ["Salt", "Powdered sugar", "Pasta", "Peas"], correctAnswer: "Powdered sugar"),
                QuizQuestion(text: "What baked dessert uses apples?", options: ["Milkshake", "Apple pie", "Yogurt", "Pudding cup"], correctAnswer: "Apple pie"),
                QuizQuestion(text: "What do bakers use to test readiness?", options: ["Pencil", "Ruler", "Toothpick", "Spoon"], correctAnswer: "Toothpick"),
                QuizQuestion(text: "Which dessert is made with cheese?", options: ["Cheesecake", "Chocolate bar", "Cupcake", "Fruit salad"], correctAnswer: "Cheesecake"),
                QuizQuestion(text: "What do muffins bake in?", options: ["Soup bowls", "Paper liners", "Frying pans", "Ice trays"], correctAnswer: "Paper liners")
            ]
        }
    }
}

struct Quiz: View {
    let topic: QuizTopic
    @Environment(\.dismiss) var dismiss
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var score = 0
    @State private var showResult = false
    
    var currentQuestion: QuizQuestion {
        topic.questions[currentQuestionIndex]
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                NavigationBar(title: "Quiz")
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    Image("DoOPKA")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            Text(currentQuestion.text.uppercased())
                                .font(.londrina(.regular, size: 24))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(24)
                        }
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            Button {
                                selectedAnswer = option
                            } label: {
                                Text(option.uppercased())
                                    .font(.londrina(.black, size: 22))
                                    .foregroundStyle(Color(hex: "#FA66B0"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 120)
                                    .background(Color(hex: "#FFE1E9"))
                                    .cornerRadius(35)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 35)
                                            .stroke(Color(hex: "#FA66B0"), lineWidth: 4)
                                    }
                                    .opacity(selectedAnswer == option ? 0.5 : 1)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    handleNext()
                } label: {
                    CustomButton(text: selectedAnswer == nil ? "SELECT ANSWER" : (currentQuestionIndex == topic.questions.count - 1 ? "FINISH" : "NEXT"), maxWidth: true)
                }
                .disabled(selectedAnswer == nil)
                .opacity(selectedAnswer == nil ? 0.6 : 1.0)
                .frame(width: 250)
            }
            .padding()
            .background {
                Image("kIQdUC")
                    .resizable()
                    .ignoresSafeArea()
            }
            
            if showResult {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    QuizResults(correctAnswers: score) {
                        restartQuiz()
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleNext() {
        if selectedAnswer == currentQuestion.correctAnswer {
            score += 1
        }
        
        if currentQuestionIndex < topic.questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
        } else {
            withAnimation {
                showResult = true
            }
        }
    }
    
    private func restartQuiz() {
        score = 0
        currentQuestionIndex = 0
        selectedAnswer = nil
        withAnimation {
            showResult = false
        }
    }
}

#Preview {
    Quiz(topic: .ingredients)
}
