/*
 * OpenCTF Rosetta Stone Challenge by Jack Sullivan (Sully) <jack@hunted.codes>
 * 
 * Hint is "Original source-orer"
 * Outputs key to circut (upper), "pwnme" but requires a patched jump.
 * Pass in "OGDecod3r" from the COBOL program (lower) to get flag piece "L1n3@g3_"
 * Flag will not be printed, but appears on the stack.
 * Check the stack at EBP-0x47 for the flag piece.
 */

#include <stdio.h>

int main(int argc, char** argv)
{
  //Include a "conditional" jump that hinders disassembly.  - Done
  //Include a jump over the flag that needs to be patched.  - Done
  //Include a INT3 breakpoint 0xCC                          - Done
  //Add instructions that cancel out, but looks complex.    - Done

  char* dm = "Pass me original source-orer's synonym";
  printf("%s\n", dm);
  char ku[6];

  //Impossible condition will require NOP patching.
  if( argc < 1)
  {    
    ku[0] = 10 ^ 122;    //'p'
    ku[1] = ku[0] ^ 7;   //'w';
    ku[2] = ku[1] ^ 25;  //'n';
    __asm__("int3");
    ku[3] = ku[2] ^ 3;   //'m';
    ku[4] = ku[3] ^ 8;   //'e';
    ku[5] = ku[4] ^ 101; // 0;
    printf("Ku: \"%s\"\n", ku);
  }

  //This screws up disassembly by jumping into the middle of an instruction.
  __asm__ volatile(
    "\n   push %eax"
    "\n   mov $255, %al"
    "\n   inc %al"
    "\n   jnz . + 3"
    "\n   add $89,%eax"
    "\n   xor $4096,%eax"
    "\n   sub $28,%eax"
    "\n   pop %eax"
  );

  //Verify argument existence and length.
  if(argc<2)
    return 0;  
  int arglen=0;
  while(argv[1][arglen]) 
  {
    arglen++;
    __asm__("int3");
  }
  if( arglen < 9 )
    return 0;

  //This screws up disassembly by jumping into the middle of an instruction.
  __asm__ volatile(
    "\n   push %eax"
    "\n   mov $255, %al"
    "\n   inc %al"
    "\n   jnz . + 3"
    "\n   add $89,%eax"
    "\n   xor $4096,%eax"
    "\n   sub $28,%eax"
    "\n   pop %eax"
  );

  //Assign bytes to be XOR'd
  char fm3 = 0x56;
  char delim7 = 0x56;
  char delim12 = 0x4d;
  char delim9 = 0x22;
  __asm__("int3");
  char delim5 = 0x3f;
  char delim11 = 0x47;
  char fm1 = 0x76;
  char fm2 = 0x2a;
  char fm4 = 0x23;
  char fm0 = 0x03;

  //This screws up disassembly by jumping into the middle of an instruction.
  __asm__ volatile(
    "\n   push %eax"
    "\n   mov $255, %al"
    "\n   inc %al"
    "\n   jnz . + 3"
    "\n   add $89,%eax"
    "\n   xor $4096,%eax"
    "\n   sub $28,%eax"
    "\n   pop %eax"
  );

  char delim1 = 0x2b;
  char delim2 = 0x25;
  char delim4 = 0x43;
  char delim3 = 0x02;
  char fm6 = 0x57;
  char fm7 = 0x6c;  
  char fm5 = 0x08;
  char delim10 = 0x7e;
  char delim8 = 0x2c;
  char delim6 = 0x0d;
  char delim0 = 0x09;
  
  //Flag array puts the pieces in the right places in random order.
  char flag[36];
  flag[33] = (argv[1][3] ^ argv[1][3]);
  flag[35] = (argv[1][7] ^ argv[1][7]);  
  flag[30] = (argv[1][5] ^ argv[1][5]);
  flag[27] = (fm7 ^ argv[1][7]);
  //This screws up disassembly by jumping into the middle of an instruction.
  __asm__ volatile(
    "\n   push %eax"
    "\n   mov $255, %al"
    "\n   inc %al"
    "\n   jnz . + 3"
    "\n   add $89,%eax"
    "\n   xor $4096,%eax"
    "\n   sub $28,%eax"
    "\n   pop %eax"
  );

  //Impossible condition will require NOP patching.
  if( argc < 1)
  {    
    flag[7]  = (argv[1][6] ^ argv[1][6]);
    flag[6]  = (argv[1][4] ^ argv[1][4]);
    flag[32] = (argv[1][1] ^ argv[1][1]);
    flag[1]  = (argv[1][2] ^ argv[1][2]);
    flag[23] = (fm3 ^ argv[1][3]);  
    flag[3]  = (argv[1][6] ^ argv[1][6]);
    flag[12] = (delim4 ^ argv[1][4]);
    flag[20] = (fm0 ^ argv[1][0]);
    __asm__("int3");
    flag[26] = (fm6 ^ argv[1][6]);
    flag[15] = (delim7 ^ argv[1][7]);
    flag[5]  = (argv[1][2] ^ argv[1][2]);
    flag[19] = (delim11 ^ argv[1][3]);  
    flag[21] = (fm1 ^ argv[1][1]);
    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
    flag[18] = (delim10 ^ argv[1][2]);  
    flag[13] = (delim5 ^ argv[1][5]);
    flag[11] = (delim3 ^ argv[1][3]);
    flag[31] = (argv[1][7] ^ argv[1][7]);
    flag[34] = (argv[1][5] ^ argv[1][5]);
    flag[24] = (fm4 ^ argv[1][4]);
    flag[29] = (argv[1][3] ^ argv[1][3]);
    flag[10] = (delim2 ^ argv[1][2]);
    __asm__("int3");
    flag[22] = (fm2 ^ argv[1][2]);
    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
    flag[9]  = (delim1 ^ argv[1][1]);
    flag[17] = (delim9 ^ argv[1][1]);
    flag[0]  = (argv[1][0] ^ argv[1][0]);
    flag[2]  = (argv[1][4] ^ argv[1][4]);
    flag[28] = (delim11 ^ argv[1][3]);
    flag[16] = (delim8 ^ argv[1][0]);
    flag[25] = (fm5 ^ argv[1][5]);
    flag[4]  = (argv[1][0] ^ argv[1][0]);
    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
    flag[8]  = (delim0 ^ argv[1][0]);
    flag[14] = (delim6 ^ argv[1][6]);
    fm5 = fm5 >> 7;
    delim12 = delim12 << 6;  
    fm2 = fm2 >> 8;
    fm3 = fm3 >> 5;
    fm7 = fm7 >> 3;
    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
    delim4 = delim4 << 2;
    delim9 = delim9 << 7;
    delim0 = delim0 << 3;
    delim2 = delim2 << 2;
    delim10 = delim10 << 1;
    fm6 = fm6 >> 7;
    __asm__("int3");
    delim6 = delim6 << 3;
    delim3 = delim3 << 3;
    fm4 = fm4 >> 7;
    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
    delim8 = delim8 << 6;
    fm1 = fm1 >> 2;
    delim1 = delim1 << 6;
    delim11 = delim11 << 7;
    fm0 = fm0 >> 7;
    __asm__("int3");
    delim7 = delim7 << 4;
    delim5 = delim5 << 1;

    //This screws up disassembly by jumping into the middle of an instruction.
    __asm__ volatile(
      "\n   push %eax"
      "\n   mov $255, %al"
      "\n   inc %al"
      "\n   jnz . + 3"
      "\n   add $89,%eax"
      "\n   xor $4096,%eax"
      "\n   sub $28,%eax"
      "\n   pop %eax"
    );
  }

  //Check the stack at EBP-0x47 for the flag piece.
  return 0;
}
