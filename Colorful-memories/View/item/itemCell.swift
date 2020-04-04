//
//  itemCell.swift
//  Finderr
//
//  Created by Ferdinand Lösch on 23/02/2019.
//  Copyright © 2019 Ferdinand Lösch. All rights reserved.
//

import Reusable
import UIKit
class itemCell: UICollectionViewCell, NibReusable {
    @IBOutlet var image: UIImageView!

    @IBOutlet var label: UILabel!
    @IBOutlet var Background: UIView!

    public func config(image: UIImage, label: String) {
        self.label.text = label
        self.image.image = image
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Background.layer.masksToBounds = false
        Background.layer.borderColor = UIColor.white.cgColor
        Background.layer.cornerRadius = 10
        Background.clipsToBounds = true
        backgroundColor = UIColor.clear
        clipsToBounds = false
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10
        setColourTheme()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setColourTheme()
    }

    func setColourTheme() {
        if traitCollection.userInterfaceStyle == .light {
            Background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            image.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            image.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Background.backgroundColor = #colorLiteral(red: 0.1705144346, green: 0.1705144346, blue: 0.1705144346, alpha: 1)
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
