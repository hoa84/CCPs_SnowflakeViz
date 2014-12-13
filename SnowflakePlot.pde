/*
** Correlation Coordinates Plots
 ** Copyright (C) 2014 - Hoa Nguyen - Paul Rosen
 */

// snowflake visualization for multi-attributes data
class SnowflakePlot {

  // set focus inner radius and outer radius
  public float focus_inner_radius = 0.25f;
  public float focus_outer_radius = 0.65f;

  // set CCP plot width in focus view
  public float focus_plot_width   = 0.1f;

  // set context inner radius and outer radius
  public float context_inner_radius = 0.05f;
  public float context_outer_radius = 0.125f;

  // set CCP plot width in context view
  public float context_plot_width   = 0.05f;
  public float range_buffer         = 0.05f;


  public SnowflakePlot( Datafile data, int attrN ) {
    // initialize parameters
    attr   = new DataAttribute[ attrN-1 ];
    leaves = new ContextLeaf[attrN-1];

    int m = int(attrN/2);    
    focus_attr = data.getAttribute(0);
    for (int i = 0; i < (attrN-1); i++) {
      int children = ( (i<m) && (attrN%2==1) ) ? m : (m-1);
      attr[i]   = data.getAttribute(i+1);
      leaves[i] = new ContextLeaf( lerp( -PI, PI, (float)(i)/(float)(attrN-1) ), children );
    }
  }

  // main draw function
  void draw() {

    // draw all labels
    drawLabels();

    // draw snowflake visualization for input data
    pushMatrix();
    translate( snfPos.x, snfPos.y );
    for (int i = 0; i < leaves.length; i++) {
      // draw focus view
      drawCCP( leaves[i], focus_attr, attr[i] );
      for ( int j = 0; j < leaves[i].children.length; j++ ) {
        // draw context views
        drawCCP( leaves[i].children[j], attr[i], attr[(i+j+1)%attr.length] );
      }
    }
    popMatrix();

    // draw line to seperate Detail view and focus/context views
    line(width/7, 0, width/7, height);

    // detail view
    pushMatrix();
    drawDetailCCP( focus_attr, attr[chosenLeaf] );
    popMatrix();
  }



  // click-to-swap interaction
  // swap chosen attribute with center attribute when user click on an attribute
  public void mousePressed() {
    PVector sel = new PVector( mouseX-snfPos.x, mouseY-snfPos.y );

    // swap chosen leave and center
    DataAttribute tmp = attr[chosenLeaf];
    attr[chosenLeaf] = focus_attr;
    focus_attr = tmp;
  }

  // hover-to-detail interaction
  // set the detail view as the mouse moves
  public void mouseMoved() {

    PVector sel = new PVector( mouseX-snfPos.x, mouseY-snfPos.y );
    float tm = 10000.0f;
    // find a pair of attributes that mouse is over (chosenLeaf, focus_attr)
    for (int i = 0; i < leaves.length; i++) {
      float dist = sel.dist( leaves[i].end_location );
      if (tm > dist) {
        tm = dist;
        chosenLeaf = i;
      }
    }
  }

  // draw labels for focus and context views
  private void drawLabels( ) {

    strokeWeight(1);
    noStroke( );
    fill(0);  
    textAlign( CENTER, CENTER );

    // center label
    text( focus_attr.getName(), snfPos.x, snfPos.y );
    for (int i = 0; i < leaves.length; i++) {

      // focus labels
      float x0 = leaves[i].end_location.x;
      float y0 = leaves[i].end_location.y;
      text( attr[i].getName(), snfPos.x+x0, snfPos.y+y0 );

      // context labels
      for ( int j = 0; j < leaves[i].children.length; j++ ) {
        float x1 = leaves[i].children[j].end_location.x;
        float y1 = leaves[i].children[j].end_location.y;
        text( attr[(i+j+1)%attr.length].getName(), snfPos.x+x1, snfPos.y+y1 );
      }
    }

    // detail labels
    textAlign( LEFT, CENTER );
    text( attr[chosenLeaf].getName(), dtlPos.x+10, dtlPos.y-height/2.5 );
    textAlign( RIGHT, CENTER );
    text( focus_attr.getName(), dtlPos.x-10, dtlPos.y-height/2.5);
  }

  // draw CCP for focus and context views
  private void drawCCP( ContextLeaf con, DataAttribute attr0, DataAttribute attr1 ) {

    pushMatrix();

    // translate to the appropriate location
    translate( con.start_location.x, con.start_location.y );

    // rotate to appropriate angle
    rotate( con.angle-PI/2.0f );

    // make appropriate radius
    scale( con.range*min(width, height)/2.0f, con.range*min(width, height)/2.0f );

    // set the plot to be ( [0,1], [-1,1] ) and draw
    scale(0.5f, 0.5f);
    translate(0, 1);
    (new CorrelationCoordinatePlot( attr0, attr1 )).draw( );

    popMatrix();
  }

  // draw CCP for detail view
  private void drawDetailCCP( DataAttribute attr0, DataAttribute attr1 ) {

    pushMatrix();

    // center the plot appropriately
    translate( dtlPos.x, dtlPos.y );

    // scale the plot appropriately
    scale(width/7.0f, height/2.75f);

    // draw the plot
    (new CorrelationCoordinatePlot( attr0, attr1 )).draw( );

    popMatrix();
  }


  // center of snowflake visualization
  private PVector snfPos =  new PVector( 2.3f*width/4.0f, height/2.0f );

  // center of detail view
  private PVector dtlPos =  new PVector( width/14.0f, height/2.0f );


  // chosen leaf for mouse interaction
  private int chosenLeaf = 0;


  // focus attribute
  private DataAttribute focus_attr;
  // other attributes
  private DataAttribute [] attr;
  // leaves in context view
  private ContextLeaf [] leaves;




  // process context leaf
  class ContextLeaf {
    PVector start_location = new PVector( );
    PVector end_location   = new PVector( );
    float   angle;
    float   range;

    ContextLeaf [] children = null;

    public ContextLeaf( float angle, int childrenN ) {
      set( angle, new PVector(0, 0), focus_inner_radius*(float)width/(float)height, focus_inner_radius, focus_outer_radius, childrenN );
    }

    private ContextLeaf( float angle, PVector center ) {
      set( angle, center, context_inner_radius, context_inner_radius, context_outer_radius, 0 );
    }

    // set location, angle and range of context leaf
    private void set( float angle, PVector center, float inner_radius_x, float inner_radius_y, float outer_radius, int childrenN ) {
      this.angle = angle;
      this.range = outer_radius-min(inner_radius_x, inner_radius_y);

      this.start_location.x = center.x + (float)width  / 2.0f * inner_radius_x * cos(angle);
      this.start_location.y = center.y + (float)height / 2.0f * inner_radius_y * sin(angle);

      this.end_location.x = start_location.x + (float)min(width, height) / 2.0f * (range+range_buffer) * cos(angle);
      this.end_location.y = start_location.y + (float)min(width, height) / 2.0f * (range+range_buffer) * sin(angle);

      if ( childrenN != 0 ) {
        children = new ContextLeaf[childrenN];
        for (int j = 0; j < childrenN; j++) {
          children[j] = new ContextLeaf( lerp( angle-PI/2.0f, angle+PI/2.0f, (float)(j)/(float)(childrenN-1) ), end_location );
        }
      }
    }
  }
}

