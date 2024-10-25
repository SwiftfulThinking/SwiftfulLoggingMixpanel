//
//  String+EXT.swift
//  SwiftfulLoggingMixpanel
//
//  Created by Nick Sarno on 10/25/24.
//
import Foundation

extension String {

    func clipped(maxCharacters: Int) -> String {
        String(prefix(maxCharacters))
    }

}
