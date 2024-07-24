import 'package:google_generative_ai/google_generative_ai.dart';

const _instruction =
    """You're used as the backend of our application called Vision Vendor where the goal is to estimate goods state, price, condition ...
Your main task is to analyze images and make some KPIs to help us appraise items for resale""";

var prompt =
    """I need to analyze this image to extract important information for the resale of an item.
The item to be appraised in located in the center of the image.
Try to find a title that best matches the item for sale.
Even if the price estimation or other KPIs (in dollars adding \$ at the beginning) are not accurate, it's okay, I just need an indicative figure.""";

// Access your API key as an environment variable (see "Set up your API key" above)
const String _apiKey = String.fromEnvironment('API_KEY');

// Define the properties of the KPI object
Map<String, Schema> kpiProperties = {
  'Title' : Schema(
    SchemaType.string,
    description:
        'Short title of the item, dont be too exhaustive, use a maximum of 10 words for the title of the item that needs to be sold',
  ),
  'Description': Schema(
    SchemaType.string,
    description:
        'Description of the item, just make a description of the object that needs to be sold',
  ),
  'Brand': Schema(
    SchemaType.string,
    description: 'Brand of the detected item',
  ),
  'Materials': Schema(
    SchemaType.string,
    description: 'Materials of the item',
  ),
  'Colors': Schema(
    SchemaType.string,
    description:
        'Colors of the detected item, can have multiple and separated by comma',
  ),
  'Weight': Schema(
    SchemaType.string,
    description:
        'Estimation of the weight of the detected item and add the units at the end of the number, in kg',
  ),
  'Object Category': Schema(
    SchemaType.string,
    description: 'Category of the detected item',
  ),
  'Condition': Schema(
    SchemaType.string,
    description: 'Condition of the item',
    enumValues: ['New', 'Excellent', 'Very Good', 'Good', 'Used', 'Damaged'],
  ),
  'Retail Price': Schema(
    SchemaType.string,
    description: 'Retail price of the item in dollars',
  ),
  'Average Resale': Schema(
    SchemaType.string,
    description: 'Average resale price of the item in dollars',
  ),
  'Highest Resale': Schema(
    SchemaType.string,
    description: 'Highest resale price of the item in dollars',
  ),
  'Lowest Resale': Schema(
    SchemaType.string,
    description: 'Lowest resale price of the item in dollars',
  ),
};

// Create the KPI schema object
Schema kpiSchema = Schema.object(
  properties: kpiProperties,
  requiredProperties: [
    'Title',
    'Description',
    'Brand',
    'Materials',
    'Colors',
    'Weight',
    'Object Category',
    'Condition',
    'Retail Price',
    'Average Resale',
    'Highest Resale',
    'Lowest Resale'
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
  model: 'gemini-1.5-pro-latest',
  apiKey: _apiKey,
  systemInstruction: Content.system(_instruction),
  generationConfig: _generationConfig,
);
