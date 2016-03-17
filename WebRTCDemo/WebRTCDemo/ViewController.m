//
//  ViewController.m
//  WebRTCDemo
//
//  Created by Prashant Kurhade on 16/03/16.
//  Copyright © 2016 Prashant Kurhade. All rights reserved.
//

#import "ViewController.h"
#import "ARDAppClient.h"
#import "ARDMainView.h"
#import "ARDVideoCallViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ARDMainView *mainView = [[ARDMainView alloc] initWithFrame:CGRectZero];
    mainView.delegate = self;
    self.view = mainView;
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - ARDMainViewDelegate

- (void)mainView:(ARDMainView *)mainView
    didInputRoom:(NSString *)room
      isLoopback:(BOOL)isLoopback
     isAudioOnly:(BOOL)isAudioOnly {
    if (!room.length) {
        [self showAlertWithMessage:@"Missing room name."];
        return;
    }
    // Trim whitespaces.
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedRoom = [room stringByTrimmingCharactersInSet:whitespaceSet];
    
    // Check that room name is valid.
    NSError *error = nil;
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"\\w+"
                                              options:options
                                                error:&error];
    if (error) {
        [self showAlertWithMessage:error.localizedDescription];
        return;
    }
    NSRange matchRange =
    [regex rangeOfFirstMatchInString:trimmedRoom
                             options:0
                               range:NSMakeRange(0, trimmedRoom.length)];
    if (matchRange.location == NSNotFound ||
        matchRange.length != trimmedRoom.length) {
        [self showAlertWithMessage:@"Invalid room name."];
        return;
    }
    
    // Kick off the video call.
    ARDVideoCallViewController *videoCallViewController =
    [[ARDVideoCallViewController alloc] initForRoom:trimmedRoom
                                         isLoopback:isLoopback
                                        isAudioOnly:isAudioOnly];
    videoCallViewController.modalTransitionStyle =
    UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoCallViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Private

- (void)showAlertWithMessage:(NSString*)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
