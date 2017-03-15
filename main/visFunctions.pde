void updateVisuals() {
  // Update motors positions and size so they are around the body
  updateMotors(chest.x, chest.y, shoulderScale);
  for (VibrationMotor v : motors) {
    v.update();
    v.display();
  }

  for (PVector p : blipPositions) {
    ellipse(p.x, p.y, 10, 10);
  }

  for (int i = 0; i < blipPositions.size (); i++) {
    int size = (int)map((float)blipMags.get(i), 0.0, 10.0, 10.0, 30.0);
    ellipse(blipPositions.get(i).x, blipPositions.get(i).y, size, size);
  }


  for (int i = 0; i < BUFFER_SIZE-1; i++) {

    float instantAcc2 = (float)getMag(accBuffer.get(i));
    float instantVel = (float)getMag(velBuffer.get(i));
    int size = 5;
    size = (int)map(instantAcc2, 0.0, 10.0, 5.0, 20.0);
    fill(255);
    strokeWeight(1);
    if (instantVel < 1.5) {
      size = 25;
      fill(color(250, 0, 0));
    }
    if (instantAcc2 <1) {
      strokeWeight(5);
    }

    //         } else {
    //      fill(255);
    //   }
    ellipse(xyBuffer.get(i).x, xyBuffer.get(i).y, size, size);
  }

  ellipse(lHand.x, lHand.y, 10, 10);
}

