//
//  Untitled.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit

// MARK: - Models
struct StepModel {
    let title: String
    let isCurrent: Bool
}

// MARK: - Step Indicator View
class StepIndicatorView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let spacing: CGFloat = 12
        static let circleSize: CGFloat = 26
        static let lineSize = CGSize(width: 14, height: 5)
        static let cornerRadius: CGFloat = 2
        static let selectedColor = UIColor(hex: "#FFAD1F")
        static let normalColor = UIColor(hex: "#DDDDDD")
        static let selectedTextColor: UIColor = .white
        static let normalTextColor: UIColor = .darkGray
    }
    
    // MARK: - Properties
    var models: [StepModel]? {
        didSet { setupSteps() }
    }
    
    // MARK: - UI Components
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.spacing
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSteps() {
        clearContainer()
        guard let models = models, !models.isEmpty else { return }
        
        for (index, model) in models.enumerated() {
            let stepCircle = createStepCircle(for: model, index: index)
            containerStackView.addArrangedSubview(stepCircle)
            
            if index != models.count - 1 {
                let lineView = createLineView(isCurrent: model.isCurrent)
                containerStackView.addArrangedSubview(lineView)
            }
        }
    }
    
    // MARK: - View Creation
    
    private func createStepCircle(for model: StepModel, index: Int) -> UIView {
        let circle = UILabel()
        circle.text = "\(index + 1)"
        circle.textAlignment = .center
        circle.font = .systemFont(ofSize: 14, weight: .medium)
        configureStepCircle(circle, with: model)
        
        circle.snp.makeConstraints { make in
            make.size.equalTo(Constants.circleSize)
        }
        
        return circle
    }
    
    private func configureStepCircle(_ circle: UILabel, with model: StepModel) {
        if model.isCurrent {
            circle.backgroundColor = Constants.selectedColor
            circle.textColor = Constants.selectedTextColor
        } else {
            circle.backgroundColor = Constants.normalColor
            circle.textColor = Constants.normalTextColor
        }
        
        circle.layer.cornerRadius = Constants.cornerRadius
        circle.layer.masksToBounds = true
    }
    
    private func createLineView(isCurrent: Bool) -> UIView {
        let lineImageView = UIImageView()
        let imageName = isCurrent ? "sel_dot_image" : "nor_dot_image"
        lineImageView.image = UIImage(named: imageName)
        lineImageView.contentMode = .scaleAspectFit
        
        lineImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.lineSize)
        }
        
        return lineImageView
    }
    
    // MARK: - Helper Methods
    
    private func clearContainer() {
        containerStackView.arrangedSubviews.forEach {
            containerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func updateModel(at index: Int, isCurrent: Bool) {
        guard var models = models,
              index >= 0 && index < models.count else { return }
        
        var updatedModels = models
        updatedModels[index] = StepModel(
            title: models[index].title,
            isCurrent: isCurrent
        )
        
        self.models = updatedModels
    }
}
