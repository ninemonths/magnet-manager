# Magnet Manager 部署指南

本文档详细说明如何将Magnet Manager打包成HAP文件并安装到鸿蒙设备进行测试。

## 📋 前置要求

### 1. 开发环境
- **DevEco Studio 3.1+**：鸿蒙官方IDE
- **HarmonyOS SDK 4.0+**：API Level 10
- **Node.js 16+**：构建工具链
- **JDK 11/17**：签名工具

### 2. 测试设备
- 鸿蒙手机（HarmonyOS 4.0+）
- 或鸿蒙模拟器
- 或远程真机服务

## 🚀 快速开始

### 步骤1：环境检查
```bash
# 克隆项目（如果尚未克隆）
git clone https://github.com/ninemonths/magnet-manager.git
cd magnet-manager

# 检查环境
./scripts/build_hap.sh check
```

### 步骤2：安装依赖
```bash
npm install
```

### 步骤3：构建HAP文件
```bash
# 构建调试版本（自动签名）
npm run build:debug

# 或使用构建脚本
./scripts/build_hap.sh debug
```

### 步骤4：安装到设备
```bash
# 自动安装（如果设备已连接）
npm run install

# 或手动安装
hdc install outputs/default/entry-default-signed.hap
```

### 步骤5：运行应用
```bash
# 启动应用
hdc shell aa start -a EntryAbility -b com.ninemonths.magnetmanager

# 查看日志
npm run log
```

## 🔐 签名配置

### 调试签名（开发使用）
首次构建时会自动生成调试证书：
- **存储文件**: `debug.p12`
- **密码**: 123456
- **有效期**: 3650天

### 发布签名（上架应用商店）
需要申请正式证书：
1. 访问 https://developer.harmonyos.com/cn/console
2. 创建应用并申请发布证书
3. 在DevEco Studio中配置发布签名

## 📱 设备连接

### 连接真实设备
1. **开启开发者模式**：
   - 设置 → 关于手机 → 连续点击版本号7次
   - 返回 → 系统和更新 → 开发人员选项
   - 开启USB调试

2. **连接电脑**：
   ```bash
   # 检查连接
   hdc list targets
   
   # 应该显示设备序列号
   ```

### 使用模拟器
1. 打开DevEco Studio
2. **Tools** → **Device Manager**
3. 下载需要的模拟器镜像
4. 启动模拟器

### 使用远程真机（免费）
1. 申请远程真机权限
2. 在DevEco Studio中连接
3. 直接安装测试

## 🛠️ 构建脚本详解

### 主要构建命令
```bash
# 完整构建流程
./scripts/build_hap.sh [debug|release]

# 仅构建
npm run build:debug
npm run build:release

# 安装到设备
npm run install

# 卸载应用
npm run uninstall

# 查看日志
npm run log
```

### 构建输出目录
```
outputs/
└── default/
    ├── entry-default-signed.hap    # 签名后的HAP文件
    ├── entry-default-unsigned.hap  # 未签名的HAP文件
    └── entry-default-unsigned.hap.map  # 源码映射文件
```

## 🔧 故障排除

### 常见问题1：构建失败
```
错误: Cannot find module '@ohos/hvigor-ohos-plugin'
```
**解决方案**：
```bash
# 重新安装依赖
rm -rf node_modules
npm install
```

### 常见问题2：签名失败
```
错误: Failed to sign HAP
```
**解决方案**：
1. 检查JDK是否安装：`java -version`
2. 重新生成调试证书：`./scripts/create_keystore.sh`
3. 在DevEco Studio中重新配置签名

### 常见问题3：设备连接失败
```
错误: No devices/emulators found
```
**解决方案**：
1. 检查USB线是否连接
2. 确认开发者选项已开启
3. 尝试不同的USB端口
4. 重启ADB服务：`hdc kill` → `hdc start`

### 常见问题4：安装失败
```
错误: Failure [INSTALL_FAILED_VERIFICATION_FAILED]
```
**解决方案**：
1. 卸载旧版本：`npm run uninstall`
2. 重新安装：`npm run install`
3. 检查设备存储空间

## 📊 测试验证

### 功能测试清单
安装成功后，验证以下功能：

1. ✅ 应用正常启动
2. ✅ 界面显示正常（手机/平板布局）
3. ✅ 磁力链接识别功能
4. ✅ 剪贴板检测
5. ✅ 跳转到下载应用

### 性能测试
```bash
# 监控应用性能
hdc shell top -n 1 | grep magnet

# 查看内存使用
hdc shell dumpsys meminfo com.ninemonths.magnetmanager
```

## 🚢 发布准备

### 测试版本发布
1. 构建发布版本：`npm run build:release`
2. 内部测试分发
3. 收集反馈并修复问题

### 应用商店发布
1. 申请华为开发者账号
2. 准备应用素材（图标、截图、描述）
3. 提交应用审核
4. 发布到华为应用市场

## 📞 技术支持

### 获取帮助
- **GitHub Issues**: https://github.com/ninemonths/magnet-manager/issues
- **鸿蒙开发者论坛**: https://developer.huawei.com/consumer/cn/forum
- **官方文档**: https://developer.harmonyos.com/cn/docs/documentation/doc-guides

### 调试工具
```bash
# 实时日志
hdc shell hilog | grep MagnetManager

# 应用信息
hdc shell aa dump -a EntryAbility

# 性能分析
hdc shell aa profile --start
```

## 📝 更新日志

### v1.0.0 (初始版本)
- 基础磁力链接识别功能
- 自适应手机/平板布局
- 调试版本构建支持
- 完整的部署文档

---

**开始测试吧！如果有任何问题，请查看故障排除部分或提交Issue。** 🚀