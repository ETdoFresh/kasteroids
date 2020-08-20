extends Node

const ENABLED = false

var files = {}

func _exit_tree():
    for file in files.values():
        file.close()

func write_line(path : String, items : Array):
    if not ENABLED:
        return
    
    var file = open_path(path)
    var line = ""
    for i in items.size():
        var item = items[i]
        if i == 0:
            line += "%s" % item
        else:
            line += ",%s" % item
    line += "\n"
    line = line.replace("(","").replace(")","")
    file.store_string(line)

func open_path(path : String) -> File:
    if files.has(path):
        return files[path]
    else:
        var file = File.new()
        file.open(path, File.WRITE)
        files[path] = file
        return file
