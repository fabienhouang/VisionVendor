library model;

import 'package:google_generative_ai/google_generative_ai.dart';

const _instruction =
    """you're used as the backend of our application called Vision Vendor where the goal is to estimate goods state, price, condition ...
You're main task is to analyze images and make some KPIs out of it""";

var prompt =
    """I need to analyze this image to extract important information for the resale of an item for my application.
Try to find a title that best matches the item for sale.
Even if the price estimation or other KPIs (in dollars adding \$ at the beginning) are not accurate, it's okay, I just need an indicative figure.""";

// Access your API key as an environment variable (see "Set up your API key" above)
const String _apiKey = String.fromEnvironment('API_KEY');

// Define the properties of the KPI object
Map<String, Schema> kpiProperties = {
  'Description': Schema(
    SchemaType.string,
    description:
        'Description of the item, dont be too exhaustive, just make a description of the object that needs to be sell',
  ),
  'Brand': Schema(
    SchemaType.string,
    description: 'Brand of the detected object',
  ),
  'Materials': Schema(
    SchemaType.string,
    description: 'Materials of the object',
  ),
  'Colors': Schema(
    SchemaType.string,
    description:
        'Colors of the detected object, can be plurial and separated by comma',
  ),
  'Weight': Schema(
    SchemaType.string,
    description:
        'Estimation of the weight of the detected object and add the units at the end of the number',
  ),
  'Object Category': Schema(
    SchemaType.string,
    description: 'Category of the detected object',
  ),
  'Condition': Schema(
    SchemaType.string,
    description: 'Condition of the item',
    enumValues: ['New', 'Excellent', 'Very Good', 'Good', 'Used', 'Damaged'],
  ),
  'Retail Price': Schema(
    SchemaType.string,
    description: 'Retail price of the item',
  ),
  'Average Resell': Schema(
    SchemaType.string,
    description: 'Average resell price of the item',
  ),
  'Highest Resell': Schema(
    SchemaType.string,
    description: 'Highest resell price of the item',
  ),
  'Lowest Resell': Schema(
    SchemaType.string,
    description: 'Lowest resell price of the item',
  ),
};

// Create the KPI schema object
Schema kpiSchema = Schema.object(
  properties: kpiProperties,
  requiredProperties: [
    'Description',
    'Brand',
    'Materials',
    'Colors',
    'Weight',
    'Object Category',
    'Condition',
    'Retail Price',
    'Average Resell',
    'Highest Resell',
    'Lowest Resell'
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
