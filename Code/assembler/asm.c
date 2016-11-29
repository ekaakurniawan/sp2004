// Copyright (C) 2004-2010 by Eka A. Kurniawan
// eka.a.kurniawan(ta)gmail(tod)com
//
// This program is free software; you can redistribute it and/or modify 
// it under the terms of the GNU General Public License as published by 
// the Free Software Foundation; version 2 of the License.
//
// This program is distributed in the hope that it will be useful, 
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License 
// along with this program; if not, write to the 
// Free Software Foundation, Inc., 
// 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

/*	File Name	:	asm.c
 *	Function	:	Assembler
 *	Writen by	:	Eka A. Kurniawan
 *	Email		:	eka.a.kurniawan(ta)gmail(tod)com
 *	Writen Date	:	November, 1st 2003
 *	Revision Date	:	September, 19th 2010
 *	Version		:	1.00
 *	Limitation	:
 *	 1. Label started with 'under score' (_) and maximum 25 character.
 *	 2. Comment can't given.
 *	 3. Write all instruction Up Case.
 *	 4. Each instruction sparate by one ENTER (don't give blank line).
 *	 5. TABULATION not allowed.
 *	 6. Give one space after Coma (,).
 *	 7. Immediate beginning with Sharp (#) and ending with 'h' character.
 *	 8. Write Register with two digits (ex. R01, R09, R21).
 *	 For example:
 *	    _start:
 *	    ADD R01, R02, R29
 *	    SUB R03, R20, #AC34h
 *	    JMP _start:
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


//###########################################  GLOBAL VARIABLE DECLARATION  ###

/* OperandType  */
#define RD_RA_RB      0
#define RD_RA_IMM     1
#define RD_RA         2
#define RD_IMM        3
#define RD            4
#define RA_RB         5
#define RB            6
#define TARGET        7
#define RA_RB_IMM     8
#define NONE          9

/* Link and No Link instruction  */
#define NO_LINK       0
#define LINK          1

typedef unsigned short USHORT;

/* Instruction Definition  */
struct inst_def {
   char mnemonic[5];
   char opcode[7];
   USHORT operand_type;
   USHORT mnemonic_length;
   USHORT link;
   struct inst_def *next;
}*inst_head = NULL, *inst_tail, *inst_cur;

/* Label Definition  */
struct label_def {
   char label[25];  // name of label
   int label_add;   // label address
   struct label_def *next;
}*label_head = NULL, *label_tail, *label_cur;

/* Pointer to Assembly and Bits file  */
FILE *ASM_FILE, *BIT_FILE;


//##################################################  FUNCTION DECLARATION  ###

void HEXchar_to_BINchar(char HEX, char *BIN);
void regDEC_to_regBIN(char *reg_dec, char *reg_bin);
void print_program_information();
void argument_validation(int argc);
void inst_colect(char mnemonic[5], char opcode[7], USHORT operand_type, \
      USHORT mnemonic_length, USHORT link);
void instruction_definition();
void label_scanning();
void get_mnemonic(int cur_p, char *mnemonic);
int its_label(char *mnemonic, int *cur_p);
int get_inst_def(char *mnemonic);
void get_opcode(char *instruction, int *cur_p);
void cmp_label(char *label_get, int inst_cnt, char *add_hex);
void operand_decode(char *instruction, int *cur_p, int inst_cnt);
void cur_p_calibrate(int *cur_p);


//##########################################################  MAIN PROGRAM  ###

