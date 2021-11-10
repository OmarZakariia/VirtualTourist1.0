//
//  BlackBoxGCD.swift
//  VirtualTourist
//
//  Created by Zakaria on 04/11/2021.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping ()-> Void){
    DispatchQueue.main.async {
        updates()
    }
}
