//
//  HeaderCell.swift
//  Colorful-memories
//
//  Created by Ferdinand Lösch on 29/03/2020.
//  Copyright © 2020 Ferdinand Lösch. All rights reserved.
//

import Reusable
import UIKit

class HeaderCell: UICollectionViewCell, NibReusable {
    @IBOutlet var teitel: UILabel!
    @IBOutlet var credetLabel: UILabel!
    @IBOutlet var Background: UIView!
    @IBOutlet var blob: UIView!

    var observer: NSKeyValueObservation?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    deinit {
        observer?.invalidate()
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
        layer.shadowOffset = CGSize(width: 2, height: 10)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        setColourTheme()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func config() {
        setLabels()
        observer = UserDefaults.standard.observe(\.keyPath, options: [.initial, .new], changeHandler: { _, _ in
            DispatchQueue.main.async {
                self.setLabels()
            }
        })
    }

    func setLabels() {
        let credets = UserDefaults.standard.integer(forKey: "credets")
        credetLabel.text = "\(credets)"
        if credets > 0 {
            teitel.text = "Number of credits left!"
        } else {
            teitel.text = "Click to buy more."
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColourTheme()
    }

    func setColourTheme() {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                Background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                teitel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                blob.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                credetLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                Background.backgroundColor = #colorLiteral(red: 0.1705144346, green: 0.1705144346, blue: 0.1705144346, alpha: 1)
                blob.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                credetLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                teitel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            Background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            teitel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            blob.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            credetLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
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
}
