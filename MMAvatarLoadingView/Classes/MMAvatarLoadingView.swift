//
//  MMAvatarLoadingView.swift
//  MMAvatarLoadingView
//
//  Created by Mohamed EL Meseery on 7/21/18.
//

import UIKit

public class MMAvatarLoadingView: UIImageView{
    
    //MARK:- Private vars & Functions
    private var downloadManager : MMDownloadService?
    private var circleProgressBar : MMCircleProgressBar?
    private var progressBarColor : UIColor?
    private var progressBarLineWidth : CGFloat = 0.0
    
    
    // MARK: Public vars & Functions.
    public func loadImage(fromURL imageURL:URL,
                          placeholder : UIImage? = nil,
                          progressBarColor : UIColor = UIColor.clear,
                          progressBarLineWidth : CGFloat = 0.0){
        
        /// Placeholder Image
        self.image = placeholder
        
        /// Progress Bar
        self.setProgressBar()
        self.circleProgressBar?.progressBarColor = progressBarColor
        self.circleProgressBar?.progressBarWidth = progressBarLineWidth
        
        /// Download Manager
        if !(downloadManager != nil)  {
            downloadManager = MMDownloadService.init(cacheMaxImagesCount: 20, cacheOnDiskSizeInBytes: 1024*1024)
        }
        downloadManager?.downloadFile(withURL: imageURL,
                                      onProgress: {[weak self] (progress) in
                self?.setProgress(progress: progress)
            }, onSuccess: { [weak self] (imageData) in
                self?.setImage(withImageData: imageData)
            }, onFailure: { [weak self] (error) in
                self?.showError(error)
        })
    }
    
    // MARK: Private Functions.
    private func setImage(withImageData data:Data?){
        guard let imageData = data  else {
            return
        }
        DispatchQueue.main.async {
            if let image = UIImage(data: imageData) {
                UIView.transition(with: self,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.image = image
                }, completion: { (completed) in
                    self.dismissProgressBar()
                })
            }
        }
    }
    
    private func setProgress(progress:Float){
        self.circleProgressBar?.progress = progress
    }
    
    private func showError(_ error:Error?){
        guard error != nil else { return }
        DispatchQueue.main.async {
            self.dismissProgressBar()
        }
        updateErrorImage {
            //TODO: Show error
            
            
        }
    }
    
    private func updateErrorImage(completion: @escaping () -> ()) {
        let errorImage = UIImage(named: "error")?.withRenderingMode(.alwaysTemplate)
        DispatchQueue.main.async {
            self.image = errorImage
            self.tintColor = UIColor.red
            completion()
        }
    }
    
    private func setProgressBar() {
        circleProgressBar = MMCircleProgressBar(frame:self.bounds)
        self.addSubview(circleProgressBar!)
    }
    
    private func dismissProgressBar() {
        circleProgressBar?.removeFromSuperview()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width/2;
        self.layer.masksToBounds = true
    }
    
}
