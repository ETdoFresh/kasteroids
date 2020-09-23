namespace FSharp

open Godot

type InputRecord = { 
    horizontal: float
    vertical: float
    fire: bool }

type InputNode() =
    inherit Node()

    [<Export>]
    let mutable horizontal = 0.0
    [<Export>]
    let mutable vertical = 0.0
    [<Export>]
    let mutable fire = false

    member this.toRecord = { 
        horizontal = horizontal
        vertical = vertical
        fire = fire }

    override this._Process delta =
        let right = float (Input.GetActionStrength "PlayerRight")
        let left = float (Input.GetActionStrength "PlayerLeft")
        let up = float (Input.GetActionStrength "PlayerUp")
        let down = float (Input.GetActionStrength "PlayerDown")
        horizontal <- right - left
        vertical <- down - up
        fire <- Input.IsActionPressed "PlayerFire"