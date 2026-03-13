/**
 * 通用按钮组件
 */
@Component
export struct AppButton {
  @Prop text: string = ''
  @Prop type: 'primary' | 'secondary' | 'outline' | 'text' = 'primary'
  @Prop size: 'small' | 'medium' | 'large' = 'medium'
  @Prop disabled: boolean = false
  @Prop loading: boolean = false
  @Prop fullWidth: boolean = false
  onClick?: () => void

  build() {
    Button() {
      if (this.loading) {
        LoadingProgress()
          .width(16)
          .height(16)
          .color(this.getButtonColor())
      } else {
        Text(this.text)
          .fontSize(this.getFontSize())
          .fontColor(this.getButtonColor())
          .fontWeight(this.getButtonColor() === '#FFFFFF' ? FontWeight.Medium : FontWeight.Regular)
      }
    }
    .type(this.getButtonType())
    .backgroundColor(this.getBackgroundColor())
    .borderColor(this.getButtonColor())
    .borderWidth(this.type === 'outline' ? 1 : 0)
    .borderRadius(this.getBorderRadius())
    .width(this.fullWidth ? '100%' : this.getWidth())
    .height(this.getHeight())
    .enabled(!this.disabled && !this.loading)
    .opacity(this.disabled ? 0.5 : 1)
    .onClick(() => {
      if (!this.disabled && !this.loading) {
        this.onClick?.()
      }
    })
  }

  private getButtonType(): ButtonType {
    if (this.type === 'outline') {
      return ButtonType.Normal
    }
    return ButtonType.Capsule
  }

  private getButtonColor(): string {
    if (this.disabled || this.loading) {
      return '#CCCCCC'
    }

    switch (this.type) {
      case 'primary':
        return '#FFFFFF'
      case 'secondary':
        return '#FFFFFF'
      case 'outline':
        return ThemeConfig.Colors.primary
      case 'text':
        return ThemeConfig.Colors.primary
      default:
        return '#FFFFFF'
    }
  }

  private getBackgroundColor(): ResourceColor {
    if (this.disabled || this.loading) {
      return '#F5F5F5'
    }

    switch (this.type) {
      case 'primary':
        return ThemeConfig.Colors.primary
      case 'secondary':
        return ThemeConfig.Colors.secondary
      case 'outline':
        return Color.Transparent
      case 'text':
        return Color.Transparent
      default:
        return ThemeConfig.Colors.primary
    }
  }

  private getFontSize(): number {
    switch (this.size) {
      case 'small':
        return 12
      case 'medium':
        return 14
      case 'large':
        return 16
      default:
        return 14
    }
  }

  private getWidth(): string {
    switch (this.size) {
      case 'small':
        return '80vp'
      case 'medium':
        return '120vp'
      case 'large':
        return '160vp'
      default:
        return '120vp'
    }
  }

  private getHeight(): string {
    switch (this.size) {
      case 'small':
        return '32vp'
      case 'medium':
        return '40vp'
      case 'large':
        return '48vp'
      default:
        return '40vp'
    }
  }

  private getBorderRadius(): number {
    switch (this.size) {
      case 'small':
        return 16
      case 'medium':
        return 20
      case 'large':
        return 24
      default:
        return 20
    }
  }
}
