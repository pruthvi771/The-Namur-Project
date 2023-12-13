import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;

enum ProductType {
  newProduct,
  secondHand,
  // onRent,
}

enum ProductQuantity {
  units,
  wkg,
  w500g,
  w250g,
}

var nameForProductQuantity = {
  ProductQuantity.units: "Units",
  ProductQuantity.wkg: "Kg",
  ProductQuantity.w500g: "500g",
  ProductQuantity.w250g: "250g",
};

enum ParentEnum {
  animal,
  food,
  machine,
  land,
}

var nameForParentEnum = {
  ParentEnum.animal: "Animals",
  ParentEnum.food: "Food",
  ParentEnum.machine: "Machine",
  ParentEnum.land: "Land",
};

var categoryListForParentEnum = {
  ParentEnum.animal: [
    CategoryEnum.animals,
    CategoryEnum.birds,
    CategoryEnum.supplies,
  ],
  ParentEnum.food: [
    CategoryEnum.vegetables,
    CategoryEnum.fruits,
    CategoryEnum.crops,
  ],
  ParentEnum.machine: [
    CategoryEnum.jcb,
    CategoryEnum.electronics,
    CategoryEnum.equipments,
  ],
  ParentEnum.land: [
    CategoryEnum.jcb,
    CategoryEnum.electronics,
    CategoryEnum.equipments,
  ],
};

var subCategoryListsForCategory = {
  CategoryEnum.animals: [
    SubCategoryEnum.cows,
    SubCategoryEnum.goats,
    SubCategoryEnum.buffaloes,
    SubCategoryEnum.sheep,
    SubCategoryEnum.bull,
    SubCategoryEnum.pig,
  ],
  CategoryEnum.birds: [
    SubCategoryEnum.parrot,
    SubCategoryEnum.pigeon,
    SubCategoryEnum.sparrow,
    SubCategoryEnum.duck,
    SubCategoryEnum.turkey,
  ],
  CategoryEnum.supplies: [
    SubCategoryEnum.barley,
    SubCategoryEnum.bengalGram,
    SubCategoryEnum.castor,
  ],
  CategoryEnum.vegetables: [
    SubCategoryEnum.beans,
    SubCategoryEnum.beetroot,
    SubCategoryEnum.bitterground,
    SubCategoryEnum.bottleground,
    SubCategoryEnum.brinjal,
    SubCategoryEnum.brocolli,
  ],
  CategoryEnum.fruits: [
    SubCategoryEnum.banana,
    SubCategoryEnum.gauva,
    SubCategoryEnum.grapes,
    SubCategoryEnum.jackfruit,
    SubCategoryEnum.mango,
    SubCategoryEnum.muskmelon,
  ],
  CategoryEnum.crops: [
    SubCategoryEnum.barley,
    SubCategoryEnum.bengalGram,
    SubCategoryEnum.castor,
    SubCategoryEnum.cotton,
    SubCategoryEnum.groundnut,
    SubCategoryEnum.jute,
  ],
  CategoryEnum.electronics: [
    SubCategoryEnum.mobile,
    SubCategoryEnum.laptop,
    SubCategoryEnum.tv,
  ],
  CategoryEnum.jcb: [
    SubCategoryEnum.jcb,
  ],
  CategoryEnum.equipments: [
    SubCategoryEnum.tractor,
    SubCategoryEnum.rotavator,
    SubCategoryEnum.cultivator,
  ],
};

CategoryEnum? findCategoryForSubCategory(SubCategoryEnum subCategory) {
  for (var category in subCategoryListsForCategory.keys) {
    if (subCategoryListsForCategory[category]!.contains(subCategory)) {
      return category;
    }
  }
  return null; // Return null if subcategory is not found in any category
}

ParentEnum? findParentForCategory(CategoryEnum category) {
  for (var parent in categoryListForParentEnum.keys) {
    if (categoryListForParentEnum[parent]!.contains(category)) {
      return parent;
    }
  }
  return null; // Return null if subcategory is not found in any category
}

enum CategoryEnum {
  animals,
  birds,
  supplies,
  crops,
  vegetables,
  fruits,
  electronics,
  jcb,
  equipments,
}

var nameForCategoryEnum = {
  CategoryEnum.animals: "Animals",
  CategoryEnum.birds: "Birds",
  CategoryEnum.crops: "Grains/Pulses",
  CategoryEnum.vegetables: "Vegetables",
  CategoryEnum.fruits: "Fruits",
  CategoryEnum.electronics: "Electronics",
  CategoryEnum.jcb: "JCB",
  CategoryEnum.equipments: "Equipments",
  CategoryEnum.supplies: "Supplies",
};

enum SubCategoryEnum {
  // animals
  cows,
  goats,
  buffaloes,
  sheep,
  bull,
  pig,

