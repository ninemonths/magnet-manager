#!/bin/bash

# Magnet Manager HAP构建脚本
# 使用方法: ./scripts/build_hap.sh [debug|release]

set -e

BUILD_MODE=${1:-debug}
PROJECT_DIR=$(pwd)
OUTPUT_DIR="$PROJECT_DIR/outputs"
HAP_DIR="$OUTPUT_DIR/default"

echo "🔨 开始构建 Magnet Manager HAP 文件..."
echo "构建模式: $BUILD_MODE"
echo "项目目录: $PROJECT_DIR"
echo ""

# 检查必要工具
check_tools() {
  echo "检查构建工具..."
  
  # 检查Node.js
  if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装"
    echo "请安装 Node.js 16+：brew install node"
    exit 1
  fi
  echo "✅ Node.js $(node -v)"
  
  # 检查npm
  if ! command -v npm &> /dev/null; then
    echo "❌ npm 未安装"
    exit 1
  fi
  echo "✅ npm $(npm -v)"
  
  # 检查鸿蒙构建工具
  if [ ! -f "hvigorfile.ts" ]; then
    echo "⚠️  hvigorfile.ts 不存在，正在创建..."
    # 已在前面的步骤中创建
  fi
  echo "✅ 构建配置文件就绪"
}

# 清理构建目录
clean_build() {
  echo "清理构建目录..."
  rm -rf entry/build 2>/dev/null || true
  rm -rf outputs 2>/dev/null || true
  echo "✅ 清理完成"
}

# 安装依赖
install_deps() {
  echo "安装项目依赖..."
  
  if [ ! -d "node_modules" ]; then
    npm install
  else
    npm ci
  fi
  
  echo "✅ 依赖安装完成"
}

# 构建HAP
build_hap() {
  echo "开始构建HAP文件..."
  
  if [ "$BUILD_MODE" = "release" ]; then
    echo "构建发布版本..."
    npm run build:release
  else
    echo "构建调试版本..."
    npm run build:debug
  fi
  
  # 检查构建结果
  if [ -d "$HAP_DIR" ]; then
    HAP_FILE=$(find "$HAP_DIR" -name "*.hap" | head -1)
    if [ -f "$HAP_FILE" ]; then
      echo "✅ HAP文件构建成功！"
      echo "文件位置: $HAP_FILE"
      echo "文件大小: $(du -h "$HAP_FILE" | cut -f1)"
      
      # 显示HAP信息
      echo ""
      echo "📦 HAP文件信息:"
      echo "----------------------------------------"
      unzip -l "$HAP_FILE" | grep -E "(\.abc$|\.json$|\.so$)" | head -10
    else
      echo "❌ 未找到HAP文件"
      exit 1
    fi
  else
    echo "❌ 构建目录不存在: $HAP_DIR"
    exit 1
  fi
}

# 安装到设备（如果连接了设备）
install_to_device() {
  if [ "$BUILD_MODE" = "debug" ]; then
    echo ""
    echo "尝试安装到设备..."
    
    # 检查是否连接了鸿蒙设备
    if command -v hdc &> /dev/null; then
      echo "检测到HDC工具，尝试查找设备..."
      DEVICES=$(hdc list targets 2>/dev/null | grep -v "List of" | wc -l)
      
      if [ "$DEVICES" -gt 0 ]; then
        echo "找到 $DEVICES 个设备，开始安装..."
        hdc install "$HAP_FILE"
        echo "✅ 安装完成！"
        echo ""
        echo "启动应用命令:"
        echo "hdc shell aa start -a EntryAbility -b com.ninemonths.magnetmanager"
      else
        echo "⚠️ 未找到连接的鸿蒙设备"
        echo "请通过USB连接鸿蒙手机或启动模拟器"
      fi
    else
      echo "⚠️ HDC工具未安装"
      echo "请安装HarmonyOS SDK并配置环境变量"
    fi
  fi
}

# 主流程
main() {
  echo "========================================"
  echo "    Magnet Manager HAP 构建工具"
  echo "========================================"
  echo ""
  
  check_tools
  echo ""
  
  clean_build
  echo ""
  
  install_deps
  echo ""
  
  build_hap
  echo ""
  
  install_to_device
  
  echo ""
  echo "🎉 构建流程完成！"
  echo ""
  echo "下一步操作:"
  echo "1. 将HAP文件传输到鸿蒙设备"
  echo "2. 在设备上使用'文件管理'应用安装"
  echo "3. 或使用HDC命令安装: hdc install $HAP_FILE"
  echo ""
  echo "调试版本可以直接安装到已连接的设备"
}

# 执行主函数
main