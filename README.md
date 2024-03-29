# RNS-simulation
This is the final course project for Neural Implants and Interfaces (EN 580.742) at Johns Hopkins University

### Prerequisites:
To run the simulation, download the MATLAB mobile app on a mobile device and connect it to the MATLAB Desktop version via MATLAB cloud. See below for specific sensor setting instructions for your mobile device.

#### Sensor settings: 
-	sensors >> stream to = MATLAB, sample rate = 10 Hz (left pic)
-	sensors >> more >> turn on Sensor Access (right pic)

![Fig A](https://user-images.githubusercontent.com/43463024/190882791-f4373447-e9f1-4e96-b7e0-5ebf60c5f97f.png)
![Fig B](https://user-images.githubusercontent.com/43463024/190882794-3aefa5da-50d2-4d18-88c8-63abb6f4f63e.png)

Check [here](https://www.mathworks.com/help/matlabmobile/ug/stream-sensor-data-with-sensor-controls.html) for a more detailed description from Mathworks.

### Running the Code
The first section of the code must be run first separately in order to connect your mobile device to the computer. Once connected, we can then proceed to the main section. Run the second section first, then press the start button on MATLAB mobile to start recording the accelerometer data in real time. To stop recording, simply press the stop button on MATLAB mobile.

### Output
Once the second section is started, a blank graph will first pop up, showing the real time values of the acceleration data and the stimulation output. As the recording starts, there will be an animated orange line and blue line that updates every millisecond on the graph. The orange line is the real-time recorded acceleration data on the x axis from the mobile device, while the blue line shows the onset of the signal response of our stimulation generated by our state machine.
	As you shake your mobile device, try shaking it aggressively (to stimulate an epileptic episode) to see the corresponding stimulation current generated compared to when there is no movement. In addition, try shaking it aggressively for a long time to see the amplitude of the stimulation current increase.

Check out the full project video [here](https://www.youtube.com/watch?v=0nrBe8qhNzo&ab_channel=AlexandraCheng).


Contributors: Vina Ro, Alexandra Cheng, Kevin Fang, Preston Zimprich 
