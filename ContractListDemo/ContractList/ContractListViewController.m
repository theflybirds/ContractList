//
//  ContractListViewController.m
//  weLiam
//
//  Created by 曹忠岩 on 2019/7/22.
//  Copyright © 2019 XXX. All rights reserved.
//

#import "ContractListViewController.h"
#import "ContractListTableViewCell.h"
#import "ContractIndexCell.h"
#import "Person.h"
#import "BMChineseSort.h"

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ContractListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *indexTableView;

@property(strong,nonatomic)NSMutableArray *letterResults;
@property(strong,nonatomic)NSMutableArray *leftList;
@property(strong,nonatomic)NSMutableArray *firstNames;
@property(strong,nonatomic)NSMutableArray *dataList;
@property(strong,nonatomic)NSMutableArray *FriendsList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isScrollToShow;
@property (nonatomic, strong) UIButton *tipViewBtn;
@property (nonatomic, assign) BOOL longPressEnd;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation ContractListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUIKit];
    [self getLocationData];
    [self.view addSubview:self.indexTableView];

}
-(void)getUIKit{
    
    self.selectIndex = 0;
    self.isScrollToShow = YES;
    
    
    [_myTableView registerNib:[UINib nibWithNibName:@"ContractListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContractListTableViewCell"];
    
    _myTableView.sectionIndexColor = [UIColor whiteColor];
    _myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tipViewBtn];

    
}
-(void)getLocationData{
    
    NSArray *xings = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楚",@"卫",@"蒋",@"沈",@"韩",@"杨"];
    NSArray *ming1 = @[@"大",@"美",@"帅",@"应",@"超",@"海",@"江",@"湖",@"春",@"夏",@"秋",@"冬",@"上",@"左",@"有",@"纯"];
    NSArray *ming2 = @[@"强",@"好",@"领",@"亮",@"超",@"华",@"奎",@"海",@"工",@"青",@"红",@"潮",@"兵",@"垂",@"刚",@"山"];
    
    for (int i = 0; i < 5; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        Person *person = [Person new];
        person.name = name;
        [self.FriendsList addObject:person];
    }
    
    for (int i = 0; i < 20; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        Person *person = [Person new];
        person.name = name;
        [self.dataList addObject:person];
    }
    
    [self loadDataWithStr:@""];
    
}
-(void)loadDataWithStr:(NSString *)str{
    
    [self.leftList removeAllObjects];
    [self.letterResults removeAllObjects];
    [self.leftList addObjectsFromArray:self.dataList];
    
    _letterResults = [BMChineseSort sortObjectArray:_leftList Key:@"name"];
    _firstNames = [BMChineseSort IndexWithArray:_leftList Key:@"name"];
    [_firstNames insertObject:@"" atIndex:0];
    [self.myTableView reloadData];
    
}

-(void)rightBtnAction{
    
}
- (void)showTipViewWithIndex:(NSIndexPath *)indexPath andDismiss:(BOOL)dismiss{
    
    CGFloat y = CGRectGetMinY(_indexTableView.frame) + indexPath.row*22;
    self.tipViewBtn.frame = CGRectMake(CGRectGetMinX(_indexTableView.frame)-70, y-15, 65, 50);
    [UIView animateWithDuration:0.2 animations:^{
        self.tipViewBtn.alpha = 1;
    }];
    self.tipViewBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    NSString *title = _firstNames[self.selectIndex];
    [self.tipViewBtn setTitle:title forState:(UIControlStateNormal)];
    if(dismiss){
        [self performSelector:@selector(dismissTipViewBtn) withObject:nil afterDelay:0.2];
    }
}

