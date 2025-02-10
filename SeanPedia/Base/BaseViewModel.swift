//
//  BaseViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/10/25.
//

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
