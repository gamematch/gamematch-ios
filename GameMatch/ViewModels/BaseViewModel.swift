//
//  BaseViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 12/26/21.
//

import Foundation

class BaseViewModel: ObservableObject
{
    @Published var loading = false
    @Published var error: Error?

    var needData = true
}