int  main(int argc, char *argv[]) {
	
   /* 'mnemonic' geted from user assembly program.  */
   char mnemonic[5];
   /* 'instruction' consist of 32 bit instruction.  */
   char instruction[32];
   
   /* Cursosr Pointer at user assembly file.  */
   int cur_p = 0;
   
   /* Counting a number of instruction. Used to know the location of a label. \
    * The value start from zero (0).  */
   int inst_cnt = 0;
   
   /* Line Feed  */
   char LINE_FEED[1] = {0xA};

   /* ASM_FILE : input file content of user assembly program (code).
    * BIT_FILE : output file content of 32 bits instruction. Copy this \
    *            content to 'rom.vhd' file and give the address for each \
    *            instruction.  */
   ASM_FILE = fopen(argv[1],"rb");
   BIT_FILE = fopen(argv[2],"wb");

   /* Print a information about the making of this assembler.  */
   print_program_information();
   
   /* Check for argument that transfered.  */
   argument_validation(argc);
   
   /* Definite all instruction that used.  */
   instruction_definition();
   
   /* Scan all label that apear in user assembly program.  */
   label_scanning();

   /* Looping to decode each instruction from user assembly program.  */
   do {
      /* Get a mnemonic (start of instruction) from user assembly program.  */
      get_mnemonic(cur_p, mnemonic);
      
      /* If a array of character that fetched is a label (not a mnemonic), \
       * continue to next instruction.  */
      if(its_label(mnemonic, &cur_p)) continue;
      
      /* Get instruction definition from mnemonic that fetched.  */
      if(!get_inst_def(mnemonic)) exit(1);
      
      /* Get opcode from the mnemonic.  */
      get_opcode(instruction, &cur_p);
      
      /* Decode all operand for each instruction that feached.  */
      operand_decode(instruction, &cur_p, inst_cnt);

      /* Write 32 instruction bits to Target FILE (BIT_FILE).  */
      fwrite(instruction, 32, 1, BIT_FILE);
      fwrite(LINE_FEED, 1, 1, BIT_FILE);   // New Line
      
      /* Cursor Pointer calibration to fetch next instruction.  */
      cur_p_calibrate(&cur_p);

      /* Increase the Instruction Counter.  */
      inst_cnt++;

   }while(!feof(ASM_FILE));

   /* Close FILE.  */
   fclose(ASM_FILE);
   fclose(BIT_FILE);

   printf("SUCCESS...Generated Complete !\n");
   exit(0);
}


//###################################################  FUNCTION DEFINITION  ###

void HEXchar_to_BINchar(char HEX, char *BIN) {
   switch(HEX) {
      case '0' : strcpy(BIN, "0000"); break;
      case '1' : strcpy(BIN, "0001"); break;
      case '2' : strcpy(BIN, "0010"); break;
      case '3' : strcpy(BIN, "0011"); break;
      case '4' : strcpy(BIN, "0100"); break;
      case '5' : strcpy(BIN, "0101"); break;
      case '6' : strcpy(BIN, "0110"); break;
      case '7' : strcpy(BIN, "0111"); break;
      case '8' : strcpy(BIN, "1000"); break;
      case '9' : strcpy(BIN, "1001"); break;
      case 'A' : strcpy(BIN, "1010"); break;
      case 'a' : strcpy(BIN, "1010"); break;
      case 'B' : strcpy(BIN, "1011"); break;
      case 'b' : strcpy(BIN, "1010"); break;
      case 'C' : strcpy(BIN, "1100"); break;
      case 'c' : strcpy(BIN, "1010"); break;
      case 'D' : strcpy(BIN, "1101"); break;
      case 'd' : strcpy(BIN, "1010"); break;
      case 'E' : strcpy(BIN, "1110"); break;
      case 'e' : strcpy(BIN, "1010"); break;
      case 'F' : strcpy(BIN, "1111"); break;
      case 'f' : strcpy(BIN, "1010"); break;
      default  : strcpy(BIN, "0000");
   }
}

void regDEC_to_regBIN(char *reg_dec, char *reg_bin) {
   int reg, reg_int[2], reg_mod;
   int i;

   /* 'reg_dec' allways like this: R12. Take the 12 then convert the '1' and \
    * '2' character to '1' and '2' integer (just subtract it with 30h). Put \
    * the result at 'reg_int' variable.  */
   reg_int[0] = reg_dec[1] - 0X30;
   reg_int[1] = reg_dec[2] - 0X30;

   /* Combine the 'reg_int[0]' and 'reg_int[1]' then put it at 'reg'.  */
   reg = (reg_int[0] * 10) + reg_int[1];

   /* Convert the 'reg' to biner character and put it on 'reg_bin'. Just loop \
    * four times because the maximum value of 'reg' is 31.  */
   for(i=4; i>=0; i--) {
      reg_mod = reg % 2;
      
      if(reg_mod == 0) reg_bin[i] = '0';
      else             reg_bin[i] = '1';

      reg /= 2;
   }
}

void print_program_information() {
   printf("*** Assembler ***\n");
   printf("Writen by     : Eka A. Kurniawan\n");
   printf("Writen Date   : November, 1st 2003\n");
   printf("Revision Date : September, 19th 2010\n");
   printf("Version       : 1.00\n");
   printf("Mail Me at    : eka.a.kurniawan(ta)gmail(tod)com\n...\n\n");
}

