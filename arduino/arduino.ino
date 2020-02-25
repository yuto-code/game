#include <Boards.h>
#include <Firmata.h>
#include <FirmataConstants.h>
#include <FirmataDefines.h>
#include <FirmataMarshaller.h>
#include <FirmataParser.h>

#include <Kalman.h>
#include <MsTimer2.h>
#include <Wire.h>

Kalman kalmanX;
double kalAngleX;
Kalman kalmanY;
double kalAngleY;

int T = 10; //[ms]

int a_i, a_X, a_Y;
double a_x, a_y, a_z;

double w_x = 0, w_y = 0, w_z = 0; //[deg]
short w_X2, w_Y2, w_Z2;     //reading
float w_x1, w_y1, w_z1;     //[deg/s]
// Connect L3GD20 with SDA (A4), SCL (A5)

const byte L3GD20_ADDR = B1101010;  // SA0 = GND
//const byte L3GD20_ADDR = B1101011;// SA0 = VDD_IO

const byte L3GD20_WHOAMI = 0x0f;
const byte L3GD20_CTRL1 = 0x20;
const byte L3GD20_CTRL2 = 0x21;
const byte L3GD20_CTRL3 = 0x22;
const byte L3GD20_CTRL4 = 0x23;
const byte L3GD20_CTRL5 = 0x24;
const byte L3GD20_X_L = 0x28;
const byte L3GD20_X_H = 0x29;
const byte L3GD20_Y_L = 0x2A;
const byte L3GD20_Y_H = 0x2B;
const byte L3GD20_Z_L = 0x2C;
const byte L3GD20_Z_H = 0x2D;

void L3GD20_write(byte reg, byte val)
{
  Wire.beginTransmission(L3GD20_ADDR);
  Wire.write(reg);
  Wire.write(val);
  Wire.endTransmission();
}

byte L3GD20_read(byte reg)
{
  byte ret = 0;
  // request the registor
  Wire.beginTransmission(L3GD20_ADDR);
  Wire.write(reg);
  Wire.endTransmission();

  // read
  Wire.requestFrom((unsigned int)L3GD20_ADDR, 1);

  while (Wire.available()) {
    ret = Wire.read();
  }

  return ret;
}

void setup() {
  Serial.begin(9600);
  while (!Serial) {}

  Wire.begin();

  Serial.println(L3GD20_read(L3GD20_WHOAMI), HEX); // should show D4

  L3GD20_write(L3GD20_CTRL1, B00001111);
  //   |||||||+ X axis enable
  //   ||||||+- Y axis enable
  //   |||||+-- Z axis enable
  //   ||||+--- PD: 0: power down, 1: active
  //   ||++---- BW1-BW0: cut off 12.5[Hz]
  //   ++------ DR1-DR0: ODR 95[HZ]
  MsTimer2::set(T, deg);
  MsTimer2::start();

  kalAngleX = 0;
  kalAngleY = 0;
}


int X, Y;
int X1,X2,Y1,Y2;
void deg() {
  w_x = w_x + w_x1 * T / 1000;
  w_y = w_y + w_y1 * T / 1000;
  w_z = w_z + w_z1 * T / 1000;
  kalmanX.setAngle(kalAngleX);
  kalAngleX = kalmanX.getAngle(a_X, w_x1, 0.01);
  X = kalAngleX;
  kalmanY.setAngle(kalAngleY);
  kalAngleY = kalmanY.getAngle(a_Y, w_y1, 0.01);
  Y = kalAngleY;
  //Serial.println(X);Serial.println(Y);
  if(X<0){
    X=abs(X);
    X1=X&15; //X_下位
    X1=X1;   //X_下位:確認0000
    X2=X>>4; //X_上位
    X2=X2|16;//X_上位:確認0001
    X2=X2|128;//-
  }else{
    X1=X&15; //X_下位
    X1=X1;   //X_下位:確認0000
    X2=X>>4; //X_上位
    X2=X2|16;//X_上位:確認0001
  }
  if(Y<0){
    Y=abs(Y);
    Y1=Y&15; //Y_下位
    Y1=Y1|32;//Y_下位:確認0010
    Y2=Y>>4; //Y_上位
    Y2=Y2|48;//Y_上位:確認0011
    Y2=Y2|128;//-
  }else{
    Y1=Y&15; //Y_下位
    Y1=Y1|32;//Y_下位:確認0010
    Y2=Y>>4; //Y_上位
    Y2=Y2|48;//Y_上位:確認0011
  }
  
  
  
  
  //Serial.println(Y1);Serial.println(Y2);Serial.println(Y);
  Serial.write(X1);Serial.write(X2);
  Serial.write(Y1);Serial.write(Y2);
  //Serial.write(X);
  //Serial.write(Y);

  
}

void loop() {
  a_x = a_y = a_z = 0;
  for (a_i = 0; a_i < 100; a_i++) {
    a_x = a_x + analogRead(A2); 
    a_y = a_y + analogRead(A1); 
    a_z = a_z + analogRead(A0); 
  }
  a_x = a_x / 100 ;
  a_y = a_y / 100 ;
  a_z = a_z / 100 ;
  a_X = (a_x - 277) / 2.48 - 90; 
  a_Y = (a_y - 277) / 2.48 - 90; 

  w_X2 = L3GD20_read(L3GD20_X_H);
  w_X2 = (w_X2 << 8) | L3GD20_read(L3GD20_X_L);
  w_Y2 = L3GD20_read(L3GD20_Y_H);
  w_Y2 = (w_Y2 << 8) | L3GD20_read(L3GD20_Y_L);
  w_Z2 = L3GD20_read(L3GD20_Z_H);
  w_Z2 = (w_Z2 << 8) | L3GD20_read(L3GD20_Z_L);

  w_x1 = w_X2 * 0.00875; // +-250dps  //x1 *= 0.0175;// +-500dps  //x1 *= 0.07;  // +-2000dps
  w_y1 = w_Y2 * 0.00875; // +-250dps
  w_z1 = w_Z2 * 0.00875; // +-250dps
}
