//
//  ActionsCell.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 01/04/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Reusable
import UIKit
protocol ActionsCellDelicate: class {
    func save()
    func share()
    func trash()
}

class ActionsCell: UICollectionViewCell, NibReusable {
    weak var delicate: ActionsCellDelicate?
    @IBOutlet var background: UIView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var saveButton: UIButton!

    @IBOutlet var trashButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        background.layer.masksToBounds = false
        background.layer.borderColor = UIColor.white.cgColor
        background.layer.cornerRadius = 10
        background.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        background.clipsToBounds = true
        backgroundColor = UIColor.clear
        clipsToBounds = false
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10
        setColourTheme()
    }

    @IBAction func trash(_: Any) {
        delicate?.trash()
    }

    @IBAction func share(_: Any) {
        delicate?.share()
    }

    @IBAction func save(_: Any) {
        delicate?.save()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setColourTheme()
    }

    func setColourTheme() {
        if traitCollection.userInterfaceStyle == .light {
            background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            trashButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            saveButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            shareButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            background.backgroundColor = #colorLiteral(red: 0.1705144346, green: 0.1705144346, blue: 0.1705144346, alpha: 1)
            trashButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            saveButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            shareButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
