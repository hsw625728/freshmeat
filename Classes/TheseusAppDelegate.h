//
//  TheseusAppDelegate.h
//  Theseus
//
//  Created by Jason Fieldman on 12/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ISNULL(x) (x?((id)x==(id)[NSNull null]):true)
@interface TheseusAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

//宝石数量
@property (nonatomic, assign) NSInteger gDiamond;
-(void)diamontToFile;

@end

