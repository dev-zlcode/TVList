//
//  Tools.m
//  MVCTest
//
//  Created by 张雷 on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

#define PI 3.1415926

@implementation Tools

//JSON(NSString类型) 到 字典/数组
+(id)JSONToObject:(NSString *)string
{
    if (![NSJSONSerialization isValidJSONObject:string])
    {
        NSError *error = nil;
        id ret = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            NSLog(@"%@",@"解析成功");
            
            return ret;
        }
        else
        {
            NSLog(@"%@",@"解析失败");
            return nil;
        }
    }
    else
    {
        NSLog(@"%@",@"非法JSON数据");
        return nil;
    }
}

//字典/数组 到 JSON(NSData类型)
+(NSData *)objectToJSON:(id)object
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!error)
    {
        NSLog(@"%@",@"解析成功");
        
        return data;
    }
    else
    {
        NSLog(@"%@",@"解析失败");
        return nil;
    }
}

//32位MD5加密方法
+(NSString *) md5: (NSString *) encodeStr
{
    const char *cStr = [encodeStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//-----------------------------------------------------------------------------------
//AES16位密钥
#define gkey			@"79b4ac9445bc3db0"
//AES16位iv
#define gIv             @"1234567812345678"

//AES128追加Base64 加密
+(NSString *)AES128Encrypt:(NSString *)plainText
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    NSInteger diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSInteger newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(NSInteger i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,               //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [self base64StringFromData:resultData];
    }
    free(buffer);
    return nil;
}

//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self dataFromBase64String:encryptText];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

//----------------------------------------------------------------------------------------
// DES密钥
NSString *key = @"zhanglei";
// DES初始化量
Byte iv[] = {0x12, 0x34, 0x56, 120, 0x90, 0xab, 0xcd, 0xef};

/*
 DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
 DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
 */

/*字符串加密
 *参数
 *plainText : 加密明文
 *key       : 密钥 64位
 */
+ (NSString*) DESEncrypt:(NSString *)plainText;
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,            //kCCEncrypt加密 kCCDecrypt解密
                                          kCCAlgorithmDES,       //加密根据哪个标准（des，3des，aes）
                                          kCCOptionPKCS7Padding, //选项分组密码算法(des:对每块分组加一次密 3DES：对每块分组加三个不同的密)
                                          [key UTF8String],      //密钥 加密和解密的密钥必须一致
                                          kCCKeySizeDES,         //DES 密钥的大小（kCCKeySizeDES=8）
                                          iv,                    //可选的初始矢量
                                          textBytes,             //数据的存储单元
                                          dataLength,            //数据的大小
                                          buffer,                //用于返回数据
                                          1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//解密
+ (NSString*) DESDecrypt:(NSString *)cipherText;
{
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

//编码：解决"+"等字符不能转义的问题
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

//解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//NSData to Base64字符串 编码
+ (NSString *)base64StringFromData:(NSData *)data
{
    if (data)
    {
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        return base64;
    }
    else
    {
        return @"";
    }
}

//Base64字符串 to NSData 解码
+ (NSData *)dataFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:@""])
    {
        return [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else
    {
        return nil;
    }
}

//产生指定位数的字符串
+(NSString *)createStringNum:(NSInteger)num
{
    char data[num];
    for (NSInteger x=0;x<num;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:num encoding:NSUTF8StringEncoding];
}

//在字符串第4位加入随机的4为字符串
+(NSString *)stringAdd4Char:(NSString *)string
{
    NSString *addString = [self createStringNum:4];
    
    NSMutableString *retString = [[NSMutableString alloc] initWithString:string];
    [retString insertString:addString atIndex:4];
    
    return retString;
}

//字符串每4位加入一个空格
+(NSString *)addSpace:(NSString *)string
{
    NSMutableString *retStr = [[NSMutableString alloc] init];
    
    for (NSInteger i = 0; i <string.length; i ++)
    {
        unichar c = [string characterAtIndex:i];
        [retStr appendFormat:@"%c",c];
        
        if ((i+1)%4==0)
        {
            [retStr appendString:@" "];
        }
    }
    return retStr;
}

//时间戳 → 北京时间
+(NSString *)timedsampToDate:(NSString *)string withFormatter:(NSString *)formatter
{
    //时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string doubleValue]];
    NSString *confromTimespStr = [self dateToBJTime:confromTimesp withFormatter:formatter];
    
    return confromTimespStr;
}

//北京时间 → 时间戳
+(NSString *)dateToTimedsamp:(NSDate *)date
{
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    
    return timeSp;
}

//时间格式化成北京时间
+(NSString *)dateToBJTime:(NSDate *)date
{
    //2015-03-22 16:9:53
    
    //设置时间显示格式:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    return confromTimespStr;
}

+(NSString *)dateToBJTime:(NSDate *)date withFormatter:(NSString *)string
{
    //2015-03-22 16:9:53
    
    //设置时间显示格式:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:string];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    return confromTimespStr;
}

//字符串转NSDate(USA时间)
-(NSDate *)stringToDate:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    return inputDate;
}