void argument_validation(int argc) {
   if(argc != 3) {
      printf("ERROR...Program Argument !\n");
      printf("Example : ASM [ASM_FILE] [BIT_FILE] <enter>\n");
      exit(1);
   }
}

void inst_colect(char mnemonic[5], char opcode[7], USHORT operand_type, \
      USHORT mnemonic_length, USHORT link) {
   /* Make a new data structure.  */
   inst_cur = (struct inst_def*) malloc(sizeof(struct inst_def));
   /* Copy the information that geted from Infromation Definition.  */
   strcpy(inst_cur->mnemonic, mnemonic);
   strcpy(inst_cur->opcode, opcode);
   inst_cur->operand_type = operand_type;
   inst_cur->mnemonic_length = mnemonic_length;
   inst_cur->link = link;

   /* Put the new data structure at the end of link list.  */
   if(inst_head == NULL) {
      inst_head = inst_tail = inst_cur;
      inst_tail->next = NULL;
   }
   else {
      inst_tail->next = inst_cur;
      inst_tail = inst_cur;
      inst_tail->next = NULL;
   }
}

void instruction_definition() {
   /*----------------------------------------------------
    *                                 MnemonicLength
    *         Mnemonic  OpCode  OperandType |  LinkInst.  
    *------------V--------V----------V------V-----V------  */
   inst_colect("ADD" , "000000", RD_RA_RB , 3, NO_LINK);
   inst_colect("ADI" , "000001", RD_RA_IMM, 3, NO_LINK);
   inst_colect("ADIU", "000010", RD_RA_IMM, 4, NO_LINK);
   inst_colect("SUB" , "000011", RD_RA_RB , 3, NO_LINK);
   inst_colect("SBI" , "000100", RD_RA_IMM, 3, NO_LINK);
   inst_colect("SBIU", "000101", RD_RA_IMM, 4, NO_LINK);
   inst_colect("AND" , "000110", RD_RA_RB , 3, NO_LINK);
   inst_colect("ANDI", "000111", RD_RA_IMM, 4, NO_LINK);
   inst_colect("OR"  , "001000", RD_RA_RB , 2, NO_LINK);
   inst_colect("ORI" , "001001", RD_RA_IMM, 3, NO_LINK);
   inst_colect("XOR" , "001010", RD_RA_RB , 3, NO_LINK);
   inst_colect("XORI", "001011", RD_RA_IMM, 4, NO_LINK);
   inst_colect("NOR" , "001100", RD_RA_RB , 3, NO_LINK);
   inst_colect("NORI", "001101", RD_RA_IMM, 4, NO_LINK);
   inst_colect("SLR" , "001110", RD_RA_IMM, 3, NO_LINK);
   inst_colect("SLRV", "001111", RD_RA_RB , 4, NO_LINK);
   inst_colect("SLL" , "010000", RD_RA_IMM, 3, NO_LINK);
   inst_colect("SLLV", "010001", RD_RA_RB , 4, NO_LINK);
   inst_colect("SAR" , "010010", RD_RA_IMM, 3, NO_LINK);
   inst_colect("SARV", "010011", RD_RA_RB , 4, NO_LINK);
   inst_colect("LUI" , "010100", RD_IMM   , 3, NO_LINK);
   inst_colect("LA"  , "010101", RD       , 2, NO_LINK);
   inst_colect("SB"  , "010110", RA_RB    , 2, NO_LINK);
   inst_colect("SH"  , "010111", RA_RB    , 2, NO_LINK);
   inst_colect("SW"  , "011000", RA_RB    , 2, NO_LINK);
   inst_colect("LB"  , "011001", RD_RA    , 2, NO_LINK);
   inst_colect("LH"  , "011010", RD_RA    , 2, NO_LINK);
   inst_colect("LW"  , "011011", RD_RA    , 2, NO_LINK);
   inst_colect("SLT" , "011100", RD_RA_RB , 3, NO_LINK);
   inst_colect("SLTI", "011101", RD_RA_IMM, 4, NO_LINK);
   inst_colect("DI"  , "011110", NONE     , 2, NO_LINK);
   inst_colect("EI"  , "011111", NONE     , 2, NO_LINK);
   inst_colect("BE"  , "100000", RA_RB_IMM, 2, NO_LINK);
   inst_colect("BH"  , "100001", RA_RB_IMM, 2, NO_LINK);
   inst_colect("BHE" , "100010", RA_RB_IMM, 3, NO_LINK);
   inst_colect("BG"  , "100011", RA_RB_IMM, 2, NO_LINK);
   inst_colect("BGE" , "100100", RA_RB_IMM, 3, NO_LINK);
   inst_colect("JMP" , "100101", TARGET   , 3, NO_LINK);
   inst_colect("JL"  , "100110", TARGET   , 2, LINK);
   inst_colect("JR"  , "100111", RB       , 2, NO_LINK);
   inst_colect("JRL" , "101000", RB       , 3, LINK);
}

