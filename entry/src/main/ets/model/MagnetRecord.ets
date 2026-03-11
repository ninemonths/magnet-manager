// 磁力链接记录数据模型

export class MagnetRecord {
  id: string = '';           // 记录ID
  title: string = '';        // 标题
  magnetLink: string = '';   // 磁力链接
  timestamp: number = 0;     // 时间戳
  isFavorite: boolean = false; // 是否收藏
  fileSize?: number;         // 文件大小（字节）
  fileCount?: number;        // 文件数量
  category?: string;         // 分类
  tags: string[] = [];       // 标签
  
  constructor(data?: Partial<MagnetRecord>) {
    if (data) {
      Object.assign(this, data);
    }
  }
  
  // 获取格式化时间
  getFormattedTime(): string {
    const date = new Date(this.timestamp);
    const now = new Date();
    const diff = now.getTime() - this.timestamp;
    
    // 今天
    if (date.toDateString() === now.toDateString()) {
      return date.toLocaleTimeString('zh-CN', { 
        hour: '2-digit', 
        minute: '2-digit' 
      });
    }
    
    // 昨天
    const yesterday = new Date(now);
    yesterday.setDate(yesterday.getDate() - 1);
    if (date.toDateString() === yesterday.toDateString()) {
      return '昨天';
    }
    
    // 一周内
    if (diff < 7 * 24 * 60 * 60 * 1000) {
      const days = Math.floor(diff / (24 * 60 * 60 * 1000));
      return `${days}天前`;
    }
    
    // 更早
    return date.toLocaleDateString('zh-CN');
  }
  
  // 获取格式化文件大小
  getFormattedFileSize(): string {
    if (!this.fileSize) return '未知大小';
    
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    let size = this.fileSize;
    let unitIndex = 0;
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return `${size.toFixed(1)} ${units[unitIndex]}`;
  }
}

// 下载应用配置
export interface DownloadApp {
  id: string;                // 应用ID
  name: string;              // 应用名称
  packageName: string;       // 包名
  scheme: string;            // 协议头
  isInstalled: boolean;      // 是否已安装
  isDefault: boolean;        // 是否为默认应用
}

// 应用设置
export interface AppSettings {
  defaultDownloadApp: string;      // 默认下载应用ID
  autoDetectClipboard: boolean;    // 自动检测剪贴板
  autoJump: boolean;               // 自动跳转
  theme: 'light' | 'dark' | 'auto'; // 主题
  language: 'zh' | 'en';           // 语言
  vibrationFeedback: boolean;      // 震动反馈
  soundFeedback: boolean;          // 声音反馈
}

// 磁力链接解析结果
export interface MagnetInfo {
  hash: string;              // 信息哈希
  displayName?: string;      // 显示名称
  trackers: string[];        // 追踪器
  exactTopic?: string;       // 精确主题
  exactLength?: number;      // 精确长度
  keywords?: string[];       // 关键词
}