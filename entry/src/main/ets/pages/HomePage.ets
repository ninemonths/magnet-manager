// 首页组件
// 提供快速跳转、最近记录等功能

import { MagnetRecord } from '../model/MagnetRecord';
import { MagnetUtils } from '../utils/MagnetUtils';

@Component
export struct HomePage {
  @State recentRecords: MagnetRecord[] = [];
  @State clipboardContent: string = '';
  @State isProcessing: boolean = false;

  aboutToAppear() {
    // 加载最近记录
    this.loadRecentRecords();
    // 检查剪贴板
    this.checkClipboard();
  }

  // 加载最近记录
  private loadRecentRecords() {
    // 这里应该从数据库加载
    // 暂时使用模拟数据
    this.recentRecords = [
      {
        id: '1',
        title: '示例磁力链接1',
        magnetLink: 'magnet:?xt=urn:btih:EXAMPLEHASH1234567890',
        timestamp: Date.now() - 3600000, // 1小时前
        isFavorite: false
      },
      {
        id: '2', 
        title: '示例磁力链接2',
        magnetLink: 'magnet:?xt=urn:btih:EXAMPLEHASH2345678901',
        timestamp: Date.now() - 7200000, // 2小时前
        isFavorite: true
      }
    ];
  }

  // 检查剪贴板内容
  private async checkClipboard() {
    try {
      // 实际开发中应该使用鸿蒙剪贴板API
      // 这里简化为模拟
      this.clipboardContent = 'magnet:?xt=urn:btih:EXAMPLEHASH';
    } catch (error) {
      console.error('检查剪贴板失败:', error);
    }
  }

  // 处理磁力链接
  private async processMagnetLink(link: string) {
    this.isProcessing = true;
    
    try {
      // 验证磁力链接
      if (!MagnetUtils.isValidMagnetLink(link)) {
        // 显示错误提示
        prompt.showToast({
          message: '无效的磁力链接',
          duration: 2000
        });
        return;
      }

      // 解析磁力链接信息
      const info = await MagnetUtils.parseMagnetLink(link);
      
      // 跳转到下载应用
      const success = await MagnetUtils.jumpToDownloadApp(link);
      
      if (success) {
        // 保存到历史记录
        await this.saveToHistory(info);
        
        prompt.showToast({
          message: '已跳转到下载应用',
          duration: 2000
        });
      } else {
        prompt.showToast({
          message: '未找到支持的下载应用',
          duration: 2000
        });
      }
    } catch (error) {
      console.error('处理磁力链接失败:', error);
      prompt.showToast({
        message: '处理失败，请重试',
        duration: 2000
      });
    } finally {
      this.isProcessing = false;
    }
  }

  // 保存到历史记录
  private async saveToHistory(record: MagnetRecord) {
    // 这里应该保存到数据库
    console.log('保存记录:', record);
    // 刷新最近记录
    this.loadRecentRecords();
  }

  build() {
    Column() {
      // 欢迎标题
      Text($r('app.string.welcome_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 8 })
      
      Text($r('app.string.welcome_subtitle'))
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 30 })

      // 快速操作区域
      Column() {
        Text($r('app.string.quick_jump'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 16 })
          .alignSelf(ItemAlign.Start)

        // 粘贴磁力链接按钮
        if (this.clipboardContent && MagnetUtils.isValidMagnetLink(this.clipboardContent)) {
          Button($r('app.string.paste_magnet'), { type: ButtonType.Normal })
            .width('90%')
            .height(48)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.processMagnetLink(this.clipboardContent);
            })
            .margin({ bottom: 12 })
        }

        // 其他快速操作按钮
        Row({ space: 12 }) {
          Button($r('app.string.scan_qrcode'), { type: ButtonType.Normal })
            .width('50%')
            .height(48)
            .backgroundColor($r('app.color.secondary'))
          
          Button($r('app.string.import_file'), { type: ButtonType.Normal })
            .width('50%')
            .height(48)
            .backgroundColor($r('app.color.secondary'))
        }
        .width('90%')
        .margin({ bottom: 30 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })

      // 最近记录区域
      Column() {
        Text($r('app.string.recent_records'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 16 })
          .alignSelf(ItemAlign.Start)

        if (this.recentRecords.length === 0) {
          // 无记录提示
          Column() {
            Image($r('app.media.ic_empty'))
              .width(80)
              .height(80)
              .margin({ bottom: 16 })
            
            Text($r('app.string.no_records'))
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
              .margin({ bottom: 8 })
            
            Text($r('app.string.add_first_record'))
              .fontSize(14)
              .fontColor($r('app.color.primary'))
          }
          .width('100%')
          .height(200)
          .justifyContent(FlexAlign.Center)
        } else {
          // 记录列表
          List({ space: 12 }) {
            ForEach(this.recentRecords, (record) => {
              ListItem() {
                MagnetRecordItem({ record: record })
              }
            })
          }
          .width('100%')
          .height(300)
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ top: 20 })

      // 处理状态指示器
      if (this.isProcessing) {
        LoadingProgress()
          .color($r('app.color.primary'))
          .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
  }
}

// 磁力链接记录项组件
@Component
struct MagnetRecordItem {
  @Prop record: MagnetRecord;

  build() {
    Row() {
      // 图标
      Image(this.record.isFavorite ? $r('app.media.ic_favorite_filled') : $r('app.media.ic_link'))
        .width(24)
        .height(24)
        .margin({ right: 12 })

      // 内容
      Column() {
        Text(this.record.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Text(this.record.magnetLink.substring(0, 40) + '...')
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')

      // 操作按钮
      Button('跳转', { type: ButtonType.Capsule })
        .width(60)
        .height(32)
        .fontSize(12)
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.card_bg'))
    .borderRadius(12)
  }
}