//
//  MovieDetailViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    private let movieDetailView = MovieDetailView()
    let viewModel = MovieDetailViewModel()
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveLikeState()
    }

    override func bind() {
        viewModel.output.movieImage.lazyBind { [weak self] images in
            if let images, let filePaths = self?.viewModel.makeFilePathList(images: images) {
                self?.movieDetailView.configPages(data: filePaths)
                self?.movieDetailView.posterCollectionView.reloadData()
            }
        }
        viewModel.output.castingList.lazyBind { [weak self] _ in
            self?.movieDetailView.castCollectionView.reloadData()
        }
        viewModel.output.isLiked.lazyBind { [weak self] isLiked in
            if let isLiked {
                self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
            }
        }
    }

    override func configView() {
        movieDetailView.fetchMovieData(movie: viewModel.selectedMovie)
        viewModel.fetchIsLiked()
    }
    
    override func configDelegate() {
        movieDetailView.backDropHorizontalScrollView.delegate = self
        movieDetailView.castCollectionView.delegate = self
        movieDetailView.castCollectionView.dataSource = self
        movieDetailView.posterCollectionView.dataSource = self
        movieDetailView.posterCollectionView.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func configNavigation() {
        guard let selectedMovie = viewModel.selectedMovie, let isLiked = viewModel.isLiked else {
            print(#function, "selected movie or isLiked nil. check MovieDetailViewModel properties.")
            return
        }
        
//        let alreadyLiked = UserDefaultsManager.shared.likedList.likedMovie.contains(selectedMovie.id)
//        let image = UIImage(systemName: alreadyLiked ? "heart.fill" : "heart")
//        self.isLiked = alreadyLiked ? true : false
        
        let image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
//        let image = UIImage(systemName: "heart")
        
        navigationItem.title = selectedMovie.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { [weak self] _ in
                // TODO: vc pop 시 좋아요 상태 저장
//
//                var newList = UserDefaultsManager.shared.likedList
//                
//                
//                
//                if self?.viewModel.isLiked && !alreadyLiked {
//                    newList.likedMovie.append(selectedMovie.id)
//                    UserDefaultsManager.shared.setData(kind: .likedMovie, type: LikedList.self, data: newList)
//                } else if !self?.isLiked && alreadyLiked {
//                    if let index = newList.likedMovie.firstIndex(of: selectedMovie.id) {
//                        newList.likedMovie.remove(at: index)
//                        UserDefaultsManager.shared.setData(kind: .likedMovie, type: LikedList.self, data: newList)
//                    }
//                }

                self?.navigationController?.popViewController(animated: true)
            })
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            primaryAction: UIAction(handler: { _ in
                self.viewModel.input.isLiked.value?.toggle()
                print("좋아요 💝")
            })
        )
    }
}

extension MovieDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case movieDetailView.backDropHorizontalScrollView:
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            movieDetailView.backDropPageControl.currentPage = Int(pageIndex)
            break
        default:
            break
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case movieDetailView.castCollectionView:
            return viewModel.castingList.count
        case movieDetailView.posterCollectionView:
            return viewModel.posterList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        switch collectionView {
        case movieDetailView.castCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell
            cell.config(item: viewModel.castingList[item])
            return cell
            
        case movieDetailView.posterCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell
            cell.config(item: viewModel.posterList[item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case movieDetailView.castCollectionView:
            return CGSize(width: screenWidth / 2.5, height: 40)
        case movieDetailView.posterCollectionView:
            return CGSize(width: screenWidth / 3.5, height: screenHeight * 0.2 )
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
}
