library model;

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';

const _instruction = """you're used as the backend of our application called Vision Vendor where the goal is to estimate goods state, price, condition ...
You're main task is to analyze images and make some KPIs out of it
You'll also be tasked to identify and detect objects plus their boxes""";


const prompt = """Je dois analyser cette image pour en sortir des informations imporatnes pour la vente d'ocassion pour mon application.
Essaie de trouver vraiment un titre qui correspond au mieux à l'objet à vendre.
Même si les estimations de prix (en dollars en rajoutant \$ au debut) ne sont pas bonnes ce n'est pas grave je souhaite juste avoir un chiffre à titre indicatif
Le but est de sortir sous format JSON les KPIs suivant :

KPIs = {'Description': str, 'Retail Price': str, 'Condition': str IN {New, Excellent, Very Good, Good, Used, Damaged}, 'Average Resell': str, 'Highest Resell': str, 'Lowest Resell': str}
Return: KPIs""";

// Access your API key as an environment variable (see "Set up your API key" above)
const String _apiKey = String.fromEnvironment('API_KEY');

final _generationConfig = GenerationConfig(
  responseMimeType: "application/json"
);

final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey, systemInstruction: Content.system(_instruction), generationConfig: _generationConfig);