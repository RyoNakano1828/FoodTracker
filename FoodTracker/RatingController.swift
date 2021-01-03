//
//  RatingController.swift
//  FoodTracker
//
//  Created by NeppsStaff on 2021/01/03.
//

import UIKit

@IBDesignable class RatingController: UIStackView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
        //fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: BUtton Action
    @objc func raitingButtonTapped(button: UIButton) {
        print("Button pressed")
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("Teh button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        //Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        //Clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightStar = UIImage(named: "highlightStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            //Create the buttons
            let button = UIButton()
            //button.backgroundColor = UIColor.red
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightStar, for: .highlighted)
            button.setImage(highlightStar, for: [.highlighted, .selected])
            
            //Add constrains
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup the button Action
            button.addTarget(self, action: #selector(RatingController.raitingButtonTapped(button:)), for: .touchUpInside)
            
            //Add the button to the stack
            addArrangedSubview(button)
            
            //Add new button to rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            //If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            //Set the high string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap the reset the rating to zero."
            } else {
                hintString = nil
            }
            
            //Calculate the value string
            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
