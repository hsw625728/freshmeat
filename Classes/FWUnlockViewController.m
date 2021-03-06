//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWUnlockViewController.h"
#import "TheseusAppDelegate.h"
#import "TheseusAppDelegate.h"
//#import "UIColor+FWAppColors.h"
//#import "UIFont+FWAppFonts.h"
//#import "UIView+FWConvenience.h"
//#import "FWPatternPickerViewController.h"

@interface FWUnlockViewController ()

/*
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIButton *unlockItem1Button;
@property (nonatomic, strong) UIButton *unlockItem2Button;
@property (nonatomic, strong) UIButton *unlockItem3Button;
@property (nonatomic, strong) UIButton *unlockItem4Button;
@property (nonatomic, strong) UILabel *copyrightLabel;
*/
@property (retain, nonatomic) IBOutlet UIButton *unlockItem1Button;
@property (retain, nonatomic) IBOutlet UIButton *unlockItem2Button;
@property (retain, nonatomic) IBOutlet UIButton *unlockItem3Button;
@property (retain, nonatomic) IBOutlet UIButton *unlockItem4Button;
@property (retain, nonatomic) IBOutlet UIButton *returnButton;
@property (retain, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (retain, nonatomic) IBOutlet UILabel *descLabel;
 
@property (nonatomic, assign) BOOL areFirstLoadAnimationsExecuted;

@end

@implementation FWUnlockViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _areFirstLoadAnimationsExecuted = NO;
    }
    return self;
}

#pragma mark - UIViewController
- (void)updateText{
    
        self.unlockItem4Button = [FWUnlockViewController createMenuButtonWithTitle:NSLocalizedString(@"unlock.item4", @"6元购买60个宝石")];

        self.unlockItem3Button = [FWUnlockViewController createMenuButtonWithTitle:NSLocalizedString(@"unlock.item3", @"12元购买130个宝石")];

        self.unlockItem2Button = [FWUnlockViewController createMenuButtonWithTitle:NSLocalizedString(@"unlock.item2", @"18元购买300个宝石")];

        self.unlockItem1Button = [FWUnlockViewController createMenuButtonWithTitle:NSLocalizedString(@"unlock.item1", @"40元购买1000个宝石")];
     
}

- (void)viewDidLoad
{
    //等待动画指示器
    _activityIndicatorView = [ [ UIActivityIndicatorView alloc ] initWithFrame:CGRectMake(250.0,20.0,30.0,30.0)];
    //这个可以修改指示器风格
    _activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicatorView];
    
    //_descLabel.text = @"点击提示按钮会自动走一步\n同时会消耗一个宝石币";
    self.returnButton = [FWUnlockViewController createMenuButtonWithTitle:NSLocalizedString(@"unlock.return", @"关闭宝石页面")];
    [self updateText];

    /*
    [self.returnButton addTarget:self action:@selector(returnButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.unlockItem1Button addTarget:self action:@selector(unlockItem1ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.unlockItem2Button addTarget:self action:@selector(unlockItem2ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.unlockItem3Button addTarget:self action:@selector(unlockItem3ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.unlockItem4Button addTarget:self action:@selector(unlockItem4ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    */
    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.text = NSLocalizedString(@"launch.copyright", @"© 2017 mengyoutu.cn");
    //self.copyrightLabel.font = [UIFont tinyBold];
    self.copyrightLabel.textColor = [UIColor whiteColor];
    

    
    self.unlockItem1Button.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 100);
    self.unlockItem2Button.frame = CGRectMake(self.view.frame.size.width/2, 200, self.view.frame.size.width/2, 100);
    self.unlockItem3Button.frame = CGRectMake(self.view.frame.size.width/2, 400, self.view.frame.size.width/2, 100);
    self.unlockItem4Button.frame = CGRectMake(self.view.frame.size.width/2, 600, self.view.frame.size.width/2, 100);
    
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.unlockItem1Button];
    [self.view addSubview:self.unlockItem2Button];
    [self.view addSubview:self.unlockItem3Button];
    [self.view addSubview:self.unlockItem4Button];
    [self.view addSubview:self.copyrightLabel];
    
    
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //[self buy:IAP0p20];
}

