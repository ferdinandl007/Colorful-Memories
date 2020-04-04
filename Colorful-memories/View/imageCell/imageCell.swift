//
//  imageCell.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Alamofire
import Reusable
import UIKit

class imageCell: UICollectionViewCell, NibReusable {
    @IBOutlet var image: UIImageView!
    @IBOutlet var Background: UIView!
    @IBOutlet var progress: CircularProgressBar!

    var timer: Timer?

    func config() {
        progress.isHidden = false
        image.isHidden = true
        progress.setProgress(to: 0, withAnimation: true)
    }

    func setImage(image: UIImage) {
        progress.isHidden = true
        self.image.isHidden = false
        self.image.image = image
    }

    func setProgress(_ p: Double) {
        DispatchQueue.main.async {
            self.progress.setProgress(to: p, withAnimation: true)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        Background.layer.masksToBounds = false
        Background.layer.borderColor = UIColor.white.cgColor
        Background.layer.cornerRadius = 10
        Background.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        Background.clipsToBounds = true
        backgroundColor = UIColor.clear
        clipsToBounds = false
        backgroundColor = UIColor.clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10
        progress.labelSize = 30
        progress.safePercent = 100
        setColourTheme()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setColourTheme()
    }

    func setColourTheme() {
        if traitCollection.userInterfaceStyle == .light {
            Background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            Background.backgroundColor = #colorLiteral(red: 0.1705144346, green: 0.1705144346, blue: 0.1705144346, alpha: 1)
        }
    }
}
