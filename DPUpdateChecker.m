//
//  DPUpdateChecker.m
//  DPUpdateChecker
//
//  Created by ILYA2606 on 10.09.12.
//  Copyright (c) 2012 U_10A24. All rights reserved.
//

#import "DPUpdateChecker.h"

@implementation DPUpdateChecker

@synthesize delegate;

- (void) startGetVersion{
    [self startGetCustomValueFromKey:@"version"];
}

- (void) startGetAverageUserRating{
    [self startGetCustomValueFromKey:@"averageUserRating"];
}

- (void) startGetUserRatingCount{
    [self startGetCustomValueFromKey:@"userRatingCount"];
}

- (void) startGetCustomValueFromKey:(NSString*)key{
    [self sendRequestWithKey: key];
}

#pragma mark - Sending Request

- (void)sendRequestWithKey:(NSString*)key{
    NSString *requestPath=[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%d", AppleID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error==nil){
            if(data != nil){
                NSDictionary *dict = [[NSDictionary new] autorelease];
                NSError *errorForJSON=nil;
                dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorForJSON];
                NSLog(@"%@", dict);
                if(errorForJSON==nil){ //success
                    if(dict!=nil && [[dict objectForKey:@"results"] count]>0){
                        if([[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:key]!=nil){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if([self.delegate respondsToSelector:@selector(didFinishRequest:)]){
                                    [self.delegate didFinishRequest:[[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:key]];
                                }
                                else{
                                    NSLog(@"%@ not responded -(void)didFinishRequest:(id)value",[self.delegate class]);
                                }
                            });
                        }
                        else{ //fail
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"incorrect key");
                                if([self.delegate respondsToSelector:@selector(didFinishRequestWithFail:)]){
                                    [self.delegate didFinishRequestWithFail:nil];
                                }
                                else{
                                    NSLog(@"%@ not responded -(void)didFinishRequestWithFail:(NSError*)error",[self.delegate class]);
                                }
                            });
                        }
                        
                    }
                    else{ //fail
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if([self.delegate respondsToSelector:@selector(didFinishRequestWithFail:)]){
                                [self.delegate didFinishRequestWithFail:nil];
                            }
                            else{
                                NSLog(@"%@ not responded -(void)didFinishRequestWithFail:(NSError*)error",[self.delegate class]);
                            }
                        });
                    }
                }
                else{ //fail
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"%@", [errorForJSON localizedDescription]);
                        if([self.delegate respondsToSelector:@selector(didFinishRequestWithFail:)]){
                        [self.delegate didFinishRequestWithFail:errorForJSON];
                        }
                        else{
                            NSLog(@"%@ not responded -(void)didFinishRequestWithFail:(NSError*)error",[self.delegate class]);
                        }
                    });
                }
            }
            else{ //fail
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", [error localizedDescription]);
                    if([self.delegate respondsToSelector:@selector(didFinishRequestWithFail:)]){
                        [self.delegate didFinishRequestWithFail:error];
                    }
                    else{
                        NSLog(@"%@ not responded -(void)didFinishRequestWithFail:(NSError*)error",[self.delegate class]);
                    }
                });
            }
        }
        else{ //fail
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", [error localizedDescription]);
                if([self.delegate respondsToSelector:@selector(didFinishRequestWithFail:)]){
                    [self.delegate didFinishRequestWithFail:error];
                }
                else{
                    NSLog(@"%@ not responded -(void)didFinishRequestWithFail:(NSError*)error",[self.delegate class]);
                }
            });
        }
    }];
    [queue release];
}



@end