//单行的size
+(CGSize)sizeWithString:(NSString *)text withFont:(UIFont *)font
{
    return [text sizeWithAttributes:@{NSFontAttributeName:font}];
}

//多行的size
+(CGSize)sizeWithMulString:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size
{
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

//判断是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断是否是邮箱
+ (BOOL) isValidEmail:(NSString *)checkString
{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:checkString];
}

//判断是否是身份证
+ (BOOL)isValidIdCard:(NSString*)idCard
{
    NSString*regex = @"^\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x)$";
    NSPredicate *idPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [idPre evaluateWithObject:idCard];
}

//判断是否为空
+ (BOOL)isEmpty:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]] || [obj isEqualToString:@""] || obj == nil)
    {
        return YES;
    }
    
    return NO;
}

// 处理null 为空字符串
+ (NSString *)handleNull:(id)obj
{
    if (obj == nil)
    {
        return @"";
    }
    else if ([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if ([obj isKindOfClass:[NSString class]])
    {
        if ([obj isEqualToString:@""])
        {
            return @"";
        }
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@",obj];
    }
    
    return obj;
}

// 比较版本号  -1 小于    0 等于    1 大于
+ (NSInteger)compareVersion:(NSString *)first second:(NSString *)second
{
    // 分割成数组
    NSMutableArray *firstArray = [[NSMutableArray alloc] initWithArray:[first componentsSeparatedByString:@"."]];
    NSMutableArray *secondArray = [[NSMutableArray alloc] initWithArray:[second componentsSeparatedByString:@"."]];
    
    // 移除数组中所有非数字字符
    for (NSInteger i = 0; i < firstArray.count; i ++)
    {
        [firstArray replaceObjectAtIndex:i withObject:[self allNumber:firstArray[i]]];
    }
    
    for (NSInteger i = 0; i < secondArray.count; i ++)
    {
        [secondArray replaceObjectAtIndex:i withObject:[self allNumber:secondArray[i]]];
    }
    
    // 比较
    if (firstArray.count > secondArray.count)
    {
        for (NSInteger i = secondArray.count; i < firstArray.count; i ++)
        {
            [secondArray addObject:@""];
        }
    }
    else
    {
        for (NSInteger i = firstArray.count; i < secondArray.count; i ++)
        {
            [firstArray addObject:@""];
        }
    }
    
    for (NSInteger i = 0; i < firstArray.count; i ++)
    {
        if ([firstArray[i] integerValue] > [secondArray[i] integerValue])
        {
            return 1;
        }
        else if ([firstArray[i] integerValue] < [secondArray[i] integerValue])
        {
            return -1;
        }
    }
    
    return 0;
}

// 移除字符串中所有非数组的字符
// "[^0-9|^.^ ]" 保留数字 小数点 空格
+ (NSString *)allNumber:(NSString *)string
{
    NSString *strippedBbox = [string stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])];
    return strippedBbox;
}

