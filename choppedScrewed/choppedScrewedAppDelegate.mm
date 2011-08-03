//
//  YoooAppDelegate.m
//  Yooo
//
//  Created by njb on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "choppedScrewedAppDelegate.h"

#import "MainViewController.h"

#import "mo_audio.h"

#define SRATE 44100
#define FRAMESIZE 256
#define NUM_CHANNELS 2


bool g_play = true;
double g_fc = 440.0; 
// double amplitude = 0.0;

// Implement audio callback here
void audioCallback( Float32 * buffer, UInt32 framesize, void* userData)
{
	// NSLog(@"inside audioCB");
	
	if (g_play) {
		static float phase = g_fc/SRATE;
		// amplitude = amplitude+(1-amplitude)*0.001; // to avoid clicks
        
		for (int i=0; i<framesize; i++)	{
			buffer[2*i] = buffer[2*i+1] = sin(2.0*M_PI*phase);    // amplitude*sin(2.0*M_PI*phase);
			phase += g_fc/(SRATE*1.0);
            
			if (phase > 1.0f) 
				phase -= 1.0f;
		}
	}
	else {
		for (int i=0; i<framesize; i++)	{
			buffer[2*i] = buffer[2*i+1] = 0.0;
		}
	}
    
}


@implementation YoooAppDelegate


@synthesize window=_window;

@synthesize mainViewController=_mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    MoAudio::init(SRATE, FRAMESIZE, NUM_CHANNELS);
    MoAudio::start(audioCallback, NULL);
    
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

@end
