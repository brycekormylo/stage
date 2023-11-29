//
//  TestInteractiveList.swift
//  Stage
//
//  Created by Bryce on 11/29/23.
//

import SwiftUI

class ListViewModel: ObservableObject {
    @Published var names = ["Bob", "Julie", "Frank"]
    
    func move(from source: IndexSet, to destination: Int) {
        names.move(fromOffsets: source, toOffset: destination)
    }
}

struct TestInteractiveList: View {
    @StateObject private var viewModel = ListViewModel()
    
    var body: some View {
        ZStack {
            
            NavigationView {
                List {
                    ForEach(viewModel.names, id: \.self) { name in
                        Text(name)
                    }
                    .onMove(perform: viewModel.move)
                }
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
}

#Preview {
    TestInteractiveList()
}
