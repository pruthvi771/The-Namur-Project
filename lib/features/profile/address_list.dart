import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Capitalized on String {
  String capitalized() =>
      this.substring(0, 1).toUpperCase() + this.substring(1).toLowerCase();
}

String translatedName({
  required String name,
  required BuildContext context,
}) {
  switch (name) {
    case 'banana':
      return AppLocalizations.of(context)!.banana;
    case 'N/A':
      return 'N/A';
    case 'beetroot':
      return AppLocalizations.of(context)!.beetroot;
    case 'betel nut':
      return AppLocalizations.of(context)!.betelnut;
    case 'cabbage':
      return AppLocalizations.of(context)!.cabbage;
    case 'capsicum':
      return AppLocalizations.of(context)!.capsicum;
    case 'carrot':
      return AppLocalizations.of(context)!.carrot;
    case 'cashew':
      return AppLocalizations.of(context)!.cashew;
    case 'cauliflower':
      return AppLocalizations.of(context)!.cauliflower;
    case 'cereal':
      return AppLocalizations.of(context)!.cereal;
    case 'chili':
      return AppLocalizations.of(context)!.chili;
    case 'chilli':
      return AppLocalizations.of(context)!.chilli;
    case 'coconut tree':
      return AppLocalizations.of(context)!.coconuttree;
    case 'coconut':
      return AppLocalizations.of(context)!.coconut;
    case 'coffee':
      return AppLocalizations.of(context)!.coffee;
    case 'coriander':
      return AppLocalizations.of(context)!.coriander;
    case 'corn':
      return AppLocalizations.of(context)!.corn;
    case 'cotton':
      return AppLocalizations.of(context)!.cotton;
    case 'cucumber':
      return AppLocalizations.of(context)!.cucumber;
    case 'drumstick':
      return AppLocalizations.of(context)!.drumstick;
    case 'eggplant':
      return AppLocalizations.of(context)!.eggplant;
    case 'food':
      return AppLocalizations.of(context)!.food;
    case 'ginger':
      return AppLocalizations.of(context)!.ginger;
    case 'grape':
      return AppLocalizations.of(context)!.grape;
    case 'grapes black dry':
      return AppLocalizations.of(context)!.grapesblackdry;
    case 'grapes black':
      return AppLocalizations.of(context)!.grapesblack;
    case 'grapes green':
      return AppLocalizations.of(context)!.grapesgreen;
    case 'grapes red':
      return AppLocalizations.of(context)!.grapesred;
    case 'green beans':
      return AppLocalizations.of(context)!.greenbeans;
    case 'green onion':
      return AppLocalizations.of(context)!.greenonion;
    case 'green tea':
      return AppLocalizations.of(context)!.greentea;
    case 'jackfruit':
      return AppLocalizations.of(context)!.jackfruit;
    case 'jaggery':
      return AppLocalizations.of(context)!.jaggery;
    case 'jar':
      return AppLocalizations.of(context)!.jar;
    case 'lemon':
      return AppLocalizations.of(context)!.lemon;
    case 'mango':
      return AppLocalizations.of(context)!.mango;
    case 'marijuana':
      return AppLocalizations.of(context)!.marijuana;
    case 'milk tank':
      return AppLocalizations.of(context)!.milktank;
    case 'mushroom':
      return AppLocalizations.of(context)!.mushroom;
    case 'olive oil':
      return AppLocalizations.of(context)!.oliveoil;
    case 'onion':
      return AppLocalizations.of(context)!.onion;
    case 'orange':
      return AppLocalizations.of(context)!.orange;
    case 'palm oil':
      return AppLocalizations.of(context)!.palmOil;
    case 'papaya':
      return AppLocalizations.of(context)!.papaya;
    case 'pea':
      return AppLocalizations.of(context)!.pea;
    case 'peanut':
      return AppLocalizations.of(context)!.peanut;
    case 'pear':
      return AppLocalizations.of(context)!.pear;
    case 'pineapple':
      return AppLocalizations.of(context)!.pineapple;
    case 'pomegranate':
      return AppLocalizations.of(context)!.pomegranate;
    case 'potato':
      return AppLocalizations.of(context)!.potato;
    case 'pumpkin':
      return AppLocalizations.of(context)!.pumpkin;
    case 'radish':
      return AppLocalizations.of(context)!.radish;
    case 'rice':
      return AppLocalizations.of(context)!.rice;
    case 'sapling':
      return AppLocalizations.of(context)!.sapling;
    case 'seed':
      return AppLocalizations.of(context)!.seed;
    case 'spinach':
      return AppLocalizations.of(context)!.spinach;
    case 'sunflower oil':
      return AppLocalizations.of(context)!.sunfloweroil;
    case 'sweet potato':
      return AppLocalizations.of(context)!.sweetPotato;
    case 'tamarind':
      return AppLocalizations.of(context)!.tamarind;
    case 'tomato':
      return AppLocalizations.of(context)!.tomato;
    case 'wheat':
      return AppLocalizations.of(context)!.wheat;
    case 'cows':
      return AppLocalizations.of(context)!.cows;
    case 'goats':
      return AppLocalizations.of(context)!.goats;
    case 'buffaloes':
      return AppLocalizations.of(context)!.buffaloes;
    case 'sheep':
      return AppLocalizations.of(context)!.sheep;
    case 'bull':
      return AppLocalizations.of(context)!.bull;
    case 'pig':
      return AppLocalizations.of(context)!.pig;
    case 'parrot':
      return AppLocalizations.of(context)!.parrot;
    case 'pigeon':
      return AppLocalizations.of(context)!.pigeon;
    case 'sparrow':
      return AppLocalizations.of(context)!.sparrow;
    case 'duck':
      return AppLocalizations.of(context)!.duck;
    case 'turkey':
      return AppLocalizations.of(context)!.turkey;
    case 'barley':
      return AppLocalizations.of(context)!.barley;
    case 'bengal gram':
      return AppLocalizations.of(context)!.bengalGram;
    case 'castor':
      return AppLocalizations.of(context)!.castor;
    case 'groundnut':
      return AppLocalizations.of(context)!.groundnut;
    case 'jute':
      return AppLocalizations.of(context)!.jute;
    case 'linseed':
      return AppLocalizations.of(context)!.linseed;
    case 'maize':
      return AppLocalizations.of(context)!.maize;
    case 'mustard':
      return AppLocalizations.of(context)!.mustard;
    case 'pearl millet':
      return AppLocalizations.of(context)!.pearlMillet;
    case 'rabi maize':
      return AppLocalizations.of(context)!.rabiMaize;
    case 'soybean':
      return AppLocalizations.of(context)!.soybean;
    case 'sunflower':
      return AppLocalizations.of(context)!.sunflower;
    case 'tobacco':
      return AppLocalizations.of(context)!.tobacco;
    case 'turmeric':
      return AppLocalizations.of(context)!.turmeric;
    case 'jower':
      return AppLocalizations.of(context)!.jower;
    case 'tea':
      return AppLocalizations.of(context)!.tea;
    case 'pepper':
      return AppLocalizations.of(context)!.pepper;
    case 'arecanut':
      return AppLocalizations.of(context)!.arecanut;
    case 'horsegram':
      return AppLocalizations.of(context)!.horsegram;
    case 'ragi':
      return AppLocalizations.of(context)!.ragi;
    case 'chikpea':
      return AppLocalizations.of(context)!.chikpea;
    case 'tamrind':
      return AppLocalizations.of(context)!.tamrind;
    case 'greengram':
      return AppLocalizations.of(context)!.greengram;
    case 'arbi':
      return AppLocalizations.of(context)!.arbi;
    case 'ber':
      return AppLocalizations.of(context)!.ber;
    case 'cow pea':
      return AppLocalizations.of(context)!.cowPea;
    case 'cumin':
      return AppLocalizations.of(context)!.cumin;
    case 'kinnow':
      return AppLocalizations.of(context)!.kinnow;
    case 'lentil':
      return AppLocalizations.of(context)!.lentil;
    case 'litchi':
      return AppLocalizations.of(context)!.litchi;
    case 'okra':
      return AppLocalizations.of(context)!.okra;
    case 'pigenopea':
      return AppLocalizations.of(context)!.pigenopea;
    case 'ridged ground':
      return AppLocalizations.of(context)!.ridgedGround;
    case 'sorghum':
      return AppLocalizations.of(context)!.sorghum;
    case 'sugarcane':
      return AppLocalizations.of(context)!.sugarcane;
    case 'tuberose':
      return AppLocalizations.of(context)!.tuberose;
    case 'beans':
      return AppLocalizations.of(context)!.beans;
    case 'bittergourd':
      return AppLocalizations.of(context)!.bittergourd;
    case 'bottlegourd':
      return AppLocalizations.of(context)!.bottlegourd;
    case 'brinjal':
      return AppLocalizations.of(context)!.brinjal;
    case 'brocolli':
      return AppLocalizations.of(context)!.brocolli;
    case 'chickpeas':
      return AppLocalizations.of(context)!.chikPeas;
    case 'cluster bean':
      return AppLocalizations.of(context)!.clusterBean;
    case 'french beans':
      return AppLocalizations.of(context)!.frenchBeans;
    case 'green peas':
      return AppLocalizations.of(context)!.greenpeas;
    case 'ivy ground':
      return AppLocalizations.of(context)!.ivyGround;
    case 'mint':
      return AppLocalizations.of(context)!.mentha;
    case 'pointed ground':
      return AppLocalizations.of(context)!.pointedGround;
    case 'snake ground':
      return AppLocalizations.of(context)!.snakeGround;
    case 'sponge ground':
      return AppLocalizations.of(context)!.spongeGround;
    case 'ladyfinger':
      return AppLocalizations.of(context)!.ladyFinger;
    case 'baby corn':
      return AppLocalizations.of(context)!.babycorn;
    case 'milk':
      return AppLocalizations.of(context)!.milk;
    case 'onions':
      return AppLocalizations.of(context)!.onions;
    case 'garlic':
      return AppLocalizations.of(context)!.garlic;
    case 'amla':
      return AppLocalizations.of(context)!.amla;
    case 'guava':
      return AppLocalizations.of(context)!.guava;
    case 'grapes':
      return AppLocalizations.of(context)!.grapes;
    case 'muskmelon':
      return AppLocalizations.of(context)!.muskmelon;
    case 'sapota':
      return AppLocalizations.of(context)!.sapota;
    case 'watermelon':
      return AppLocalizations.of(context)!.watermelon;
    case 'strawberry':
      return AppLocalizations.of(context)!.strawberry;
    case 'custard apple':
      return AppLocalizations.of(context)!.custardApple;
    case 'apple':
      return AppLocalizations.of(context)!.apple;
    case 'marasebu pear':
      return AppLocalizations.of(context)!.marasebuPear;
    case 'mosambi':
      return AppLocalizations.of(context)!.mosambi;
    case 'musk melon':
      return AppLocalizations.of(context)!.muskMelon;
    case 'tender coconut':
      return AppLocalizations.of(context)!.tenderCoconut;
    case 'dates':
      return AppLocalizations.of(context)!.dates;
    case 'resins':
      return AppLocalizations.of(context)!.resins;
    case 'fig':
      return AppLocalizations.of(context)!.fig;
    case 'jamun':
      return AppLocalizations.of(context)!.jamun;
    case 'rose':
      return AppLocalizations.of(context)!.rose;
    case 'marigold':
      return AppLocalizations.of(context)!.marigold;
    case 'egg':
      return AppLocalizations.of(context)!.egg;
    case 'chicken':
      return AppLocalizations.of(context)!.chicken;
    case 'mobile':
      return AppLocalizations.of(context)!.mobile;
    case 'laptop':
      return AppLocalizations.of(context)!.laptop;
    case 'tv':
      return AppLocalizations.of(context)!.tv;
    case 'jcb':
      return AppLocalizations.of(context)!.jcb;
    case 'tractor':
      return AppLocalizations.of(context)!.tractor;
    case 'rotavator':
      return AppLocalizations.of(context)!.rotavator;
    case 'cultivator':
      return AppLocalizations.of(context)!.cultivator;
    case 'backhoe':
      return "jcb";
    case 'billhook':
      return AppLocalizations.of(context)!.billhook;
    case 'car':
      return AppLocalizations.of(context)!.car;
    case 'combine harvester':
      return AppLocalizations.of(context)!.combine_harvester;
    case 'electric scooter':
      return AppLocalizations.of(context)!.electric_scooter;
    case 'equipment':
      return AppLocalizations.of(context)!.equipment;
    case 'fan':
      return AppLocalizations.of(context)!.fan;
    case 'gardening tools':
      return AppLocalizations.of(context)!.gardening_tools;
    case 'loader':
      return AppLocalizations.of(context)!.loader;
    case 'plow':
      return AppLocalizations.of(context)!.plow;
    case 'scooter':
      return AppLocalizations.of(context)!.scooter;
    case 'shredder':
      return AppLocalizations.of(context)!.shredder;
    case 'soaps':
      return AppLocalizations.of(context)!.soaps;
    case 'pet shelters':
      return AppLocalizations.of(context)!.petShelters;
    case 'transporters':
      return AppLocalizations.of(context)!.transporters;
    case 'cleaner':
      return AppLocalizations.of(context)!.cleaner;
    case 'honey tools':
      return AppLocalizations.of(context)!.honeyTools;
    case 'hive':
      return AppLocalizations.of(context)!.hive;
    case 'dairy products':
      return AppLocalizations.of(context)!.dairy_products;
    case 'honey':
      return AppLocalizations.of(context)!.honey;
    case 'pets':
      return AppLocalizations.of(context)!.pets;
    case 'other animals':
      return AppLocalizations.of(context)!.other_animals;
    case 'fish':
      return AppLocalizations.of(context)!.fish;
    case 'chicks':
      return AppLocalizations.of(context)!.chicks;
    case 'other birds':
      return AppLocalizations.of(context)!.other_birds;
    case 'pet food':
      return AppLocalizations.of(context)!.pet_food;
    case 'vet doctor':
      return AppLocalizations.of(context)!.vet_doctor;
    case 'pet medicine':
      return AppLocalizations.of(context)!.pet_medicine;
    case 'pet daily care':
      return AppLocalizations.of(context)!.pet_daily_care;
    case 'bee tools':
      return AppLocalizations.of(context)!.bee_tools;
    case 'pet toy tools':
      return AppLocalizations.of(context)!.pet_toy_tools;
    case 'other supplies':
      return AppLocalizations.of(context)!.other_supplies;
    case 'herekai sorekai agalkai':
      return AppLocalizations.of(context)!.herekai_sorekai_agalkai;
    case 'areca':
      return AppLocalizations.of(context)!.areca;
    case 'root veggi':
      return AppLocalizations.of(context)!.root_veggi;
    case 'other vegetables':
      return AppLocalizations.of(context)!.other_vegetables;
    case 'sapodilla':
      return AppLocalizations.of(context)!.sapodilla;
    case 'melon':
      return AppLocalizations.of(context)!.melon;
    case 'jamun fruit':
      return AppLocalizations.of(context)!.jamun_fruit;
    case 'berrys':
      return AppLocalizations.of(context)!.berrys;
    case 'fruit juice':
      return AppLocalizations.of(context)!.fruit_juice;
    case 'ragi millets':
      return AppLocalizations.of(context)!.ragi_millet;
    case 'millets':
      return AppLocalizations.of(context)!.millets;
    case 'oil seeds':
      return AppLocalizations.of(context)!.oil_seeds;
    case 'grams':
      return AppLocalizations.of(context)!.grams;
    case 'spices':
      return AppLocalizations.of(context)!.spices;
    case 'beverage crop':
      return AppLocalizations.of(context)!.beverage_crop;
    case 'sweeteners':
      return AppLocalizations.of(context)!.sweeteners;
    case 'other crops':
      return AppLocalizations.of(context)!.other_crops;
    case 'other fruits':
      return AppLocalizations.of(context)!.other_fruits;
    case 'tiller':
      return AppLocalizations.of(context)!.tiller;
    case 'tractor big mini':
      return AppLocalizations.of(context)!.tractor_big_mini;
    case 'sprayer planter':
      return AppLocalizations.of(context)!.sprayer_planter;
    case 'truck big mini':
      return AppLocalizations.of(context)!.truck_big_mini;
    case 'water tanker':
      return AppLocalizations.of(context)!.water_tanker;
    case 'trailer attachments':
      return AppLocalizations.of(context)!.trailer_attachments;
    case 'taxi':
      return AppLocalizations.of(context)!.taxi;
    case 'logistics':
      return AppLocalizations.of(context)!.logistics;
    case 'maintenance':
      return AppLocalizations.of(context)!.maintenance;
    case 'other machines':
      return AppLocalizations.of(context)!.other_machines;
    case 'areca machines':
      return AppLocalizations.of(context)!.areca_machines;
    case 'soil testing':
      return AppLocalizations.of(context)!.soil_testing;
    case 'areca polisher':
      return AppLocalizations.of(context)!.areca_polisher;
    case 'leveler':
      return AppLocalizations.of(context)!.leveler;
    case 'auger drill':
      return AppLocalizations.of(context)!.auger_drill;
    case 'brush cutter':
      return AppLocalizations.of(context)!.brush_cutter;
    case 'chainsaw':
      return AppLocalizations.of(context)!.chainsaw;
    case 'lawnmower':
      return AppLocalizations.of(context)!.lawnmower;
    case 'water pump':
      return AppLocalizations.of(context)!.water_pump;
    case 'welding':
      return AppLocalizations.of(context)!.welding;
    case 'wheelbarrow':
      return AppLocalizations.of(context)!.wheelbarrow;
    case 'water hose':
      return AppLocalizations.of(context)!.water_hose;
    case 'other attachments':
      return AppLocalizations.of(context)!.other_attachments;
    case 'pipe drip sprinkler':
      return AppLocalizations.of(context)!.pipe_drip_sprinkler;
    case 'starter borewell':
      return AppLocalizations.of(context)!.starter_borewell;
    case 'drone services':
      return AppLocalizations.of(context)!.drone_services;
    case 'warehouse greenhouse':
      return AppLocalizations.of(context)!.warehouse_greenhouse;
    case 'farm security':
      return AppLocalizations.of(context)!.farm_security;
    case 'smart irrigation':
      return AppLocalizations.of(context)!.smart_irrigation;
    case 'smart farm':
      return AppLocalizations.of(context)!.smart_farm;
    case 'solar pump':
      return AppLocalizations.of(context)!.solar_pump;
    case 'solar energy':
      return AppLocalizations.of(context)!.solar_energy;
    case 'crop doctor':
      return AppLocalizations.of(context)!.crop_doctor;
    case 'finance service':
      return AppLocalizations.of(context)!.finance_service;
    case 'soft toys':
      return AppLocalizations.of(context)!.soft_toys;
    case 'electronic toys':
      return AppLocalizations.of(context)!.electronic_toys;
    case 'wooden toys':
      return AppLocalizations.of(context)!.wooden_toys;
    case 'misc':
      return AppLocalizations.of(context)!.misc;
    case 'other tools':
      return AppLocalizations.of(context)!.other_tools;
    case 'other toys':
      return AppLocalizations.of(context)!.other_toys;
    case 'other services':
      return AppLocalizations.of(context)!.other_services;
    case 'rental property':
      return AppLocalizations.of(context)!.rental_property;
    case 'farm stay':
      return AppLocalizations.of(context)!.farm_stay;
    case 'farm rental':
      return AppLocalizations.of(context)!.farm_rental;
    case 'buy & sale':
      return AppLocalizations.of(context)!.buy_n_sale;
    case 'farm labour':
      return AppLocalizations.of(context)!.farm_labour;
    case 'greenhouse':
      return AppLocalizations.of(context)!.greenhouse;
    case 'other properties':
      return AppLocalizations.of(context)!.other_property;
    case 'sensors meters':
      return AppLocalizations.of(context)!.sensors_meters;
    case 'local manufacturing':
      return AppLocalizations.of(context)!.local_manufacturing;
    case 'service':
      return AppLocalizations.of(context)!.service;
    case 'electronics':
      return AppLocalizations.of(context)!.electronics;
    case 'furniture':
      return AppLocalizations.of(context)!.furniture;
    case 'kitchen':
      return AppLocalizations.of(context)!.kitchen;
    case 'electricals':
      return AppLocalizations.of(context)!.electricals;
    case 'event function':
      return AppLocalizations.of(context)!.event_function;
    case 'clothing':
      return AppLocalizations.of(context)!.clothing;
    case 'other house items':
      return AppLocalizations.of(context)!.other_house_items;
    case 'farm extracts':
      return AppLocalizations.of(context)!.farm_extracts;
    case 'local brands':
      return AppLocalizations.of(context)!.local_brands;
    case 'oils & gels':
      return AppLocalizations.of(context)!.oils_and_gels;
    case 'local products':
      return AppLocalizations.of(context)!.local_products;
    case 'energy drinks':
      return AppLocalizations.of(context)!.energy_drinks;
    case 'artisans':
      return AppLocalizations.of(context)!.artisans;
    case 'home made':
      return AppLocalizations.of(context)!.home_made;
    case 'others':
      return AppLocalizations.of(context)!.other_others;
    default:
      return name.capitalized();
  }
}

