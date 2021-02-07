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
        self.setNeedsDisplay()
    }
    
   
 
}