- (void)viewWillLayoutSubviews
{
    //[super viewWillLayoutSubviews];
    /*
    [self.copyrightLabel sizeToFit];
    CGRect copyrightFrame = self.copyrightLabel.frame;
    copyrightFrame.origin.x = FWRoundFloat((self.view.bounds.size.width - copyrightFrame.size.width) / 2.0f);
    copyrightFrame.origin.y = self.view.bounds.size.height - copyrightFrame.size.height - 12.0f;
    self.copyrightLabel.frame = copyrightFrame;
    
    NSArray *buttons = @[self.returnButton, self.unlockItem1Button, self.unlockItem2Button, self.unlockItem3Button, self.unlockItem4Button];
    CGFloat availableHeight = self.copyrightLabel.frame.origin.y - CGRectGetMaxY(self.logoImageView.frame);
    //CGFloat buttonSpacing = [UIView verticalSpaceToDistributeViews:buttons inAvailableVerticalSpace:availableHeight];
    CGFloat buttonSpacing = 10;*/
    /*[UIView distributeVerticallyViews:buttons
                      startingAtPoint:CGPointMake(FWRoundFloat(self.view.bounds.size.width / 2.0f), CGRectGetMaxY(self.logoImageView.frame) + buttonSpacing)
                          withSpacing:buttonSpacing];*/
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.areFirstLoadAnimationsExecuted)
    {
        [self animateItems];
        self.areFirstLoadAnimationsExecuted = YES;
    }
}

#pragma mark - Private Methods

- (void)animateItems
{
    /*
    [self.logoImageView slideTo:[self.logoImageView frameWithY:50.0f] duration:0.7f delay:0.4f completion:nil];
    [self.returnButton fadeInWithDuration:0.5f delay:1.0f];
    [self.unlockItem1Button fadeInWithDuration:0.5f delay:1.0f];
    [self.unlockItem2Button fadeInWithDuration:0.5f delay:1.0f];
    [self.unlockItem3Button fadeInWithDuration:0.5f delay:1.0f];
    [self.unlockItem4Button fadeInWithDuration:0.5f delay:1.0f];
     */
}

- (IBAction)meat1:(id)sender {
    [self buy:LineLifeItem1];
}
- (IBAction)meat2:(id)sender {
    [self buy:LineLifeItem1];
}
- (IBAction)meat3:(id)sender {
    [self buy:LineLifeItem3];
}
- (IBAction)meat4:(id)sender {
    [self buy:LineLifeItem4];
}
- (IBAction)returnButton:(id)sender {
    //关闭购买界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    //[newButton.titleLabel setFont:[UIFont largeBold]];
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    newButton.alpha = 0.0f;
    newButton.frame = CGRectMake(0.0f, 0.0f, 300.0f, 30.0f);
    newButton.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin
                    | UIViewAutoresizingFlexibleRightMargin
                    | UIViewAutoresizingFlexibleBottomMargin
                    | UIViewAutoresizingFlexibleLeftMargin;
    return newButton;
}

-(void)buy:(int)type{
    buyType = type;
    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductData]; NSLog(@"允许程序内付费购买");
    }else{
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买"
                                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        [alerView show]; }
}

-(void)RequestProductData{
    
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType)
    {
        case LineLifeItem1: product=[[NSArray alloc] initWithObjects:@"UNLOCK",nil];
            break;
            
        case LineLifeItem2: product=[[NSArray alloc] initWithObjects:@"UNLOCK",nil];
            break;
            
        case LineLifeItem3: product=[[NSArray alloc] initWithObjects:@"DIAMOND_3",nil];
            break;
            
        case LineLifeItem4: product=[[NSArray alloc] initWithObjects:@"DIAMOND_4",nil];
            break;
            
        default:
            break;
    }
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    
    [request start];
    [_activityIndicatorView startAnimating];
}

