import asyncio
import base64
from websockets.asyncio.server import serve
import cv2
import numpy as np
import json
from detection import ShotDetector
import datetime as dt


async def response(websocket):
    # Receive the message from the client
    async for message in websocket:
        # Decode message information
        message = json.loads(message)
        image_base64 = message["image"]
        image_bytes = base64.b64decode(image_base64) 
        image_np = np.frombuffer(image_bytes, np.uint8)
        image = cv2.imdecode(image_np, cv2.IMREAD_COLOR)
        # Process the frame
        result = detector.process_frame(
            image,
            message["ball_pos"],
            message["hoop_pos"],
            message["frame_count"],
            message["up"],
            message["down"],
            message["up_frame"],
            message["down_frame"],
            message["makes"],
            message["attempts"],
            message["AO"],
            message["s1"],
            message["s2"],
            message["player"],
            [dt.datetime.fromisoformat(message["r_time"][0]), dt.datetime.fromisoformat(message["r_time"][1])]
        )
        # Send the result back to the client
        await websocket.send(json.dumps(result))

async def main():
    global detector
    # Load the shot detector model
    detector = ShotDetector("best.pt")
    # Start the websocket server
    async with serve(response, "", 3324) as server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())