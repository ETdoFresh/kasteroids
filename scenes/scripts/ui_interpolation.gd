extends CheckButton

func _ready():
    #warning-ignore:return_value_discarded
    connect("toggled", self, "toggle_interpolation")

func toggle_interpolation(value):
    Settings.interpolation_enable = value

func _process(_delta):
    pressed = Settings.interpolation_enable
