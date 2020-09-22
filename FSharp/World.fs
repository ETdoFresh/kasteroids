namespace FSharp

open Godot
open State
open Game

type World() =
    inherit Node2D()

    let mutable currentState = Game.state
    //private State current_state;

    override this._Ready () =
        GD.Print "Hello from F#!"
        currentState <- _ready this currentState
        printState currentState

    override this._Process delta =
        GD.Print delta
        currentState <- _process currentState