void label_scanning() {
   int cur_p = 0;
   int inst_cnt = 0;
   char inst_char;
   
   /* The labael must be start with 'under score' (_).  */
   do {
      inst_char = '\0';

      /* Get the next character.  */
      fseek(ASM_FILE, cur_p, SEEK_SET);
      if(feof(ASM_FILE)) exit(0);
      cur_p++;
      inst_char = fgetc(ASM_FILE);
      
      /* Its a next or first insturction.  */
      if(inst_char == 0xA || cur_p == 1) {
         if(cur_p == 1) cur_p -= 1;
	 
	 /* Get the character and compare it with under score '_' that mean \
	  * it is a LABEL.  */
         fseek(ASM_FILE, cur_p, SEEK_SET);
         inst_char = fgetc(ASM_FILE);

	 if(cur_p == 0) cur_p += 1;
	   
         if(inst_char == '_') {
	    /* Alocate memory for new structure of label definition.  */
	    label_cur = (struct label_def*) malloc(sizeof(struct label_def));
            fseek(ASM_FILE, cur_p-1, SEEK_SET);
            fscanf(ASM_FILE, "%s", label_cur->label);
	    label_cur->label_add = inst_cnt;

	    /* Connect the label link list.  */
	    if(label_head == NULL) {
	       label_head = label_tail = label_cur;
	       label_tail->next = NULL;
	    }
	    else {
	       label_tail->next = label_cur;
	       label_tail = label_cur;
	       label_tail->next = NULL;
	    }
	    
	    /* Pass the current label and go to next character.  */
	    if(cur_p == 1) inst_cnt++;
	    inst_cnt--;
	    cur_p += strlen(label_cur->label);
         }

	 inst_cnt++;
      }
   
   }while(!feof(ASM_FILE));
}

void get_mnemonic(int cur_p, char *mnemonic) {
   /* Get Mnemonic.  */
   fseek(ASM_FILE, cur_p, SEEK_SET); // Redy to fetching position
   fscanf(ASM_FILE, "%s", mnemonic); // and ... read the mnemonic

   /* Its END of FILE ???  */
   if(feof(ASM_FILE)) {
      printf("SUCCESS...Generated Complete !\n");
      exit(0);
   }
}

int its_label(char *mnemonic, int *cur_p) {
   /* Its LABEL ??? (Label started with under score ('_')).  */
   if(mnemonic[0] == '_') {
      *cur_p += strlen(mnemonic) + 1;
      return(1);
   }
   return(0);
}

int get_inst_def(char *mnemonic) {
   /* Set the Current Instruction (inst_cur) to Instruction Head \
    * (inst_head).  */
   inst_cur = inst_head;
   /* If mnemonic that fetch from user assembly program equal to mnemonic at \
    * Instruction Collection (inst_colect) then stop, else print out ERROR \
    * message.  */
   while(1) {
      if(!strcmp(inst_cur->mnemonic, mnemonic))
         return(1);
      else if(inst_cur->next == NULL) {
         printf("ERROR : Instruction \"%s\" unrecognize.\n", mnemonic);
         return(0);
      }
      else
         inst_cur = inst_cur->next;
   };
}

void get_opcode(char *instruction, int *cur_p) {
   int i;

   /* Insert Opcode to 32 bits Instruction.  */
   for(i=0; i<=5; i++) {
      instruction[i] = inst_cur->opcode[i];
   }
   /* Go to First Operand with pass the mnemonic and one space.  */
   *cur_p += (inst_cur->mnemonic_length + 1);
   fseek(ASM_FILE, *cur_p, SEEK_SET);
}

