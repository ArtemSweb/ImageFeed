//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.12.2024.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    
   func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListViewControllerObserver: NSObjectProtocol?
    
    var presenter: ImagesListViewPresenterProtocol?

    private var photos: [Photo] = []
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        presenter?.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
//        imageListViewControllerObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main
//        ) { [weak self] _ in
//            self?.updateTableViewAnimated()
//        }
    }
    
    //MARK: - Реализация segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath,
                  let presenter = presenter
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let image = presenter.getPhoto(index: indexPath.row)
            viewController.imageURL = image.largeImageURL
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Injection
    func configure(_ presenter: ImagesListViewPresenterProtocol) {
        self.presenter = presenter
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        
        guard newCount > oldCount else { return }
        
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: 0)
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

//MARK: - Расширения для tableView
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else {
            return 0
        }
        return presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ошибка создания ячейки таблицы, в таблице отобразится пустая ячейка")
            return UITableViewCell()
        }
        let photo = presenter?.getPhoto(index: indexPath.row)
        
        guard let photo else {
            return UITableViewCell()
        }
        
        imageListCell.configure(with: photo)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else {
            return 0
        }
        let photo = presenter.getPhoto(index: indexPath.row)
        let tableWidth = tableView.bounds.width - tableView.layoutMargins.left - tableView.layoutMargins.right
        return (photo.size.height / photo.size.width) * tableWidth + 8
    }
    
    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let presenter else { return }
        
        presenter.willDisplayRow(at: indexPath.row)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                print("✅ Обработка нажатия лайка прошла успешно")
            case .failure:
                print("❌ Ошибка лайка, photo.id: \(photo.id)")
            }
        }
    }
}
