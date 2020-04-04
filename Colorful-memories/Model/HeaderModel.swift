//
//  HeaderModel.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Alamofire
import Foundation
import IGListKit
class HeaderModel: ListDiffable {
    let uuid: String
    init() {
        uuid = UUID().uuidString
    }

    func diffIdentifier() -> NSObjectProtocol {
        return uuid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? HeaderModel else { return false }
        return uuid == object.uuid
    }
}

class ImageModel: ListDiffable {
    var isColor: Bool
    var image: UIImage
    let uuid: String
    func diffIdentifier() -> NSObjectProtocol {
        return uuid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ImageModel else { return false }
        return uuid == object.uuid
    }

    init(image: UIImage, isColor: Bool) {
        self.isColor = isColor
        self.image = image
        uuid = UUID().uuidString
    }
}

struct AI_Response: Codable {
    public let decolourised_img_url: String
    public let status: String
}
