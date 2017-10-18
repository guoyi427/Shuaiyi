//
//  HallView.m
//  KKZ
//
//  Created by da zhang on 11-10-24.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "HallView.h"


static int seatMap[500][500];

@interface HallView ()

- (CGRect)frameForSeatAtColumn:(int)col andRow:(int)row andStatus:(int)status;
- (void)drawSeatAtColumn:(int)col andRow:(int)row andStatus:(int)status;
- (NSString *)keyForSeatAtColumn:(int)col andRow:(int)row;
- (SeatState)seatStateAtCol:(int)col andRow:(int)row;

@property (nonatomic, strong) NSArray *allSeats;
@property (nonatomic, copy) void (^updateDrawBlock)();
@property (nonatomic, copy) id<SeatProtocol> (^getSeatBlock)(NSString *seatId);
/**
 *  过道的行 <NSString>
 */
@property (nonatomic, strong) NSArray *aisle;

@property (nonatomic, strong) NSArray *seatMatrix;

/**
 座位宽度
 */
@property (nonatomic) CGFloat seatWidth;

/**
 座位高度
 */
@property (nonatomic) CGFloat seatHeight;

@property (nonatomic) NSInteger currentIndex;
@end


@implementation HallView

@synthesize columnNum, rowNum, maxSelectedNum;
@synthesize cinemaId, hallId;
@synthesize delegate;
@synthesize allSeats;

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *imageSeat = [UIImage imageNamed:@"seat_icon.png"];
        self.seatWidth = imageSeat.size.width;
        self.seatHeight = imageSeat.size.height;
        
        selected = [UIImage imageNamed:@"seatSelected.png"];
        normal = imageSeat;
        unavailable = [UIImage imageNamed:@"seatBooked.png"];
        selectedKota = [UIImage imageNamed:@"seatKota.png"];
        loverL = [UIImage imageNamed:@"seat_loverleft_icon.png"];
        loverR = [UIImage imageNamed:@"seat_loverright_icon.png"];
        selectLoverL = [UIImage imageNamed:@"seat_loverleft_select_icon.png"];
        selectLoverR = [UIImage imageNamed:@"seat_loverright_select_icon.png"];
        loverLUnavailable = [UIImage imageNamed:@"seat_loverleft_lock_icon.png"];
        loverRUnavailable = [UIImage imageNamed:@"seat_loveright_lock_icon.png"];
        self.backgroundColor = [UIColor clearColor];
        self.space = 1.0;
        self.currentIndex = 0;
        
        seatNOs = [[NSMutableDictionary alloc] init];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //    DLog(@"call draw rect in rect:%@", NSStringFromCGRect(rect));
    // Drawing code
    CGRect seatSize = CGRectMake(0, 0, 0, 0);
    for (int i = 1; i <= columnNum; i++) {
        for (int j = 1; j <= rowNum; j++) {
            
            SeatState status = [self seatStateAtCol:i andRow:j];
            
            CGRect seatRect = [self frameForSeatAtColumn:i andRow:j andStatus:status];
            if (CGRectContainsRect(rect, seatRect)) {
                [self drawSeatAtColumn:i andRow:j andStatus:status];
                if (i==columnNum/2 && j==rowNum/2) {
                    if (status > 4) {
                        //情侣座
                        seatRect = [self frameForSeatAtColumn:i andRow:j andStatus:SeatStateAvailable];
                    }
                    seatSize = seatRect;
                }
            }
        }
    }
    
    
    [[UIImage imageNamed:@"hallView_horizon_line"] drawInRect:CGRectMake(0, seatSize.origin.y+seatSize.size.height, rect.size.width, 1)];
    
    [[UIImage imageNamed:@"hallview_vertical_line"] drawInRect:CGRectMake(seatSize.origin.x+seatSize.size.width + self.space/2, 0, 1,rect.size.height)];
    
    
    if (self.updateDrawBlock) {
        self.updateDrawBlock();
    }
    
}

