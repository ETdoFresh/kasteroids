# Input Serialization

How is client input serialized and sent to the server? Here is the layout:

- Inputs : Array
  - Input : Dictionary
    - Tick : int
    - Username : String
    - Horizontal : float
    - Vertical : float
    - Fire : Bool