//
//  ViewController.swift
//  TapTest
//
//  Created by 財部圭太 on 2018/11/06.
//  Copyright © 2018年 財部圭太. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIGestureRecognizerDelegate {
	
	var myImageView:UIImageView!
	var scale:CGFloat = 1.0
	var screenWidth:CGFloat = 0
	var screenHeight:CGFloat = 0
	
	//表示されている画像のタップ座標用変数
	var tapPoint = CGPoint(x: 0, y: 0)
	//元の画像のタップ座標用変数
	var originalTapPoint = CGPoint(x: 0, y: 0)
	
	var imageWidth:CGFloat = 0
	var imageHeight:CGFloat = 0
	var imageRawValue:Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Screen Size の取得
		screenWidth = self.view.bounds.width
		screenHeight = self.view.bounds.height
		let image = UIImage(named: "Map.png")!
		imageWidth = image.size.width
		imageHeight = image.size.height
		imageRawValue = image.imageOrientation.rawValue
		
		myImageView = UIImageView(image: image)
		
		// 画像サイズをスクリーン幅に合わせる
		scale = screenWidth/imageWidth
		let rect:CGRect = CGRect(x:0, y:0, width:imageWidth * scale, height:imageHeight * scale)
		myImageView.frame = rect
		myImageView.image = image
		
		// 画像の中心をスクリーンの中心位置に設定
		myImageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
		
		// 画像の縦横サイズ比率を変えずに制約に合わせる
		myImageView.contentMode = UIView.ContentMode.scaleAspectFit
		
		let imageSize:CGSize
		// UIImageの向きによって縦横を変える
		switch image.imageOrientation.rawValue {
		case 3:
			imageSize = CGSize(width: image.size.height, height: image.size.width)
		default:
			imageSize = CGSize(width: image.size.width, height: image.size.height)
		}
		
		 //UIImageViewのサイズを表示されている画像のサイズに合わせる
		if imageSize.width > imageSize.height{
			myImageView.frame.size.height = imageSize.height/imageSize.width * myImageView.frame.width
		}else{
			myImageView.frame.size.width = imageSize.width/imageSize.height * myImageView.frame.height
		}
		
		//表示位置を真ん中にする
		myImageView.center = self.view.center
		
		//画像のタップイベント有効化
		myImageView.isUserInteractionEnabled = true
		
		let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(ViewController.tapAction(_:)))
		
		// デリゲートをセット
		tapGesture.delegate = self
		
		myImageView.addGestureRecognizer(tapGesture)
		self.view.addSubview(myImageView)
	}
	
	//画像のどこの座標をタップしたかを取得する関数
	@objc func tapAction(_ sender: UITapGestureRecognizer){
		
		tapPoint = sender.location(in: myImageView)
		//向きによって元の画像のタップ座標を変える(右に90°回転している場合)
		switch imageRawValue {
		case 3:
			originalTapPoint.x = imageHeight/myImageView.frame.height * tapPoint.y
			originalTapPoint.y = imageWidth - (imageWidth/myImageView.frame.width * tapPoint.x)
		default:
			originalTapPoint.x = imageWidth/myImageView.frame.width * tapPoint.x
			originalTapPoint.y = imageHeight/myImageView.frame.height * tapPoint.y
		}
		print(originalTapPoint)
	}
}