  // birds
  parrot,
  pigeon,
  sparrow,
  // chicken,
  duck,
  turkey,

  //CROPS
  barley,
  bengalGram,
  castor,
  cotton,
  groundnut,
  jute,
  linseed,
  maize,
  mustard,
  pearlMillet,
  rabiMaize,
  soybean,
  sunflower,
  tobacco,
  turmeric,
  wheat,
  rice,
  jower,
  coffee,
  tea,
  pepper,
  coconut,
  arecanut,
  horsegram,
  ragi,
  chikpea,
  jaggery,
  tamrind,
  cashew,
  palmOil,
  greengram,
  arbi,
  ber,
  cowPea,
  cumin,
  kinnow,
  lentil,
  litchi,
  okra,
  pigenopea,
  ridgedGround,
  sorghum,
  sugarcane,
  tuberose,

  // VEGETABLES
  beans,
  beetroot,
  bitterground,
  bottleground,
  brinjal,
  brocolli,
  cabbage,
  capsicum,
  carrot,
  cauliflower,
  chikPeas,
  chilli,
  clusterBean,
  coriander,
  cucumber,
  drumstick,
  frenchBeans,
  ginger,
  greenpeas,
  IvyGround,
  lemon,
  mentha,
  pointedGround,
  potato,
  pumpkin,
  raddish,
  snakeGround,
  spinach,
  spongeGround,
  tomato,
  sweetPotato,
  mashroom,
  ladyFinger,
  babycorn,
  milk,
  onions,
  garlic,

  // FRUITS
  amla,
  banana,
  gauva,
  grapes,
  jackfruit,
  mango,
  muskmelon,
  pineapple,
  sapota,
  watermelon,
  orange,
  strawberry,
  custardApple,
  papaya,
  pomegranate,
  apple,
  MarasebuPear,
  mosambi,
  muskMelon,
  tenderCoconut,
  dates,
  resins,
  fig,
  jamun,

  // FLOWERS
  rose,
  marigold,

  // MISCELLANEOUS
  egg,
  chicken,

  // ELECTRONICS
  mobile,
  laptop,
  tv,

  // JCB
  jcb,

  // EQUIPMENTS
  tractor,
  rotavator,
  cultivator,
}