/**
 获取选中座位的图片
 
 @return 图片
 */
- (UIImage *)getSeletedSeatImage{
    
    if (self.seatSeletedIcons.count > 0) {
        UIImage *image = [self.seatSeletedIcons objectAtIndex:self.currentIndex];
        self. currentIndex ++;
        if (self.currentIndex == self.seatSeletedIcons.count-1) {
            self.currentIndex = 0;
        }
        
        return image;
    }
    
    return selected;
}


#pragma mark utility
- (void)drawSeatAtColumn:(int)col andRow:(int)row andStatus:(int)status {
    if (status == SeatStateNone) {
        return;
    }
    
    UIImage *imageToDraw = nil;
    if (status == SeatStateAvailable) {
        imageToDraw = normal;
    } else if (status == SeatStateSelected) {
        imageToDraw = [self getSeletedSeatImage];
    } else if (status == SeatStateUnavailable){
        imageToDraw = unavailable;
    } else if (status == SeatStateLoverLUnavailable){
        imageToDraw = loverLUnavailable;
    } else if (status == SeatStateLoverRUnavailable){
        imageToDraw = loverRUnavailable;
    }else if (status == SeatStateLoverL){
        imageToDraw = loverL;
    } else if (status == SeatStateLoverR){
        imageToDraw = loverR;
    } else if (status == SeatStateLoverLSelected){
        imageToDraw = selectLoverL;
    } else if (status == SeatStateLoverRSelected){
        imageToDraw = selectLoverR;
    }
    [imageToDraw drawInRect:[self frameForSeatAtColumn:col andRow:row andStatus:status]];
    
}

- (void)updateLayout {
    [self setNeedsDisplay];
}

- (NSString *)keyForSeatAtColumn:(int)col andRow:(int)row {
    return [NSString stringWithFormat:@"%d_%d", col, row];
}

- (CGRect)frameForSeatAtColumn:(int)col andRow:(int)row andStatus:(int)status{
    if (status == SeatStateAvailable ||
        status == SeatStateSelected ||
        status == SeatStateUnavailable) {
        return CGRectMake(self.seatWidth*(col-1)+1, self.seatHeight*(row-1)+1, self.seatWidth-self.space, self.seatHeight-self.space);
    } else if (status == SeatStateLoverL ||
               status == SeatStateLoverLSelected ||
               status == SeatStateLoverLUnavailable){
        // 情侣座 宽度调整 减去中间的间隔
        return CGRectMake(self.seatWidth*(col-1)+1, self.seatHeight*(row-1), self.seatWidth - self.space/2, self.seatHeight-self.space);
    }else {
        return CGRectMake(self.seatWidth*(col-1)-self.space/2, self.seatHeight*(row-1), self.seatWidth-self.space/2, self.seatHeight-self.space);
    }
}

- (void)updateDataSource:(NSArray *)seatList {
    
    //clean matrix
    for (int i = 0; i <= columnNum; i++) {
        for (int j = 0; j <= rowNum; j++) {
            seatMap[i][j] = SeatStateNone;
        }
    }
    
    if ([seatList count]) {
        self.allSeats = seatList;
        [seatNOs removeAllObjects];
        
        NSMutableDictionary *rows = [NSMutableDictionary dictionaryWithCapacity:rowNum];
        /*
         {
         1 = 1;
         10 = 1;
         2 = 1;
         3 = 1;
         4 = 1;
         5 = 1;
         6 = 1;
         7 = 1;
         8 = 1;
         9 = 1;
         }
         */
        for (NSInteger i = 1; i < (rowNum+1) ; i++) {
            
            [rows setObject:@YES forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            
        }
        
        /*
         {
         6 = 1;
         7 = 1;
         8 = 1;
         9 = 1;
         }
         */
        for (id<SeatProtocol> seat in allSeats) {
            int row = [seat.graphRow intValue], col = [seat.graphCol intValue];
            NSString *key = [self keyForSeatAtColumn:col andRow:row];
            [seatNOs setObject:seat.seatId forKey:key];
            seatMap[col][row] = seat.seatState;
            
            //删除有的座位的graph行
            [rows removeObjectForKey:[NSString stringWithFormat:@"%d",row]];
        }
        currentSelectedNum = 0;
        
        /*
         [6,7,8,9]
         */
        //处理过道，列出没有座位（过道）的graphRow
        if (rows.count != 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.aisle.count];
            [rows.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *key = obj;
                [arr addObject:[NSNumber numberWithInteger:[key integerValue]]];
            }];
            NSArray *sorted = [arr sortedArrayUsingSelector:@selector(compare:)];
            self.aisle = [sorted copy];
        }
        
    }
}