void cmp_label(char *label_get, int inst_cnt, char *add_hex) {
   int i;
   unsigned long delta_add;	// delta address
   int tmp;			// calculation tmeporary
   USHORT cnt;			// cnt = 4 if branch and cnt = 7 if jump

   /* Compare label_get with the colection of label from HEAD to TAIL.  */
   label_cur = label_head;
   while(1) {
      if(strcmp(label_get, label_cur->label) == 0) {
	 /* Label is indentify so calculate the address.  */
	 if(inst_cnt < label_cur->label_add)
            delta_add = label_cur->label_add - inst_cnt - 1;
	 else
            /* -1 for 28 bit is 268435455 (unsign) where maximum bits for \
	     * branch and target is 16 and 26 bits.  */
	    delta_add = 268435455 - (inst_cnt - label_cur->label_add);
	 break;
      }
      else if(label_cur->next == NULL) {
         printf("ERROR : Unrecognize label \"%s\".\n", label_get);
         exit(1);
      }
      else
         label_cur = label_cur->next;
   }
   
   if(inst_cur->operand_type == RA_RB_IMM)
      cnt = 4;	// branch
   else
      cnt = 7;  // jump

   for(i=0; i<cnt; i++) {
      tmp = delta_add % 16;
      if(tmp <= 9)
         add_hex[cnt-i] = (char)tmp + '0';  // 0 - 9
      else
         add_hex[cnt-i] = ((char)tmp - 10) + 'A';  // A - F
      delta_add /= 16;
   }
}

