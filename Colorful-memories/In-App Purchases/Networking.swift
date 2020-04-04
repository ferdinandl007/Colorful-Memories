//
//  Networking.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 03/04/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Alamofire
import Foundation

class Networking {
    static let shared = Networking()
    var processinQueue = Set<UIImage>()

    struct imageResult {
        let progress: Double
        let image: UIImage?
        let error: String?
        init(progress: Double, image: UIImage?, error: String?) {
            self.progress = progress
            self.image = image
            self.error = error
        }
    }

    private init() {}

    func prossessImage(image: UIImage, body: @escaping (imageResult) -> Void) {
        if processinQueue.contains(image) { return }
        processinQueue.insert(image)
        if processinQueue.contains(image) { return }
        processinQueue.insert(image)
        var completed: Double = 0 {
            didSet {
                body(imageResult(progress: completed, image: nil, error: nil))
            }
        }
        var isProssesing = false

        let mytimer = Timer(timeInterval: 0.7, repeats: true, block: { timer in
            if isProssesing {
                completed += 0.01
                if completed >= 0.90 {
                    timer.invalidate()
                }
            }
            })
        RunLoop.current.add(mytimer, forMode: .common)
        let base64Image = image.toBase64()! // Final image selected by the user
        let parameters: [String: Any] = [
            "render_factor": 32,
            "encoded_img": base64Image,
        ]

        AF.request("https://colourize.cf/images/predict", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .uploadProgress { p in
                let upload = p.fractionCompleted
                if upload == 1 || isProssesing {
                    isProssesing = true
                    return
                } else {
                    completed = upload / 3
                }
            }.responseDecodable(of: AI_Response.self) { response in
                switch response.result {
                case .success:
                    guard let aiResponse = response.value else {
                        body(imageResult(progress: completed, image: nil, error: "Error decoding image"))
                        return
                    }
                    mytimer.invalidate()
                    downloadImage(url: aiResponse.decolourised_img_url)
                case let .failure(error): body(imageResult(progress: completed, image: nil, error: error.localizedDescription))
                }
            }

        func downloadImage(url: String) {
            AF.request(url, method: .get)
                .downloadProgress { p in
                    completed = 0.90 + (p.fractionCompleted * 0.1)
                }
                .response { response in
                    self.processinQueue.remove(image)
                    switch response.result {
                    case let .success(responseData):
                        guard let newImage = UIImage(data: responseData!, scale: 1) else { return }
                        body(imageResult(progress: completed, image: newImage, error: nil))
                    case let .failure(error): body(imageResult(progress: completed, image: nil, error: error.localizedDescription))
                    }
                }
        }
    }
}
