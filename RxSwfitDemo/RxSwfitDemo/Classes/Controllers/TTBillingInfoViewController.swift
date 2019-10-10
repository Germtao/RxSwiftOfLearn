//
//  TTBillingInfoViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TTBillingInfoViewController: UIViewController {
    @IBOutlet weak var creditCardNumberTextField: TTValidatingTextField!
    @IBOutlet weak var creditCardImageView: UIImageView!
    @IBOutlet weak var expirationDateTextfield: TTValidatingTextField!
    @IBOutlet weak var cvvTextfield: TTValidatingTextField!
    @IBOutlet weak var purchaseButton: UIButton!
    
    private let cardType: BehaviorRelay<TTCardType> = BehaviorRelay(value: .unknown)
}

extension TTBillingInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "💳详情"
    }
}

private extension TTBillingInfoViewController {
    /// 验证卡号是否有效
    func validate(cardText: String?) -> Bool {
        guard let cardText = cardText else { return false }
        
        let noWhiteSpace = cardText.removingSpaces
        
        updateCardType(using: noWhiteSpace)
        formatCardNumber(using: noWhiteSpace)
        advanceIfNecessary(noSpacesCardNumber: noWhiteSpace)
        
        guard cardType.value != .unknown else { return false }
        
        guard noWhiteSpace.isValid else { return false }
        
        return noWhiteSpace.count == cardType.value.expectedDigits
    }
    
    /// 验证日期是否有效
    func validate(expirationDateText expiration: String?) -> Bool {
        guard let expiration = expiration else { return false }
        
        let strippedSlashExpiration = expiration.removingSlash
        
        formatExpirationDate(using: strippedSlashExpiration)
        advanceIfNecessary(noSpacesCardNumber: strippedSlashExpiration)
        
        return strippedSlashExpiration.isExpirationDateValid
    }
    
    /// 验证cvva码是否有效
    func validate(cvv cvvString: String?) -> Bool {
        guard let cvvString = cvvString,
            cvvString.areAllCharactersNumbers else { return false }
        
        dismissIfNecessary(cvv: cvvString)
        
        return cvvString.count == cardType.value.cvvDigits
    }
}

private extension TTBillingInfoViewController {
    func updateCardType(using noSpacesNumber: String) {
        cardType.accept(TTCardType.fromString(string: noSpacesNumber))
    }
    
    func formatCardNumber(using noSpacesCardNumber: String) {
        creditCardNumberTextField.text = cardType.value.format(noSpaces: noSpacesCardNumber)
    }
    
    func advanceIfNecessary(noSpacesCardNumber: String) {
        if noSpacesCardNumber.count == cardType.value.expectedDigits {
            expirationDateTextfield.becomeFirstResponder()
        }
    }
    
    func formatExpirationDate(using expirationNoSpacesOrSlash: String) {
        expirationDateTextfield.text = expirationNoSpacesOrSlash.addingSlash
    }
    
    func advanceIfNecessary(expirationNoSpacesOrSlash: String) {
        if expirationNoSpacesOrSlash.count == 6 {
            cvvTextfield.becomeFirstResponder()
        }
    }
    
    func dismissIfNecessary(cvv: String) {
        if cvv.count == cardType.value.cvvDigits {
            _ = cvvTextfield.resignFirstResponder()
        }
    }
}
