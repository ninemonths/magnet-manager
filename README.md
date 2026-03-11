# Magnet Manager - 鸿蒙磁力链接管理器

![HarmonyOS](https://img.shields.io/badge/HarmonyOS-4.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Mobile%20%26%20Tablet-orange)

一个专为鸿蒙操作系统设计的磁力链接跳转和管理工具，完美兼容手机和平板设备。

## ✨ 功能特性

### 🔗 磁力链接处理
- **智能识别**：自动识别剪贴板中的磁力链接
- **一键跳转**：快速跳转到支持的下载应用
- **链接管理**：历史记录、收藏夹、分类管理
- **批量操作**：支持批量导入和导出磁力链接

### 📱 鸿蒙特性
- **自适应布局**：完美适配手机和平板不同尺寸
- **原子化服务**：支持卡片服务，快速访问常用功能
- **分布式能力**：多设备间同步磁力链接记录
- **安全沙箱**：安全的链接验证和跳转机制

### 🛠️ 实用工具
- **链接解析**：显示磁力链接的详细信息（文件大小、文件数量等）
- **速度测试**：测试磁力链接的可用性和速度
- **格式转换**：磁力链接与其他格式的相互转换
- **二维码生成**：生成磁力链接的二维码，方便分享

## 🚀 快速开始

### 环境要求
- HarmonyOS SDK 4.0 或更高版本
- DevEco Studio 3.1 或更高版本
- Node.js 16+ (用于工具链)

### 安装步骤
```bash
# 克隆仓库
git clone https://github.com/ninemonths/magnet-manager.git

# 进入项目目录
cd magnet-manager

# 安装依赖
npm install

# 运行开发服务器
npm run dev
```

### 构建应用
```bash
# 调试版本
npm run build:debug

# 发布版本
npm run build:release
```

## 📁 项目结构

```
magnet-manager/
├── entry/                    # 主模块
│   ├── src/main/
│   │   ├── ets/             # ArkTS代码
│   │   │   ├── pages/       # 页面组件
│   │   │   ├── utils/       # 工具函数
│   │   │   ├── model/       # 数据模型
│   │   │   └── common/      # 公共组件
│   │   ├── resources/       # 资源文件
│   │   └── module.json5     # 模块配置
├── features/                # 特性模块
│   ├── magnet-parser/       # 磁力链接解析器
│   ├── download-manager/    # 下载管理器
│   └── history-manager/     # 历史记录管理器
├── docs/                    # 文档
├── tests/                   # 测试文件
└── tools/                   # 构建工具
```

## 🎯 核心功能实现

### 1. 磁力链接识别
```typescript
// 智能识别剪贴板内容
function detectMagnetLink(text: string): MagnetLink | null {
  const magnetPattern = /magnet:\?xt=urn:btih:[a-zA-Z0-9]{32,40}/;
  if (magnetPattern.test(text)) {
    return parseMagnetLink(text);
  }
  return null;
}
```

### 2. 应用跳转
```typescript
// 跳转到支持的下载应用
async function jumpToDownloadApp(magnetLink: string): Promise<boolean> {
  const supportedApps = await getSupportedApps();
  for (const app of supportedApps) {
    if (await canOpenUrl(app.scheme)) {
      return openUrl(`${app.scheme}${magnetLink}`);
    }
  }
  return false;
}
```

### 3. 历史记录管理
```typescript
// 使用鸿蒙分布式数据库
class HistoryManager {
  private rdbStore: relationalStore.RdbStore;
  
  async addRecord(record: MagnetRecord): Promise<void> {
    await this.rdbStore.insert(record);
    // 同步到其他设备
    await this.syncToOtherDevices();
  }
}
```

## 📱 界面设计

### 主界面布局
- **手机模式**：底部导航栏，卡片式列表
- **平板模式**：侧边栏导航，分栏布局
- **自适应**：根据屏幕尺寸自动调整布局

### 核心页面
1. **首页**：快速跳转、最近记录
2. **收藏夹**：收藏的磁力链接
3. **历史记录**：按时间排序的使用记录
4. **设置**：应用偏好、下载应用配置

## 🔧 配置说明

### 支持的下载应用
应用默认支持以下下载器（可配置添加）：
- 🟢 **Aria2**：`aria2://` 协议
- 🟢 **qBittorrent**：`qbittorrent://` 协议  
- 🟢 **Transmission**：`transmission://` 协议
- 🟢 **其他**：支持自定义协议配置

### 权限配置
```json
{
  "reqPermissions": [
    {
      "name": "ohos.permission.INTERNET"
    },
    {
      "name": "ohos.permission.GET_NETWORK_INFO"
    },
    {
      "name": "ohos.permission.READ_CLIPBOARD"
    },
    {
      "name": "ohos.permission.DISTRIBUTED_DATASYNC"
    }
  ]
}
```

## 📊 开发进度

### ✅ 已完成
- [x] 项目结构初始化
- [x] 基础框架搭建
- [x] README文档编写

### 🔄 进行中
- [ ] 磁力链接解析器开发
- [ ] 主界面UI设计
- [ ] 应用跳转功能实现

### 📅 计划中
- [ ] 历史记录管理
- [ ] 分布式数据同步
- [ ] 平板适配优化
- [ ] 测试用例编写

## 🤝 贡献指南

我们欢迎任何形式的贡献！

### 报告问题
请使用 [GitHub Issues](https://github.com/ninemonths/magnet-manager/issues) 报告bug或提出功能建议。

### 提交代码
1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 开发规范
- 使用 ArkTS 进行开发
- 遵循鸿蒙开发规范
- 编写单元测试
- 更新相关文档

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系与支持

- **问题反馈**：[GitHub Issues](https://github.com/ninemonths/magnet-manager/issues)
- **功能建议**：通过Issue提交
- **技术讨论**：欢迎提交Pull Request

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

---

**让磁力链接管理变得更简单！** 🚀

*为鸿蒙生态贡献力量，让每一台设备都能高效处理磁力链接。*