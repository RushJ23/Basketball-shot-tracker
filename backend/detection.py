from ultralytics import YOLO
import math
import numpy as np
from utils import score, detect_down, detect_up, clean_hoop_pos, clean_ball_pos, in_hoop_region, getStats, in_player_region, detect_upwards_movement, detect_downwards_movement
import datetime as dt

class ShotDetector:
    def __init__(self, model_path):
        # Load the YOLO model
        self.model = YOLO(model_path)
        self.class_names = ['Basketball', 'Person', 'Basketball Hoop']

    def process_frame(self, frame, ball_pos, hoop_pos, frame_count, up, down, up_frame, down_frame, makes, attempts, AO, s1, s2, player, r_time):
        results = self.model(frame, stream=True)
        updated_ball_pos = ball_pos.copy()
        updated_hoop_pos = hoop_pos.copy()

        for r in results:
            boxes = r.boxes
            for box in boxes:
                # Bounding box
                x1, y1, x2, y2 = box.xyxy[0]
                x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2)
                w, h = x2 - x1, y2 - y1

                # Confidence
                conf = math.ceil((box.conf[0] * 100)) / 100

                # Class Name
                cls = int(box.cls[0])
                current_class = self.class_names[cls]

                center = (int(x1 + w / 2), int(y1 + h / 2))

                # Only create ball points if high confidence or near hoop
                if (conf > .3 or (in_hoop_region(center, hoop_pos) and conf > 0.15)) and current_class == "Basketball":
                    updated_ball_pos.append((center, frame_count, w, h, conf))

                # Create hoop points if high confidence
                if conf > .5 and current_class == "Basketball Hoop":
                    updated_hoop_pos.append((center, frame_count, w, h, conf))

                # Detect player and record time of release and start of shot
                try:
                    if conf > .5 and current_class == "Person" and in_player_region(ball_pos[-1][0], (center, w, h)) and frame_count-ball_pos[-1][1]<10:
                        if detect_upwards_movement(updated_ball_pos) and dt.datetime.now() - r_time[1] > dt.timedelta(seconds=1):
                            r_time[0] = dt.datetime.now()
                        player = frame_count
                        if detect_upwards_movement(updated_ball_pos):
                            r_time[1] = dt.datetime.now()
                        if detect_downwards_movement(updated_ball_pos):
                            r_time[0] = dt.datetime(2000,1,1)
                            r_time[1] = dt.datetime(2000,1,1)
                except:
                    pass

        # Clean motion data
        updated_ball_pos = clean_ball_pos(updated_ball_pos, frame_count, player)
        if len(updated_hoop_pos) > 1:
            updated_hoop_pos = clean_hoop_pos(updated_hoop_pos)

        # Shot detection logic
        shot_taken = False
        if len(updated_hoop_pos) > 0 and len(updated_ball_pos) > 0:
            if not up:
                up = detect_up(updated_ball_pos, updated_hoop_pos)
                if up:
                    up_frame = updated_ball_pos[-1][1]

            if up and not down:
                down = detect_down(updated_ball_pos, updated_hoop_pos)
                if down:
                    down_frame = updated_ball_pos[-1][1]

            # If ball goes from 'up' area to 'down' area in that order, detect shot
            if up and down and up_frame < down_frame:
                attempts += 1
                up = False
                down = False
                made = False
                height, width = frame.shape[:2]
    
                # Determine the scaling factor
                max_dimension = max(width, height)
                
                # Resize only if the largest axis exceeds 640 pixels
                if max_dimension > 640:
                    scale_factor = 640 / max_dimension
                    width = int(width * scale_factor)
                    height = int(height * scale_factor)
                
                coords, angle, height = getStats((width, height), AO, updated_hoop_pos, updated_ball_pos, s1, s2, player)

                #If player is not detected recently or nonsensical value, default to value of 1.9
                if player+200 < frame_count or 12>height or height>132:
                    height = 76

                if score(updated_ball_pos, updated_hoop_pos):
                    makes += 1
                    made = True

                release = (r_time[1]-r_time[0]).total_seconds()
                if release>5 or release<0.1:
                    release = 1.0
            
                #Feedback for user
                if abs(45-angle)>10:
                    feedback = "Try to aim for a 45 degree angle"
                elif AO[0]-coords[0]>5:
                    feedback = "Use less power in your shot"
                elif AO[0]-coords[0]<-5:
                    feedback = "Use more power in your shot"
                elif coords[2]-AO[2]>5:
                    feedback = "Your shots are too far right"
                elif coords[2]-AO[2]<-5:
                    feedback = "Your shots are too far left"
                

                #Returns shot in format [made, angle, depth, position, height, release]
                shot_taken = [made, round(angle,1), round(AO[0]-coords[0],1), round(coords[2]-AO[2],1), round(height,1), round(release,1), feedback]
                
        # Return the updated state
        return {
            "ball_pos": updated_ball_pos,
            "hoop_pos": updated_hoop_pos,
            "frame_count": frame_count + 1,
            "up": up,
            "down": down,
            "player": player,
            "up_frame": up_frame,
            "down_frame": down_frame,
            "makes": makes,
            "attempts": attempts,
            "shot_taken": shot_taken,
            "r_time": [r_time[0].isoformat(), r_time[1].isoformat()]
        }
    