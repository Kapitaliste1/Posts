//
//  CompanyDetailView.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-06.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit


  
class CompanyDetailView: UIView {
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyBSLabel: UILabel!
    @IBOutlet weak var companyCatchPhraseLabel: UILabel!

    @IBOutlet var view: UIView!
    let reversedRotation : CATransform3D = CATransform3D(m11: -0.9876883405951372, m12: 0.0, m13: -0.15643446504023087, m14: 0.0, m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m31: 0.15643446504023087, m32: 0.0, m33: -0.9876883405951372, m34: 0.0, m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0)
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    func xibSetup() {
        self.view = loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CompanyDetailView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func setupView(company : Company) {
        self.companyNameLabel.text = company.name
        self.companyBSLabel.text = company.bs
        self.companyCatchPhraseLabel.text = company.catchPhrase
        if #available(iOS 13.0, *) {
            self.companyBSLabel.transform3D =  self.reversedRotation
            self.companyNameLabel.transform3D =  self.reversedRotation
            self.companyCatchPhraseLabel.transform3D = self.reversedRotation
        } else {
            // Fallback on earlier versions
        }
        self.setNeedsDisplay()
    }
    
   
 
}

