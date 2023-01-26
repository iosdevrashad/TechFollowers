//
//  FollowersListVC.swift
//
//  Created by Rashad Surratt on 1/10/23.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    
    
    
    enum Section { case main }
    
    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    
    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(userName: userName, page: page)
        configureSearchController()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController                                     = UISearchController()
        searchController.searchResultsUpdater                    = self
        searchController.searchBar.placeholder                   = "Search Username"
        searchController.obscuresBackgroundDuringPresentation    = true
        navigationItem.searchController                          = searchController
    }
    
    func getFollowers(userName: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: userName, page: page)
                updateUI(with: followers)
                dismissLoadingView()
                isLoadingMoreFollowers = false
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Uhh Ohh, don't do it.", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                isLoadingMoreFollowers = false 
                dismissLoadingView()
            }
            
            //            guard let followers = try? await NetworkManager.shared.getFollowers(for: userName, page: page) else {
            //                presentDefaultError()
            //                return
            //            }
            //
            //            updateUI(with: followers)
            //            dismissLoadingView()
        }
        
        
        //        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
        //            guard let self = self else { return }
        //            self.dismissLoadingView()
        //
        //            switch result {
        //            case .success(let followers):
        //                self.updateUI(with: followers)
        //                DispatchQueue.main.async {
        //                    if followers.isEmpty {
        //                        self.title = nil
        //                    } else {
        //                        self.title = userName
        //                    }
        //                }
        //            case .failure(let error):
        //                self.presentGFAlertOnMainThread(title: "Uhh Ohh", message: error.rawValue, buttonTitle: "Alrighty")
        //            }
        //            self.isLoadingMoreFollowers = false
        //        }
    }
    
    func updateUI(with followers: [Follower]) {
        
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "\(userName ?? "") doesn't have any followers,\nfeel free to follow them."
            DispatchQueue.main.async {
                self.showEmptyStateViewWithAttributedString(with: message, userName: self.userName, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: userName)
                addUserToFavorites(user: user)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Something ain't right.", message: gfError.rawValue, buttonTitle: "Alrighty")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        let favorite = Follower(id: user.id, login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }
            
            guard let error else {
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Success!", message: "This user was successfully added to your favorites.", buttonTitle: "Alrighty.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Something ain't right.", message: error.rawValue, buttonTitle: "Alrighty")
            }
        }
    }
}
    
    extension FollowersListVC: UICollectionViewDelegate {
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            let offSetY         = scrollView.contentOffset.y
            let contentHeight   = scrollView.contentSize.height
            let height          = scrollView.frame.size.height
            
            if offSetY > contentHeight - height {
                guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
                page += 1
                getFollowers(userName: userName, page: page)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let activeArray = isSearching ? filteredFollowers : followers
            let follower = activeArray[indexPath.item]
            
            let destVC = UserInfoVC()
            destVC.userName = follower.login
            destVC.delegate = self
            let navController = UINavigationController(rootViewController: destVC)
            present(navController, animated: true)
        }
    }
    
extension FollowersListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}


extension FollowersListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.userName   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(userName: username, page: page)
    }
}
