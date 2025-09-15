import math
import numpy as np


def score(ball_pos, hoop_pos):
    x = []
    y = []
    rim_height = hoop_pos[-1][0][1] - 0.5 * hoop_pos[-1][3]

    # Get first point above rim and first point below rim
    for i in reversed(range(len(ball_pos))):
        if ball_pos[i][0][1] < rim_height:
            x.append(ball_pos[i][0][0])
            y.append(ball_pos[i][0][1])
            x.append(ball_pos[i+1][0][0])
            y.append(ball_pos[i+1][0][1])
            break

    # Create line from two points
    if len(x) > 1:
        m, b = np.polyfit(x, y, 1)
        # Checks if projected line fits between the ends of the rim {x = (y-b)/m}
        predicted_x = ((rim_height) - b)/m
        rim_x1 = hoop_pos[-1][0][0] - 0.4 * hoop_pos[-1][2]
        rim_x2 = hoop_pos[-1][0][0] + 0.4 * hoop_pos[-1][2]
        if rim_x1 < predicted_x < rim_x2:
            return True


# Detects if the ball is below the net - used to detect shot attempts
def detect_down(ball_pos, hoop_pos):
    y = hoop_pos[-1][0][1] + 0.5 * hoop_pos[-1][3]
    if ball_pos[-1][0][1] > y:
        return True
    return False


# Detects if the ball is around the backboard - used to detect shot attempts
def detect_up(ball_pos, hoop_pos):
    x1 = hoop_pos[-1][0][0] - 4 * hoop_pos[-1][2]
    x2 = hoop_pos[-1][0][0] + 4 * hoop_pos[-1][2]
    y1 = hoop_pos[-1][0][1] - 2 * hoop_pos[-1][3]
    y2 = hoop_pos[-1][0][1]

    if x1 < ball_pos[-1][0][0] < x2 and y1 < ball_pos[-1][0][1] < y2 - 0.5 * hoop_pos[-1][3]:
        return True
    return False


# Checks if center point is near the hoop
def in_hoop_region(center, hoop_pos):
    if len(hoop_pos) < 1:
        return False
    x = center[0]
    y = center[1]

    x1 = hoop_pos[-1][0][0] - 1 * hoop_pos[-1][2]
    x2 = hoop_pos[-1][0][0] + 1 * hoop_pos[-1][2]
    y1 = hoop_pos[-1][0][1] - 1 * hoop_pos[-1][3]
    y2 = hoop_pos[-1][0][1] + 0.5 * hoop_pos[-1][3]

    if x1 < x < x2 and y1 < y < y2:
        return True
    return False

#Checks if ball is near player
def in_player_region(center, player_pos):
    x = center[0]
    y = center[1]

    x1 = player_pos[0][0] - 0.7 * player_pos[1]
    x2 = player_pos[0][0] + 0.7 * player_pos[1]
    y1 = player_pos[0][1] -  0.6* player_pos[2]
    y2 = player_pos[0][1] + 0.6 * player_pos[2]

    if x1 < x < x2 and y1 < y < y2:
        return True
    return False


# Removes inaccurate data points
def clean_ball_pos(ball_pos, frame_count, player):
    # Removes inaccurate ball size to prevent jumping to wrong ball
    if len(ball_pos) > 1:
        # Width and Height
        w1 = ball_pos[-2][2]
        h1 = ball_pos[-2][3]
        w2 = ball_pos[-1][2]
        h2 = ball_pos[-1][3]

        # X and Y coordinates
        x1 = ball_pos[-2][0][0]
        y1 = ball_pos[-2][0][1]
        x2 = ball_pos[-1][0][0]
        y2 = ball_pos[-1][0][1]

        # Frame count
        f1 = ball_pos[-2][1]
        f2 = ball_pos[-1][1]
        f_dif = f2 - f1

        dist = math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

        max_dist = 4 * math.sqrt((w1) ** 2 + (h1) ** 2)

        # Ball should not move a 4x its diameter within 5 frames
        if (dist > max_dist) and (f_dif < 5):
            ball_pos.pop()

        # Ball should be relatively square
        elif (w2*1.4 < h2) or (h2*1.4 < w2):
            ball_pos.pop()

    # Remove points older than 30 frames
    if len(ball_pos) > 0:
        while True:
            if frame_count - ball_pos[0][1] > 30:
                if abs(ball_pos[0][1]-player) <10:
                    break
                ball_pos.pop(0)
            else:
                break

    return ball_pos


