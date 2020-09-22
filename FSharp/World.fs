namespace FSharp

open Godot

type World() =
    inherit Node2D()

    //private State current_state;

    override this._Ready () =
        GD.Print "Hello from F#!"
        //current_state = InitialState(GetChildren());

    override this._Process delta =
        GD.Print delta
        //current_state = UpdateState(current_state, delta, this);