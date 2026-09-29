extends Resource
class_name TooltipStyle

@export_group("Background")
## Если задана текстура — используется как NinePatch-подложка.
## Иначе используется StyleBox.
@export var background_texture: Texture2D
@export var texture_margins_left: int = 16
@export var texture_margins_top: int = 16
@export var texture_margins_right: int = 16
@export var texture_margins_bottom: int = 16
@export var style_box: StyleBox

@export_group("Padding")
@export var padding_left: int = 12
@export var padding_top: int = 8
@export var padding_right: int = 12
@export var padding_bottom: int = 8

@export_group("Font")
@export var font: Font
@export var font_size: int = 16
@export var font_color: Color = Color(1, 1, 1, 1)

@export_group("Divider")
@export var show_dividers: bool = true
@export var divider_texture: Texture2D
@export var divider_color: Color = Color(1, 1, 1, 0.3)
@export var divider_height: int = 1
@export var divider_margin: int = 4
