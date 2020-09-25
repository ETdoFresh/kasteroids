namespace FSharp

open Domain
open Godot

type InputNode() =
    inherit Node()

    [<Export>]
    let mutable horizontal = 0.0f
    [<Export>]
    let mutable vertical = 0.0f
    [<Export>]
    let mutable fire = false

    member this.toRecord = { 
        horizontal = float horizontal
        vertical = float vertical
        fire = fire }

    override this._Process delta =
        let right = Input.GetActionStrength "PlayerRight"
        let left = Input.GetActionStrength "PlayerLeft"
        let up = Input.GetActionStrength "PlayerUp"
        let down = Input.GetActionStrength "PlayerDown"
        horizontal <- right - left
        vertical <- down - up
        fire <- Input.IsActionPressed "PlayerFire"