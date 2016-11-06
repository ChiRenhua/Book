//
//  BookFileBrowserViewController.m
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookFileBrowserViewController.h"
#import "UIColor+AppConfig.h"
#import "BookDownloadModel.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "IDMPhotoBrowser.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size
#define CELL_HEIGHT 50

@interface BookFileBrowserViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BookFileBrowserType type;
@property (nonatomic, retain) Book *bookInfo;
@property (nonatomic, retain) UILabel *noDataLable;
@property (nonatomic, retain) UILabel *errorLable;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *IndicatorView;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *fileArray;
@property (nonatomic, retain) UIProgressView *downLoadProgressView;
@property (nonatomic, strong) UILabel *downloadStatusLable;
@end

@implementation BookFileBrowserViewController

- (id)initWithBookInfo:(Book *)bookInfo bookFileBrowserType:(BookFileBrowserType)type {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.type = type;
        self.bookInfo = bookInfo;
        self.noDataLable = [[UILabel alloc] init];
        self.tableView = [[UITableView alloc]init];
        self.fileArray = [[NSArray alloc]init];
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [BookDownloadModel sharedInstance].showLoginAlert = ^() {
            [self showLoginView];
        };
        [BookDownloadModel sharedInstance].getBookDataSuccess = ^(NSArray *data) {
            if (data.count == 0) {
                _noDataLable.text = @"暂无数据";
                [_IndicatorView stopAnimating];
                [_noDataLable setHidden:NO];
            }else {
                self.fileArray = data;
                [self.view addSubview:self.tableView];
                [_noDataLable setHidden:YES];
                [_IndicatorView stopAnimating];
                [self.tableView reloadData];
            }
            
        };
        [BookDownloadModel sharedInstance].getBookDataFailed = ^(NSError *error) {
            [_noDataLable setHidden:YES];
            [_IndicatorView stopAnimating];
            [_errorLable setHidden:NO];
        };
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addIndicatorView];
    [self setNavigationBar];
    [self addErrorLable];
    [self addNoDataLable];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height - 65) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadBookFileData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (self.type) {
        case BookFileBrowserType_Image:
            return @"图片列表";
            break;
        case BookFileBrowserType_PDF:
            return @"PDF列表";
            break;
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIBookFileListCell"];
    NSDictionary *dic = [self.fileArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UIBookFileListCell"];
    }else {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    switch (self.type) {
        case BookFileBrowserType_Image: {
            UIImageView *imagelogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 23, 30)];
            imagelogo.image = [UIImage imageNamed:@"jpgLogo.png"];
            [cell.contentView addSubview:imagelogo];
            
            UILabel *imageLable = [[UILabel alloc]initWithFrame:CGRectMake(imagelogo.bounds.size.width + 25, (CELL_HEIGHT - 15) / 2, cell.bounds.size.width / 2 - 20, 15)];
            imageLable.text = [dic objectForKey:@"key"];
            imageLable.font = [UIFont systemFontOfSize:15];
            imageLable.textColor = [UIColor blackColor];
            [cell.contentView addSubview:imageLable];
        }
            break;
        case BookFileBrowserType_PDF: {
             UIImageView *pdflogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 23, 30)];
             pdflogo.image = [UIImage imageNamed:@"pdfLogo.png"];
             [cell.contentView addSubview:pdflogo];
             
             UILabel *bookNameLable = [[UILabel alloc]initWithFrame:CGRectMake(pdflogo.bounds.size.width + 25, (CELL_HEIGHT - 15) / 2, cell.bounds.size.width / 2 - 20, 15)];
             bookNameLable.text = [dic objectForKey:@"key"];
             bookNameLable.font = [UIFont systemFontOfSize:15];
             bookNameLable.textColor = [UIColor blackColor];
             [cell.contentView addSubview:bookNameLable];
            
            CGSize textSize = [Utils stringWedith:@"下载" size:15];
             _downloadStatusLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width - textSize.width - 10, 0, textSize.width, CELL_HEIGHT)];
            _downloadStatusLable.text = @"下载";
            _downloadStatusLable.font = [UIFont systemFontOfSize:15];
            _downloadStatusLable.textColor = [UIColor bookLableColor];
             [cell.contentView addSubview:_downloadStatusLable];
             
             _downLoadProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width / 2, CELL_HEIGHT / 2, SCREEN_BOUNDS.width / 2 - _downloadStatusLable.bounds.size.width - 20, 1)];
             [cell.contentView addSubview:_downLoadProgressView];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case BookFileBrowserType_Image: {
            NSMutableArray *imageURLArray = [[NSMutableArray alloc]init];
            [self.fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *url = [NSString stringWithFormat:@"http://121.42.174.184:8080/bookmgyun/%@",dic[@"value"]];
                NSString *UTF8url = [Utils UTF8URL:url];
                NSURL *bookImageUrl = [NSURL URLWithString:UTF8url];
                [imageURLArray addObject:bookImageUrl];
            }];
            
            NSMutableArray *photos = [NSMutableArray new];
            
            for (int i = 0; i < imageURLArray.count; i++) {
                IDMPhoto *photo = [IDMPhoto photoWithURL:imageURLArray[i]];
                photo.caption = self.fileArray[i][@"key"];
                [photos addObject:photo];
            }
            
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
            browser.displayArrowButton = YES;
            browser.displayCounterLabel = YES;
            [browser setInitialPageIndex:indexPath.row];
            [self presentViewController:browser animated:YES completion:nil];
            
        }
            break;
        case BookFileBrowserType_PDF: {
            
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_BOUNDS.height / 20;
}

