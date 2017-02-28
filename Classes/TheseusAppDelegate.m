//
//  TheseusAppDelegate.m
//  Theseus
//
//  Created by Jason Fieldman on 12/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "TheseusAppDelegate.h"
#import "DungeonViewController.h"
#import "MainMenuViewController.h"
#import "FlourishController.h"
#import "TileHelper.h"
#import "SoundManager.h"
#import "GameStateModel.h"
#import "MapGenerator.h"
#import "MapModel.h"

//#import "Flurry.h"



@implementation TheseusAppDelegate

@synthesize window;

- (void)_generateSolutionDump {
	int best_solutions[NUM_LEVELS];
	for (int level = 0; level < NUM_LEVELS; level++) {
		MapModel *map = [MapGenerator getMap:level];
		[map createSolveMap];
		int cur = [map getCurrentPosSolve];
		best_solutions[level] = (cur & 0xFF);
		NSLog(@"best for level %d: %d", level, best_solutions[level]);
		[map cleanSolveMap];
	}
	
	for (int i = 0; i < NUM_LEVELS; i++) {
	//	NSLog(@"best for level %d: %d", i, best_solutions[i]);
	}
	
	exit(0);
}

void uncaughtExceptionHandler(NSException *exception) {
	//[Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	//[Flurry startSession:@"YTCADT3LIDMKBGT7WKTQ"];
	[Globals initGlobals];
	InitializeTiles();
	[SoundManager initialize];
	[GameStateModel CreateGameStateFileIfNecessary];
	[GameStateModel LoadGameState];
    [self initDiamond];
	srand(time(0));
	
	if (![GameStateModel getIdleTimer]) [UIApplication sharedApplication].idleTimerDisabled = YES;
	
//#define GENERATE_SOLUTION_DUMP
#ifdef GENERATE_SOLUTION_DUMP
	[self _generateSolutionDump];
#endif
		
	/* Do some pre-init of the classes */
	[MainMenuViewController sharedInstance];
	[DungeonViewController sharedInstance];
	
	window.backgroundColor = [UIColor blackColor];
	
	//[window addSubview:[DungeonViewController sharedInstance].view];
	CGRect f = window.frame;
	f.size.height = [UIScreen mainScreen].bounds.size.height;
	window.frame = f;
	
	//[window addSubview:[FlourishController sharedInstance].view];
    window.rootViewController = [FlourishController sharedInstance];
	//window.rootViewController = [FlourishController sharedInstance];
	
	/* Load into the puzzle if we left off there.. */
	int saved_level = [GameStateModel getCurrentLevel];
	if (saved_level >= 0) {
		[GameStateModel fillHistory];		
		[[FlourishController sharedInstance] transitionToDungeon:saved_level];
	} else {
		[[FlourishController sharedInstance] transitionToMenu];
	}
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[GameStateModel SaveGameState];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[GameStateModel SaveGameState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)initDiamond {
    //尝试从本地获取宝石数量
    NSString *docPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"DiamondFile"];
    
    
    NSString* tmpDiamond = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //临时放这里 写入代码
    //[NSKeyedArchiver archiveRootObject:appDelegate.gJobInfo toFile:path];
    
    if (ISNULL(tmpDiamond)){
        //本地宝石存储文件不存在
        //尝试从服务器获取宝石信息
        NSString* serDiamond = [[NSString alloc] init];
        serDiamond = [self getDiamondFromServer];
        if ([serDiamond isEqualToString:@"noDiamond"]){
            //服务器没有宝石信息
            _gDiamond = 0;
            NSLog(@"第一次运行，并且服务器没有宝石信息！");
            NSLog(@"%@", serDiamond);
        }else{
            //成功从服务器获取到宝石信息
            _gDiamond = [serDiamond integerValue];
            NSLog(@"安装、充值、卸载、再次安装后第一次启动，从服务器获取到宝石信息！");
            NSLog(@"%@", serDiamond);
        }
        //从服务器获取到宝石信息写入到本地
        tmpDiamond = [NSString stringWithFormat:@"%i", _gDiamond];
        [NSKeyedArchiver archiveRootObject:tmpDiamond toFile:path];
    }else{
        //成功从获取成功后完成初始化
        //这种情况什么也不用做就行
        NSLog(@"非第一次运行，从本地获取到宝石信息！");
    }
}

- (NSString*)getDiamondFromServer {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString *scoreStr = [NSString stringWithFormat:@"%i", [AppDelegate highScore]];
    
    
    NSString *post = [NSString stringWithFormat:@"deviceID=%@",idfv];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://mengyoutu.cn/freshmeat/meat.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    return theReply;
    //NSLog(@"& API  | %@", theReply);
}

@end
