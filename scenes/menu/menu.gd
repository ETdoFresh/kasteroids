extends Control

onready var root = get_tree().get_root()

func _ready():
    $Version.text = Settings.VERSION
    
    #warning-ignore-all:return_value_discarded
    $VBoxContainer/Button1.connect("button_down", self, "go_to_local")
    if OS.get_name() != "HTML5":
        $VBoxContainer/Button2.connect("button_down", self, "go_to_server")
        $VBoxContainer/Button3.connect("button_down", self, "go_to_client")
        $VBoxContainer/Button4.connect("button_down", self, "go_to_network_test")
        $VBoxContainer/Button5.connect("button_down", self, "go_to_web_socket_server")
    else:
        $VBoxContainer/Button2.visible = false
        $VBoxContainer/Button3.visible = false
        $VBoxContainer/Button4.visible = false
        $VBoxContainer/Button5.visible = false
    
    $VBoxContainer/Button6.connect("button_down", self, "go_to_web_socket_client")
    
    if OS.get_name() != "HTML5":
        $VBoxContainer/Button7.connect("button_down", self, "go_to_web_socket_both")
    else:
        $VBoxContainer/Button7.visible = false
    
    $Username/Value.text = Data.get_username()
    $Username/Value.connect("text_changed", Data, "set_username")
    
    Settings.client_url = $ClientURL/Value.text
    $ClientURL/Value.connect("text_changed", self, "update_client_url")

func update_client_url(url):
    Settings.client_url = url

func go_to_local(): get_tree().change_scene_to(Scene.LOCAL_GAME)
func go_to_server(): get_tree().change_scene_to(Scene.TCP_SERVER_GAME)
func go_to_client(): get_tree().change_scene_to(Scene.TCP_CLIENT_GAME)
func go_to_network_test(): get_tree().change_scene_to(Scene.TCP_BOTH_GAME)
func go_to_web_socket_server(): get_tree().change_scene_to(Scene.WEB_SOCKET_SERVER_GAME)
func go_to_web_socket_client(): get_tree().change_scene_to(Scene.WEB_SOCKET_CLIENT_GAME)
func go_to_web_socket_both(): get_tree().change_scene_to(Scene.WEB_SOCKET_BOTH_GAME)
