/*
** Correlation Coordinates Plots
 ** Copyright (C) 2014 - Hoa Nguyen - Paul Rosen
 */

// get information of data attributes
class Datafile {

  // Constructor loads text-based whitespace separated data 
  public Datafile( String datfile ) {
    // load input data
    String [] lines = loadStrings(datfile);

    // process input data
    if ( lines != null ) {
      elemN = lines.length;
      attrN = splitTokens(lines[0]).length;

      data = new DataAttribute[attrN];
      for ( int i = 0; i < attrN; i++ ) {
        data[i] = new  DataAttribute( elemN, "D" + (i+1) );
      }

      for ( int row = 0; row < elemN; row++ ) {
        String[] items = splitTokens(lines[row]);
        for ( int col = 0; col < attrN; col++ ) {
          data[ col ].set( row, float(items[col]) );
        }
      }
    }
    //print("Loaded " + elemN + " elements for " + attrN + " attributes\n");
  }  

  // get data attribute name
  public String getAttributeName( int attr ) {
    return data[ attr ].getName( );
  }

  // get number of attributes
  public int attributeCount( ) { 
    return attrN;
  }

  // get number of elements 
  public int elementCount( ) { 
    return elemN;
  } 

  // get number of elements for attribute attr
  public float get( int elem, int attr ) {
    return data[ attr ].get( elem );
  }

  // get normalized data values
  public float getNormalized( int elem, int attr ) {
    return data[ attr ].getNormalized( elem );
  }

  // get attribute information
  public DataAttribute getAttribute( int attr ) {
    return data[ attr ];
  }

  public float calculatePopulationCovariance( DataAttribute attr0, DataAttribute attr1 ) {
    float mean0 = attr0.getMean( );
    float mean1 = attr1.getMean( );
    int size = min( attr0.size(), attr1.size() );
    float cov = 0;
    for (int i = 0; i < size; i++) {
      cov += (attr0.get(i) - mean0)*(attr1.get(i) - mean1);
    }
    return cov / (float)size;
  }

  public float calculateSampleCovariance( DataAttribute attr0, DataAttribute attr1 ) {
    int size = min( attr0.size(), attr1.size() );
    return calculatePopulationCovariance(attr0, attr1) * (float)size / (float)(size-1);
  }

  // calculate Pearson correlation coefficient
  public float calculatePearsonCorrelation( DataAttribute attr0, DataAttribute attr1 ) {
    return calculatePopulationCovariance( attr0, attr1 ) / ( attr0.getStdevPopulation() * attr1.getStdevPopulation() );
  }

  private DataAttribute [] data = null;

  private int elemN = 0;
  private int attrN = 0;
}

