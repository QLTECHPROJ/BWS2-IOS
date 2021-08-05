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
    var isIAPEnabled = shouldEnableIAP
    var successPurchase : ( () -> Void )?
    var originalTransactionID:String?
    var planID:String?
    
    
    //MARK:- product fetch
    
    //Retrieve Data from ProductID
    func productRetrive(arrayProductIDs: [String], complition : @escaping (Bool,Set<IAPPlanDetailsModel>?) -> Void) {
        showHud()
        let productIDS = Set(arrayProductIDs)
        SwiftyStoreKit.retrieveProductsInfo(productIDS) { result in
            hideHud()
            
            var arrayPlanData = Set<IAPPlanDetailsModel>()
            
            if result.retrievedProducts.count > 0 {
                for i in result.retrievedProducts {
                    let planProduct = IAPPlanDetailsModel()
                    planProduct.iapProductIdentifier = i.productIdentifier
                    planProduct.iapTitle = i.localizedTitle
                    planProduct.iapDescription = i.localizedDescription
                    planProduct.iapPrice = i.localizedPrice ?? ""
                    
                    if #available(iOS 12.0, *) {
                        planProduct.iapTrialPeriod = i.introductoryPrice?.localizedSubscriptionPeriod ?? ""
                        planProduct.iapSubscriptionPeriod = i.localizedSubscriptionPeriod
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    arrayPlanData.insert(planProduct)
                }
                
                print("Plan Data :- ",arrayPlanData)
                complition(true,arrayPlanData)
            } else {
                complition(false,nil)
            }
            
            self.alertForProductRetrievalInfo(result)
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    
    // MARK:- Purchase Subscriptions
    func purchaseSubscriptions(productIdentifier : String, atomically: Bool) {
        showHud()
        SwiftyStoreKit.purchaseProduct(productIdentifier, atomically: atomically) { result in
            hideHud()
            
            if case .success(let purchase) = result {
                self.originalTransactionID = purchase.transaction.transactionIdentifier
                self.planID = purchase.productId
                print("transactionIdentifier:-",purchase.transaction.transactionIdentifier ?? "")
                print("PurchaseProductID:-",purchase.productId)
                
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                self.successPurchase?()
            }
            
            self.alertForPurchaseResult(result)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown:
                alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                print("User cancelled the request")
            case .paymentInvalid: // purchase identifier was invalid, etc.
                alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }
    
    
    // MARK:- Verify Subscriptions
    func verifySubscriptions(productIdentifier : String) {
        showHud()
        verifyReceipt { result in
            hideHud()
            switch result {
            case .success(let receipt):
                let productIDS = Set([productIdentifier])
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIDS, inReceipt: receipt)
                self.alertForVerifySubscriptions(purchaseResult, productIds: productIDS)
            case .error:
                self.alertForVerifyReceipt(result)
            }
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "d8685d38871b4df48bd3221b50629a64")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) {
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
            alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) {
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    
    // MARK:- Restore Purchase
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
            
            self.alertForRestorePurchases(results)
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) {
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    
    // MARK:- Alert
    func alertWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
}
