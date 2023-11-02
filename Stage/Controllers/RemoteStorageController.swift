//
//  ImgBBController.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import Foundation
import SwiftUI

class RemoteStorageController: NSObject, ObservableObject, URLSessionTaskDelegate {

    func uploadToImgBB(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Error converting image to JPEG")
            completion(.failure(NSError(domain: "Image Conversion Error", code: 1, userInfo: nil)))
            return
        }
        
        let url = URL(string: "https://api.imgbb.com/1/upload?key=\(Secrets.imgBBApiKey)")!
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession(configuration: .default, delegate: self, delegateQueue: nil).dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with request: \(error)")
                completion(.failure(error))
            } else if let data = data {
                print("Data received")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Parsed JSON: \(json)")
                        //Save url and delete url for each image
                        if let dataDict = json["data"] as? [String: Any],
                           let url = dataDict["url"] as? String {
                            print("Image uploaded successfully")
                            completion(.success(url))
                        } else {
                            print("Error parsing JSON: data or url not found")
                            completion(.failure(NSError(domain: "JSON Parsing Error", code: 1, userInfo: nil)))
                        }
                    } else {
                        print("Error parsing JSON: not a valid JSON")
                        completion(.failure(NSError(domain: "JSON Parsing Error", code: 1, userInfo: nil)))
                    }
                } catch {
                    print("Error serializing JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        print("Task started")
        task.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        print("Upload progress: \(progress * 100)%")
    }
}