- (CGSize)sizeWithColumnNum:(int)col andRowNum:(int)row {
    return CGSizeMake(self.seatWidth*col, self.seatHeight*row);
}

- (SeatState)seatStateAtCol:(int)col andRow:(int)row {
    if (col < 1 || row < 1 || col > columnNum || row > rowNum) {
        return SeatStateNone;
    } else {
        return (SeatState)seatMap[col][row];
    }
}

- (BOOL)hasEmtpySeats {
    for (int row = 1; row <= rowNum; row++ ) {
        for (int col = 1; col <= columnNum; col++ ) {
            if (seatMap[col][row] == SeatStateSelected) {
                int originL = col, originR = col;
                for (; col <= columnNum; col++ ) {
                    if (seatMap[col][row] == SeatStateSelected) {
                        originR = col;
                    } else break;
                }
                
                /*
                 同一排的座位
                 1 左或右挨着已选座位或者边界，ok ！
                 左或右不可能挨着自选
                 左或右加1如果挨着自选，则中间隔的已选或者没座
                 2 左右挨着空座，左右隔一个不挨着自选，已选，边界
                 */
                SeatState l1State = [self seatStateAtCol:originL - 1 andRow:row];
                SeatState l2State = [self seatStateAtCol:originL - 2 andRow:row];
                
                SeatState r1State = [self seatStateAtCol:originR + 1 andRow:row];
                SeatState r2State = [self seatStateAtCol:originR + 2 andRow:row];
                
                if ((l1State == SeatStateUnavailable) || l1State == SeatStateNone
                    || (r1State == SeatStateUnavailable ) || r1State == SeatStateNone ) {
                    
                    if (l2State == SeatStateSelected
                        && l1State != SeatStateNone
                        && l1State != SeatStateUnavailable) {
                        return YES;
                    }
                    if (r2State == SeatStateSelected
                        && r1State != SeatStateNone
                        && r1State != SeatStateUnavailable) {
                        return YES;
                    }
                    
                } else {
                    if (l2State != SeatStateAvailable || r2State != SeatStateAvailable) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}


/**
 delegate 验证是否座位可选
 
 @param seats 座位 情侣座会是2个
 @return yes：可选 no：不可选
 */
- (BOOL) callDelegateSelects:(NSArray *)seats
{
    BOOL canSelect = YES;
    if ([delegate respondsToSelector:@selector(shouldSelectSeats:)]) {
        canSelect = [delegate shouldSelectSeats:seats];
    }
    
    return canSelect;
}

#pragma mark touche sense
- (BOOL)touchAtPoint:(CGPoint)point {
    
    int col = point.x/self.seatWidth + 1, row = point.y/self.seatHeight + 1;
    
    NSString *key = [self keyForSeatAtColumn:col andRow:row];
    
    NSString *seatId = [seatNOs objectForKey:key];
    if (!seatId)
        return NO;
    
    id<SeatProtocol> seat = [self getSeatBy:seatId];
    
    if (seat == nil) {
        return NO;
    }
    
    int graphCol = col, graphRow = row;
    SeatState status = [self seatStateAtCol:graphCol andRow:graphRow];
    if (status == SeatStateNone) {
        return NO;
    }
    
    
    BOOL statusDidChange = NO; //座位状态是否改变
    if (status == SeatStateAvailable) {
        if (currentSelectedNum < maxSelectedNum) {
            
            if ([self callDelegateSelects:@[seat]] == NO) {
                return NO;
            }
            
            currentSelectedNum ++;
            status = SeatStateSelected;
            statusDidChange = YES;
            if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
                [delegate selectSeatAtColumn:seat.seatCol
                                         row:seat.seatRow
                                      withId:seatId];
            }
        } else {
            if ([delegate respondsToSelector:@selector(selectNumReachMax)]) {
                [delegate selectNumReachMax];
            }
        }
    } else if (status == SeatStateLoverL) {
        if (currentSelectedNum+1 < maxSelectedNum) {
            id<SeatProtocol> seatLoverOther = [self otherSeatOfLover:col row:row];
            if (seatLoverOther != nil && [self callDelegateSelects:@[seat, seatLoverOther]] == NO) {
                return NO;
            }
            currentSelectedNum ++;
            status = SeatStateLoverLSelected;
            statusDidChange = YES;
            if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
                [delegate selectSeatAtColumn:seat.seatCol
                                         row:seat.seatRow
                                      withId:seatId];
            }
            
            // 选中另一个座位
            [self selectLoverSeat:graphCol andRow:graphRow];
            
        } else {
            if ([delegate respondsToSelector:@selector(selectNumReachMax)]) {
                [delegate selectNumReachMax];
            }
        }
    } else if (status == SeatStateLoverR) {
        if (currentSelectedNum+1 < maxSelectedNum) {
            // 先选中另一个座位 保持好选中情侣座顺序
            [self selectLoverSeat:graphCol andRow:graphRow];
            id<SeatProtocol> seatLoverOther = [self otherSeatOfLover:col row:row];
            if (seatLoverOther != nil && [self callDelegateSelects:@[seat, seatLoverOther]] == NO) {
                return NO;
            }
            currentSelectedNum ++;
            status = SeatStateLoverRSelected;
            statusDidChange = YES;
            if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
                [delegate selectSeatAtColumn:seat.seatCol
                                         row:seat.seatRow
                                      withId:seatId];
            }
            
            
            
        } else {
            if ([delegate respondsToSelector:@selector(selectNumReachMax)]) {
                [delegate selectNumReachMax];
            }
        }
    } else if (status == SeatStateSelected) {
        currentSelectedNum --;
        status = SeatStateAvailable;
        statusDidChange = YES;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
    } else if (status == SeatStateLoverLSelected) {
        currentSelectedNum --;
        status = SeatStateLoverL;
        statusDidChange = YES;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
        
        // 取消选择另一个座位
        [self deselectLoverSeat:col andRow:row];
        
    } else if (status == SeatStateLoverRSelected) {
        currentSelectedNum --;
        status = SeatStateLoverR;
        statusDidChange = YES;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
        
        // 取消选择另一个座位
        [self deselectLoverSeat:col andRow:row];
        
    }
    seatMap[graphCol][graphRow] = status;
    
    CGRect redrawRect = [self frameForSeatAtColumn:col andRow:row andStatus:status];
    [self setNeedsDisplayInRect:redrawRect];
    
    return statusDidChange;
}


/**
 获取情侣座的另外一半
 
 @param col col
 @param row row
 @return 另一半情侣座
 */
- (id<SeatProtocol>) otherSeatOfLover:(int) col row:(int) row
{
    int loverOtherRow = row;
    int loverOtherCol = col;
    SeatState status = [self seatStateAtCol:col andRow:row];
    
    if ([self isLoverSeat:status] == NO) {
        //不是情侣座
        return nil;
    }
    
    if (status == SeatStateLoverLSelected || status == SeatStateLoverLUnavailable || status == SeatStateLoverL) {
        loverOtherCol = col + 1;
    } else if (status == SeatStateLoverR || status == SeatStateLoverRSelected || status == SeatStateLoverRUnavailable) {
        loverOtherCol = col - 1;
    }
    
    NSString *keyLoverOther = [self keyForSeatAtColumn:loverOtherCol andRow:loverOtherRow];
    NSString *seatLoverOtherId = [seatNOs objectForKey:keyLoverOther];
    if (!seatLoverOtherId)
        return nil;
    id<SeatProtocol> seatLoverOther = [self getSeatBy:seatLoverOtherId];
    
    return seatLoverOther;
}

- (void)deselectLoverSeat:(int)col andRow:(int)row  {
    
    id<SeatProtocol> seatLoverOther = [self otherSeatOfLover:col row:row];
    if (!seatLoverOther) {
        return;
    }
    int loverOtherCol = seatLoverOther.graphCol.intValue;
    int loverOtherRow = seatLoverOther.graphRow.intValue;
    SeatState statusLoverOther = [self seatStateAtCol:loverOtherCol andRow:loverOtherRow];
    if ([self isLoverSeat:statusLoverOther] == NO) {
        return;
    }
    
    currentSelectedNum --;
    
    if (statusLoverOther == SeatStateLoverRSelected) {
        statusLoverOther = SeatStateLoverR;
    } else if (statusLoverOther == SeatStateLoverLSelected) {
        statusLoverOther = SeatStateLoverL;
    }
    
    if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
        [delegate deselectSeatAtColumn:seatLoverOther.seatCol
                                   row:seatLoverOther.seatRow
                                withId:seatLoverOther.seatId];
    }
    
    seatMap[loverOtherCol][loverOtherRow] = statusLoverOther;
    CGRect redrawRect = [self frameForSeatAtColumn:loverOtherCol andRow:loverOtherRow andStatus:statusLoverOther];
    [self setNeedsDisplayInRect:redrawRect];
}


