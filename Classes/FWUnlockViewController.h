//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//
#import <StoreKit/StoreKit.h>
@class FWUnlockViewController;

enum{
    LineLifeItem1,
    LineLifeItem2,
    LineLifeItem3,
    LineLifeItem4,}
buyCoinsTag;

@protocol FWUnlockViewControllerDelegate

- (void)returnButtonTapped:(FWUnlockViewController *)returnViewController;
- (void)unlockItem1ButtonTapped:(FWUnlockViewController *)unlockViewController;
- (void)unlockItem2ButtonTapped:(FWUnlockViewController *)unlockViewController;
- (void)unlockItem3ButtonTapped:(FWUnlockViewController *)unlockViewController;
- (void)unlockItem4ButtonTapped:(FWUnlockViewController *)unlockViewController;

@end

@interface FWUnlockViewController : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate >
{
    int buyType;
}

@property (nonatomic, weak) id<FWUnlockViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;

//内购代码
- (void) requestProUpgradeProductData;
- (void) RequestProductData;
- (void) buy:(int)type;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) PurchasedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentTransaction *)transaction;
- (void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) provideContent:(NSString *)product;
- (void) recordTransaction:(NSString *)product;
@end
