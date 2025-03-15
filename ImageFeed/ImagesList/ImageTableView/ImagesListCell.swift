//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 21.12.2024.
//
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    private var currentImageURL: String?
    private var isLike = false
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientLine: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    func configure(with photo: Photo) {
        currentImageURL = photo.thumbImageURL
        let placeholder = UIImage(named: "Stub")
        imageCell.kf.indicatorType = .activity
        imageCell.kf.setImage(with: URL(string: photo.thumbImageURL), placeholder: placeholder)
        setIsLiked(photo.isLiked)
        dateLabel.text = photo.createdAt?.dateTimeString ?? "Неизвестная дата"
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Active.png") : UIImage(named: "No Active.png")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
