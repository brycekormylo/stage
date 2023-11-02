//
//  ColorPicker.swift
//  Fotofolio
//
//  Created by Bryce on 10/19/23.
//

import SwiftUI

struct ColorPickerView: View {
    @State private var selectedColor: Color = .white
    
    var body: some View {
        ColorPicker("Color chooser", selection: $selectedColor, supportsOpacity: true)
    }
}

#Preview {
    ColorPickerView()
}
