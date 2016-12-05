//
//  BookDownloadModel.m
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookDownloadModel.h"
#import "Utils.h"
#import "TCBlobDownload.h"
#import "AFNetworking/AFNetworking.h"

@interface BookDownloadModel()
@property (nonatomic, retain) TCBlobDownloadManager *sharedManager;
@property (nonatomic, retain) TCBlobDownloader *downloader;
@end

@implementation BookDownloadModel

+ (BookDownloadModel *)sharedInstance {
    static BookDownloadModel *instance;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        instance = [[BookDownloadModel alloc]init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _sharedManager = [TCBlobDownloadManager sharedInstance];
    }
    return self;
}

- (void)getBookFileListWithBookInfo:(Book *)bookInfo {
    NSString *urlString = [NSString stringWithFormat:@"http://218.7.18.46/bookmgyun/servlet/getPdfInfo.serv?username=%@&sessionid=%@&bookid=%@", [[UserInfoModel sharedInstance] getUserName], [[UserInfoModel sharedInstance] getUserSessionid], bookInfo.bookID];
    NSString *url = [Utils UTF8URL:urlString];
    [self getBookListWithURL:url];
}

- (void)getBookImageListWithBookInfo:(Book *)bookInfo {
    NSString *urlString = [NSString stringWithFormat:@"http://218.7.18.46/bookmgyun/servlet/getPicInfo.serv?username=%@&sessionid=%@&bookid=%@", [[UserInfoModel sharedInstance] getUserName], [[UserInfoModel sharedInstance] getUserSessionid], bookInfo.bookID];
    NSString *url = [Utils UTF8URL:urlString];
    [self getBookListWithURL:url];
}

- (void)downloadBookFileWithBookInfo:(Book *)bookInfo url:(NSURL *)url indexPath:(NSUInteger)index{
    NSString *bookID = bookInfo.bookID;
    NSString *customPath = [self getBookDownloadPathWithBookID:bookID];
    _downloader = [_sharedManager startDownloadWithURL:url
                                            customPath:customPath
                                         firstResponse:^(NSURLResponse *response) {
                                             
                                         }
                                              progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                  NSLog(@"receivedLength:%llu/totalLength:%llu/remainingTime:%ld/progress:%f",receivedLength,totalLength,(long)remainingTime,progress);
                                                  self.downloadingBookFileWithProgress(progress, index);
                                              }
                                                 error:^(NSError *error) {
                                                     self.downloadBookFileFailed(error, index);
                                                 }
                                              complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                  self.downloadBookFileComplete(index);
                                              }];
}

- (NSString *)getBookDownloadPathWithBookID:(NSString *)bookID;
{
    NSString *path = [NSString stringWithFormat:@"%@/Application Support/%@", [Utils getLibraryPath],bookID];
    return path;
}

- (void)getBookListWithURL:(NSString *)url {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        int status = [responseObject[@"status"] intValue];
        if (status == 1000) {
            NSArray *array = responseObject[@"message"];
            _getBookDataSuccess(array);
        }else if(status == 1001) {
            _showLoginAlert();
        }else if(status == 1002) {
            _getBookDataSuccess([[NSArray alloc] init]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _getBookDataFailed(error);
    }];
}

@end
