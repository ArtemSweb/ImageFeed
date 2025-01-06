//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 05.01.2025.
//
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    //MARK: - кнопки
    @IBAction private func didTapReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