- (void)dismissTipViewBtn {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tipViewBtn.alpha = 0;
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return tableView == self.myTableView ? _firstNames.count : 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView == self.myTableView ? 30 : 0;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    head.backgroundColor = UIColorFromRGB(0x13161E);
    
    UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, [UIScreen mainScreen].bounds.size.width-30, 30)];
    tit.textColor = [UIColor whiteColor];
    if(section == 0){
        tit.text = @"好友";
    }else{
        tit.text = _firstNames[section];
    }
    tit.font = [UIFont systemFontOfSize:14];
    [head addSubview:tit];
    return head;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(tableView == self.indexTableView)
        return 0;

    if(section == 0){
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    foot.backgroundColor = UIColorFromRGB(0x13161E);
    
    UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, [UIScreen mainScreen].bounds.size.width-30, 40)];
    tit.textColor = [UIColor whiteColor];
    tit.text = @"全部好友";
    tit.font = [UIFont systemFontOfSize:14];
    [foot addSubview:tit];
    return foot;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == _indexTableView){
        return _firstNames.count;
    }
    
    if(section == 0){
        return self.FriendsList.count;
    }
    
    NSArray *arr = _letterResults[section-1];
    return arr.count;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(tableView == _myTableView){
        
        static NSString *CellTableIndentifier = @"ContractListTableViewCell";
        
        ContractListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        
        if (cell == nil){
            cell = [[ContractListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIndentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        Person *p;
        if(indexPath.section == 0){
            p = self.FriendsList[indexPath.row];
        }else{
            NSArray *arr = self.letterResults[indexPath.section-1];
            p = arr[indexPath.row];
        }
        cell.name.text = p.name;
        return  cell;
        
    }else{
        
        ContractIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractIndexCell" forIndexPath:indexPath];
        cell.textLabel.frame = cell.bounds;
        if (indexPath.row == 0) {
//            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode_wodeguituangwenhao"]];
//            img.center = cell.contentView.center;
//            [cell.contentView addSubview:img];
            cell.tit.text = @"";
            cell.contentView.backgroundColor = [UIColor clearColor];
        }else {
        
            if (self.selectIndex == indexPath.row) {
                cell.tit.textColor = [UIColor whiteColor];
                cell.contentView.layer.cornerRadius = 22/2;
                cell.contentView.layer.masksToBounds = YES;
            }else {
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.tit.textColor = UIColorFromRGB(0x9E9FAE);

            }
            
            cell.tit.text = _firstNames[indexPath.row];
        }
    
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}
-(void)longtapAction:(UILongPressGestureRecognizer *)longPress{
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [longPress locationInView:_indexTableView];
            self.currentIndexPath = [_indexTableView indexPathForRowAtPoint:point];
            if(self.currentIndexPath.row == 0){
                return;
            }
            self.longPressEnd = YES;
            self.isScrollToShow = NO;
            self.selectIndex = self.currentIndexPath.row;
            [_indexTableView reloadData];
            [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentIndexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self showTipViewWithIndex:self.currentIndexPath andDismiss:NO];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [longPress locationInView:_indexTableView];
            NSIndexPath *indexPath = [_indexTableView indexPathForRowAtPoint:point];
            if(self.currentIndexPath){
                if(self.currentIndexPath.row-indexPath.row > 1){
                    return;
                }
            }
            self.currentIndexPath = indexPath;
            if(self.currentIndexPath.row == 0){
                return;
            }
            self.longPressEnd = NO;
            self.isScrollToShow = NO;
            self.selectIndex = self.currentIndexPath.row;
            [_indexTableView reloadData];
            [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentIndexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self showTipViewWithIndex:self.currentIndexPath andDismiss:NO];

        }
        case UIGestureRecognizerStateEnded:
        {

            if(self.longPressEnd){
                [self dismissTipViewBtn];
            }
            self.longPressEnd = YES;
            
            
        }
            break;
        
        default:
            break;
    }


    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _myTableView){
        return 85;
    }
    return 22;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _indexTableView){
        if(indexPath.row == 0){
            return;
        }
        self.isScrollToShow = NO;
        self.selectIndex = indexPath.row;
        [tableView reloadData];
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      [self showTipViewWithIndex:indexPath andDismiss:YES];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    if (self.isScrollToShow) {
        // 获取当前屏幕可见范围的indexPath
        NSArray *visiblePaths = [_myTableView indexPathsForVisibleRows];
        
        if (visiblePaths.count < 1) {
            return;
        }
        
        NSIndexPath *indexPath0 = visiblePaths[0];
        
        // 判断是否已滑到最底部
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        NSIndexPath *indexPath;
        if (bottomOffset <= height || fabs(bottomOffset - height) < 1) {
            //在最底部（显示最后一个索引字母）
            NSInteger row = _firstNames.count;
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            self.selectIndex = indexPath.row;
        }else {
            indexPath = [NSIndexPath indexPathForRow:indexPath0.section inSection:0];
            self.selectIndex = indexPath.row;
        }
        indexPath = [NSIndexPath indexPathForRow:indexPath0.section inSection:0];
        self.selectIndex = indexPath.row;
        [_indexTableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}


-(UITableView *)indexTableView{
    
    if(!_indexTableView){
        _indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 22, _firstNames.count*22) style:(UITableViewStylePlain)];
        _indexTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width-16,[UIScreen mainScreen].bounds.size.height/2);
        _indexTableView.delegate = self;
        _indexTableView.dataSource = self;
        _indexTableView.scrollEnabled = NO;
        _indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _indexTableView.showsVerticalScrollIndicator = NO;
        _indexTableView.backgroundColor = [UIColor clearColor];
        _indexTableView.tableFooterView = [[UIView alloc] init];
        [_indexTableView registerNib:[UINib nibWithNibName:@"ContractIndexCell" bundle:nil] forCellReuseIdentifier:@"ContractIndexCell"];
        UILongPressGestureRecognizer *tap = [UILongPressGestureRecognizer new];
        tap.minimumPressDuration = 0.3;
        [tap addTarget:self  action:@selector(longtapAction:)];
        [_indexTableView addGestureRecognizer:tap];
    }
    
    return _indexTableView;
}
-(NSMutableArray *)leftList{
    
    if(!_leftList){
        
        _leftList = [NSMutableArray new];
    }
    return _leftList;
}
-(NSMutableArray *)letterResults{
    
    if(!_letterResults){
        
        _letterResults = [NSMutableArray new];
    }
    return _letterResults;
}
-(NSMutableArray *)firstNames{
    
    if(!_firstNames){
        
        _firstNames = [NSMutableArray new];
    }
    return _firstNames;
}
-(NSMutableArray *)dataList{
    
    if(!_dataList){
        
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}
-(NSMutableArray *)FriendsList{
    
    if(!_FriendsList){
        
        _FriendsList = [NSMutableArray new];
    }
    return _FriendsList;
}

- (UIButton *)tipViewBtn {
    
    if (!_tipViewBtn) {
        _tipViewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _tipViewBtn.enabled = NO;
        _tipViewBtn.alpha = 0;
        [_tipViewBtn setBackgroundImage:[UIImage imageNamed:@"chat_letterbg"] forState:(UIControlStateNormal)];
        _tipViewBtn.titleLabel.textColor = [UIColor whiteColor];
        [_tipViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    return _tipViewBtn;
}
@end
