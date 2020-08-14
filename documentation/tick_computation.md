# Tick Computation

If you read my World Serialization post, you know, on the client side, we are dealing with various ticks:

- **Received Server Tick**: The latest tick received by the server *[aka. Past Tick]*
- **Received Client Tick**: The latest tick received by the server that was originally sent by the client
- **Predicted Tick**: What tick do we think the server is on right now? *[aka. Current Tick]*
- **Interpolated Tick**: How far back (minimizing time distance) should we go back so that we can always smoothly interpolated between the two latest packets
- **Extrapolated Tick**: How far in the future (minimizing time distance) must the client be in order for the server to successfully get receive input from the client at a given tick. *[aka. Future Tick]*
- **Smooth Tick**: A ticker that doesn't jump around everywhere as calculations are made. Smoothly always move towards Extrapolated Tick, trying to match at all possible.