/**
 根据状态 看是否是情侣座
 
 @param status 状态
 @return yes： 情侣座 no：不是情侣座
 */
- (BOOL) isLoverSeat:(SeatState) status
{
    if (status == SeatStateLoverL ||
        status == SeatStateLoverR ||
        status == SeatStateLoverLSelected ||
        status == SeatStateLoverRSelected ||
        status == SeatStateLoverLUnavailable ||
        status == SeatStateLoverRUnavailable) {
        //是情侣座
        return YES;
    }
    
    return NO;
}

- (void)selectLoverSeat:(int)col andRow:(int)row  {
    
    id<SeatProtocol> seatLoverOther = [self otherSeatOfLover:col row:row];
    if (!seatLoverOther) {
        return;
    }
    int loverOtherCol = seatLoverOther.graphCol.intValue;
    int loverOtherRow = seatLoverOther.graphRow.intValue;
    SeatState statusLoverOther = [self seatStateAtCol:loverOtherCol andRow:loverOtherRow];
    
    if ([self isLoverSeat:statusLoverOther] == NO) {
        return;
    }
    
    currentSelectedNum ++;
    
    if (statusLoverOther == SeatStateLoverR) {
        statusLoverOther = SeatStateLoverRSelected;
    } else if (statusLoverOther == SeatStateLoverL) {
        statusLoverOther = SeatStateLoverLSelected;
    }
    
    if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
        [delegate selectSeatAtColumn:seatLoverOther.seatCol
                                 row:seatLoverOther.seatRow
                              withId:seatLoverOther.seatId];
    }
    
    seatMap[loverOtherCol][loverOtherRow] = statusLoverOther;
    CGRect redrawRect = [self frameForSeatAtColumn:loverOtherCol andRow:loverOtherRow andStatus:statusLoverOther];
    [self setNeedsDisplayInRect:redrawRect];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    
    BOOL seatStatusDidChange = [self touchAtPoint:point];
    if ([delegate respondsToSelector:@selector(touchAt:didChangeSteatStatus:)]) {
        [delegate touchAt:point didChangeSteatStatus:seatStatusDidChange];
    }
}

