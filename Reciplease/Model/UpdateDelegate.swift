//
//  UpdateDelegate.swift
//  Reciplease
//
//  Created by Enzo Gammino on 08/12/2022.
//

import Foundation

protocol UpdateDelegate: NSObject {
    func throwAlert(message: String)
    func updateScreen(ingredientText: String)
    func showEmptyMessage(state: Bool)
}
