import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;

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
  ],
  ParentEnum.food: [
    CategoryEnum.vegetables,
    CategoryEnum.fruits,
    CategoryEnum.crops,
  ],
  ParentEnum.machine: [
    CategoryEnum.electronics,
    CategoryEnum.jcb,
    CategoryEnum.equipments,
  ],
};

var subCategoryListsForCategory = {
  CategoryEnum.animals: [
    SubCategoryEnum.cows,
    SubCategoryEnum.goats,
    SubCategoryEnum.buffaloes,
  ],
  CategoryEnum.birds: [
    SubCategoryEnum.parrot,
    SubCategoryEnum.pigeon,
    SubCategoryEnum.sparrow,
  ],
  CategoryEnum.vegetables: [
    SubCategoryEnum.beans,
    SubCategoryEnum.beetroot,
    SubCategoryEnum.bitterground,
  ],
  CategoryEnum.fruits: [
    SubCategoryEnum.banana,
    SubCategoryEnum.gauva,
    SubCategoryEnum.grapes,
  ],
  CategoryEnum.crops: [
    SubCategoryEnum.barley,
    SubCategoryEnum.bengalGram,
    SubCategoryEnum.castor,
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

enum CategoryEnum {
  animals,
  birds,
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
};

enum SubCategoryEnum {
  // animals
  cows,
  goats,
  buffaloes,

  // birds
  parrot,
  pigeon,
  sparrow,

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
  SubCategoryEnum.parrot: "Parrot",
  SubCategoryEnum.pigeon: "Pigeon",
  SubCategoryEnum.sparrow: "Sparrow",
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
  // SubCategoryEnum.mobile: "Mobile",
  // SubCategoryEnum.laptop: "Laptop",
  // SubCategoryEnum.tv: "TV",
  // SubCategoryEnum.jcb: "JCB",
  // SubCategoryEnum.tractor: "Tractor",
  // SubCategoryEnum.rotavator: "Rotavator",
  // SubCategoryEnum.cultivator: "Cultivator",
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
  // SubCategoryEnum.jcb: [
  //   'JCB',
  //   'JCB Black',
  //   'JCB White',
  // ],
  // SubCategoryEnum.tractor: [
  //   'Tractor',
  //   'Tractor Black',
  //   'Tractor White',
  // ],
  // SubCategoryEnum.rotavator: [
  //   'Rotavator',
  //   'Rotavator Black',
  //   'Rotavator White',
  // ],
  // SubCategoryEnum.cultivator: [
  //   'Cultivator',
  //   'Cultivator Black',
  //   'Cultivator White',
  // ],
};