/**
 *  MARK: 选中座位
 *
 *  @param seat 座位
 */
- (void) selectSeat:(id<SeatProtocol>)seat
{
    int graphCol = seat.graphCol.intValue, graphRow = seat.graphRow.intValue;
    SeatState status = [self seatStateAtCol:graphCol andRow:graphRow];
    if (status == SeatStateNone) {
        return;
    }
    if (status == SeatStateAvailable || status == SeatStateLoverL || status == SeatStateLoverR) {
        if (currentSelectedNum < maxSelectedNum) {
            currentSelectedNum ++;
            switch (status) {
                case SeatStateAvailable:
                    status = SeatStateSelected;
                    break;
                case SeatStateLoverL:
                    status = SeatStateLoverLSelected;
                    break;
                case SeatStateLoverR:
                    status = SeatStateLoverRSelected;
                    break;
                    
                default:
                    break;
            }
            if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
                [delegate selectSeatAtColumn:seat.seatCol
                                         row:seat.seatRow
                                      withId:seat.seatId];
            }
        }
        seatMap[graphCol][graphRow] = status;
        CGRect redrawRect = [self frameForSeatAtColumn:graphCol andRow:graphRow andStatus:status];
        [self setNeedsDisplayInRect:redrawRect];
    }
}

/**
 *  MARK: 选中座位
 *
 *  @param seats 座位
 */
