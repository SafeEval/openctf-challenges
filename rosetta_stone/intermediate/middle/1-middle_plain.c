/*
 * DEFCON23 OpenCTF Rosetta Stone Challenge by Jack Sullivan (Sully) <jack@hunted.codes>
 * 
 * Hint is "Original source-orer"
 * Pass in "OGDecod3r" from the COBOL program (lower) to get flag piece "L1n3@g3_"
 * Outputs key to circut (upper), "pwnme"
 */

#include <stdio.h>

int main(int argc, char** argv)
{

  //Include a "conditional" jump that hinders disassembly.
  //Include a jump over the flag that needs to be patched.
  //Include a INT3 breakpoint 0xCC
  //Do math stuff that cancels out, but looks complex.

  char* dm = "Pass me original source-orer's synonym";
  printf("%s\n", dm);

  char ku[6];
  ku[0] = 10 ^ 122;    //'p'
  ku[1] = ku[0] ^ 7;   //'w';
  ku[2] = ku[1] ^ 25;  //'n';
  ku[3] = ku[2] ^ 3;   //'m';
  ku[4] = ku[3] ^ 8;   //'e';
  ku[5] = ku[4] ^ 101; // 0;
  printf("Ku: \"%s\"\n", ku);

  if(argc<2)
    return 0;
  int arglen=0;
  while(argv[1][arglen]) arglen++;
  if( arglen < 9 )
    return 0;

  //Delimiter bytes "Flag piece:" to be XOR'd.
  char delim0 = 0x09; // ^ argv[1][0]
  char delim1 = 0x2b; // ^ argv[1][1]
  char delim2 = 0x25; // ^ argv[1][2]
  char delim3 = 0x02; // ^ argv[1][3]
  char delim4 = 0x43; // ^ argv[1][4]
  char delim5 = 0x3f; // ^ argv[1][5]
  char delim6 = 0x0d; // ^ argv[1][6]
  char delim7 = 0x56; // ^ argv[1][7]
  char delim8 = 0x2c; // ^ argv[1][0]
  char delim9 = 0x22; // ^ argv[1][1]
  char delim10 = 0x7e; // ^ argv[1][2]
  char delim11 = 0x47; // ^ argv[1][3]
  char delim12 = 0x4d; // ^ argv[1][4]

  //The flag bytes to be XOR'd against "OGDecod3r"
  char fm0 = 0x03;
  char fm1 = 0x76;
  char fm2 = 0x2a;
  char fm3 = 0x56;
  char fm4 = 0x23;
  char fm5 = 0x08;
  char fm6 = 0x57;
  char fm7 = 0x6c;

  char flag[36];
  flag[0]  = (argv[1][0] ^ argv[1][0]);
  flag[1]  = (argv[1][2] ^ argv[1][2]);
  flag[2]  = (argv[1][4] ^ argv[1][4]);
  flag[3]  = (argv[1][6] ^ argv[1][6]);
  flag[4]  = (argv[1][0] ^ argv[1][0]);
  flag[5]  = (argv[1][2] ^ argv[1][2]);
  flag[6]  = (argv[1][4] ^ argv[1][4]);
  flag[7]  = (argv[1][6] ^ argv[1][6]);

  flag[8]  = (delim0 ^ argv[1][0]);
  flag[9]  = (delim1 ^ argv[1][1]);
  flag[10] = (delim2 ^ argv[1][2]);
  flag[11] = (delim3 ^ argv[1][3]);
  flag[12] = (delim4 ^ argv[1][4]);
  flag[13] = (delim5 ^ argv[1][5]);
  flag[14] = (delim6 ^ argv[1][6]);
  flag[15] = (delim7 ^ argv[1][7]);
  flag[16] = (delim8 ^ argv[1][0]);
  flag[17] = (delim9 ^ argv[1][1]);
  flag[18] = (delim10 ^ argv[1][2]);  
  flag[19] = (delim11 ^ argv[1][3]);  

  flag[20] = (fm0 ^ argv[1][0]);
  flag[21] = (fm1 ^ argv[1][1]);
  flag[22] = (fm2 ^ argv[1][2]);
  flag[23] = (fm3 ^ argv[1][3]);
  flag[24] = (fm4 ^ argv[1][4]);
  flag[25] = (fm5 ^ argv[1][5]);
  flag[26] = (fm6 ^ argv[1][6]);
  flag[27] = (fm7 ^ argv[1][7]);

  flag[28] = (delim11 ^ argv[1][3]);
  flag[29] = (argv[1][3] ^ argv[1][3]);
  flag[30] = (argv[1][5] ^ argv[1][5]);
  flag[31] = (argv[1][7] ^ argv[1][7]);
  flag[32] = (argv[1][1] ^ argv[1][1]);
  flag[33] = (argv[1][3] ^ argv[1][3]);
  flag[34] = (argv[1][5] ^ argv[1][5]);
  flag[35] = (argv[1][7] ^ argv[1][7]);

  return 0;
}

