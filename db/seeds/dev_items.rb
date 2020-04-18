measurement_unit_ids = MeasurementUnit.custom.pluck(:name, :id).to_h

[
  {
    calcium: 0.00067,
    calories: 7,
    carbs: 0.2,
    cholesterol: 0,
    fat: 0.533300018310547,
    fiber: 0.0669999980926513,
    grams_per_tablespoon: 15,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free, :gluten_free, :kosher, :pescatarian, :tree_nut_free, :vegan, :vegetarian
    ),
    iron: 0.0000240000009536743,
    measurement_units: { Serving: 30 },
    name: 'ORGANIC PEANUT BUTTER',
    potassium: 0.00667,
    protein: 0.3,
    saturated_fat: 0.1,
    sodium: 0.00133,
    sugar: 0.0667000007629393,
    upc: '077890403327'
  },
  {
    calories: 2.5,
    grams_per_tablespoon: 20.1596608888889,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Package: 907, Serving: 20 },
    name: 'Smucker\'s Jam Strawberry',
    protein: 0,
    sodium: 0,
    sugar: 0.599999999999998,
    upc: '051500001639'
  },
  {
    calcium: 0.0016,
    calories: 2.4,
    carbs: 0.44,
    cholesterol: 0,
    fat: 0.02,
    fiber: 0.08,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free, :kosher, :peanut_free, :pescatarian, :tree_nut_free, :vegetarian
    ),
    iron: 0.0000288000011444092,
    measurement_units: { Package: 453, Serving: 25, Slice: 25 },
    monounsaturated_fat: 0,
    name: '100% WHOLE WHEAT BREAD',
    niacin: 0.0000320000004768372,
    polyunsaturated_fat: 0,
    protein: 0.16,
    riboflavin: 0.00000136000007390976,
    saturated_fat: 0,
    sodium: 0.0042,
    sugar: 0,
    thiamin: 0,
    trans_fat: 0,
    upc: '072250011365',
    vitamin_c: 0
  },
  {
    calories: 0.2,
    carbs: 0.05,
    fat: 0,
    fiber: 0.02,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Serving: 100, Whole: 100 },
    name: 'ORANGE PEPPER',
    protein: 0.01,
    sodium: 0,
    sugar: 0.02,
    upc: '035826089519',
    vitamin_c: 0.00078
  },
  {
    calories: 0,
    grams_per_tablespoon: 10.7999997131673,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Package: 21, Whole: 7 },
    name: 'Fleischmann\'s ActiveDry Yeast Original - 3 CT',
    protein: 0,
    sugar: 0,
    upc: '040100009282'
  },
  {
    calcium: 0,
    calories: 0.4,
    carbs: 0.0794000005722046,
    cholesterol: 0,
    fat: 0,
    fiber: 0.0160000002384186,
    grams_per_tablespoon: 15.7499999997337,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    iron: 0.0000171000003814697,
    measurement_units: { Package: 822, Serving: 63 },
    name: 'GIANT, TOMATO PUREE',
    protein: 0.015900000333786,
    saturated_fat: 0,
    sodium: 0.00024,
    sugar: 0.0476000022888183,
    trans_fat: 0,
    upc: '688267080715',
    vitamin_c: 0.0000759999990463255
  },
  {
    calcium: 0.0005,
    calories: 0.34,
    carbs: 0.0671999979019166,
    cholesterol: 0,
    fat: 0,
    fiber: 0.0170000004768372,
    grams_per_tablespoon: 29.749999999497,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    iron: 0.00000910000026226044,
    measurement_units: { Package: 793, Serving: 119 },
    name: 'CHUNKY CRUSHED TOMATOES',
    protein: 0.00839999973773956,
    saturated_fat: 0,
    sodium: 0.00101,
    sugar: 0.0335999989509583,
    trans_fat: 0,
    upc: '041188046831',
    vitamin_c: 0.00000999999999999999
  },
  {
    calories: 3.75,
    carbs: 1,
    cholesterol: 0,
    fat: 0,
    fiber: 0,
    grams_per_tablespoon: 11.9999999991885,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Serving: 4 },
    name: 'PURE CANE GRANULATED WHITE SUGAR',
    protein: 0,
    saturated_fat: 0,
    sodium: 0,
    sugar: 1,
    trans_fat: 0,
    upc: '077890382462'
  },
  {
    calories: 4,
    cholesterol: 0,
    fiber: 0.199999999999999,
    grams_per_tablespoon: 7.55987283282207,
    health_label_ids: HealthLabel.ids.values_at(
      :gluten_free, :kosher, :peanut_free, :pescatarian, :tree_nut_free, :vegetarian
    ),
    measurement_units: { Package: 226, Serving: 5 },
    name: 'Kraft Parmesan Cheese Grated',
    protein: 0.4,
    saturated_fat: 0,
    sodium: 0.015,
    sugar: 0,
    upc: '021000615315'
  },
  {
    calories: 8,
    carbs: 0,
    fat: 0.93330001831055,
    grams_per_tablespoon: 14.786764781,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Package: 2_874, Serving: 14 },
    monounsaturated_fat: 0.666699981689453,
    name: 'EXTRA VIRGIN OLIVE OIL',
    polyunsaturated_fat: 0.13329999923706,
    protein: 0,
    saturated_fat: 0.13329999923706,
    sodium: 0,
    trans_fat: 0,
    upc: '688267133138'
  },
  {
    calcium: 0.0088184904873951,
    calories: 4.99714460952389,
    carbs: 1.29337863285117,
    fat: 0.0587899374586723,
    fiber: 0.499714474969004,
    grams_per_tablespoon: 3.401942775,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    iron: 0.000158732835080588,
    magnesium: 0.00352739619495804,
    measurement_units: { Package: 85, Serving: 3 },
    monounsaturated_fat: 0.0293949687293361,
    name: 'McCormick Pure Ground Black Pepper',
    polyunsaturated_fat: 0.0293949687293361,
    potassium: 0.0270433708280116,
    protein: 0.205764774535066,
    saturated_fat: 0.0293949687293361,
    sodium: 0.00029394968291317,
    sugar: 0,
    upc: '052100029962'
  },
  {
    calories: 81.1536544803072,
    carbs: 0,
    cholesterol: 0,
    fat: 0,
    fiber: 0,
    grams_per_tablespoon: 14.786764781,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Serving: 1 },
    name: 'Ahold Oregano Leaves',
    potassium: 0,
    protein: 0,
    saturated_fat: 0,
    sodium: 0,
    sugar: 0,
    trans_fat: 0,
    upc: '688267143908'
  },
  {
    calcium: 0.000337837837837838,
    calories: 0.297297297297297,
    carbs: 0.0743243243243243,
    cholesterol: 0,
    fat: 0,
    fiber: 0.0202702702702703,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    iron: 0.00000729729758726584,
    measurement_units: { Serving: 148 },
    name: 'Yellow Onion',
    protein: 0.00682432425988687,
    saturated_fat: 0,
    sodium: 0.000027027027027027,
    sugar: 0.0608108108108108,
    trans_fat: 0,
    upc: '688267083532',
    vitamin_c: 0.000121621621621622
  },
  {
    calories: 0,
    carbs: 0,
    fat: 0,
    grams_per_tablespoon: 17.9999999987827,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Package: 1_814, Serving: 1 },
    name: 'TABLE SALT',
    protein: 0,
    sodium: 0.39333,
    upc: '024600010849'
  },
  {
    calcium: 0.00710714285714286,
    calories: 3.21428571428571,
    carbs: 0.0357142857142858,
    cholesterol: 0.000535714285714286,
    fat: 0.214285714285714,
    grams_per_tablespoon: 7.08738078113017,
    health_label_ids: HealthLabel.ids.values_at(
      :gluten_free, :kosher, :peanut_free, :pescatarian, :tree_nut_free, :vegetarian
    ),
    iron: 0.00000250000001064369,
    measurement_units: { Package: 226, Serving: 28 },
    name: 'Kraft Mozzarella Finely Shredded Natural Cheese  8oz Bag',
    phosphorus: 0.0050832143511091,
    protein: 0.25,
    saturated_fat: 0.125,
    sodium: 0.00535714285714286,
    sugar: 0,
    upc: '021000055166',
    vitamin_c: 0
  },
  {
    calcium: 0,
    calories: 5,
    carbs: 0,
    cholesterol: 0.00125,
    fat: 0.464300003051758,
    fiber: 0,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free, :gluten_free, :peanut_free, :pescatarian, :tree_nut_free
    ),
    iron: 0.0000128999996185303,
    measurement_units: { Package: 170, Serving: 28, Slice: 2 },
    name: 'HORMEL, PEPPERONI',
    protein: 0.178600006103516,
    saturated_fat: 0.214300003051758,
    sodium: 0.0175,
    sugar: 0,
    trans_fat: 0,
    upc: '037600398855',
    vitamin_c: 0
  },
  {
    calcium: 0,
    calories: 3.3199022662167,
    carbs: 0.788476778332386,
    cholesterol: 0,
    fat: 0,
    fiber: 0.165995115784355,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    iron: 0,
    measurement_units: { Package: 74, Serving: 2 },
    name: 'Mccormick Onion Powder, 2.62 Oz',
    potassium: 0.0099597067986501,
    protein: 0.0829975578921774,
    saturated_fat: 0,
    sodium: 0.000829975566554175,
    sugar: 0.0829975578921774,
    upc: '052100006475',
    vitamin_c: 0.000248992679860332
  },
  {
    calcium: 0,
    calories: 3.666666667,
    carbs: 0.733300018310547,
    cholesterol: 0,
    fat: 0,
    fiber: 0.0329999995231629,
    grams_per_tablespoon: 7.4999999998732,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free, :kosher, :peanut_free, :pescatarian, :tree_nut_free, :vegan, :vegetarian
    ),
    iron: 0.0000359999990463257,
    measurement_units: { Package: 2_250, Serving: 30 },
    name: 'GOLD MEDAL BL EN PS AP FLOUR',
    potassium: 0.00133,
    protein: 1,
    riboflavin: 0.00000340000003576279,
    saturated_fat: 0,
    sodium: 0,
    sugar: 0.0332999992370606,
    thiamin: 0,
    trans_fat: 0,
    upc: '016000106109'
  },
  {
    calories: 0,
    grams_per_tablespoon: 14.786764781,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Serving: 4 },
    name: 'Ahold Basil Leaves',
    upc: '688267015700'
  },
  {
    calories: 0,
    grams_per_tablespoon: 14.786764781,
    health_label_ids: HealthLabel.ids.values_at(
      :dairy_free,
      :gluten_free,
      :kosher,
      :peanut_free,
      :pescatarian,
      :tree_nut_free,
      :vegan,
      :vegetarian
    ),
    measurement_units: { Serving: 28 },
    name: 'Badia Garlic Powder',
    upc: '033844000011'
  }
].each do |data|
  measurement_units = data.delete(:measurement_units)
  item = Item.create!(data)
  measurement_units&.each do |name, grams|
    ItemMeasurementUnit.create!(
      grams: grams,
      item: item,
      measurement_unit_id: measurement_unit_ids[name.to_s]
    )
  end
end