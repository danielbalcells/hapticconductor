void updateVisuals() {
  // Update motors positions and size so they are around the body
  updateMotors(chest.x, chest.y, shoulderScale);
  for (VibrationMotor v : motors) {
    v.update();
    if (v.isVisible()) {
      v.display();
    }
  }
  if (TRACKING_SOMETHING) {
    for (PVector p : blipPositions) {
      ellipse(p.x, p.y, 10, 10);
    }


    for (int i = 0; i < blipPositions.size (); i++) {
      int size = (int)map((float)blipMags.get(i), 0.0, 10.0, 10.0, 30.0);
      if (size > MAX_BLIP_VIS_SIZE) {
        size = MAX_BLIP_VIS_SIZE;
      }
      ellipse(blipPositions.get(i).x, blipPositions.get(i).y, size, size);
    }



    for (int i = 0; i < BUFFER_SIZE-1; i++) {

      float instantAcc2 = (float)getMag(accBuffer.get(i));
      float instantVel = (float)getMag(velBuffer.get(i));
      int size = 5;
      size = (int)map(instantAcc2, 0.0, 10.0, 5.0, 20.0);
      fill(255);
      strokeWeight(1);
      if (isBlip()) {
        size = 75;
        fill(color(250, 0, 0));
      }
      if (instantAcc2 <1) {
        strokeWeight(5);
      }

      //         } else {
      //      fill(255);
      //   }
      if (size > MAX_BLIP_VIS_SIZE) {
        size = MAX_BLIP_VIS_SIZE;
      }
      fill(255);
      size =25;
      ellipse(xyBuffer.get(i).x, xyBuffer.get(i).y, size, size);
    }
  }
}

