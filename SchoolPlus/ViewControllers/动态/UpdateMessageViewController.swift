//
//  UpdateMessageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/15.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import YPImagePicker
import RxSwift
import RxCocoa
import ProgressHUD

class UpdateMessageViewController: UIViewController {
    var scrollView = UIScrollView()
    var textView = UITextView()
    var collectionView :  UICollectionView!
    var images:[UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var newImages:[UIImage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var info: Infomation?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        initSubView()
        updateConstraints()
        if let info = info {
            textView.text = info.text
            
            if !(info.media?.isEmpty ?? true) && images.isEmpty  {
                print(info.media!)
                for image in info.media! {
                    if let url = URL(string: image) {
                        do {
                            let data = try Data(contentsOf: url)
                            if let image = UIImage(data: data) {
                                images.append(image)
                            }
                        }catch let error as NSError {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func initSubView(){
        self.view.backgroundColor = UIColor.white
        title = "发布动态"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "✈️", style: .plain, target: self, action: #selector(done))
        scrollView.frame = self.view.frame
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        self.scrollView.addSubview(textView)
        textView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        textView.addButtonLine()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 1.0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 45, width: self.view.frame.width, height: 100), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
        self.scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.top.equalTo(55+textView.frame.size.height)
            $0.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        })
        
        textView.rx.didChange
            .subscribe(onNext: {
                print("正在输入")
                self.updateConstraints()
            })
            .disposed(by: disposeBag)

        textView.becomeFirstResponder()
    }
    
    @objc func done() {
        if let info = info {
            print("编辑")
            print(info.newsId!)
            print(newImages)
            print(info.media!)
            ProgressHUD.show("正在加载中")
            info.editNews(newsId:info.newsId!,text: textView.text!, media: info.media!,pic:newImages).subscribe(onNext:{ string in
                guard string == "success" else {
                    ProgressHUD.show(string)
                    return
                }
                    ProgressHUD.showSucceed()
                    self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            user.uploadNews(text: textView.text!, pic: images).subscribe(onNext:{ string in
                guard string == "success" else {
                    ProgressHUD.show(string)
                    return
                }
                ProgressHUD.showSucceed()
                self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    
  
    
    func updateConstraints() {
        let frame = self.textView.frame
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        let constrainSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let size = self.textView.sizeThatFits(constrainSize)
        
        scrollView.contentSize.height = 100+size.height+contentSize.height
        self.textView.frame.size.height=size.height
        
        self.collectionView.snp.remakeConstraints({
                   $0.top.equalTo(55+textView.frame.size.height)
                   $0.left.equalToSuperview()
                   $0.width.equalToSuperview()
                   $0.height.equalTo(contentSize.height)
               })
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    @objc func deleteImage(_ sender: AnyObject) {
        print("触发方法")
        let btn = sender as! UIButton
        let cell = superUICollectionViewCell(of: btn)!
        let indexPath = collectionView.indexPath(for: cell)
        if indexPath?.item ?? 100 < images.count {
            images.remove(at: indexPath!.item)
        }
        if let info = info {
            if !(info.media)!.isEmpty && indexPath!.row < (info.media)!.count {
                info.media?.remove(at: indexPath!.item)
            }
        }
    }
    

}

extension UpdateMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num:CGFloat = 4.0
        let width = collectionView.bounds.width/num
        let height:CGFloat = 100.0
        
        if indexPath.row == 0 {
            let realWidth = collectionView.bounds.width - width * (num-1)
            return CGSize(width: realWidth, height: height)
        } else {
            return CGSize(width: width, height: height)
        }
    }
    
    func superUICollectionViewCell(of: UIButton) -> UICollectionViewCell? {
        for view in sequence(first: of.superview, next: { $0?.superview }) {
            if let cell = view as? UICollectionViewCell {
                return cell
            }
        }
        return nil
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count+1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        if indexPath.row == images.count {
            cell.imageView.image = UIImage(named: "zhaoxiangji")
        } else {
            cell.imageView.image = images[indexPath.row]
            if indexPath.row < images.count {
                cell.deleteButton.isHidden = false
            }
            cell.deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击item")
        if indexPath.row == images.count {
            guard images.count < 9 else {
                ProgressHUD.showFailed("最多9张图片")
                return}
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = 9
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if items.count + self.images.count == 9 {
                    print("超过9张照片")
                }
                for item in items {
                    switch item {
                    case .photo(let photo):
                        print(photo)
                        if self.images.count <= 9 {
                            self.newImages.append(photo.image)
                            self.images.append(photo.image)
                        }
                    case .video(let video):
                        print(video)
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        } else {
            let previewVC = ImageDetailViewController(images: images)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
}