var nameForSubCategoryEnum = {
  SubCategoryEnum.cows: "Cows",
  SubCategoryEnum.goats: "Goats",
  SubCategoryEnum.buffaloes: "Buffaloes",
  SubCategoryEnum.sheep: "Sheep",
  SubCategoryEnum.bull: "Bull",
  SubCategoryEnum.pig: "Pig",
  SubCategoryEnum.parrot: "Parrot",
  SubCategoryEnum.pigeon: "Pigeon",
  SubCategoryEnum.sparrow: "Sparrow",
  SubCategoryEnum.duck: "Duck",
  SubCategoryEnum.turkey: "Turkey",
  SubCategoryEnum.barley: "Barley",
  SubCategoryEnum.bengalGram: "Bengal Gram",
  SubCategoryEnum.castor: "Castor",
  SubCategoryEnum.cotton: "Cotton",
  SubCategoryEnum.groundnut: "Groundnut",
  SubCategoryEnum.jute: "Jute",
  SubCategoryEnum.linseed: "Linseed",
  SubCategoryEnum.maize: "Maize",
  SubCategoryEnum.mustard: "Mustard",
  SubCategoryEnum.pearlMillet: "Pearl Millet",
  SubCategoryEnum.rabiMaize: "Rabi Maize",
  SubCategoryEnum.soybean: "Soybean",
  SubCategoryEnum.sunflower: "Sunflower",
  SubCategoryEnum.tobacco: "Tobacco",
  SubCategoryEnum.turmeric: "Turmeric",
  SubCategoryEnum.wheat: "Wheat",
  SubCategoryEnum.rice: "Rice",
  SubCategoryEnum.jower: "Jower",
  SubCategoryEnum.coffee: "Coffee",
  SubCategoryEnum.tea: "Tea",
  SubCategoryEnum.pepper: "Pepper",
  SubCategoryEnum.coconut: "Coconut",
  SubCategoryEnum.arecanut: "Arecanut",
  SubCategoryEnum.horsegram: "Horsegram",
  SubCategoryEnum.ragi: "Ragi",
  SubCategoryEnum.chikpea: "Chikpea",
  SubCategoryEnum.jaggery: "Jaggery",
  SubCategoryEnum.tamrind: "Tamrind",
  SubCategoryEnum.cashew: "Cashew",
  SubCategoryEnum.palmOil: "Palm Oil",
  SubCategoryEnum.greengram: "Greengram",
  SubCategoryEnum.arbi: "Arbi",
  SubCategoryEnum.ber: "Ber",
  SubCategoryEnum.cowPea: "Cow Pea",
  SubCategoryEnum.cumin: "Cumin",
  SubCategoryEnum.kinnow: "Kinnow",
  SubCategoryEnum.lentil: "Lentil",
  SubCategoryEnum.litchi: "Litchi",
  SubCategoryEnum.okra: "Okra",
  SubCategoryEnum.pigenopea: "Pigenopea",
  SubCategoryEnum.ridgedGround: "Ridged Ground",
  SubCategoryEnum.sorghum: "Sorghum",
  SubCategoryEnum.sugarcane: "Sugarcane",
  SubCategoryEnum.tuberose: "Tuberose",
  SubCategoryEnum.beans: "Beans",
  SubCategoryEnum.beetroot: "Beetroot",
  SubCategoryEnum.bitterground: "Bitterground",
  SubCategoryEnum.bottleground: "Bottleground",
  SubCategoryEnum.brinjal: "Brinjal",
  SubCategoryEnum.brocolli: "Brocolli",
  SubCategoryEnum.cabbage: "Cabbage",
  SubCategoryEnum.capsicum: "Capsicum",
  SubCategoryEnum.carrot: "Carrot",
  SubCategoryEnum.cauliflower: "Cauliflower",
  SubCategoryEnum.chikPeas: "Chickpeas",
  SubCategoryEnum.chilli: "Chilli",
  SubCategoryEnum.clusterBean: "Cluster Bean",
  SubCategoryEnum.coriander: "Coriander",
  SubCategoryEnum.cucumber: "Cucumber",
  SubCategoryEnum.drumstick: "Drumstick",
  SubCategoryEnum.frenchBeans: "French Beans",
  SubCategoryEnum.ginger: "Ginger",
  SubCategoryEnum.greenpeas: "Green Peas",
  SubCategoryEnum.IvyGround: "Ivy Ground",
  SubCategoryEnum.lemon: "Lemon",
  SubCategoryEnum.mentha: "Mint",
  SubCategoryEnum.pointedGround: "Pointed Ground",
  SubCategoryEnum.potato: "Potato",
  SubCategoryEnum.pumpkin: "Pumpkin",
  SubCategoryEnum.raddish: "Radish",
  SubCategoryEnum.snakeGround: "Snake Ground",
  SubCategoryEnum.spinach: "Spinach",
  SubCategoryEnum.spongeGround: "Sponge Ground",
  SubCategoryEnum.tomato: "Tomato",
  SubCategoryEnum.sweetPotato: "Sweet Potato",
  SubCategoryEnum.mashroom: "Mushroom",
  SubCategoryEnum.ladyFinger: "Ladyfinger",
  SubCategoryEnum.babycorn: "Baby Corn",
  SubCategoryEnum.milk: "Milk",
  SubCategoryEnum.onions: "Onions",
  SubCategoryEnum.garlic: "Garlic",
  SubCategoryEnum.amla: "Amla",
  SubCategoryEnum.banana: "Banana",
  SubCategoryEnum.gauva: "Guava",
  SubCategoryEnum.grapes: "Grapes",
  SubCategoryEnum.jackfruit: "Jackfruit",
  SubCategoryEnum.mango: "Mango",
  SubCategoryEnum.muskmelon: "Muskmelon",
  SubCategoryEnum.pineapple: "Pineapple",
  SubCategoryEnum.sapota: "Sapota",
  SubCategoryEnum.watermelon: "Watermelon",
  SubCategoryEnum.orange: "Orange",
  SubCategoryEnum.strawberry: "Strawberry",
  SubCategoryEnum.custardApple: "Custard Apple",
  SubCategoryEnum.papaya: "Papaya",
  SubCategoryEnum.pomegranate: "Pomegranate",
  SubCategoryEnum.apple: "Apple",
  SubCategoryEnum.MarasebuPear: "Marasebu Pear",
  SubCategoryEnum.mosambi: "Mosambi",
  SubCategoryEnum.muskMelon: "Musk Melon",
  SubCategoryEnum.tenderCoconut: "Tender Coconut",
  SubCategoryEnum.dates: "Dates",
  SubCategoryEnum.resins: "Resins",
  SubCategoryEnum.fig: "Fig",
  SubCategoryEnum.jamun: "Jamun",
  SubCategoryEnum.rose: "Rose",
  SubCategoryEnum.marigold: "Marigold",
  SubCategoryEnum.egg: "Egg",
  SubCategoryEnum.chicken: "Chicken",
  SubCategoryEnum.mobile: "Mobile",
  SubCategoryEnum.laptop: "Laptop",
  SubCategoryEnum.tv: "TV",
  SubCategoryEnum.jcb: "JCB",
  SubCategoryEnum.tractor: "Tractor",
  SubCategoryEnum.rotavator: "Rotavator",
  SubCategoryEnum.cultivator: "Cultivator",
};

