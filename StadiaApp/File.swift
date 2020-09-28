//
//  File.swift
//  StadiaApp
//
//  Created by Jason Meulenhoff on 15/09/2020.
//

import Foundation

@propertyWrapper struct File<DataType> {

	let name: String
	let type: String
	let fileManager: FileManager = .default
	let bundle: Bundle = .main
	let decoder: (Data) -> DataType

	var wrappedValue: DataType {
		guard let path = bundle.path(forResource: name, ofType: type) else { fatalError("Resource not found: \(name).\(type)") }
		guard let data = fileManager.contents(atPath: path) else { fatalError("Can not load file at: \(path)") }
		return decoder(data)
	}
}
