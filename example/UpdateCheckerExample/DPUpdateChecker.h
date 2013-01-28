//
//  DPUpdateChecker.h
//  DPUpdateChecker
//
//  Created by ILYA2606 on 10.09.12.
//  Copyright (c) 2012 U_10A24. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppleID 495655551 /* overwrite with your Application AppleID */

@protocol DPDelegate <NSObject>
@optional
- (void)didFinishRequest: (id)value;
- (void)didFinishRequestWithFail: (NSError*)error;
@end

@interface DPUpdateChecker : NSObject{
    id <DPDelegate> delegate;
}

@property (nonatomic, assign) id <DPDelegate> delegate;

/* preconfigured getters */
- (void) startGetVersion;
- (void) startGetAverageUserRating;
- (void) startGetUserRatingCount;

/* getter for custom key */
- (void) startGetCustomValueFromKey:(NSString*)key;

@end