// CategoryEnum.animals: [
//     SubCategoryEnum.cows,
//     SubCategoryEnum.goats,
//     SubCategoryEnum.buffaloes,
//   ],
//   CategoryEnum.birds: [
//     SubCategoryEnum.parrot,
//     SubCategoryEnum.pigeon,
//     SubCategoryEnum.sparrow,
//   ],
//   CategoryEnum.vegetables: [
//     SubCategoryEnum.beans,
//     SubCategoryEnum.beetroot,
//     SubCategoryEnum.bitterground,
//   ],
//   CategoryEnum.fruits: [
//     SubCategoryEnum.banana,
//     SubCategoryEnum.gauva,
//     SubCategoryEnum.grapes,
//   ],
//   CategoryEnum.crops: [
//     SubCategoryEnum.barley,
//     SubCategoryEnum.bengalGram,
//     SubCategoryEnum.castor,
//   ],

var imageForCrop = addressList.imageForCrop;

var imageFromFirebaseStorage = {
  'Banana':
      'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers%2FfruitsAndVeg%2Fbanana.png?alt=media&token=5cf50bc8-63e0-495f-9581-37e98d1833c4',
  'Beetroot': 'assets/ikons/fruitsAndVeg/beetroot.png',
  'Betel Nut': 'assets/ikons/fruitsAndVeg/betel-nut.png',
  'Cabbage': 'assets/ikons/fruitsAndVeg/cabbage.png',
  'Capsicum': 'assets/ikons/fruitsAndVeg/capsicum.png',
  'Carrot': 'assets/ikons/fruitsAndVeg/carrot.png',
  'Cashew': 'assets/ikons/fruitsAndVeg/cashew.png',
  'Cauliflower': 'assets/ikons/fruitsAndVeg/cauliflower.png',
  'Cereal': 'assets/ikons/fruitsAndVeg/cereal.png',
  'Chili': 'assets/ikons/fruitsAndVeg/chili.png',
  'Chilli': 'assets/ikons/fruitsAndVeg/chilli.png',
  'Coconut Tree': 'assets/ikons/fruitsAndVeg/coconut-tree.png',
  'Coconut': 'assets/ikons/fruitsAndVeg/coconut.png',
  'Coffee': 'assets/ikons/fruitsAndVeg/coffee.png',
  'Coriander': 'assets/ikons/fruitsAndVeg/coriander.png',
  'Corn': 'assets/ikons/fruitsAndVeg/corn.png',
  'Cotton': 'assets/ikons/fruitsAndVeg/cotton.png',
  'Cucumber': 'assets/ikons/fruitsAndVeg/cucumber.png',
  'Drumstick': 'assets/ikons/fruitsAndVeg/drumstick.png',
  'Eggplant': 'assets/ikons/fruitsAndVeg/eggplant.png',
  'Food': 'assets/ikons/fruitsAndVeg/food.png',
  'Ginger': 'assets/ikons/fruitsAndVeg/ginger.png',
  'Grape': 'assets/ikons/fruitsAndVeg/grape.png',
  'Grapes Black Dry': 'assets/ikons/fruitsAndVeg/Grapes black dry.jpeg',
  'Grapes Black': 'assets/ikons/fruitsAndVeg/Grapes Black.jpeg',
  'Grapes Green': 'assets/ikons/fruitsAndVeg/Grapes green.jpg',
  'Grapes Red': 'assets/ikons/fruitsAndVeg/Grapes red.jpeg',
  'Green Beans': 'assets/ikons/fruitsAndVeg/green-beans.png',
  'Green Onion': 'assets/ikons/fruitsAndVeg/green-onion.png',
  'Green Tea': 'assets/ikons/fruitsAndVeg/green-tea.png',
  'Jackfruit': 'assets/ikons/fruitsAndVeg/jackfruit.png',
  'Jaggery': 'assets/ikons/fruitsAndVeg/jaggery.png',
  'Jar': 'assets/ikons/fruitsAndVeg/jar.png',
  'Lemon': 'assets/ikons/fruitsAndVeg/lemon.png',
  'Mango': 'assets/ikons/fruitsAndVeg/mango.png',
  'Marijuana': 'assets/ikons/fruitsAndVeg/marijuana.png',
  'Milk Tank': 'assets/ikons/fruitsAndVeg/milk-tank.png',
  'Mushroom': 'assets/ikons/fruitsAndVeg/mushroom.png',
  'Olive Oil': 'assets/ikons/fruitsAndVeg/olive-oil.png',
  'Onion': 'assets/ikons/fruitsAndVeg/onion.png',
  'Orange': 'assets/ikons/fruitsAndVeg/orange.png',
  'Palm Oil': 'assets/ikons/fruitsAndVeg/palm-oil.png',
  'Papaya': 'assets/ikons/fruitsAndVeg/papaya.png',
  'Pea': 'assets/ikons/fruitsAndVeg/pea.png',
  'Peanut': 'assets/ikons/fruitsAndVeg/peanut.png',
  'Pear': 'assets/ikons/fruitsAndVeg/pear.png',
  'Pineapple': 'assets/ikons/fruitsAndVeg/pineapple.png',
  'Planting': 'assets/ikons/fruitsAndVeg/planting.png',
  'Pomegranate': 'assets/ikons/fruitsAndVeg/pomegranate.png',
  'Potato': 'assets/ikons/fruitsAndVeg/potato.png',
  'Pumpkin': 'assets/ikons/fruitsAndVeg/pumpkin.png',
  'Radish': 'assets/ikons/fruitsAndVeg/radish.png',
  'Rice': 'assets/ikons/fruitsAndVeg/rice.png',
  'Sapling': 'assets/ikons/fruitsAndVeg/sapling.png',
  'Seed Bag': 'assets/ikons/fruitsAndVeg/seed-bag.png',
  'Seed': 'assets/ikons/fruitsAndVeg/seed.png',
  'Seeding': 'assets/ikons/fruitsAndVeg/seeding.png',
  'Seeds': 'assets/ikons/fruitsAndVeg/seeds.png',
  'Spinach': 'assets/ikons/fruitsAndVeg/spinach.png',
  'Sunflower Oil': 'assets/ikons/fruitsAndVeg/sunflower-oil.png',
  'Sweet Potato': 'assets/ikons/fruitsAndVeg/sweet-potato.png',
  'Tamarind': 'assets/ikons/fruitsAndVeg/tamarind.png',
  'Tomato': 'assets/ikons/fruitsAndVeg/tomato.png',
  'Wheat': 'assets/ikons/fruitsAndVeg/wheat-sack.png',
};

