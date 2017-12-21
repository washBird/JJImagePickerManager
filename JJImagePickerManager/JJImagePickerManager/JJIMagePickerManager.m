//
//  JJIMagePickerManager.m
//  JJImagePickerManager
//
//  Created by zoujie on 2017/7/14.
//  Copyright © 2017年 zoujie. All rights reserved.
//

#import "JJIMagePickerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface JJIMagePickerManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation JJIMagePickerManager
+ (instancetype )imagePickerManagerFromController:( UIViewController *)fromController{
    JJIMagePickerManager *manager = [[JJIMagePickerManager alloc] init];
    manager.fromViewController = fromController;
    manager.allowEditing = NO;
    manager.needComplete = NO;
    return manager;
}

#pragma mark - Select Alert Sheet
- (void)alertSelectActionSheet{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoSelectDidSelectSheetIndex:)]) {
            [weakSelf.delegate photoSelectDidSelectSheetIndex:0];
        }
        [weakSelf enterCamera];
    }];
    UIAlertAction *actionPhotoLib = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoSelectDidSelectSheetIndex:)]) {
            [weakSelf.delegate photoSelectDidSelectSheetIndex:1];
        }
        [weakSelf enterPhotoLibrary];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoSelectDidSelectSheetIndex:)]) {
            [weakSelf.delegate photoSelectDidSelectSheetIndex:2];
        }
    }];
    [alertController addAction:actionTakePhoto];
    [alertController addAction:actionPhotoLib];
    [alertController addAction:actionCancel];
    [self.fromViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Pravite Method
- (void)enterCamera{
    if (self.fromViewController == nil) {
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请检查相机是否可用" preferredStyle:UIAlertControllerStyleAlert];
        [self.fromViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = self.allowEditing;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    __weak typeof(self) weakSelf = self;
    [self.fromViewController presentViewController:picker animated:YES completion:^{
        [weakSelf cameraAccessRequestFromPickerController:picker];
    }];
}

- (void)enterPhotoLibrary{
    if (self.fromViewController == nil) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = self.allowEditing;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        [self.fromViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)cameraAccessRequestFromPickerController:(UIImagePickerController *)picker{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){//没授权
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"无法拍照" message:@"请在iPhone“设置-隐私-相机”中允许口袋记账使用相机服务" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *actionKnown = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf imagePickerControllerDidCancel:picker];
        }];
        UIAlertAction *actionOpen = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url];
            [weakSelf imagePickerControllerDidCancel:picker];
        }];
        [alertCtr addAction:actionKnown];
        [alertCtr addAction:actionOpen];
        [picker presentViewController:alertCtr animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    if (self.needComplete){
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(photoSelectCompleteWithOriginImage:editedImage:)]) {
                [self.delegate photoSelectCompleteWithOriginImage:originalImage editedImage:editedImage];
            }
        }];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:nil];
        if ([self.delegate respondsToSelector:@selector(photoSelectCompleteWithOriginImage:editedImage:)]) {
            [self.delegate photoSelectCompleteWithOriginImage:originalImage editedImage:editedImage];
        }
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.needComplete){
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(photoSelectCancle)]) {
                [self.delegate photoSelectCancle];
            }
        }];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:nil];
        if ([self.delegate respondsToSelector:@selector(photoSelectCancle)]) {
            [self.delegate photoSelectCancle];
        }
    }
    
    
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

@end