#pragma mark - NavigationBar
- (void)setNavigationBar {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.width, 65)];
    navigationBar.barTintColor = [UIColor bookAppColor];
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle;
    switch (self.type) {
        case BookFileBrowserType_Image:
            navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"图片"];
            break;
        case BookFileBrowserType_PDF:
            navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"PDF"];
            break;
        default:
            break;
    }
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    navigationBarTitle.leftBarButtonItem = leftBarItem;
    leftBarItem.tintColor = [UIColor whiteColor];
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
// 添加菊花
- (void)addIndicatorView {
    _IndicatorView = [[UIActivityIndicatorView alloc]init];
    _IndicatorView.center = CGPointMake(SCREEN_BOUNDS.width/2, SCREEN_BOUNDS.height/2);
    _IndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_IndicatorView];
    [_IndicatorView startAnimating];
}

- (void)addNoDataLable {
    _noDataLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2 - 100, SCREEN_BOUNDS.height/2 - 25, 200, 50)];
    _noDataLable.textColor = [UIColor grayColor];
    _noDataLable.text = @"暂无数据!";
    _noDataLable.textColor = [UIColor bookLableColor];
    _noDataLable.textAlignment = NSTextAlignmentCenter;
    _noDataLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_noDataLable];
    [_noDataLable setHidden:YES];
}

// 数据加载失败lable
- (void)addErrorLable {
    _errorLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.height/2 - 25, SCREEN_BOUNDS.width, 50)];
    _errorLable.textColor = [UIColor grayColor];
    _errorLable.text = @"数据加载失败\n点击重新加载!";
    _errorLable.numberOfLines = 0;
    _errorLable.textAlignment = NSTextAlignmentCenter;
    _errorLable.font = [UIFont systemFontOfSize:15];
    _errorLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBookFileData)];
    [_errorLable addGestureRecognizer:tapGesture];
    [self.view addSubview:_errorLable];
    [_errorLable setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBookFileData {
    [_IndicatorView startAnimating];
    [_errorLable setHidden:YES];
    switch (self.type) {
        case BookFileBrowserType_Image:
            [[BookDownloadModel sharedInstance] getBookImageListWithBookInfo:_bookInfo];
            break;
        case BookFileBrowserType_PDF:
            [[BookDownloadModel sharedInstance] getBookFileListWithBookInfo:_bookInfo];
            break;
        default:
            break;
    }
}

- (void)showLoginView {
    UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"错误!" message:@"登录态失效，请重新登陆!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [self presentViewController:self.appDelegate.loginVC animated:YES completion:nil];
    }];
    UIAlertAction *calcleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [loginAlert addAction:loginAction];
    [loginAlert addAction:calcleAction];
    [self presentViewController:loginAlert animated:YES completion:nil];
}

@end