// var imageForNameCloud = {
//   'Beetroot':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FBeetroot.png?alt=media&token=a8e45430-5864-45a9-b244-c8de7a721ef9',
//   'Cashew':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCashew.png?alt=media&token=f20d899f-4760-428e-8375-7ba2ebdefe8d',
//   'Betel Nut':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FBetel%20Nut.png?alt=media&token=91cc7908-6d7d-4ec0-add0-d6c0558744d2',
//   'Capsicum':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCapsicum.png?alt=media&token=4021b55b-4fea-46f6-8884-bf2a4a8938e6',
//   'Carrot':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCarrot.png?alt=media&token=3863e7d5-e721-40a2-90d0-f22b868cb4ac',
//   'Cereal':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCereal.png?alt=media&token=75a5ec90-d98f-4ca2-ad68-a6463d107190',
//   'Chilli':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FChilli.png?alt=media&token=1aa06388-a71a-4d29-a3f6-29d5b2668a06',
//   'Cauliflower':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCauliflower.png?alt=media&token=12b82fbc-c793-4d45-b2c7-68861799d0c3',
//   'Chili':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FChili.png?alt=media&token=cf0a0b55-e9b6-47a4-a0c7-609a107b1d7c',
//   'Cabbage':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCabbage.png?alt=media&token=f4cd8e3b-7d45-4fb5-bec9-f6ae817be93f',
//   'Coconut Tree':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCoconut%20Tree.png?alt=media&token=83ff21e8-2ad2-48d8-b971-58b5c27b5411',
//   'Coconut':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCoconut.png?alt=media&token=2acd1fbb-2423-4744-b253-08303d96d1ae',
//   'Coffee':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCoffee.png?alt=media&token=9cad2b25-a345-4edc-8264-12f7c4021949',
//   'Eggplant':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FEggplant.png?alt=media&token=5dce2c6c-3cec-49bd-bb82-3b2f8afaae5a',
//   'Grapes Red':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGrapes%20Red.png?alt=media&token=54e02836-e954-4758-9ecd-c01017171161',
//   'Ginger':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGinger.png?alt=media&token=04afb153-2650-402c-901c-e7ebd66e881b',
//   'Grapes Black':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGrapes%20Black.png?alt=media&token=a0ddd927-d655-4e5a-b756-734c3554ab41',
//   'Drumstick':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FDrumstick.png?alt=media&token=ca052be0-e1b3-4399-9b01-5e5edbb7324a',
//   'Marijuana':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FMarijuana.png?alt=media&token=166b107c-4fa8-40f2-bc2c-ac33c639d1d7',
//   'Jaggery':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FJaggery.png?alt=media&token=1936d136-832f-4b3a-ba77-73501bef9a46',
//   'Cotton':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCotton.png?alt=media&token=ac35f93c-eb75-4187-ae74-f473804a7be9',
//   'Jackfruit':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FJackfruit.png?alt=media&token=4a8d13ef-1fcb-45a4-aefc-165cd550d3c9',
//   'Green Tea':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGreen%20Tea.png?alt=media&token=8af6383a-423b-4252-9585-1f54693cf5a9',
//   'Corn':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCorn.png?alt=media&token=b6b44685-951e-4cd4-b89e-fd6fc99ff259',
//   'Jar':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FJar.png?alt=media&token=83cf4f03-b4fe-4317-a7f4-b44b5457e20d',
//   'Coriander':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCoriander.png?alt=media&token=978fb1a1-6cfa-461f-9c54-6a98ba66db97',
//   'Grapes Black Dry':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGrapes%20Black%20Dry.png?alt=media&token=8dd1f175-5cd6-43cd-bc36-256c57321390',
//   'Green Beans':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGreen%20Beans.png?alt=media&token=946913b4-be43-4326-a262-3fb667d99b3a',
//   'Cucumber':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FCucumber.png?alt=media&token=680a2ed1-49f1-4915-9209-d522db7e962f',
//   'Grapes Green':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGrapes%20Green.png?alt=media&token=b5a9422a-6ef6-4ffa-a966-b6a64bf8d75f',
//   'Grape':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGrape.png?alt=media&token=41fd6f36-acdc-4d31-abc1-75923e9ca637',
//   'Food':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FFood.png?alt=media&token=f0b0eea9-4e53-4bac-9996-80e3a6e7ec9c',
//   'Green Onion':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FGreen%20Onion.png?alt=media&token=4d352fdf-fb0b-44d9-b043-4618471340b0',
//   'Mango':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FMango.png?alt=media&token=1b4496d6-98be-481b-bb4f-489bf08973a3',
//   'Lemon':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FLemon.png?alt=media&token=b186f8b9-6af3-448f-b2f2-d02dfd79cc68',
//   'Milk Tank':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FMilk%20Tank.png?alt=media&token=aa87d3f4-3960-4d07-a055-da16e7c29090',
//   'Olive Oil':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FOlive%20Oil.png?alt=media&token=12f5ceea-58a5-4c0e-bae5-9fee7f3096c7',
//   'Onion':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FOnion.png?alt=media&token=fd5aa0c1-6bb2-486c-b264-9e6ab52ee3f9',
//   'Orange':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FOrange.png?alt=media&token=966f0f77-b485-43a6-b24a-aa2e8e9e1c46',
//   'Mushroom':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FMushroom.png?alt=media&token=8ea08697-70dc-4eb3-83e9-65aa5e4901bd',
//   'Papaya':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPapaya.png?alt=media&token=755d2317-fd9b-4b57-9a4e-d0d8886fbe18',
//   'Palm Oil':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPalm%20Oil.png?alt=media&token=000edfe0-2ca6-4039-9fc7-7e0fe6275a31',
//   'Peanut':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPeanut.png?alt=media&token=526e738c-fd57-4e97-9f15-ab57f051c89f',
//   'Potato':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPotato.png?alt=media&token=f80c79fe-f8f6-442a-a9dd-d759d02b90ee',
//   'Pomegranate':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPomegranate.png?alt=media&token=fcaec4a2-b1fc-4441-b9c6-b2d6cd0535bb',
//   'Pea':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPea.png?alt=media&token=56a65210-c18a-4632-b688-58f22733b4cc',
//   'Radish':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FRadish.png?alt=media&token=bb8632c5-854e-4e70-8501-bcaa12af309f',
//   'Seeds':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSeeds.png?alt=media&token=f67ee2ae-7f21-4fe3-b070-b07931e9e6e3',
//   'Pear':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPear.png?alt=media&token=e9f8124d-5d7d-4aae-a27e-c8c3619bd7ff',
//   'Planting':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPlanting.png?alt=media&token=3f591411-f0d4-406b-b4b0-b0fa9e7962da',
//   'Tamarind':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FTamarind.png?alt=media&token=c76905b3-1131-47d0-9b7c-9383770f1fe7',
//   'Tomato':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FTomato.png?alt=media&token=973d88af-6a5c-4dcc-9697-88a28702485e',
//   'Wheat':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FWheat.png?alt=media&token=0b025a66-d5f6-491a-acfd-c583203b22ec',
//   'Spinach':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSpinach.png?alt=media&token=59e56d71-a0a0-4be5-9394-53559d858aa0',
//   'Rice':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FRice.png?alt=media&token=f1cdb9a1-8f46-4fef-8fe4-d73cb01959d1',
//   'Seed':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSeed.png?alt=media&token=5ab3d61e-bf34-4e8f-aab6-738142ca421c',
//   'Sweet Potato':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSweet%20Potato.png?alt=media&token=703c613d-ff31-4889-b5c1-2772faf3cc25',
//   'Seeding':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSeeding.png?alt=media&token=1b756797-5acb-4af3-93a9-db5e63697207',
//   'Pineapple':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPineapple.png?alt=media&token=339ae686-08b5-4d9f-b466-041e533dd359',
//   'Pumpkin':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FPumpkin.png?alt=media&token=667c9527-8e38-4374-9fdf-2ed0a91e0ef9',
//   'Sapling':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSapling.png?alt=media&token=26cd42d0-644e-4a26-b2ca-bd73871ede0f',
//   'Sunflower Oil':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FfruitsAndVeg%2FSunflower%20Oil.png?alt=media&token=8a882cde-aeb4-4f7e-b4f1-40ab65f98785',
//   'Combine harvester':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FCombine%20harvester.png?alt=media&token=83f01c1d-df87-4da5-bd21-36c0c3eb5c8d',
//   'Backhoe':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FBackhoe.png?alt=media&token=c2b877fc-1a25-48dc-b616-08fac3ffecf4',
//   'Equipment':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FEquipment.png?alt=media&token=db7d9d2d-3ffa-4c1f-9921-ce1fa7307eb5',
//   'Billhook':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FBillhook.png?alt=media&token=dee1028c-9369-4949-89bf-c62a7c168a27',
//   'Gardening tools':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FGardening%20tools.png?alt=media&token=49fdce61-e190-426e-9e13-7b4222082caa',
//   'Electric scooter':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FElectric%20scooter.png?alt=media&token=c8b2999f-07ab-46d0-b0c7-42130546e4cd',
//   'Fan':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FFan.png?alt=media&token=4435275d-3365-46ee-9c4b-e68426a60cee',
//   'Scooter':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FScooter.png?alt=media&token=ac726aba-3129-4146-9869-2b0e82c42aa3',
//   'Loader':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FLoader.png?alt=media&token=b1613855-0554-4123-84ad-15d0133a5e29',
//   'Tractor':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FTractor.png?alt=media&token=42e725b1-8142-4258-a1a4-caafd6cf9ee8',
//   'Car':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FCar.png?alt=media&token=3b6f7331-7486-462d-9ade-ab9e28537384',
//   'Shredder':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FShredder.png?alt=media&token=51013d9e-da12-441e-8878-86d23b1b0d42',
//   'Plow':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FPlow.png?alt=media&token=f94691b1-4419-4f5d-9404-3a81a768e780',
// };

