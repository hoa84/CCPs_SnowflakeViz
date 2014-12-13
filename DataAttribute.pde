/*
** Correlation Coordinates Plots
 ** Copyright (C) 2014 - Hoa Nguyen - Paul Rosen
 */

// process input data
static class DataAttribute {

  public DataAttribute( int len, String name ) {
    this.data = new float[len];
    this.name = name;
  }

  // size of data
  public int size() {
    return data.length;
  }

  public void set( int row, float v ) {
    // set value 
    data[row] = v;

    // invalidate attributes
    att_min     = null;
    att_max     = null;
    att_mean    = null;
    att_var_pop = null;
  }

  // get name of attribute
  public String getName( ) {
    return name;
  }  

  // get a row of data set
  public float get( int row ) { 
    return data[row];
  }

  // normalization
  public float getNormalized( int row ) {
    calculateRange( );    
    return (get(row) - att_min)/(att_max - att_min);
  }

  // get mean of attribute
  public float getMean( ) {
    calculateMean( );
    return att_mean;
  }

  // get variance population of attribute
  public float getVariancePopulation( ) {
    calculateVariancePopulation( );
    return att_var_pop;
  }

  public float getVarianceSample( ) {
    return getVariancePopulation( ) * (float)data.length / (float)(data.length-1);
  }

  public float getStdevSample( ) {
    return sqrt( getVarianceSample(  ) );
  }

  public float getStdevPopulation( ) {
    return sqrt( getVariancePopulation( ) );
  }

  // calculate range of data
  private void calculateRange( ) {
    if ( att_min == null || att_max == null ) {
      att_min = att_max = data[0];
      for ( float v : data ) { 
        att_min = min( att_min, v );
        att_max = max( att_max, v );
      }
    }
  }

  // calculate mean
  private void calculateMean( ) {
    if ( att_mean == null ) { 
      att_mean = 0.0f;
      for (int i = 0; i < data.length; i++) {
        att_mean += get(i);
      }
      att_mean /= (float)data.length;
    }
  }

  // calculate variance population
  private void calculateVariancePopulation( ) {
    if ( att_var_pop == null ) {
      calculateMean( );
      att_var_pop = 0.0f;
      for (int i = 0; i < data.length; i++) { 
        att_var_pop += (get(i) - att_mean)*(get(i) - att_mean);
      }
      att_var_pop /= (float)(data.length);
    }
  }


  private float [] data;

  private String name = "";

  // minimum, maximum, mean and VariancePopulation of attributes
  private Float att_min     = null;
  private Float att_max     = null;
  private Float att_mean    = null;
  private Float att_var_pop = null;
}

