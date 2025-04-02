//
//  ExchangeRate.swift
//  CurrencyConvertorApp
//
//  Created by Pouya Sadri on 27/10/2024.
//

import Foundation

// Model representing individual exchange rate information.
struct ExchangeRate: Codable {
	let currency: String  // Currency code, e.g., "USD" or "EUR"
	let rate: Double      // The exchange rate value
}

// Model for decoding the full response from the API, which includes all exchange rates.
struct ExchangeRateResponse: Codable {
	let conversionRates: [String: Double]  // Dictionary of all currency exchange rates
	
	// Maps the API's "conversion_rates" JSON key to the property conversionRates
	enum CodingKeys: String, CodingKey {
		case conversionRates = "conversion_rates"
	}
}