// var manAndMcs = {
//   'Combine harvester':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FCombine%20harvester.png?alt=media&token=83f01c1d-df87-4da5-bd21-36c0c3eb5c8d',
//   'Backhoe':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FBackhoe.png?alt=media&token=c2b877fc-1a25-48dc-b616-08fac3ffecf4',
//   'Equipment':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FEquipment.png?alt=media&token=db7d9d2d-3ffa-4c1f-9921-ce1fa7307eb5',
//   'Billhook':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FBillhook.png?alt=media&token=dee1028c-9369-4949-89bf-c62a7c168a27',
//   'Gardening tools':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FGardening%20tools.png?alt=media&token=49fdce61-e190-426e-9e13-7b4222082caa',
//   'Electric scooter':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FElectric%20scooter.png?alt=media&token=c8b2999f-07ab-46d0-b0c7-42130546e4cd',
//   'Fan':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FFan.png?alt=media&token=4435275d-3365-46ee-9c4b-e68426a60cee',
//   'Scooter':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FScooter.png?alt=media&token=ac726aba-3129-4146-9869-2b0e82c42aa3',
//   'Loader':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FLoader.png?alt=media&token=b1613855-0554-4123-84ad-15d0133a5e29',
//   'Tractor':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FTractor.png?alt=media&token=42e725b1-8142-4258-a1a4-caafd6cf9ee8',
//   'Car':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FCar.png?alt=media&token=3b6f7331-7486-462d-9ade-ab9e28537384',
//   'Shredder':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FShredder.png?alt=media&token=51013d9e-da12-441e-8878-86d23b1b0d42',
//   'Plow':
//       'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2FmanAndMcs%2FPlow.png?alt=media&token=f94691b1-4419-4f5d-9404-3a81a768e780',
// };

