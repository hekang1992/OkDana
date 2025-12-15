//
//  DashedLineView.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit

class DashedLineView: UIView {
    
    var lineColor: UIColor = .gray
    var lineWidth: CGFloat = 1.0
    var dashPattern: [NSNumber] = [4, 4]
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLine()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    private func setupLine() {
        layer.addSublayer(shapeLayer)
    }
    
    private func updatePath() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        
        // path.move(to: CGPoint(x: bounds.midX, y: 0))
        // path.addLine(to: CGPoint(x: bounds.midX, y: bounds.height))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.fillColor = UIColor.clear.cgColor
    }
}
