//
//  Tools.h
//  MVCTest
//
//  Created by 张雷 on 15/6/30.
//  Copyright (c) 2015年 zhanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/*
 
 关于appStore的几个链接
 
 app首页（需要指定特定的app首页）：[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/le-ye-tian-kong/id%@?mt=8",APP_ID]
 获取app信息（get/post）：[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APP_ID]
 去评分（只需要appid）：[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID]
 
 */

//---------------------------JSON----------------------------------------------------
//JSON(NSString类型) 到 字典/数组
+(id)JSONToObject:(NSString *)string;
//字典/数组 到 JSON(NSData类型)
+(NSData *)objectToJSON:(id)object;

//---------------------------字符串处理（MD5加密 AES加密 DES加密 Base64编码）--------------------
//32位MD5加密方法
+(NSString *) md5: (NSString *) encodeStr ;

//AES128追加Base64 加密
+(NSString *)AES128Encrypt:(NSString *)plainText;
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText;

//DES追加Base64 加密
+ (NSString*) DESEncrypt:(NSString *)plainText;
//解密
+ (NSString*) DESDecrypt:(NSString *)cipherText;

//编码：解决"+"字符不能转义的问题
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
//解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

//NSData to Base64字符串
+ (NSString *)base64StringFromData:(NSData *)data;
//Base64字符串 to NSData
+ (NSData *)dataFromBase64String:(NSString *)base64;

//产生指定位数的字符串
+(NSString *)createStringNum:(NSInteger)num;

//在字符串第4位加入随机的4为字符串
+(NSString *)stringAdd4Char:(NSString *)string;

//字符串每4位加入一个空格
+(NSString *)addSpace:(NSString *)string;

//---------------------------文本校验-------------------------------------------------
//判断是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//判断是否是邮箱
+ (BOOL) isValidEmail:(NSString *)checkString;

//判断是否是身份证
+ (BOOL)isValidIdCard:(NSString*)idCard;

//判断是否为空
+ (BOOL)isEmpty:(id)obj;

// 处理null 为空字符串
+ (NSString *)handleNull:(id)obj;

// 比较版本号  -1 小于    0 等于    1 大于
+ (NSInteger)compareVersion:(NSString *)first second:(NSString *)second;

// 移除字符串中所有非数组的字符
// "[^0-9|^.^ ]" 保留数字 小数点 空格
+ (NSString *)allNumber:(NSString *)string;

//---------------------------日期处理-------------------------------------------------
/**
 时间戳 → 北京时间
 参数：时间戳 1427016098.171510
 返回：日期   2015-03-22 17:21:38
 */
+(NSString *)timedsampToDate:(NSString *)string withFormatter:(NSString *)formatter;

/**
 北京时间 → 时间戳
 参数：日期   2015-03-22 17:21:38
 返回：时间戳 1427016098.171510
 */
+(NSString *)dateToTimedsamp:(NSDate *)date;

/**
 时间格式化成北京时间
 参数：date      日期   2015-03-22 09:50:42 +0000
 参数：string    格式   YYYY-MM-dd HH:mm:ss
 返回：时间戳  2015-03-22 17:50:42
 */
+(NSString *)dateToBJTime:(NSDate *)date;
+(NSString *)dateToBJTime:(NSDate *)date withFormatter:(NSString *)string;

//字符串转NSDate(USA时间)
-(NSDate *)stringToDate:(NSString *)string;

//---------------------------计算文本长度----------------------------------------------
//单行的size
+(CGSize)sizeWithString:(NSString *)text withFont:(UIFont *)font;

//多行的size
+(CGSize)sizeWithMulString:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size;

//计算两个经纬度的距离
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

//生成全色图片
+ (UIImage *)imageWithTheColor:(UIColor *)color;

//改变图片颜色
+ (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image;

// 获取设备号
+ (NSString *)getMobileUDID;

// 获取当前版本号
+ (NSString *)getVersion;

/**
 * 设置指定字颜色
 * color         设定的颜色
 * norCorlor     常规颜色
 * string        字符串
 * index         第几位开始
 * count         总共几位
 */
+ (NSMutableAttributedString *)setMulColor:(UIColor *)color norColor:(UIColor *)norCorlor string:(NSString *)string index:(NSInteger)index count:(NSInteger)count;

/*
 *监测数组内是否包含该字符串
 *@parameter:数组
 *@parameter:字符串
 */
+ (BOOL)isArray:(NSArray *)array stirng:(NSString *)string;

/*
 *根据制定定字符串截取字符串成数组，并且过滤空字符串
 *@parameter firstStr:需要截取的字符串
 *@parameter secondStr:依据的字符串
 */
+ (NSMutableArray *)componentsStringByString:(NSString *)firstStr string:(NSString *)secondStr;

/*
 *把数组拼接成字符串，并且过滤数组中的空字符串
 *@parameter array:数组
 *@parameter string:依据的字符串
 */
+ (NSString *)pingjieStringFromArray:(NSArray *)array string:(NSString *)string;


//压缩图片质量
// percent 0-1
// NSData/1000 KB
// NSData/1000/1000 MB
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent;

//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

// 压缩图片：0-300KB
+ (NSData *)reduceMinImage:(UIImage *)image;

// 保存图片到本地相册
+ (void)saveImageToPhotos:(UIImage*)savedImage;

@end
