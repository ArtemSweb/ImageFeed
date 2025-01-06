//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    //Список картинок
    private let photosName: [String] = Array(0..<20).map {"\($0)"}
    
    //форматирование даты
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        //стили таблицы
        //отступы всей таблицы (16(макет)-4(отступы для каждой картинки)=12)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    //MARK: - Реализация segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - Вспомогательные методы
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.imageCell.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLike = indexPath.row % 2 == 0
        let likeImage = isLike ? UIImage(named: "Active") : UIImage(named: "No Active")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

//MARK: - Расширения для tableView
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ошибка создания ячейки таблицы, в таблице отобразится пустая ячейка") //принт для отладки приложения
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
//        Подсказка: Высота ImageView будет ровно во столько же раз больше высоты image, во сколько раз ширина ImageView больше ширины image.
        let imageViewWidth = tableView.bounds.width - 32 //32 так как отступы по бокам - 16
        let imageWidth = image.size.width //реальная ширина картинки
        let scale = imageViewWidth / imageWidth //индекс скалирования
        let cellHeight = image.size.height * scale + 8 //8 так как отступы сверху и снизу по 4
        
        return cellHeight
    }
}
