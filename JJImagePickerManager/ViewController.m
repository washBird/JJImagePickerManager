//
//  ViewController.m
//  JJImagePickerManager
//
//  Created by zoujie on 2017/7/14.
//  Copyright © 2017年 zoujie. All rights reserved.
//

#import "ViewController.h"
#import "JJIMagePickerManager.h"

@interface ViewController ()<JJIMagePickerManagerDelegate>

@property (nonatomic, strong) JJIMagePickerManager *photoManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)actionSheetSelect:(UIButton *)sender {
    [self.photoManager alertSelectActionSheet];
}
- (IBAction)takePhoto:(UIButton *)sender {
    self.photoManager.allowEditing = NO;
    [self.photoManager enterCamera];
}
- (IBAction)goPhotoLib:(UIButton *)sender {
    self.photoManager.allowEditing = YES;
    [self.photoManager enterPhotoLibrary];
}

- (JJIMagePickerManager *)photoManager{
    if (!_photoManager) {
        _photoManager = [JJIMagePickerManager imagePickerManagerFromController:self];
        _photoManager.delegate = self;
    }
    return _photoManager;
}

#pragma mark - JJIMagePickerManagerDelegate
- (void)photoSelectDidSelectSheetIndex:(NSInteger)index{
    
}
- (void)photoSelectCompleteWithOriginImage:(UIImage *)originImage editedImage:(UIImage *)editedImage{
    
}
- (void)photoSelectCancle{
    
}
@end
