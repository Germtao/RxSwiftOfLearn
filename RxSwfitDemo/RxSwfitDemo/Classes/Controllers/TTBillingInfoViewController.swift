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
    
    private let disposeBag = DisposeBag()
    
    private let throttleIntervalInMilliseconds = 100
}

extension TTBillingInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "💳详情"
        
        setupCardImageDisplay()
        setupTextChangeHandling()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = self.identifier(forSegue: segue)
        switch identifier {
        case .purchaseSuccess:
            guard let destination = segue.destination as? TTCommodityComingViewController else {
                assertionFailure("Couldn't get chocolate is coming VC!")
                return
            }
            destination.cardType = cardType.value
        }
    }
}

// MARK: - Rx Setup
extension TTBillingInfoViewController {
    func setupCardImageDisplay() {
        cardType
            .asObservable() // 1.
            .subscribe(onNext: { [unowned self] (cardType) in // 2.
                self.creditCardImageView.image = cardType.image
            })
            .disposed(by: disposeBag) // 3.
    }
    
    func setupTextChangeHandling() {
        let creditCardValid = creditCardNumberTextField
            .rx
            .text // 1.
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance) // 2.
            .map { [unowned self] in
                self.validate(cardText: $0) // 3.
        }
        
        creditCardValid
            .subscribe(onNext: { [unowned self] in
                self.creditCardNumberTextField.valid = $0 // 4.
            })
            .disposed(by: disposeBag) // 5.
        
        let expirationDateValid = expirationDateTextfield
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validate(expirationDateText: $0)
        }
        
        expirationDateValid
            .subscribe(onNext: { [unowned self] in
                self.expirationDateTextfield.valid = $0
            })
            .disposed(by: disposeBag)
        
        let cvvValid = cvvTextfield
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map { [unowned self] in
                self.validate(cvv: $0)
        }
        
        cvvValid
            .subscribe(onNext: { [unowned self] in
                self.cvvTextfield.valid = $0
            })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(creditCardValid, expirationDateValid, cvvValid) {
                $0 && $1 && $2
        }
        
        everythingValid
            .bind(to: purchaseButton.rx.isEnabled)
            .disposed(by: disposeBag)
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
        advanceIfNecessary(expirationNoSpacesOrSlash: strippedSlashExpiration)
        
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

extension TTBillingInfoViewController: TTSegueHandlerType {
    enum SegueIdentifier: String {
        case purchaseSuccess
    }
}