var SubSubCategoryList = {
  SubCategoryEnum.cows: [
    'Cows',
    'Black Cows',
    'White Cows',
  ],
  SubCategoryEnum.goats: [
    'Goats',
    'Black Goats',
    'White Goats',
  ],
  SubCategoryEnum.buffaloes: [
    'Buffaloes',
    'Black Buffaloes',
    'White Buffaloes',
  ],
  SubCategoryEnum.sheep: [
    'Sheep',
    'Black Sheep',
    'White Sheep',
  ],
  SubCategoryEnum.bull: [
    'Bull',
  ],
  SubCategoryEnum.pig: [
    'Pig',
  ],
  SubCategoryEnum.parrot: [
    'Parrot',
    'Green Parrot',
  ],
  SubCategoryEnum.pigeon: [
    'Pigeon',
    'White Pigeon',
  ],
  SubCategoryEnum.sparrow: [
    'Sparrow',
    'White Sparrow',
  ],
  SubCategoryEnum.duck: [
    'Duck',
  ],
  SubCategoryEnum.turkey: [
    'Turkey',
  ],
  SubCategoryEnum.beans: [
    'Beans',
    'Green Beans',
    'Red Beans',
  ],
  SubCategoryEnum.beetroot: [
    'Beetroot',
    'Red Beetroot',
  ],
  SubCategoryEnum.bitterground: [
    'Bitterground',
    'Green Bitterground',
  ],
  SubCategoryEnum.bottleground: [
    'Bottleground',
  ],
  SubCategoryEnum.brinjal: [
    'Brinjal',
  ],
  SubCategoryEnum.brocolli: [
    'Brocolli',
  ],
  SubCategoryEnum.barley: [
    'Barley',
    'Barley Green',
  ],
  SubCategoryEnum.bengalGram: [
    'Bengal Gram',
    'Bengal Gram Green',
  ],
  SubCategoryEnum.castor: [
    'Castor',
    'Castor Green',
  ],
  SubCategoryEnum.banana: [
    'Banana',
    'Banana Green',
  ],
  SubCategoryEnum.gauva: [
    'Guava',
    'Guava Green',
  ],
  SubCategoryEnum.grapes: [
    'Grapes Black',
    'Grapes Green',
    'Grapes Red',
  ],
  // SubCategoryEnum.laptop: [
  //   'Laptop',
  //   'Laptop Black',
  //   'Laptop White',
  // ],
  // SubCategoryEnum.tv: [
  //   'TV',
  //   'TV Black',
  //   'TV White',
  // ],
  SubCategoryEnum.jcb: [
    'On Rent',
    'Sell',
  ],
  SubCategoryEnum.tractor: [
    'On Rent',
    'Sell',
  ],
  SubCategoryEnum.rotavator: [
    'On Rent',
    'Sell',
  ],
  SubCategoryEnum.cultivator: [
    'On Rent',
    'Sell',
  ],
};

