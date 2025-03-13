//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 05.01.2025.
//
import UIKit

final class SingleImageViewController: UIViewController {
//    var image: String? {
//        didSet {
//            guard isViewLoaded, let image else { return }
//            
//            imageView.image = image
//            imageView.frame.size = image.size
//            
//            doImageSizeAsDisplay(image: image)
//        }
//    }
    
    var imageURL: String?
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
//        guard let image else { return }
//        imageView.image = image
//        imageView.frame.size = image.size
//        
//        doImageSizeAsDisplay(image: imageURL)
    }
    
    //MARK: - Вспомогательные методы
    //метод зума
    private func doImageSizeAsDisplay(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    //MARK: - кнопки
    @IBAction private func didTapReturnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let imageURL else { return }
        
        let share = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
        
        present(share, animated: true , completion: nil)
    }
}

//MARK: - расшрения
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    //для центрирования в любой непонятной ситуации
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let view else { return }
        
        let visibleRectSize = scrollView.bounds.size
        let realSize = view.frame.size
        
        let horizontalInset = max(0, (visibleRectSize.width - realSize.width) / 2)
        let verticalInset = max(0, (visibleRectSize.height - realSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset)
    }
}
