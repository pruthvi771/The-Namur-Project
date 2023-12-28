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
    CategoryEnum.vehicles,
    CategoryEnum.equipments,
    CategoryEnum.tools,
  ],
  ParentEnum.land: [
    CategoryEnum.vehicles,
    CategoryEnum.equipments,
    CategoryEnum.tools,
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
    SubCategoryEnum.emu,
  ],
  CategoryEnum.supplies: [
    SubCategoryEnum.soaps,
    SubCategoryEnum.petShelters,
    SubCategoryEnum.transporters,
    SubCategoryEnum.cleaner,
    SubCategoryEnum.honeyTools,
    SubCategoryEnum.hive,
  ],
  CategoryEnum.vegetables: [
    SubCategoryEnum.beans,
    SubCategoryEnum.beetroot,
    SubCategoryEnum.bittergourd,
    SubCategoryEnum.bottlegourd,
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
  CategoryEnum.equipments: [
    SubCategoryEnum.mobile,
    SubCategoryEnum.laptop,
    SubCategoryEnum.tv,
  ],
  CategoryEnum.vehicles: [
    SubCategoryEnum.jcb,
    SubCategoryEnum.tractor,
    SubCategoryEnum.rotavator,
    SubCategoryEnum.cultivator,
    SubCategoryEnum.Loader,
    SubCategoryEnum.Backhoe,
  ],
  CategoryEnum.tools: [
    SubCategoryEnum.ElectricScooter,
    SubCategoryEnum.Equipment,
    SubCategoryEnum.Scooter,
    SubCategoryEnum.Fan,
    SubCategoryEnum.GardeningTools,
    SubCategoryEnum.Plow,
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
  // electronics,
  // jcb,
  // equipments,
  vehicles,
  equipments,
  tools,
}

var nameForCategoryEnum = {
  CategoryEnum.animals: "Animals",
  CategoryEnum.birds: "Birds",
  CategoryEnum.crops: "Grains/Pulses",
  CategoryEnum.vegetables: "Vegetables",
  CategoryEnum.fruits: "Fruits",
  // CategoryEnum.electronics: "Electronics",
  // CategoryEnum.jcb: "JCB",
  CategoryEnum.vehicles: "Vehicles",
  CategoryEnum.tools: "Tools",
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
  emu,

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
  bittergourd,
  bottlegourd,
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
  Backhoe,
  Billhook,
  Car,
  CombineHarvester,
  ElectricScooter,
  Equipment,
  Fan,
  GardeningTools,
  Loader,
  Plow,
  Scooter,
  Shredder,
  Tractor,

  // supplies
  soaps,
  petShelters,
  transporters,
  cleaner,
  honeyTools,
  hive,
}

// String translatedNameForSubCategoryEnum({
//   required SubCategoryEnum subCategory,
//   required BuildContext context,
// }) {
//   switch (subCategory) {
//     case SubCategoryEnum.cows:
//       return AppLocalizations.of(context)!.cows;
//     case SubCategoryEnum.goats:
//       return AppLocalizations.of(context)!.goats;
//     case SubCategoryEnum.buffaloes:
//       return AppLocalizations.of(context)!.buffaloes;
//     case SubCategoryEnum.sheep:
//       return AppLocalizations.of(context)!.sheep;
//     case SubCategoryEnum.bull:
//       return AppLocalizations.of(context)!.bull;
//     case SubCategoryEnum.pig:
//       return AppLocalizations.of(context)!.pig;
//     case SubCategoryEnum.parrot:
//       return AppLocalizations.of(context)!.parrot;
//     case SubCategoryEnum.pigeon:
//       return AppLocalizations.of(context)!.pigeon;
//     case SubCategoryEnum.sparrow:
//       return AppLocalizations.of(context)!.sparrow;
//     case SubCategoryEnum.duck:
//       return AppLocalizations.of(context)!.duck;
//     case SubCategoryEnum.turkey:
//       return AppLocalizations.of(context)!.turkey;
//     case SubCategoryEnum.barley:
//       return AppLocalizations.of(context)!.barley;
//     case SubCategoryEnum.bengalGram:
//       return AppLocalizations.of(context)!.bengalGram;
//     case SubCategoryEnum.castor:
//       return AppLocalizations.of(context)!.castor;
//     case SubCategoryEnum.cotton:
//       return AppLocalizations.of(context)!.cotton;
//     case SubCategoryEnum.groundnut:
//       return AppLocalizations.of(context)!.groundnut;
//     case SubCategoryEnum.jute:
//       return AppLocalizations.of(context)!.jute;
//     case SubCategoryEnum.linseed:
//       return AppLocalizations.of(context)!.linseed;
//     case SubCategoryEnum.maize:
//       return AppLocalizations.of(context)!.maize;
//     case SubCategoryEnum.mustard:
//       return AppLocalizations.of(context)!.mustard;
//     case SubCategoryEnum.pearlMillet:
//       return AppLocalizations.of(context)!.pearlMillet;
//     case SubCategoryEnum.rabiMaize:
//       return AppLocalizations.of(context)!.rabiMaize;
//     case SubCategoryEnum.soybean:
//       return AppLocalizations.of(context)!.soybean;
//     case SubCategoryEnum.sunflower:
//       return AppLocalizations.of(context)!.sunflower;
//     case SubCategoryEnum.tobacco:
//       return AppLocalizations.of(context)!.tobacco;
//     case SubCategoryEnum.turmeric:
//       return AppLocalizations.of(context)!.turmeric;
//     case SubCategoryEnum.wheat:
//       return AppLocalizations.of(context)!.wheat;
//     case SubCategoryEnum.rice:
//       return AppLocalizations.of(context)!.rice;
//     case SubCategoryEnum.jower:
//       return AppLocalizations.of(context)!.jower;
//     case SubCategoryEnum.coffee:
//       return AppLocalizations.of(context)!.coffee;
//     case SubCategoryEnum.tea:
//       return AppLocalizations.of(context)!.tea;
//     case SubCategoryEnum.pepper:
//       return AppLocalizations.of(context)!.pepper;
//     case SubCategoryEnum.coconut:
//       return AppLocalizations.of(context)!.coconut;
//     case SubCategoryEnum.arecanut:
//       return AppLocalizations.of(context)!.arecanut;
//     case SubCategoryEnum.horsegram:
//       return AppLocalizations.of(context)!.horsegram;
//     case SubCategoryEnum.ragi:
//       return AppLocalizations.of(context)!.ragi;
//     case SubCategoryEnum.chikpea:
//       return AppLocalizations.of(context)!.chikpea;
//     case SubCategoryEnum.jaggery:
//       return AppLocalizations.of(context)!.jaggery;
//     case SubCategoryEnum.tamrind:
//       return AppLocalizations.of(context)!.tamrind;
//     case SubCategoryEnum.cashew:
//       return AppLocalizations.of(context)!.cashew;
//     case SubCategoryEnum.palmOil:
//       return AppLocalizations.of(context)!.palmOil;
//     case SubCategoryEnum.greengram:
//       return AppLocalizations.of(context)!.greengram;
//     case SubCategoryEnum.arbi:
//       return AppLocalizations.of(context)!.arbi;
//     case SubCategoryEnum.ber:
//       return AppLocalizations.of(context)!.ber;
//     case SubCategoryEnum.cowPea:
//       return AppLocalizations.of(context)!.cowPea;
//     case SubCategoryEnum.cumin:
//       return AppLocalizations.of(context)!.cumin;
//     case SubCategoryEnum.kinnow:
//       return AppLocalizations.of(context)!.kinnow;
//     case SubCategoryEnum.lentil:
//       return AppLocalizations.of(context)!.lentil;
//     case SubCategoryEnum.litchi:
//       return AppLocalizations.of(context)!.litchi;
//     case SubCategoryEnum.okra:
//       return AppLocalizations.of(context)!.okra;
//     case SubCategoryEnum.pigenopea:
//       return AppLocalizations.of(context)!.pigenopea;
//     case SubCategoryEnum.ridgedGround:
//       return AppLocalizations.of(context)!.ridgedGround;
//     case SubCategoryEnum.sorghum:
//       return AppLocalizations.of(context)!.sorghum;
//     case SubCategoryEnum.sugarcane:
//       return AppLocalizations.of(context)!.sugarcane;
//     case SubCategoryEnum.tuberose:
//       return AppLocalizations.of(context)!.tuberose;
//     case SubCategoryEnum.beans:
//       return AppLocalizations.of(context)!.beans;
//     case SubCategoryEnum.beetroot:
//       return AppLocalizations.of(context)!.beetroot;
//     case SubCategoryEnum.bittergourd:
//       return AppLocalizations.of(context)!.bittergourd;
//     case SubCategoryEnum.bottlegourd:
//       return AppLocalizations.of(context)!.bottlegourd;
//     case SubCategoryEnum.brinjal:
//       return AppLocalizations.of(context)!.brinjal;
//     case SubCategoryEnum.brocolli:
//       return AppLocalizations.of(context)!.brocolli;
//     case SubCategoryEnum.cabbage:
//       return AppLocalizations.of(context)!.cabbage;
//     case SubCategoryEnum.capsicum:
//       return AppLocalizations.of(context)!.capsicum;
//     case SubCategoryEnum.carrot:
//       return AppLocalizations.of(context)!.carrot;
//     case SubCategoryEnum.cauliflower:
//       return AppLocalizations.of(context)!.cauliflower;
//     case SubCategoryEnum.chikPeas:
//       return AppLocalizations.of(context)!.chikPeas;
//     case SubCategoryEnum.chilli:
//       return AppLocalizations.of(context)!.chilli;
//     case SubCategoryEnum.clusterBean:
//       return AppLocalizations.of(context)!.clusterBean;
//     case SubCategoryEnum.coriander:
//       return AppLocalizations.of(context)!.coriander;
//     case SubCategoryEnum.cucumber:
//       return AppLocalizations.of(context)!.cucumber;
//     case SubCategoryEnum.drumstick:
//       return AppLocalizations.of(context)!.drumstick;
//     case SubCategoryEnum.frenchBeans:
//       return AppLocalizations.of(context)!.frenchBeans;
//     case SubCategoryEnum.ginger:
//       return AppLocalizations.of(context)!.ginger;
//     case SubCategoryEnum.greenpeas:
//       return AppLocalizations.of(context)!.greenpeas;
//     case SubCategoryEnum.IvyGround:
//       return AppLocalizations.of(context)!.ivyGround;
//     case SubCategoryEnum.lemon:
//       return AppLocalizations.of(context)!.lemon;
//     case SubCategoryEnum.mentha:
//       return AppLocalizations.of(context)!.mentha;
//     case SubCategoryEnum.pointedGround:
//       return AppLocalizations.of(context)!.pointedGround;
//     case SubCategoryEnum.potato:
//       return AppLocalizations.of(context)!.potato;
//     case SubCategoryEnum.pumpkin:
//       return AppLocalizations.of(context)!.pumpkin;
//     case SubCategoryEnum.raddish:
//       return AppLocalizations.of(context)!.raddish;
//     case SubCategoryEnum.snakeGround:
//       return AppLocalizations.of(context)!.snakeGround;
//     case SubCategoryEnum.spinach:
//       return AppLocalizations.of(context)!.spinach;
//     case SubCategoryEnum.spongeGround:
//       return AppLocalizations.of(context)!.spongeGround;
//     case SubCategoryEnum.tomato:
//       return AppLocalizations.of(context)!.tomato;
//     case SubCategoryEnum.sweetPotato:
//       return AppLocalizations.of(context)!.sweetPotato;
//     case SubCategoryEnum.mashroom:
//       return AppLocalizations.of(context)!.mashroom;
//     case SubCategoryEnum.ladyFinger:
//       return AppLocalizations.of(context)!.ladyFinger;
//     case SubCategoryEnum.babycorn:
//       return AppLocalizations.of(context)!.babycorn;
//     case SubCategoryEnum.milk:
//       return AppLocalizations.of(context)!.milk;
//     case SubCategoryEnum.onions:
//       return AppLocalizations.of(context)!.onions;
//     case SubCategoryEnum.garlic:
//       return AppLocalizations.of(context)!.garlic;
//     case SubCategoryEnum.amla:
//       return AppLocalizations.of(context)!.amla;
//     case SubCategoryEnum.banana:
//       return AppLocalizations.of(context)!.banana;
//     case SubCategoryEnum.gauva:
//       return AppLocalizations.of(context)!.gauva;
//     case SubCategoryEnum.grapes:
//       return AppLocalizations.of(context)!.grapes;
//     case SubCategoryEnum.jackfruit:
//       return AppLocalizations.of(context)!.jackfruit;
//     case SubCategoryEnum.mango:
//       return AppLocalizations.of(context)!.mango;
//     case SubCategoryEnum.muskmelon:
//       return AppLocalizations.of(context)!.muskmelon;
//     case SubCategoryEnum.pineapple:
//       return AppLocalizations.of(context)!.pineapple;
//     case SubCategoryEnum.sapota:
//       return AppLocalizations.of(context)!.sapota;
//     case SubCategoryEnum.watermelon:
//       return AppLocalizations.of(context)!.watermelon;
//     case SubCategoryEnum.orange:
//       return AppLocalizations.of(context)!.orange;
//     case SubCategoryEnum.strawberry:
//       return AppLocalizations.of(context)!.strawberry;
//     case SubCategoryEnum.custardApple:
//       return AppLocalizations.of(context)!.custardApple;
//     case SubCategoryEnum.papaya:
//       return AppLocalizations.of(context)!.papaya;
//     case SubCategoryEnum.pomegranate:
//       return AppLocalizations.of(context)!.pomegranate;
//     case SubCategoryEnum.apple:
//       return AppLocalizations.of(context)!.apple;
//     case SubCategoryEnum.MarasebuPear:
//       return AppLocalizations.of(context)!.marasebuPear;
//     case SubCategoryEnum.mosambi:
//       return AppLocalizations.of(context)!.mosambi;
//     case SubCategoryEnum.muskMelon:
//       return AppLocalizations.of(context)!.muskMelon;
//     case SubCategoryEnum.tenderCoconut:
//       return AppLocalizations.of(context)!.tenderCoconut;
//     case SubCategoryEnum.dates:
//       return AppLocalizations.of(context)!.dates;
//     case SubCategoryEnum.resins:
//       return AppLocalizations.of(context)!.resins;
//     case SubCategoryEnum.fig:
//       return AppLocalizations.of(context)!.fig;
//     case SubCategoryEnum.jamun:
//       return AppLocalizations.of(context)!.jamun;
//     case SubCategoryEnum.rose:
//       return AppLocalizations.of(context)!.rose;
//     case SubCategoryEnum.marigold:
//       return AppLocalizations.of(context)!.marigold;
//     case SubCategoryEnum.egg:
//       return AppLocalizations.of(context)!.egg;
//     case SubCategoryEnum.chicken:
//       return AppLocalizations.of(context)!.chicken;
//     case SubCategoryEnum.mobile:
//       return AppLocalizations.of(context)!.mobile;
//     case SubCategoryEnum.laptop:
//       return AppLocalizations.of(context)!.laptop;
//     case SubCategoryEnum.tv:
//       return AppLocalizations.of(context)!.tv;
//     case SubCategoryEnum.jcb:
//       return AppLocalizations.of(context)!.jcb;
//     case SubCategoryEnum.tractor:
//       return AppLocalizations.of(context)!.tractor;
//     case SubCategoryEnum.rotavator:
//       return AppLocalizations.of(context)!.rotavator;
//     case SubCategoryEnum.cultivator:
//       return AppLocalizations.of(context)!.cultivator;
//     default:
//       return nameForSubCategoryEnum[subCategory]!;
//   }
// }

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
  SubCategoryEnum.bittergourd: "bittergourd",
  SubCategoryEnum.bottlegourd: "bottlegourd",
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
  SubCategoryEnum.Backhoe: "Backhoe",
  SubCategoryEnum.Billhook: "Billhook",
  SubCategoryEnum.Car: "Car",
  SubCategoryEnum.CombineHarvester: "Combine Harvester",
  SubCategoryEnum.ElectricScooter: "Electric Scooter",
  SubCategoryEnum.Equipment: "Equipment",
  SubCategoryEnum.Fan: "Fan",
  SubCategoryEnum.GardeningTools: "Gardening Tools",
  SubCategoryEnum.Loader: "Loader",
  SubCategoryEnum.Plow: "Plow",
  SubCategoryEnum.Scooter: "Scooter",
  SubCategoryEnum.Shredder: "Shredder",
  SubCategoryEnum.Tractor: "Tractor",
  SubCategoryEnum.emu: "Emu",
  SubCategoryEnum.soaps: 'Soaps',
  SubCategoryEnum.petShelters: 'Pet Shelters',
  SubCategoryEnum.transporters: 'Transporters',
  SubCategoryEnum.cleaner: 'Cleaner',
  SubCategoryEnum.honeyTools: 'Honey Tools',
  SubCategoryEnum.hive: 'Hive',
};

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
  SubCategoryEnum.bittergourd: [
    'bittergourd',
    'Green bittergourd',
  ],
  SubCategoryEnum.bottlegourd: [
    'bottlegourd',
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

var animalsList = [
  'Parrot',
  'Pigeon',
  'Sparrow',
  'Bull',
  'Rabbit',
  'Buffalo',
  'Bee',
  'Duck',
  'Donkey',
  'Dog',
  'Cow',
  'Fish',
  'Pig',
  'Pork',
  'Sheep',
  'Turkey',
  'Hen',
  'Goat',
  'Emu',
  'Cat',
  'Black Cat',
];