def clean_hoop_pos(hoop_pos):
    # Prevents jumping from one hoop to another
    if len(hoop_pos) > 1:
        x1 = hoop_pos[-2][0][0]
        y1 = hoop_pos[-2][0][1]
        x2 = hoop_pos[-1][0][0]
        y2 = hoop_pos[-1][0][1]

        w1 = hoop_pos[-2][2]
        h1 = hoop_pos[-2][3]
        w2 = hoop_pos[-1][2]
        h2 = hoop_pos[-1][3]

        f1 = hoop_pos[-2][1]
        f2 = hoop_pos[-1][1]

        f_dif = f2-f1

        dist = math.sqrt((x2-x1)**2 + (y2-y1)**2)

        max_dist = 0.5 * math.sqrt(w1 ** 2 + h1 ** 2)

        # Hoop should not move 0.5x its diameter within 5 frames
        if dist > max_dist and f_dif < 5:
            hoop_pos.pop()

        # Hoop should be relatively square
        if (w2*1.3 < h2) or (h2*1.3 < w2):
            hoop_pos.pop()

    # Remove old points
    if len(hoop_pos) > 25:
        hoop_pos.pop(0)

    return hoop_pos

def calculate_coordinates(pixel_coords, distance, image_center, known_coords, known_AO):
    # Pixel coordinates (xi, yi)
    xi, yi = pixel_coords
    
    # Image center (xc, yc)
    xc, yc = image_center

    known_AI = (known_coords[0] - xc, yc-known_coords[1])
    w = known_AI[1] / known_AO[1] * known_AO[2]
    
    # Calculate AI in terms of pixels
    AI = np.array([xi - xc, yc-yi, w])
    
    # Calculate magnitude of AI
    AI_magnitude = np.linalg.norm(AI)
    
    # Calculate the scale factor k
    k = distance / AI_magnitude
    
    # Calculate AO in terms of world coordinates
    AO = k * AI
    
    return AO

# Calculate the focal length of the camera
def calculate_focal_length(perceived_width, distance, known_width):
    focal_length = (perceived_width * distance) / known_width
    return focal_length

# Calculate the distance of the object from the camera
def calculate_distance(focal_length, known_width, perceived_width):
    return (known_width * focal_length) / perceived_width

def getStats(image_resolution, AO, hoop_pos, ball_pos, known_width1, known_width2, player):
    x = []
    y = []
    perceived_width2 = 0
    pixel_coords3 = (0, 0)
    perceived_width3 = 0
    rim_height = hoop_pos[-1][0][1] - 0.5 * hoop_pos[-1][3]

    # Get first point above rim and first point below rim
    for i in reversed(range(len(ball_pos))):
        if ball_pos[i][0][1] < rim_height and len(x) < 2:
            x.append(ball_pos[i][0][0])
            y.append(ball_pos[i][0][1])
            perceived_width2 = ball_pos[i][2]
            x.append(ball_pos[i+1][0][0])
            y.append(ball_pos[i+1][0][1])
        if ball_pos[i][1] == player:
            pixel_coords3 = ball_pos[i][0]
            perceived_width3 = ball_pos[i][2]
            break
        elif ball_pos[i][1] < player and pixel_coords3 == (0, 0):
            pixel_coords3 = ball_pos[i][0]
            perceived_width3 = ball_pos[i][2]
            break
    
    if pixel_coords3 == (0, 0):
        height = 1.9
    
    m, b = np.polyfit(x, y, 1)
    predicted_x = ((rim_height) - b)/m
    pixel_coords1 = (hoop_pos[-1][0][0], rim_height)
    pixel_coords2 = (predicted_x, rim_height)
    
    perceived_width1 = hoop_pos[-1][2]
    # Calculate the image center
    image_center = (image_resolution[0] // 2, image_resolution[1] // 2)
    
    # Calculate the focal length using the first object's parameters
    focal_length = calculate_focal_length(perceived_width1, np.linalg.norm(AO), known_width1)
    
    # Calculate the distance for the second object using the focal length
    distance2 = calculate_distance(focal_length, known_width2, perceived_width2)
    distance3 = calculate_distance(focal_length, known_width2, perceived_width3)
    
    # Calculate the world coordinates of the second object
    coordinates = calculate_coordinates(pixel_coords2, distance2, image_center, pixel_coords1, AO)
    height = calculate_coordinates(pixel_coords3, distance3, image_center, pixel_coords1, AO)[2]
    
    return coordinates, 90-abs(math.degrees(math.atan(m))), height

# Detects if the ball is moving significantly upwards
def detect_upwards_movement(ball_pos):
    if len(ball_pos) > 1:
        distance = ball_pos[-1][0][1] - ball_pos[-2][0][1]
        frame_dif = ball_pos[-1][1] - ball_pos[-2][1]
        if -distance > 0.4*ball_pos[-1][3] and frame_dif < 5 and frame_dif > 0:
            return True
    return False

# Detects if the ball is moving significantly downwards
def detect_downwards_movement(ball_pos):
    if len(ball_pos) > 1:
        distance = ball_pos[-1][0][1] - ball_pos[-2][0][1]
        frame_dif = ball_pos[-1][1] - ball_pos[-2][1]
        if distance > 0.7*ball_pos[-1][3] and frame_dif < 5 and frame_dif > 0:
            return True
    return False