// animal images:
var animalAndBirdsImages = {
  'honey': 'assets/ikons/animals/honey.png',
  'veterinarian': 'assets/ikons/animals/veterinarian.png',
  'veterinary': 'assets/ikons/animals/veterinary.png',
  'shampoo': 'assets/ikons/animals/shampoo.png',
  'smoker': 'assets/ikons/animals/smoker.png',
  'rabbit': 'assets/ikons/animals/rabbit.png',
  'kennel': 'assets/ikons/animals/kennel.png',
  'milk tank': 'assets/ikons/animals/milk-tank.png',
  'pet food': 'assets/ikons/animals/pet-food.png',
  'pet supplies': 'assets/ikons/animals/pet-supplies.png',
  'dairy products': 'assets/ikons/animals/dairy-products.png',
  'dog-carrier': 'assets/ikons/animals/dog-carrier.png',
  'buffalo': 'assets/ikons/animals/buffalo.png',
  'cow': 'assets/ikons/animals/cow.png',
  'duck': 'assets/ikons/animals/duck.png',
  'bee': 'assets/ikons/animals/bee.png',
  'beehive': 'assets/ikons/animals/beehive.png',
  'hive': 'assets/ikons/animals/hive.png',
  'bird': 'assets/ikons/animals/bird.png',
  'donkey': 'assets/ikons/animals/donkey.png',
  'dog': 'assets/ikons/animals/dog.png',
  'fish': 'assets/ikons/animals/fish.png',
  'pig': 'assets/ikons/animals/pig.png',
  'pork': 'assets/ikons/animals/pork.png',
  'pills': 'assets/ikons/animals/pills.png',
  'sheep': 'assets/ikons/animals/sheep.png',
  'turkey': 'assets/ikons/animals/turkey.png',
  'hen': 'assets/ikons/animals/hen.png',
  'goat': 'assets/ikons/animals/goat.png',
  'fertilizer': 'assets/ikons/animals/fertilizer.png',
  'first aid kit': 'assets/ikons/animals/first-aid-kit.png',
  'cat': 'assets/ikons/animals/cat.png',
  'egg': 'assets/ikons/animals/egg.png',
  'emu': 'assets/ikons/animals/emu.png',
  'black cat': 'assets/ikons/animals/black-cat.png',
};
