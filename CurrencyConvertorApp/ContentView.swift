//
//  ContentView.swift
//  CurrencyConvertorApp
//
//  Created by Pouya Sadri on 27/10/2024.
//

import SwiftUI

struct CurrencyConverterView: View {
	// Connects the ViewModel to the View, making ViewModel properties available in the View
	@StateObject private var viewModel = CurrencyConverterViewModel()
	
	var body: some View {
		VStack(spacing: 20) {
			// Title of the app
			Text("Currency Converter")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			// Input field for the user to enter the amount to convert
			TextField("Enter amount", text: $viewModel.amount)
				.textFieldStyle(.roundedBorder)
				.keyboardType(.decimalPad)
				.padding(.horizontal)
			
			// Picker for selecting the base currency
			HStack {
				Text("From:")
				Picker("Base Currency", selection: $viewModel.baseCurrency) {
					// Populates picker options dynamically from the exchange rates dictionary keys
					ForEach(Array(viewModel.exchangeRates.keys), id: \.self) { currency in
						Text(currency)
					}
				}
				.pickerStyle(.menu)  // Displays the picker as a dropdown menu
			}
			.padding(.horizontal)
			
			// Picker for selecting the target currency
			HStack {
				Text("To:")
				Picker("Target Currency", selection: $viewModel.targetCurrency) {
					ForEach(Array(viewModel.exchangeRates.keys), id: \.self) { currency in
						Text(currency)
					}
				}
				.pickerStyle(.menu)
			}
			.padding(.horizontal)
			
			// Slider for selecting the number of decimal places in the result
			VStack {
				Text("Decimal Precision: \(viewModel.decimalPlaces)")
				Slider(value: Binding(
					get: { Double(viewModel.decimalPlaces) },
					set: { viewModel.decimalPlaces = Int($0) }
				), in: 0...4, step: 1)
			}
			.padding(.horizontal)
			
			// Button to trigger the currency conversion
			Button(action: {
				viewModel.convertCurrency()
			}) {
				Text("Convert")
					.font(.title2)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
			.padding(.horizontal)
			
			// Displays the converted amount if available
			if !viewModel.convertedAmount.isEmpty {
				Text("Converted Amount: \(viewModel.convertedAmount)")
					.font(.title2)
					.fontWeight(.medium)
					.padding()
			}
			
			// Shows an error message if there is an error
			if let errorMessage = viewModel.errorMessage {
				Text(errorMessage)
					.foregroundColor(.red)
					.padding()
			}
			
			// Shows a loading spinner while exchange rates are being fetched
			if viewModel.isLoading {
				ProgressView("Fetching Rates...")
			}
		}
		.padding()
	}
}

#Preview {
	CurrencyConverterView()
}
