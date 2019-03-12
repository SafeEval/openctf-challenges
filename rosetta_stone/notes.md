- Challenge: Rosetta Stone
- Author: Jack Sullivan
- Flag: `f1@g[L1n3@g3_Tr1but3]`

## Summary

This is an obfuscation challenge composed of three interlocking puzzles,
refered to as "upper," "middle," and "lower." Each puzzle contains logic of
some sort that has a default output, and a keyed output.


## Steps

1. Use a simple wordlist and brute force the PDF password, `monkey`.

       pdfcrack -w wordlist.txt -f rosetta_stone.pdf

2. OCR pages 6 through 66.
3. The OCR'd text contains 


## Assembly

Combine the three PDFs:

    sudo apt-get install imagemagick
    convert *.pdf rosetta_stone.pdf

Password protect the PDF:

    sudo apt-get install pdftk
    pdftk rosetta_stone.pdf output rosetta.pdf user_pw PROMPT

Crack the PDF:

    sudo apt-get install pdfcrack
    pdfcrack -w wordlist.txt -f rosetta_stone.pdf


## Integration

P = Program 

    Pu = Upper section, PLA circuits. Nulls give lower key.   Key bits gives flag1.
    Pm = Middle section, ASM code.    Jump gives upper key.   String gives flag2.
    Pl = Lower section, Cobol.        Jump gives middle key.  5 integers gives flag3.

D = Default Outputs

    Du = PLA default. All zeros give Km
    Dm = ASM default.
    Dl = Cobol default. pull the plug to power me up  (all 0 to circuit for Kl)

K = key data, output from programs with a modified jump

    Ku = PLA key.     pwnme                 from Pm ASM
    Km = ASM key.     OGDecod3r             from Pl Cobol
    Kl = Cobol key.   205,179,171,250,221   from Pu Circuit

F = flag text, output from programs with modified jump, and given a key K

    Fu = PLA flag piece.    f1@g[
    Fm = ASM flag piece.    L1n3@g3_
    Fl = Cobol flag piece.  Tr1but3]


## Value Mappings

Programs default hint text

- Pu(): Du
- Pm(): Dm
- Pl(): Dl

Programs give keys to other programs

- Pu(): Kl
- Pm(): Ku
- Pl(): Km

Programs turn keys into flags

- Pu(Ku): Fu
- Pm(Km): Fm
- Pl(Kl): Fl


## Sub-Flag Representations

Item | ASCII    | Hexadecimal             | Binary
-----|----------|-------------------------|-------------------------------------------------------------------------
Fu   | `f1@g[`    | 66 31 40 67 5b          | 01100110 00110001 01000000 01100111 01011011
-----|----------|-------------------------|-------------------------------------------------------------------------
     |          | 663140675b              | 0110011000110001010000000110011101011011
-----|----------|-------------------------|-------------------------------------------------------------------------
Fm   | `L1n3@g3_` | 4c 31 6e 33 40 67 33 5f | 01001100 00110001 01101110 00110011 01000000 01100111 00110011 01011111
-----|----------|-------------------------|-------------------------------------------------------------------------
     |          | 4c316e334067335f        | 0100110000110001011011100011001101000000011001110011001101011111
-----|----------|-------------------------|-------------------------------------------------------------------------
Fl   | `Tr1but3]` | 54 72 31 62 75 74 33 5d | 01010100 01110010 00110001 01100010 01110101 01110100 00110011 01011101
-----|----------|-------------------------|-------------------------------------------------------------------------
     |          | 547231627574335d        | 0101010001110010001100010110001001110101011101000011001101011101


## Upper: Logic Circuits (PLAs)

- Flag fragment: `f1@g[`
- Key: `pwnme`
- Key source: middle
- Emits key: lower


### Key Upper Input to Flag Upper Output

Ku -> Fu
Key upper input to upper (Ku): x = `pwnme`
Flag output from upper (Fu): z = `f1@g[`

```
u0 x:	p |	0 1 1 1 0 0 0 0
      --|----------------
u0 z:	f |	0 1 1 0 0 1 1 0


u1 x:	w	| 0 1 1 1 0 1 1 1
      --|----------------
u1 z:	1	| 0 0 1 1 0 0 0 1


u2 x:	n	| 0 1 1 0 1 1 1 0
      --|----------------
u2 z:	@	| 0 1 0 0 0 0 0 0		


u3 x:	m	| 0 1 1 0 1 1 0 1		
      --|----------------
u3 z:	g	| 0 1 1 0 0 1 1 1		


u4 x:	e	| 0 1 1 0 0 1 0 1		
      --|----------------
u4 z:	[	| 0 1 0 1 1 0 1 1		
```

### Null Input to Key Lower Output

N -> Kl		
Null input to upper (N): x = `00000000`
Key lower (Kl) output from upper: z = `0xcdb3abfadd`

```
u0 x:	0 | 0 0 0 0 0 0 0 |
      --|---------------|---------
u0 z:	1 | 1 0 0 1 1 0 1	| 205	| cd	


u1 x:	0 | 0 0 0 0 0 0 0 |
      --|---------------|---------
u1 z:	1 | 0 1 1 0 0 1 1	| 179	| b3


u2 x:	0 | 0 0 0 0 0 0 0 |
      --|---------------|---------
u2 z:	1 | 0 1 0 1 0 1 1	| 171	| ab


u3 x:	0 | 0 0 0 0 0 0 0 |
      --|---------------|---------
u3 z:	1 | 1 1 1 1 0 1 0	| 250	| fa


u4 x:	0 | 0 0 0 0 0 0 0 |
      --|---------------|---------
u4 z:	1 | 1 0 1 1 1 0 1	| 221	| dd
```


## Middle: ASM Code

- Flag fragment: `L1n3@g3_`
- Key: `OGDecod3r`
- Key source: lower
- Emits key: `pwnme` (upper)

- Emits default: `Original source-orer`

### Pseudo Code

```
def middle( string ):

  # Initialize the Kl values
  k0-k4 = 0

  # Print the Dl message and exit
  default = "Pull the plug to power me up."
  print( default )
  return 0

  # Construct the ASM key, Km.
  [0]    O -> 79   = (11*7)+2
  [1]    G -> 71   = 79  -  8
  [2]      -> 32   = 71  - 39
  [3]    D -> 68   = 32  + 36
  [4]    e -> 101  = 68  + 33
  [5]    c -> 99   = 101 -  2
  [6]    o -> 111  = 99  + 12
  [7]    d -> 100  = 111 - 11
  [8]    e -> 101  = 100 +  1
  [9]    r -> 114  = 101 + 13

  # Print Km, and exit.
  print( asmkey ) <OG Decoder>
  return 0
```