// sorted
List<String> crops = [
  'N/A',
  // '',
  'Banana',
  'Beetroot',
  'Betel Nut',
  'Cabbage',
  'Capsicum',
  'Carrot',
  'Cashew',
  'Cauliflower',
  'Cereal',
  'Chili',
  // 'Chilli',
  // 'Coconut Tree',
  'Coconut',
  'Coffee',
  'Coriander',
  'Corn',
  'Cotton',
  'Cucumber',
  'Drumstick',
  'Brinjal',
  'Ginger',
  'Grape',
  // 'Grapes Black Dry',
  // 'Grapes Black',
  // 'Grapes Green',
  // 'Grapes Red',
  'Green Beans',
  'Green Onion',
  'Tea',
  'Jackfruit',
  'Jaggery',
  // 'Jar',
  'Lemon',
  'Mango',
  // 'Marijuana',
  // 'Milk Tank',
  'Mushroom',
  // 'Olive Oil',
  'Onion',
  'Orange',
  'Palm Oil',
  'Papaya',
  'Pea',
  'Peanut',
  // 'Pear',
  'Pineapple',
  'Pomegranate',
  'Potato',
  'Pumpkin',
  'Radish',
  'Rice',
  'Sapling',
  'Seed',
  'Spinach',
  // 'Sunflower Oil',
  'Sunflower',
  'Sweet Potato',
  'Tamarind',
  'Tomato',
  'Wheat',
];

// sorted
List<String> equipment = [
  'N/A',
  // '',
  'JCB',
  'Billhook',
  'Car',
  'Combine harvester',
  'Electric scooter',
  'Equipment',
  'Fan',
  'Gardening tools',
  'Loader',
  'Plow',
  'Scooter',
  'Shredder',
  'Tractor',
];

// sorted
var districtListForWeather = [
  '',
  'Ballari',
  'Belagavi',
  'Bengaluru',
  'Bijapur',
  'Bidar',
  'Chitradurga',
  'Dharwad',
  'Gadag',
  'Hassan',
  'Haveri',
  'Kolar',
  'Mandya',
  'Mysuru',
  'Ramanagara',
  'Shivamogga',
  'Tumakuru',
  'Udupi',
];

// sorted
List<String> animals = [
  'N/A',
  'Bee',
  'Black Cat',
  'Buffalo',
  'Bull',
  'Cat',
  'Cow',
  'Dog',
  'Donkey',
  'Duck',
  'Emu',
  'Fish',
  'Goat',
  'Hen',
  'Parrot',
  'Pig',
  'Pigeon',
  'Rabbit',
  'Sheep',
  'Sparrow',
  'Turkey',
];
