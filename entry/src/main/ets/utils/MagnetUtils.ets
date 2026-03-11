// 磁力链接工具类

import { MagnetRecord, MagnetInfo, DownloadApp } from '../model/MagnetRecord';

export class MagnetUtils {
  // 验证磁力链接格式
  static isValidMagnetLink(link: string): boolean {
    if (!link || typeof link !== 'string') {
      return false;
    }
    
    // 基本格式验证
    const magnetPattern = /^magnet:\?xt=urn:btih:[a-zA-Z0-9]{32,40}/;
    if (!magnetPattern.test(link)) {
      return false;
    }
    
    return true;
  }
  
  // 解析磁力链接
  static async parseMagnetLink(link: string): Promise<MagnetInfo> {
    if (!this.isValidMagnetLink(link)) {
      throw new Error('无效的磁力链接格式');
    }
    
    const url = new URL(link);
    const params = new URLSearchParams(url.search);
    
    const info: MagnetInfo = {
      hash: '',
      trackers: [],
      keywords: []
    };
    
    // 提取哈希值
    const xt = params.get('xt');
    if (xt && xt.startsWith('urn:btih:')) {
      info.hash = xt.substring(9);
    }
    
    // 提取显示名称
    const dn = params.get('dn');
    if (dn) {
      info.displayName = decodeURIComponent(dn);
    }
    
    // 提取追踪器
    params.forEach((value, key) => {
      if (key === 'tr') {
        info.trackers.push(decodeURIComponent(value));
      }
    });
    
    // 提取精确主题
    const xtExact = params.get('xt.1');
    if (xtExact && xtExact.startsWith('urn:btih:')) {
      info.exactTopic = xtExact.substring(9);
    }
    
    // 提取精确长度
    const xl = params.get('xl');
    if (xl) {
      info.exactLength = parseInt(xl, 10);
    }
    
    // 提取关键词
    const kt = params.get('kt');
    if (kt) {
      info.keywords = kt.split('+').map(k => decodeURIComponent(k));
    }
    
    return info;
  }
  
  // 跳转到下载应用
  static async jumpToDownloadApp(magnetLink: string): Promise<boolean> {
    try {
      // 获取支持的下载应用
      const supportedApps = await this.getSupportedApps();
      
      // 查找已安装的默认应用
      const defaultApp = supportedApps.find(app => app.isInstalled && app.isDefault);
      if (defaultApp) {
        return await this.openUrl(`${defaultApp.scheme}${encodeURIComponent(magnetLink)}`);
      }
      
      // 查找第一个已安装的应用
      const installedApp = supportedApps.find(app => app.isInstalled);
      if (installedApp) {
        return await this.openUrl(`${installedApp.scheme}${encodeURIComponent(magnetLink)}`);
      }
      
      return false;
    } catch (error) {
      console.error('跳转到下载应用失败:', error);
      return false;
    }
  }
  
  // 获取支持的下载应用列表
  static async getSupportedApps(): Promise<DownloadApp[]> {
    // 这里应该从配置或系统查询
    // 暂时返回预定义列表
    return [
      {
        id: 'aria2',
        name: 'Aria2',
        packageName: 'com.aria2.android',
        scheme: 'aria2://',
        isInstalled: await this.checkAppInstalled('com.aria2.android'),
        isDefault: true
      },
      {
        id: 'qbittorrent',
        name: 'qBittorrent',
        packageName: 'com.qbittorrent.android',
        scheme: 'qbittorrent://',
        isInstalled: await this.checkAppInstalled('com.qbittorrent.android'),
        isDefault: false
      },
      {
        id: 'transmission',
        name: 'Transmission',
        packageName: 'org.transmission.android',
        scheme: 'transmission://',
        isInstalled: await this.checkAppInstalled('org.transmission.android'),
        isDefault: false
      },
      {
        id: 'flud',
        name: 'Flud',
        packageName: 'com.delphicoder.flud',
        scheme: 'flud://',
        isInstalled: await this.checkAppInstalled('com.delphicoder.flud'),
        isDefault: false
      }
    ];
  }
  
  // 检查应用是否安装
  private static async checkAppInstalled(packageName: string): Promise<boolean> {
    try {
      // 实际开发中应该使用鸿蒙的应用管理API
      // 这里简化为模拟
      return Math.random() > 0.5; // 50%概率返回已安装
    } catch (error) {
      console.error('检查应用安装状态失败:', error);
      return false;
    }
  }
  
  // 打开URL
  private static async openUrl(url: string): Promise<boolean> {
    try {
      // 实际开发中应该使用鸿蒙的意图启动API
      // 这里简化为模拟
      console.log('尝试打开URL:', url);
      return true;
    } catch (error) {
      console.error('打开URL失败:', error);
      return false;
    }
  }
  
  // 生成磁力链接的二维码数据
  static generateQRCodeData(magnetLink: string): string {
    // 对磁力链接进行URL编码
    return encodeURIComponent(magnetLink);
  }
  
  // 从磁力链接提取文件名
  static extractFileName(magnetLink: string): string {
    try {
      const url = new URL(magnetLink);
      const params = new URLSearchParams(url.search);
      const dn = params.get('dn');
      
      if (dn) {
        return decodeURIComponent(dn);
      }
      
      // 如果没有dn参数，使用哈希值作为文件名
      const xt = params.get('xt');
      if (xt && xt.startsWith('urn:btih:')) {
        return xt.substring(9, 19) + '...'; // 取前10位
      }
      
      return '未知文件';
    } catch (error) {
      console.error('提取文件名失败:', error);
      return '无效链接';
    }
  }
  
  // 计算磁力链接的哈希值（简化的指纹）
  static calculateLinkHash(magnetLink: string): string {
    try {
      const url = new URL(magnetLink);
      const params = new URLSearchParams(url.search);
      const xt = params.get('xt');
      
      if (xt && xt.startsWith('urn:btih:')) {
        return xt.substring(9); // 返回完整的哈希值
      }
      
      // 如果没有xt参数，使用整个链接的哈希
      let hash = 0;
      for (let i = 0; i < magnetLink.length; i++) {
        hash = ((hash << 5) - hash) + magnetLink.charCodeAt(i);
        hash = hash & hash; // 转换为32位整数
      }
      return Math.abs(hash).toString(16);
    } catch (error) {
      console.error('计算链接哈希失败:', error);
      return '0';
    }
  }
}