import Foundation

// Main actor ensures UI-related updates happen on the main thread
@MainActor
class CurrencyConverterViewModel: ObservableObject {
	// User-entered amount for conversion
	@Published var amount: String = ""
	// Selected base (from) and target (to) currencies
	@Published var baseCurrency: String = "USD"
	@Published var targetCurrency: String = "EUR"
	// Number of decimal places for the converted amount
	@Published var decimalPlaces: Int = 2
	// Resulting converted amount to be displayed
	@Published var convertedAmount: String = ""
	// Dictionary of available exchange rates fetched from the API
	@Published var exchangeRates: [String: Double] = [:]
	// Loading indicator state to inform the user that rates are being fetched
	@Published var isLoading: Bool = false
	// Holds error messages if API fetching fails
	@Published var errorMessage: String? = nil
	
	private let apiKey = "Your-api-key"  // API key for ExchangeRate API
	private let baseURL = "https://v6.exchangerate-api.com/v6"  // Base URL for the API
	
	// ViewModel initialization
	init() {
		Task {
			await fetchExchangeRates()  // Fetches exchange rates from API when initialized
		}
	}
	
	// Fetches exchange rates asynchronously from the API
	func fetchExchangeRates() async {
		isLoading = true  // Sets loading indicator to true
		errorMessage = nil  // Clears any previous error message
		let urlString = "\(baseURL)/\(apiKey)/latest/USD"  // Builds the full API request URL
		
		// Checks if the URL is valid
		guard let url = URL(string: urlString) else {
			errorMessage = "Invalid URL"  // Shows error if URL is invalid
			isLoading = false
			return
		}
		
		do {
			// Attempts to fetch data from API
			let (data, _) = try await URLSession.shared.data(from: url)
			// Decodes the fetched data into the ExchangeRateResponse model
			let result = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
			exchangeRates = result.conversionRates  // Updates exchange rates
		} catch {
			errorMessage = "Failed to fetch rates: \(error.localizedDescription)"  // Shows error if data fetching fails
		}
		
		isLoading = false  // Hides loading indicator after data is fetched or an error occurs
	}
	
	// Performs currency conversion based on user input
	func convertCurrency() {
		// Validation: Checks that amount is numeric and greater than 0
		guard let amountValue = Double(amount), amountValue > 0 else {
			convertedAmount = "Please enter a valid numeric amount"
			return
		}
		
		// Validation: Ensures the selected currencies are different
		guard baseCurrency != targetCurrency else {
			convertedAmount = "Please choose two different currencies"
			return
		}
		
		// Fetches rates for the selected base and target currencies
		guard let baseRate = exchangeRates[baseCurrency],
			  let targetRate = exchangeRates[targetCurrency] else {
			convertedAmount = "Conversion rate unavailable"  // Error if either rate is missing
			return
		}
		
		// Calculates the conversion rate from base to target
		let rate = targetRate / baseRate
		// Computes the final converted amount
		let result = amountValue * rate
		
		// Formats the result according to the selected decimal places
		convertedAmount = String(format: "%.\(decimalPlaces)f", result)
	}
}
