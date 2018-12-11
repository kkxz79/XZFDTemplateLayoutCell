//
//  ViewController.m
//  XZFDTemplateLayoutCell
//
//  Created by kkxz on 2018/12/10.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Masonry.h"
#import "XZFeedCell.h"
NSString * const kXZFeedCell  = @"XZFeedCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *prototypeEntitiesFromJSON;
@property(nonatomic,strong)NSMutableArray *feedEntitySections;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Feed";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self createSubViews];
    [self createAutoLayout];
    
    [self.tableView registerClass:[XZFeedCell class] forCellReuseIdentifier:kXZFeedCell];//注册
    
    __weak __typeof(self)myself = self;
    [self buildTestDataThen:^{
        myself.feedEntitySections = @[].mutableCopy;
        [myself.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
        [myself.tableView reloadData];
    }];
}

- (void)createSubViews {
    [self.view addSubview:self.tableView];
}

- (void)createAutoLayout {
    __weak __typeof(self)myself = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(myself.view).with.insets(UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f));
    }];
}

-(void)rightButtonAction {
    [[[UIActionSheet alloc]
      initWithTitle:@"Actions"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"Insert a row",@"Insert a section",@"Delete a section", nil]
     showInView:self.view];
}

- (void)buildTestDataThen:(void (^)(void))then {
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"feed"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[XZFeedEntity alloc] initWithDictionary:obj]];
        }];
        self.prototypeEntitiesFromJSON = entities;
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feedEntitySections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedEntitySections[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZFeedCell * cell = [tableView dequeueReusableCellWithIdentifier:kXZFeedCell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(XZFeedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.entity = self.feedEntitySections[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self)myself = self;
    return [tableView fd_heightForCellWithIdentifier:kXZFeedCell cacheByIndexPath:indexPath configuration:^(XZFeedCell *cell) {
        [myself configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *mutableEntities = self.feedEntitySections[indexPath.section];
        [mutableEntities removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SEL selectors[] = {
        @selector(insertRow),
        @selector(insertSection),
        @selector(deleteSection)
    };
    
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
}

-(void)insertRow {
    if(self.feedEntitySections.count == 0) {
        [self insertSection];
    } else {
        [self.feedEntitySections[0] insertObject:self.randomEntity atIndex:0];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)insertSection {
    [self.feedEntitySections insertObject:@[self.randomEntity].mutableCopy atIndex:0];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)deleteSection {
    if(self.feedEntitySections.count>0) {
        [self.feedEntitySections removeObjectAtIndex:0];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(XZFeedEntity*)randomEntity {
    NSUInteger randomNumber = arc4random_uniform((int32_t)self.prototypeEntitiesFromJSON.count);
    XZFeedEntity * randomEntity = self.prototypeEntitiesFromJSON[randomNumber];
    return randomEntity;
}

#pragma mark - lazy init
@synthesize tableView = _tableView;
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.fd_debugLogEnabled = YES;
    }
    return _tableView;
}

@end
