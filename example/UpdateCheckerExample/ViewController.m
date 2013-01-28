//
//  ViewController.m
//  UpdateCheckerExample
//
//  Created by ILYA2606 on 10.09.12.
//  Copyright (c) 2012 Darkness Production. All rights reserved.
//

#import "ViewController.h"
#import "DPUpdateChecker.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DPUpdateChecker *cont = [[DPUpdateChecker new] autorelease];
    cont.delegate = (id<DPDelegate>) self;
    [cont startGetVersion];
}

- (void)didFinishRequest: (id)value{
    NSString *myAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appstoreVersion = [[NSString alloc] initWithString:value];
    if(appstoreVersion==nil){
        NSLog(@"failed");
    }
    else if([myAppVersion compare: appstoreVersion]==NSOrderedAscending){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:[NSString stringWithFormat:@"Your app version: %@. Update to %@?", myAppVersion, appstoreVersion] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update", nil];
        [alert show];
        [alert release];
    }
}
- (void)didFinishRequestWithFail: (NSError*)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSString *linkToAppstore = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d",AppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkToAppstore]];
    }
}

@end
