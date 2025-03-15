//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 05.01.2025.
//
import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    private let placeholderImageView: UIImageView = {
        let placeholderImage = UIImageView(image: UIImage(named: "single_placeholder"))
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImage
    }()
    
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.5
        
        configScrollView()
        setupPlaceholder()
        
        loadImage()
    }
    
    //MARK: - верстка
    private func configScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholderImageView)
        NSLayoutConstraint.activate([
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - вспомогательные методы
    private func loadImage() {
        guard let imageURL,
              let url = URL(string: imageURL) else {
            return
        }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "single_placeholder"),
                              options: [.transition(.fade(0.2))]) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let value):
                self.placeholderImageView.isHidden = true
                self.imageView.image = value.image
                self.doImageSizeAsDisplay(image: value.image)
            case .failure:
                self.showAlert()
            }
        }
    }
    
    private func doImageSizeAsDisplay(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadImage()
        })
        present(alert, animated: true)
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
