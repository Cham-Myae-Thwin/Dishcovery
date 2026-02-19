class Recipe {
  final String id;
  final String title;
  final String image;
  final String time;
  final String difficulty;
  final String servings;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.time,
    required this.difficulty,
    required this.servings,
    required this.ingredients,
    required this.instructions,
  });
}

// Mock recipe data
final List<Recipe> mockRecipes = [
  Recipe(
    id: '1',
    title: 'Spicy Chicken Tacos',
    image:
        'https://images.unsplash.com/photo-1768716697797-5eed4d2173f6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcGljeSUyMGNoaWNrZW4lMjB0YWNvcyUyMG1leGljYW58ZW58MXx8fHwxNzcwMjM3MDU0fDA&ixlib=rb-4.1.0&q=80&w=1080',
    time: '15 min',
    difficulty: 'Easy',
    servings: '2 people',
    ingredients: [
      '2 boneless chicken breasts',
      '1 tablespoon olive oil',
      '1 teaspoon chili powder',
      '1/2 teaspoon cumin',
      '1/2 teaspoon paprika',
      '4 small tortillas',
      '1/2 cup chopped lettuce',
      '1/4 cup diced tomatoes',
      '1/4 cup shredded cheese',
      'Salt and pepper to taste',
    ],
    instructions: [
      'Cut chicken breasts into small bite-sized pieces and season with chili powder, cumin, paprika, salt, and pepper.',
      'Heat olive oil in a large pan over medium-high heat.',
      'Add seasoned chicken to the pan and cook for 6-8 minutes, stirring occasionally, until golden brown and cooked through.',
      'While chicken cooks, warm tortillas in a separate pan or microwave for 20 seconds.',
      'Assemble tacos by placing chicken on tortillas and topping with lettuce, tomatoes, and cheese. Serve immediately.',
    ],
  ),
  Recipe(
    id: '2',
    title: 'Creamy Chicken Pasta',
    image:
        'https://images.unsplash.com/photo-1748012199657-3f34292cdf70?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjcmVhbXklMjBjaGlja2VuJTIwcGFzdGElMjBpdGFsaWFufGVufDF8fHx8MTc3MDIzNzA1NXww&ixlib=rb-4.1.0&q=80&w=1080',
    time: '25 min',
    difficulty: 'Easy',
    servings: '3 people',
    ingredients: [
      '300g pasta (penne or fettuccine)',
      '2 chicken breasts, sliced',
      '1 cup heavy cream',
      '1/2 cup parmesan cheese',
      '2 cloves garlic, minced',
      '2 tablespoons butter',
      'Fresh parsley for garnish',
      'Salt and pepper to taste',
    ],
    instructions: [
      'Cook pasta according to package instructions. Drain and set aside.',
      'Season chicken slices with salt and pepper.',
      'In a large pan, melt butter over medium heat and cook chicken until golden, about 5-6 minutes per side.',
      'Add minced garlic and cook for 1 minute until fragrant.',
      'Pour in heavy cream and bring to a simmer. Add parmesan cheese and stir until melted.',
      'Add cooked pasta to the sauce and toss to combine. Garnish with fresh parsley and serve hot.',
    ],
  ),
  Recipe(
    id: '3',
    title: 'One Pot Chicken Stew',
    image:
        'https://images.unsplash.com/photo-1764304733301-3a9f335f0c67?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlja2VuJTIwc3RldyUyMHBvdCUyMGNvbWZvcnR8ZW58MXx8fHwxNzcwMjM3MDU1fDA&ixlib=rb-4.1.0&q=80&w=1080',
    time: '40 min',
    difficulty: 'Medium',
    servings: '4 people',
    ingredients: [
      '4 chicken thighs',
      '2 carrots, chopped',
      '2 potatoes, cubed',
      '1 onion, diced',
      '3 cups chicken broth',
      '2 bay leaves',
      '1 teaspoon thyme',
      '2 tablespoons flour',
      'Salt and pepper to taste',
    ],
    instructions: [
      'Season chicken thighs with salt and pepper, then coat lightly with flour.',
      'In a large pot, brown chicken on both sides over medium-high heat. Remove and set aside.',
      'In the same pot, sauté onions until translucent, about 3 minutes.',
      'Add carrots and potatoes, cook for 5 minutes.',
      'Return chicken to pot, add chicken broth, bay leaves, and thyme.',
      'Bring to a boil, then reduce heat and simmer for 25-30 minutes until chicken is cooked through and vegetables are tender.',
      'Remove bay leaves before serving. Enjoy with crusty bread.',
    ],
  ),
  Recipe(
    id: '4',
    title: 'Chicken Butter Stir Fry',
    image:
        'https://images.unsplash.com/photo-1761314025701-34795be5f737?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlja2VuJTIwc3RpciUyMGZyeSUyMHZlZ2V0YWJsZXN8ZW58MXx8fHwxNzcwMTQ4ODc0fDA&ixlib=rb-4.1.0&q=80&w=1080',
    time: '20 min',
    difficulty: 'Easy',
    servings: '2 people',
    ingredients: [
      '2 chicken breasts, thinly sliced',
      '2 cups mixed vegetables (bell peppers, broccoli, snap peas)',
      '3 tablespoons soy sauce',
      '1 tablespoon sesame oil',
      '2 cloves garlic, minced',
      '1 teaspoon ginger, grated',
      '2 tablespoons vegetable oil',
      'Cooked rice for serving',
    ],
    instructions: [
      'Heat vegetable oil in a wok or large pan over high heat.',
      'Add chicken slices and stir-fry for 4-5 minutes until cooked through. Remove and set aside.',
      'Add garlic and ginger to the pan, cook for 30 seconds.',
      'Add mixed vegetables and stir-fry for 3-4 minutes until crisp-tender.',
      'Return chicken to the pan, add soy sauce and sesame oil. Toss everything together for 1-2 minutes.',
      'Serve immediately over cooked rice.',
    ],
  ),
  Recipe(
    id: '5',
    title: 'Garlic Shrimp Parsley Fried',
    image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    time: '10 min',
    difficulty: 'Easy',
    servings: '2 people',
    ingredients: [
      '200g shrimp, peeled and deveined',
      '2 cloves garlic, minced',
      '1 tablespoon butter',
      '1 tablespoon olive oil',
      'Salt and pepper to taste',
      '1 tablespoon lemon juice',
      'Chopped parsley (optional)',
    ],
    instructions: [
      'Heat butter and olive oil in a pan over medium heat.',
      'Add garlic and sauté for 30 seconds until fragrant.',
      'Add shrimp, season with salt and pepper, and cook for 3-4 minutes until pink.',
      'Drizzle lemon juice, garnish with parsley, and serve warm.',
    ],
  ),

  Recipe(
    id: '6',
    title: 'Vegetble Olive Pasta',
    image: 'https://images.unsplash.com/photo-1525755662778-989d0524087e',
    time: '20 min',
    difficulty: 'Easy',
    servings: '3 people',
    ingredients: [
      '200g pasta',
      '1 zucchini, sliced',
      '1 bell pepper, sliced',
      '1/2 cup cherry tomatoes',
      '2 tablespoons olive oil',
      '2 cloves garlic, minced',
      'Salt and Italian seasoning to taste',
    ],
    instructions: [
      'Cook pasta according to package instructions.',
      'Sauté garlic and vegetables in olive oil for 5-7 minutes.',
      'Drain pasta and toss with vegetables.',
      'Season and serve hot.',
    ],
  ),

  Recipe(
    id: '7',
    title: 'Avocado Garlic Toast',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
    time: '5 min',
    difficulty: 'Easy',
    servings: '1 person',
    ingredients: [
      '2 slices bread',
      '1 ripe avocado',
      'Salt and pepper to taste',
      '1 teaspoon lemon juice',
      'Chili flakes (optional)',
    ],
    instructions: [
      'Toast the bread slices.',
      'Mash avocado with lemon juice, salt, and pepper.',
      'Spread avocado mixture on toast.',
      'Sprinkle chili flakes and serve immediately.',
    ],
  ),

  Recipe(
    id: '8',
    title: 'Blue Berry Honey Smoothie',
    image: 'https://images.unsplash.com/photo-1497534446932-c925b458314e',
    time: '5 min',
    difficulty: 'Easy',
    servings: '2 glasses',
    ingredients: [
      '1 cup mixed berries',
      '1 banana',
      '1 cup milk',
      '1/2 cup yogurt',
      '1 tablespoon honey',
    ],
    instructions: [
      'Add all ingredients into a blender.',
      'Blend until smooth and creamy.',
      'Pour into glasses and serve chilled.',
    ],
  ),
];