- (void) selectSeats:(NSArray *)seats
{
    for (id<SeatProtocol> seat in seats) {
        [self selectSeat:seat];
    }
}

- (void)deselectSeatWithSeatId:(NSString *)seatId{
    
    if (!seatId)
        return;
    
    id<SeatProtocol> seat = [self getSeatBy:seatId];
    int row = [seat.graphRow intValue];
    int col = [seat.graphCol intValue];
    int graphCol = col, graphRow = row;
    SeatState status = [self seatStateAtCol:graphCol andRow:graphRow];
    if (status == SeatStateNone) {
        return;
    }
    if (status == SeatStateAvailable) {
        if (currentSelectedNum < maxSelectedNum) {
            currentSelectedNum ++;
            status = SeatStateSelected;
            if ([delegate respondsToSelector:@selector(selectSeatAtColumn:row:withId:)]) {
                [delegate selectSeatAtColumn:seat.seatCol
                                         row:seat.seatRow
                                      withId:seatId];
            }
        } else {
            if ([delegate respondsToSelector:@selector(selectNumReachMax)]) {
                [delegate selectNumReachMax];
            }
        }
    } else if (status == SeatStateSelected ) {
        currentSelectedNum --;
        status = SeatStateAvailable;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
    }else if (status == SeatStateLoverLSelected ) {
        currentSelectedNum --;
        status = SeatStateLoverL;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
    }else if (status == SeatStateLoverRSelected ) {
        currentSelectedNum --;
        status = SeatStateLoverR;
        if ([delegate respondsToSelector:@selector(deselectSeatAtColumn:row:withId:)]) {
            [delegate deselectSeatAtColumn:seat.seatCol
                                       row:seat.seatRow
                                    withId:seatId];
        }
    }
    seatMap[graphCol][graphRow] = status;
    
    
    CGRect redrawRect = [self frameForSeatAtColumn:col andRow:row andStatus:status];
    [self setNeedsDisplayInRect:redrawRect];
    
}

- (void) setUpdateDrawCallBack:(void (^)())a_block
{
    self.updateDrawBlock = a_block;
}

- (void) getSeatByIdBlock:(id<SeatProtocol>(^)(NSString *seatId))a_block
{
    self.getSeatBlock = [a_block copy];
}


- (id<SeatProtocol>) getSeatBy:(NSString *)seatId
{
    if (self.getSeatBlock && seatId) {
        return self.getSeatBlock(seatId);
    }
    return nil;
}


@end
