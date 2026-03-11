// Magnet Manager - 主入口页面
// 兼容手机和平板的自适应布局

import { HomePage, FavoritesPage, HistoryPage, SettingsPage } from './IndexPages';

@Entry
@Component
struct Index {
  @State currentTab: number = 0;
  
  // 标签页配置
  private tabs: Array<{
    index: number;
    title: Resource;
    icon: Resource;
    page: any;
  }> = [
    {
      index: 0,
      title: $r('app.string.main_tab_home'),
      icon: $r('app.media.ic_home'),
      page: HomePage
    },
    {
      index: 1,
      title: $r('app.string.main_tab_favorites'),
      icon: $r('app.media.ic_favorite'),
      page: FavoritesPage
    },
    {
      index: 2,
      title: $r('app.string.main_tab_history'),
      icon: $r('app.media.ic_history'),
      page: HistoryPage
    },
    {
      index: 3,
      title: $r('app.string.main_tab_settings'),
      icon: $r('app.media.ic_settings'),
      page: SettingsPage
    }
  ];

  build() {
    // 根据设备类型选择布局
    if (this.isTablet()) {
      // 平板布局：侧边栏 + 主内容区
      this.buildTabletLayout();
    } else {
      // 手机布局：底部导航栏
      this.buildPhoneLayout();
    }
  }

  // 检查是否为平板设备
  private isTablet(): boolean {
    // 实际开发中应该使用设备能力查询
    // 这里简化为检查屏幕宽度
    const screenWidth = vp2px(100);
    return screenWidth > 600; // 假设宽度大于600px为平板
  }

  // 手机布局
  @Builder
  buildPhoneLayout() {
    Column() {
      // 内容区域
      TabContent({ index: this.currentTab }) {
        ForEach(this.tabs, (tab) => {
          TabContentItem({}) {
            tab.page();
          }
        })
      }
      .width('100%')
      .height('100%')

      // 底部导航栏
      TabBar({ barPosition: BarPosition.End }) {
        ForEach(this.tabs, (tab) => {
          TabBarItem({
            icon: tab.icon,
            text: tab.title
          })
          .onClick(() => {
            this.currentTab = tab.index;
          })
        })
      }
      .backgroundColor($r('app.color.tab_bar_bg'))
      .height(56)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }

  // 平板布局
  @Builder
  buildTabletLayout() {
    Row() {
      // 侧边栏
      Column() {
        ForEach(this.tabs, (tab) => {
          Button(tab.title, { type: ButtonType.Normal })
            .width('80%')
            .margin({ top: 8, bottom: 8 })
            .backgroundColor(
              this.currentTab === tab.index 
                ? $r('app.color.primary') 
                : $r('app.color.sidebar_button')
            )
            .onClick(() => {
              this.currentTab = tab.index;
            })
        })
      }
      .width(200)
      .height('100%')
      .backgroundColor($r('app.color.sidebar_bg'))
      .padding({ top: 20 })

      // 主内容区
      Column() {
        TabContent({ index: this.currentTab }) {
          ForEach(this.tabs, (tab) => {
            TabContentItem({}) {
              tab.page();
            }
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}