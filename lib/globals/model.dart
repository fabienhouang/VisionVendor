import 'package:google_generative_ai/google_generative_ai.dart';

const _instruction =
    """You're used as the backend of our application called Vision Vendor where the goal is to estimate goods state, price, condition ...
Your main task is to analyze images and make some KPIs to help us appraise items for resale""";

var prompt =
    """I need to analyze this image to extract important information for the resale of an item.
The item to be appraised in located in the center of the image.
Try to find a title that best matches the item for sale.
Even if the price estimation or other KPIs (in dollars units) are not accurate, it's okay, I just need an indicative figure.""";

// Access your API key as an environment variable (see "Set up your API key" above)
const String _apiKey = String.fromEnvironment('API_KEY');

// Define the properties of the KPI object
Map<String, Schema> kpiProperties = {
  'title' : Schema.string(
    description:
      'Short title of the item, dont be too exhaustive, use a maximum of 10 words for the title of the item that needs to be sold',
  ),
  'description': Schema.string(
    description:
      'Description of the item, just make a description of the object that needs to be sold',
  ),
  'brand': Schema.string(
    description: 'Brand of the detected item',
  ),
  'materials': Schema.string(
    description: 'Materials of the item',
  ),
  'colors': Schema.string(
    description:
      'Colors of the detected item, can have multiple and separated by comma',
  ),
  'weight': Schema.string(
    description:
      'Estimation of the weight of the detected item and add the units at the end of the number, in kg',
  ),
  'category': Schema.string(
    description: 'Category of the detected item',
  ),
  'condition': Schema.enumString(
    description: 'Condition of the item',
    enumValues: ['New', 'Good', 'Used', 'Damaged', 'Broken'],
  ),
  'retail_price': Schema.integer(
    description: 'Retail price of the item',
  ),
  'avg_resale': Schema.integer(
    description: 'Average resale price of the item',
  ),
  'max_resale': Schema.integer(
    description: 'Highest resale price of the item',
  ),
  'min_resale': Schema.integer(
    description: 'Lowest resale price of the item',
  ),
  'link': Schema.string(
    description: 'One link where I can find this item',
  ),
};

// Create the KPI schema object
Schema kpiSchema = Schema.object(
  properties: kpiProperties,
  requiredProperties: [
    'title',
    'description',
    'brand',
    'materials',
    'colors',
    'weight',
    'category',
    'condition',
    'retail_price',
    'avg_resale',
    'max_resale',
    'min_resale',
    'link'
  ],
  description: 'Schema for the KPI object returned by the analysis',
);

// Define the generation configuration
final _generationConfig = GenerationConfig(
  responseMimeType: 'application/json',
  temperature: 0,
  responseSchema: kpiSchema,
);

// Create the GenerativeModel
final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: _apiKey,
  systemInstruction: Content.system(_instruction),
  generationConfig: _generationConfig,
);
