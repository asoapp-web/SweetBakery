import SwiftUI

struct Story: View {
    
    let index: Int
    
    let covers: [String] = [
        "HUGGuD", "dDoqkX", "jJOlAW", "ubeZwe", "SbBCRH"
    ]
    
    let titles: [String] = [
        "Surprise cupcake",
        "Raspberry Magic",
        "Chocolate River",
        "Smile cookie",
        "Lemon Flash"
    ]
    
    let descriptions: [String] = [
"""
The little chef woke up at dawn with an incredible idea:
"What if I bake a cake that will surprise everyone?"

He put on his snow-white hat, tied on his apron, and opened a jar of fragrant flour.
In a bowl, he mixed milk, softened butter, and sugar, then added a splash of vanilla—the kitchen immediately filled with a warm, cozy aroma.

But something was missing. Then he looked into the jar of colorful marshmallows and thought:
"Why not?"

He carefully tucked one marshmallow inside the dough, placed the mold in the oven, and waited.

When the cake was baked, he cut into it—and inside was a bright, rainbow-colored cloud.
The chef smiled so widely that his eyes sparkled.

He made five more of these cakes and delivered them to his friends. Everyone said:
— It was like I'd eaten a little miracle!
""",
"""
One morning, the chef went out into the garden, where delicate raspberries, covered in dewdrops, grew on the bushes.
Each berry sparkled in the sun like a tiny ruby.

He gathered a basket and brought it into the kitchen. He decided to make a raspberry soufflé.
He whipped the berries, added sugar, and listened to the sound of the whipped mixture—it resembled a soft, sweet cloud.

As the soufflé rose in the oven, the aroma spread so quickly that even the birds in the trees began chirping louder than usual.

His friends tasted the dessert and exclaimed in unison:
"It's like a sweet spell!"

The chef just smiled and said:
"Raspberry magic always works."
""",
"""
One gray day, the chef decided the world needed more smiles.
He opened the cookie cutter cabinet and found some funny ones: a happy smile, a sly smile, a surprised smile.

He kneaded the soft dough, added a drop of honey to make the cookies warm and heartfelt, and began cutting out different expressions.

When the cookies were baked, each one was unique in its own way.

One looked cheerful, another as if telling a joke, a third as if surprised by its own existence.

The chef arranged them on a plate and realized that the kitchen had been transformed—like a miniature exhibition of emotions.

And the most wonderful thing: everyone who came to visit him was always smiling.
""",
"""
The chef adored chocolate. But most of all, he loved the surprises inside desserts.
So one day, he decided to make a chocolate fondant.

He melted dark chocolate, added butter and an egg, and poured the mixture into a mold.
He left the center of the dessert liquid—"the river's main secret," as he said.

When the fondant was baked, he cut it with a spoon—and the hot chocolate filling gushed out like a true sweet river.

The chef exclaimed:
"What a flow! I found gold in the chocolate!"

He made another batch—this time for his friends to share the joyful moment.
""",
"""
One summer day, the chef wanted to make something refreshing.
He took two bright yellow lemons and grated some of the aromatic zest.

As soon as he opened the lemons, the kitchen filled with a crisp, tart aroma—as if a small sun had exploded right on the table.

He made a lemon curd, soft and shiny, and spooned it into the tart.
When the dessert was ready, it looked like a solar disk shining in the kitchen shadow.

The neighbors, smelling the fresh aroma, popped in to ask:
"What's that sweet smell?"

The chef merely smiled mysteriously:
"It's a little lemony burst of mood."
"""
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: 24){
                NavigationBar(title: "Stories")
                Image(covers[index])
                    .resizable()
                    .scaledToFit()
                Text(titles[index].uppercased())
                    .font(.londrina(.regular, size: 32))
                    .foregroundStyle(Color(hex: "#005098"))
                Text(descriptions[index].uppercased())
                    .font(.londrina(.regular, size: 24))
                    .foregroundStyle(Color(hex: "#4A0D00"))
            }
            .padding()
        }
        .background {
            Color(hex: "#FEF8E5")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Story(index: 0)
}
