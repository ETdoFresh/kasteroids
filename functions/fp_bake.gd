class_name FPBake

var func_ref
var arg1

func init(init_func_ref, init_arg1):
    func_ref = init_func_ref
    arg1 = init_arg1
    return self

func bake(arg2):
    return func_ref.call_func(arg1, arg2)

func get_funcref():
    return funcref(self, "bake")
