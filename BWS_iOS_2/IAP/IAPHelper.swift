//
//  IAPHelper.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 21/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

class IAPHelper : UIViewController {
    
    // MARK:- VARIABLES
    static var shared = IAPHelper()
    var isIAPEnabled = false
    var arrPlanData = [SKProduct]()
    var successPurchase : ( () -> Void )?
    var originalTransactionID:String?
    
    
    //MARK:- product fetch
    func productRetrive(arrProdID:[String]) {
        //Retrieve Data from ProductID
        
        showHud()
        let productIDS = Set(arrProdID)
        SwiftyStoreKit.retrieveProductsInfo(productIDS) { result in
            hideHud()
            self.alertForProductRetrievalInfo(result)
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) {
        
        let prod = result.retrievedProducts
        print(prod)
        
        for i in prod {
            arrPlanData = [i]
            print("1.PLAN_NAME:-",i.localizedTitle,"2. USER:-",i.localizedDescription, "3.PRICE:-",i.localizedPrice! , "4.LOCAL_PRICE:-",i.priceLocale,"5.PRICENEW:-",i.price)
            
        }
    }
    
    //MARK:-  purchase
    func purchaseSubscriptions(atomically: Bool) {
        
        showHud()
        SwiftyStoreKit.purchaseProduct(self.arrPlanData[0].productIdentifier, atomically: atomically) { result in
            hideHud()
            print("PurchaseProductID:-",self.arrPlanData[0].productIdentifier)
            
            if case .success(let purchase) = result {
                self.originalTransactionID = purchase.transaction.transactionIdentifier
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
            self.successPurchase?()
        }
        
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }
    
    //MARK:- verify
    func verifySubscriptions() {
        
        showHud()
        verifyReceipt { result in
            hideHud()
            switch result {
            case .success(let receipt):
                let data = [self.arrPlanData[0].productIdentifier]
                let productIDS = Set(data)
              
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIDS, inReceipt: receipt)
                self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: productIDS))
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "d8685d38871b4df48bd3221b50629a64")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {

        switch result {
        case .success(let receipt):
            print("Verify receipt:-",convertIntoJSON(arrayObject: receipt)!)
           
            // Get the receipt if it's available
            if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
                FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

                do {
                    let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    print(receiptData)

                    let receiptString = receiptData.base64EncodedString(options: [])
                    print(receiptString)
                    // Read receiptData
                }
                catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
            }
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {

        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
            
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    //MARK:- Restore Purchase
    func restorePurchase()  {
        showHud()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            hideHud()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
            
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    //MARK:-  Alert
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
}
