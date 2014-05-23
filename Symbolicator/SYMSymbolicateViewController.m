//
//  SYMSymbolicateViewController.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/22/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMSymbolicateViewController.h"

#import "SYMFilePickerViewController.h"

@interface SYMSymbolicateViewController ()

@property(nonatomic, strong) SYMFilePickerViewController* crashReportFilePickerViewController;
@property(nonatomic, strong) SYMFilePickerViewController* dSYMFilePickerViewController;

@end

@implementation SYMSymbolicateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.crashReportFilePickerViewController = [[SYMFilePickerViewController alloc] initWithNibName:NSStringFromClass([SYMFilePickerViewController class])
                                                                                                 bundle:nil];
        self.dSYMFilePickerViewController = [[SYMFilePickerViewController alloc] initWithNibName:NSStringFromClass([SYMFilePickerViewController class])
                                                                                                 bundle:nil];
        self.leftFilePickerView = self.crashReportFilePickerViewController.view;
        self.rightFilePickerView = self.dSYMFilePickerViewController.view;
    }
    return self;
}

@end