void operand_decode(char *instruction, int *cur_p, int inst_cnt) {
   USHORT i, j;
   USHORT loop_operand;
   char reg_dec[5], reg_bin[5];		// reg_dec ( RXX,@ )
   char imm_hex[7], imm_bin[4];		// imm_hex ( #XXXXh@ )
   char target_hex[10], target_bin[4]; 	// target_hex ( #XXXXXXXh@ )
   char branch_bin[16];

   char label_get[25];
		
      // loop three time to make sure that all operand fetched
      for(loop_operand=0; loop_operand<=2; loop_operand++) {
	      
	
         // Get RD (Destenition Register)
         if((inst_cur->operand_type == RD_RA_RB  && loop_operand == 0) ||
            (inst_cur->operand_type == RD_RA_IMM && loop_operand == 0) ||
            (inst_cur->operand_type == RD_RA     && loop_operand == 0) ||
            (inst_cur->operand_type == RD_IMM    && loop_operand == 0) ||
            (inst_cur->operand_type == RD        && loop_operand == 0)) {
				
            fscanf(ASM_FILE, "%s", reg_dec);
	    regDEC_to_regBIN(reg_dec, reg_bin);

	    for(i=6; i<=10; i++) instruction[i] = reg_bin[i-6];

	    // Go to Next Operand
	    *cur_p += 5;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);
	 }
	 else if((inst_cur->operand_type == RA_RB && loop_operand == 0) ||
                 (inst_cur->operand_type == RB    && loop_operand == 0)) {

            strcpy(reg_bin, "00000");
            for(i=6; i<=10; i++) instruction[i] = reg_bin[i-6];
	 }

	 // Get RA (Source Register A)
	 if((inst_cur->operand_type == RD_RA_RB  && loop_operand == 1) ||
            (inst_cur->operand_type == RD_RA_IMM && loop_operand == 1) ||
            (inst_cur->operand_type == RD_RA     && loop_operand == 1) ||
            (inst_cur->operand_type == RA_RB     && loop_operand == 0) ||
            (inst_cur->operand_type == RA_RB_IMM && loop_operand == 0)) {

            fscanf(ASM_FILE, "%s", reg_dec);
	    regDEC_to_regBIN(reg_dec, reg_bin);

	    for(i=11; i<=15; i++) instruction[i] = reg_bin[i-11];

	    // Go to Next Operand
	    *cur_p += 5;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);
	 }
	 else if((inst_cur->operand_type == RD_IMM && loop_operand == 0) ||
                 (inst_cur->operand_type == RD     && loop_operand == 0) ||
                 (inst_cur->operand_type == RB     && loop_operand == 0)) {
            strcpy(reg_bin, "00000");

	    for(i=11; i<=15; i++) instruction[i] = reg_bin[i-11];
	 }

	 // Get RB (Source Register B)
	 if((inst_cur->operand_type == RD_RA_RB  && loop_operand == 2) ||
            (inst_cur->operand_type == RA_RB     && loop_operand == 1) ||
            (inst_cur->operand_type == RB        && loop_operand == 0) ||
            (inst_cur->operand_type == RA_RB_IMM && loop_operand == 1)) {
				
            fscanf(ASM_FILE, "%s", reg_dec);
	    regDEC_to_regBIN(reg_dec, reg_bin);

	    for(i=16; i<=20; i++) instruction[i] = reg_bin[i-16];

	    // Go to Next Operand
	    *cur_p += 5;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);
	 }
			
	 // Get Immediate
         if((inst_cur->operand_type == RD_RA_IMM && loop_operand == 2) ||
            (inst_cur->operand_type == RD_IMM    && loop_operand == 1)) {

            fscanf(ASM_FILE, "%s", imm_hex);
				
            for(i=1; i<=4; i++) {
               HEXchar_to_BINchar(imm_hex[i], imm_bin);
	       for(j=0; j<=3; j++) instruction[16+((i-1)*4)+j] = imm_bin[j];
	    }
	    
	    // Go to Next Operand
	    *cur_p += 7;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);	
	 }
	 else if((inst_cur->operand_type == RD_RA && loop_operand == 0) ||
                 (inst_cur->operand_type == RD    && loop_operand == 0)) {
            for(i=16; i<=31; i++) instruction[i] = '0';
	 }
			
	 // Get Immediate for Branch Target
	 if((inst_cur->operand_type == RA_RB_IMM && loop_operand == 2)) {
		 
	    fscanf(ASM_FILE, "%s", label_get);
	    cmp_label(label_get, inst_cnt, imm_hex);
		    
	    //fscanf(ASM_FILE, "%s", imm_hex);
	    for(i=1; i<=4; i++) {
	       HEXchar_to_BINchar(imm_hex[i], imm_bin);
	       for(j=0; j<=3; j++) branch_bin[((i-1)*4) + j] = imm_bin[j];
	    }

	    instruction[6]  = branch_bin[0];
	    instruction[7]  = branch_bin[1];
	    instruction[8]  = branch_bin[2];
	    instruction[9]  = branch_bin[3];
	    instruction[10] = branch_bin[4];
				
	    for(i=1; i<=11; i++) instruction[20+i] = branch_bin[4+i];
				
	    // Go to Next Operand
	    *cur_p += strlen(label_get) + 1;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);
	 }
			
	 // Get Target

	 if((inst_cur->operand_type == TARGET && loop_operand == 0)) {
				
            fscanf(ASM_FILE, "%s", label_get);
	    cmp_label(label_get, inst_cnt, target_hex);
	    
	    for(i=1; i<=7; i++) {
	       HEXchar_to_BINchar(target_hex[i], target_bin);
	       for(j=0; j<=3; j++) {
	          if(i == 1) {
		     instruction[6] = target_bin[2];
		     instruction[7] = target_bin[3];
		     j = 4;
		  }
		  else
		     instruction[8 + ((i-2)*4) + j] = target_bin[j];
	       }
	    }
				
	    // Go to Next Operand
	    *cur_p += strlen(label_get) + 1;
	    fseek(ASM_FILE, *cur_p, SEEK_SET);
	 }

	 // Unused : Instruction[21 to 31] = '0'
	 if((inst_cur->operand_type == RD_RA_RB && loop_operand == 0) ||
            (inst_cur->operand_type == RA_RB    && loop_operand == 0) ||
            (inst_cur->operand_type == RB       && loop_operand == 0)) {
				
	    for(i=21; i<=31; i++) instruction[i] = '0';
	 }
			
	 // Operand Type 9 -> Interrupt
	 if(inst_cur->operand_type == NONE && loop_operand == 0)
	    for(i=6; i<=31; i++) instruction[i] = '0';
	 
	 // JL dan JRL Instruction where PC value saved in R31
	 if(inst_cur->link)
	    for(i=6; i<=10; i++) instruction[i] = '1';
		
      } // end for (operand decode)
}

void cur_p_calibrate(int *cur_p) {
   /* 'cur_p' for operand type that ended with register (RD, RA, or RB) must \
    * be subtract by 1.  */
   switch (inst_cur->operand_type) {
      case RD_RA_RB  : *cur_p -= 1; break;
      case RD_RA     : *cur_p -= 1; break;
      case RD        : *cur_p -= 1; break;
      case RA_RB     : *cur_p -= 1; break;
      case RB        : *cur_p -= 1; break;
      default : *cur_p -= 0;
   }
}
