/**
 * 主题配置类
 * 统一管理应用的主题样式
 */
export class ThemeConfig {
  // 颜色配置
  static readonly Colors = {
    primary: '#FF6B6B',
    primaryDark: '#FF5252',
    primaryLight: '#FF8A80',
    secondary: '#4DB6AC',
    background: '#FFFFFF',
    surface: '#F5F5F5',
    error: '#F44336',
    success: '#4CAF50',
    warning: '#FF9800',
    info: '#2196F3',

    // 文字颜色
    fontPrimary: 'rgba(0, 0, 0, 0.87)',
    fontSecondary: 'rgba(0, 0, 0, 0.60)',
    fontHint: 'rgba(0, 0, 0, 0.38)',
    fontDisabled: 'rgba(0, 0, 0, 0.26)',

    // 分割线
    divider: 'rgba(0, 0, 0, 0.12)',

    // 阴影
    shadow: 'rgba(0, 0, 0, 0.24)',
  }

  // 字体配置
  static readonly Typography = {
    displayLarge: { fontSize: 57, fontWeight: FontWeight.Regular },
    displayMedium: { fontSize: 45, fontWeight: FontWeight.Regular },
    displaySmall: { fontSize: 36, fontWeight: FontWeight.Regular },
    headlineLarge: { fontSize: 32, fontWeight: FontWeight.Regular },
    headlineMedium: { fontSize: 28, fontWeight: FontWeight.Regular },
    headlineSmall: { fontSize: 24, fontWeight: FontWeight.Regular },
    titleLarge: { fontSize: 22, fontWeight: FontWeight.Medium },
    titleMedium: { fontSize: 16, fontWeight: FontWeight.Medium },
    titleSmall: { fontSize: 14, fontWeight: FontWeight.Medium },
    bodyLarge: { fontSize: 16, fontWeight: FontWeight.Regular },
    bodyMedium: { fontSize: 14, fontWeight: FontWeight.Regular },
    bodySmall: { fontSize: 12, fontWeight: FontWeight.Regular },
    labelLarge: { fontSize: 14, fontWeight: FontWeight.Medium },
    labelMedium: { fontSize: 12, fontWeight: FontWeight.Medium },
    labelSmall: { fontSize: 11, fontWeight: FontWeight.Medium },
  }

  // 间距配置
  static readonly Spacing = {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  }

  // 圆角配置
  static readonly BorderRadius = {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999,
  }
}
