//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 21.12.2024.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private var isLike = false
    
    //элементы экрана
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientLine: UIImageView!
    
    @IBAction func likeButtonClick() {
        if isLike {
            likeButton.setImage(.noActive, for: .normal)
            isLike = false
        } else {
            likeButton.setImage(.active, for: .normal)
            isLike = true
        }
    }
}
