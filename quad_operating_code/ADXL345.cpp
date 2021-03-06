#include "Sensor.h"
#include "Arduino.h"
#include "ADXL345.h"

ADXL345::ADXL345()
:Sensor(0x53)
{
  
}

void ADXL345::init(){
  //set range +/- 4G
  writeI2C(DATA_FORMAT, 0x01);
  //put into measurement mode.
  writeI2C(POWER_CTL, 0x08);
  
//  get_zeros();
}

void ADXL345::get_zeros(){
  
  int sum[2];
  int ssize = 40; //sample size.
  
  for (int i = 0; i < ssize; i++){
    for (int j = 0; j < 2; j++){
      sum[j] += buffer[j]; 
    }
  }
  for (int j = 0; j < 2; j++){
    zero[j] = sum[j] / ssize;
  }
}

void ADXL345::read(){
  byte bytes[6];
  memset(bytes,0,6);
  readI2C(DATA_REG,bytes,6);
  
  for (int i = 0; i < 3; i++)
     buffer[i] = (((int)bytes[2*i+1]) << 8) + (int)bytes[2*i];
}



