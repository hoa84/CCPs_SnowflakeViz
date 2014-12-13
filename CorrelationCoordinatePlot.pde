/*
** Correlation Coordinates Plots
 ** Copyright (C) 2014 - Hoa Nguyen - Paul Rosen
 */

// CorrelationCoordinatePlot class draw Correlation Coordinate Plot of two attributes
class CorrelationCoordinatePlot {

  // set minimum and maximum of axis width
  public float axis_width_min = 0.005;
  public float axis_width_max = 0.05;

  // set border spacing
  public float border_spacing_x = 0.60;
  public float border_spacing_y = 0.05;

  // set pearson correlation coefficient threshold
  public float correlation_threshold = 0.2;

  // if we have many points, we might want to skip some
  public int step = 1;

  // set axis color as grey
  public int axis_color = #898484;

  // set size of point
  public float point_size = 0.03f;


  // two input data attributes as attr0 and attr1
  public CorrelationCoordinatePlot( DataAttribute attr0, DataAttribute attr1 ) {

    this.attr0 = attr0;
    this.attr1 = attr1;

    // compute Pearson correlation coefficient of two attributes
    this.corr_coeff = data.calculatePearsonCorrelation( attr0, attr1 );
  }


  // main draw function
  public void draw( ) {

    drawAxis( );

    // for aesthetics only -- draw outline of points
    noFill( );
    strokeWeight(point_size*1.5f);
    stroke( 125 );  
    drawPoints( );

    // draw points colored with Pearson correlation coefficient
    setColor( );      
    drawPoints( );
  }


  // draw axis
  private void drawAxis( ) {
    // set axis color
    noStroke();
    fill(axis_color);

    beginShape(QUADS);

    // Positive Correlation -- upper triangle
    if ( corr_coeff > correlation_threshold ) {
      vertex(  axis_width_max, -1 );
      vertex( -axis_width_max, -1 );
      vertex( -axis_width_min, 1 );
      vertex(  axis_width_min, 1 );
    }

    // Negative Correlation -- lower triangle
    if ( corr_coeff < -correlation_threshold ) {
      vertex(  axis_width_min, -1 );
      vertex( -axis_width_min, -1 );
      vertex( -axis_width_max, 1 );
      vertex(  axis_width_max, 1 );
    }

    // No Correlation -- straight line
    if ( abs(corr_coeff) <= correlation_threshold ) {
      vertex(  axis_width_min, -1 );
      vertex( -axis_width_min, -1 );
      vertex( -axis_width_min, 1 );
      vertex(  axis_width_min, 1 );
    }

    endShape();
  }

  // set point color based on value of correlation coefficient
  private void setColor( ) {

    strokeWeight(point_size);
    stroke(0, 0, 0);
    if ( corr_coeff < -correlation_threshold )
      stroke(0, 0, -corr_coeff*255);
    if ( corr_coeff >  correlation_threshold )
      stroke(corr_coeff*255, 0, 0);
  }

  // draw points base on correlation coordinate system
  private void drawPoints( ) {

    for (int i = 0; i < data.elementCount (); i+=step) {
      float a0 = attr0.getNormalized( i ) * 2.0f - 1.0f;
      float a1 = attr1.getNormalized( i ) * 2.0f - 1.0f;

      float x = (corr_coeff < -correlation_threshold) ? ((a1+a0)/2.0f) : ((a1-a0)/2.0f);
      float y = a0;

      point(x * (1.0f-border_spacing_x), y * (1.0f-border_spacing_y) );
    }
  }


  // two attribute attr0 and attr1 will be ploted
  private DataAttribute attr0, attr1;

  // Pearson correlation coeffient
  private float corr_coeff;
}