//<SKProductsRequestDelegate> 请求协议//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [_activityIndicatorView stopAnimating];
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
    }
    
    SKPayment *payment = nil;
    switch (buyType) {
            
        case LineLifeItem1:
            payment = [SKPayment paymentWithProductIdentifier:@"UNLOCK"]; //支付6
            break;
            
        case LineLifeItem2:
            payment = [SKPayment paymentWithProductIdentifier:@"DIAMOND_2"]; //支付12
            break;
            
        case LineLifeItem3:
            payment = [SKPayment paymentWithProductIdentifier:@"DIAMOND_3"]; //支付25
            break;
            
        case LineLifeItem4:
            payment = [SKPayment paymentWithProductIdentifier:@"DIAMOND_4"]; //支付45
            break;
            
        default:
            break;
    }
    NSLog(@"---------发送购买请求------------");
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestProUpgradeProductData{
    
    NSLog(@"------请求升级数据---------");
    
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
}

-(void) requestDidFinish:(SKRequest *)request{
    
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    
    NSLog(@"-----PurchasedTransaction----");
    
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [ self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    
}

//<SKPaymentTransactionObserver>千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{

NSLog(@"-----paymentQueue--------");

for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchased:{
            //交易完成
            [self  completeTransaction:transaction];
            
            NSLog(@"-----交易完成 --------");
            
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"购买成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
            [alerView show];
        } break;
        case SKPaymentTransactionStateFailed://交易失败
            
        {
            [self failedTransaction:transaction];
            NSLog(@"-----交易失败 --------");
            UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买失败，请重新尝试购买" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
            [alerView2 show];
        }break;
            
        case SKPaymentTransactionStateRestored://已经购买过该商品
            [self restoreTransaction:transaction];
            NSLog(@"-----已经购买过该商品 --------");
        case SKPaymentTransactionStatePurchasing:
            //商品添加进列表
            NSLog(@"-----商品添加进列表 --------");
            break
            ; default:
            break;
    }
}
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid]; [self provideContent:bookid];}
    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue   defaultQueue] finishTransaction: transaction];
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
    TheseusAppDelegate *appDelegate = (TheseusAppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (buyType) {
        case LineLifeItem1:
            appDelegate.gDiamond = 60;
            break;
            
        case LineLifeItem2:
            appDelegate.gDiamond = 60;
            break;
            
        case LineLifeItem3:
            appDelegate.gDiamond = 300;
            break;
            
        case LineLifeItem4:
            appDelegate.gDiamond = 1000;
            break;
        default:
            break;
    }

    //宝石数量写入文件
    [appDelegate diamontToFile];
        
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled) { }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@" 交易恢复处理");
    TheseusAppDelegate *appDelegate = (TheseusAppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (buyType) {
        case LineLifeItem1:
            appDelegate.gDiamond = 60;
            break;
            
        case LineLifeItem2:
            appDelegate.gDiamond = 60;
            break;
            
        case LineLifeItem3:
            appDelegate.gDiamond = 300;
            break;
            
        case LineLifeItem4:
            appDelegate.gDiamond = 1000;
            break;
        default:
            break;
    }
    
    //宝石数量写入文件
    [appDelegate diamontToFile];
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{ 
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{}- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{ switch([(NSHTTPURLResponse *)response statusCode]) {
    case 200:
    case 206:
        NSLog(@"200   206");
        break; 
    case 304: NSLog(@"304");
        break; 
    case 400: NSLog(@"400");
        break; 
    case 404:NSLog(@"404");
        break; 
    case 416: NSLog(@"416");
        break; 
    case 403: NSLog(@"403");
        break; 
    case 401:
    case 500:NSLog(@"401  500");
        break; 
        
    default: 
        break; 
}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

-(void)dealloc{
    /*
    [_descLabel release];
    [_copyrightLabel release];
    [_returnButton release];
    [_unlockItem4Button release];
    [_unlockItem3Button release];
    [_unlockItem2Button release];
    [_unlockItem1Button release];
    */
     [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    //解除监听
    
}
@end
