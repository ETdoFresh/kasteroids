namespace FSharp

module Game =
    open Domain
    open State

    let mutable state = { 
        tick = 0
        objects = [
            Ship {
                position = { x = 0.0; y = 0.0 }
                rotation = 0.0
                scale = { x = 1.0; y = 1.0 }
                linearVelocity = { x = 10.0; y = 0.0 }
                angularVelocity = 0.0
                input = {
                    horizontal = 0.0
                    vertical = 0.0
                    fire = false }}]}

    // let _ready =
    //     state <- { state with objects = state.objects
    //         |> List.map nodeToObject }

    let _process =
        printState state
        state <- step state (1.0 / 60.0)
        printState state