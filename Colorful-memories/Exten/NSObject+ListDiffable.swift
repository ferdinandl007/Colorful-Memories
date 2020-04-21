//
//  NSObject+ListDiffable.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Foundation
import IGListKit
import PixelEngine

// MARK: - ListDiffable

extension UIImage {
    enum Format: String {
        case png
        case jpeg
    }

    func toBase64(type: Format = .jpeg, quality: CGFloat = 1, addMimePrefix: Bool = false) -> String? {
        let imageData: Data?
        switch type {
        case .jpeg: imageData = jpegData(compressionQuality: quality)
        case .png: imageData = pngData()
        }
        guard let data = imageData else { return nil }

        let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

        var result = base64
        if addMimePrefix {
            let prefix = "data:image/\(type.rawValue);base64,"
            result = prefix + base64
        }
        return result
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UserDefaults {
    @objc dynamic var keyPath: Int {
        return integer(forKey: "keyPath")
    }
}

extension String {
    func parseToInt() -> Int? {
        return Int(components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension ColorCubeStorage {
    static func loadToDefault() {
        do {
            try autoreleasepool {
                let bundle = Bundle.main
                let rootPath = bundle.bundlePath as NSString
                let fileList = try FileManager.default.contentsOfDirectory(atPath: rootPath as String)

                let filters = fileList
                    .filter { $0.hasPrefix("LUT") && $0.hasSuffix(".png") }
                    .sorted()
                    .map { path -> FilterColorCube in
                        let url = URL(fileURLWithPath: rootPath.appendingPathComponent(path))
                        let data = try! Data(contentsOf: url)
                        let image = UIImage(data: data)!
                        let name = path
                            .replacingOccurrences(of: "LUT_", with: "")
                            .replacingOccurrences(of: ".png", with: "")
                            .replacingOccurrences(of: ".PNG", with: "")
                        return FilterColorCube(
                            name: name,
                            identifier: path,
                            lutImage: image,
                            dimension: 64
                        )
                    }

                self.default.filters = filters
                print(filters)
            }

        } catch {
            assertionFailure("\(error)")
        }
    }
}
