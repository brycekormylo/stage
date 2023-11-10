//
//  DataSequence.swift
//  Stage
//
//  Created by Bryce on 11/9/23.
//

import Foundation

struct DataSequence: AsyncSequence {
    
    typealias Element = Data
    
    let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func makeAsyncIterator() -> DataIterator {
        return DataIterator(urls: urls)
    }
}

struct DataIterator: AsyncIteratorProtocol {
    typealias Element = Data
    
    private var index = 0
    
    private var urlSession = URLSession.shared
    
    let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    mutating func next() async throws -> Data? {
        
        guard index < urls.count else {
            return nil
        }
        
        let url = urls[index]
        index += 1
        
        let (data, _) = try await urlSession.data(from: url)
        
        return data
        
    }
}

//Task {
//    let string = "https://source.unsplash.com/random"
//    let urls = Array(0...10).map { _ in
//        URL(string: string)}.compactMap( {$0} )
//    
//    for try await data in DataSequence(urls: urls) {
//        print(data.count)
//    }
//}