//计算两个经纬度的距离
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    //地球半径
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    //把纬度换算成rad单位值
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //把经度换算成rad单位值
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    //计算真实的经纬度度数
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    //计算间距
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    //换算成距离值
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

//生成全色的图片
+ (UIImage *)imageWithTheColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //打开图片上下文
    UIGraphicsBeginImageContext(rect.size);
    //获取当前图片上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //填充颜色
    CGContextFillRect(context, rect);
    //生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘画
    UIGraphicsEndImageContext();
    
    return image;
}

//改变图片颜色
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getMobileUDID
{
    return [OpenUDID value];
}

// 获取当前版本号
+ (NSString *)getVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

/**
 *
 * 设置字符串指定位置连续的颜色
 *
 * color         设定的颜色
 * norCorlor     常规颜色
 * string        字符串
 * index         第几位开始
 * count         总共几位
 */
+ (NSMutableAttributedString *)setMulColor:(UIColor *)color norColor:(UIColor *)norCorlor string:(NSString *)string index:(NSInteger)index count:(NSInteger)count
{
    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [showStr addAttribute:NSForegroundColorAttributeName value:norCorlor range:NSMakeRange(0,index)];
    [showStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(index,count)];
    [showStr addAttribute:NSForegroundColorAttributeName value:norCorlor range:NSMakeRange(count+index,string.length-count-index)];
    
    return showStr;
}

/*
 *监测数组内是否包含该字符串
 *@parameter:数组
 *@parameter:字符串
 */
+ (BOOL)isArray:(NSArray *)array stirng:(NSString *)string
{
    BOOL flag = NO;
    
    for (NSInteger i = 0; i < array.count; i ++)
    {
        if ([array[i] isEqualToString:string])
        {
            flag = YES;
            break;
        }
    }
    
    return flag;
}

/*
 *根据制定定字符串截取字符串成数组，并且过滤空字符串
 *@parameter firstStr:需要截取的字符串
 *@parameter secondStr:依据的字符串
 */
+ (NSMutableArray *)componentsStringByString:(NSString *)firstStr string:(NSString *)secondStr
{
    NSArray *array = [firstStr componentsSeparatedByString:secondStr];
    
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    for (NSString *str in array)
    {
        if (![str isEqualToString:@""] && str != nil)
        {
            [retArr addObject:str];
        }
    }
    return retArr;
}

/*
 *把数组拼接成字符串，并且过滤数组中的空字符串
 *@parameter array:数组
 *@parameter string:依据的字符串
 */
+ (NSString *)pingjieStringFromArray:(NSArray *)array string:(NSString *)string
{
    NSString *retString = @"";
    
    for (NSString *obj in array)
    {
        if (![obj isEqualToString:@""] && obj != nil)
        {
            retString = [retString stringByAppendingString:[NSString stringWithFormat:@"%@%@",string,obj]];
        }
    }
    
    if (retString.length)
    {
        return [retString substringFromIndex:1];
    }
    else
    {
        return @"";
    }
}

//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

// 压缩图片：0-300KB
+ (NSData *)reduceMinImage:(UIImage *)image
{
    // 限制条件：最大300KB
    CGFloat MaxKB = 300;
    // 限制条件：最大尺寸 854*854
    CGFloat WidthOrHeight = 854;
    
    // 图片信息
    // 获取图片大小
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    CGFloat KB = data.length/1000;
    
    // 获取图片尺寸
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    // 策略
    if (KB > MaxKB)
    {
        // 通过尺寸压缩
        if (width > WidthOrHeight || height > WidthOrHeight)
        {
            if (width > height)
            {
                image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(WidthOrHeight, height/(width/WidthOrHeight))];
            }
            else
            {
                image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(width/(height/WidthOrHeight), WidthOrHeight)];
            }
        }
    }
    return UIImageJPEGRepresentation(image, 0.8);
}

#pragma mark - 保存图片到本地相册
+ (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }
    else
    {
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
