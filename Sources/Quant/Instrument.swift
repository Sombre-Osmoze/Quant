//
//  Instrument.swift
//  Quant
//
//  Created by @Sombre-Osmoze on 18/12/2022.
//

import Foundation

protocol Instrument: Codable {
	
				associatedtype Quantity
				var value: Quantity { get }
				var code: String { get }
}
