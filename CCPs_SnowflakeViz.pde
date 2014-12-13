/*
** Correlation Coordinates Plots
 ** Copyright (C) 2014 - Hoa Nguyen - Paul Rosen
 */

// process input data
Datafile data;

// draw snowflake visualization
SnowflakePlot sfp;


void setup() { 
  // size of window
  size(1280, 720);
  smooth();  

  // set font
  textFont( createFont( "SansSerif", 20, true ) );

  // process input data
  data = new Datafile("housing.data.txt");

  // set snowflake visualization method
  sfp = new SnowflakePlot( data, 12 );
}

void draw() {
  background(255);
  sfp.draw();
}

// when mouse is pressed, snowflake visualization will process
void mousePressed() {
  sfp.mousePressed();
}

// when mouse is pressed, focus view may update
void mouseMoved() {
  sfp.mouseMoved();
}

