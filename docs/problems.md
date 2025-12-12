# Implemented Problems

## Summary Table

|Name  | Description                            |nvar|nobj|Has Jacb?|Convexity                |
|------|----------------------------------------|----|----|---------|-------------------------|
|AAS1  | Amaral, Assunção, Souza, 2025         | 2  | 2  | yes     | [cv, cv]                |
|AAS2  | Amaral, Assunção, Souza, 2025         | 2  | 2  | no      | [cv, cv]                |
|AP1   | Ansary & Panda, 2014         | 2  | 3  | yes     | [n-cv, cv, cv]          |
|AP2   | Ansary & Panda, 2014         | 1  | 2  | yes     | [str cv, str cv]        |
|AP3   | Ansary & Panda, 2014         | 2  | 2  | yes     | [n-cv, n-cv]            |
|AP4   | Ansary & Panda, 2014         | 3  | 3  | yes     | [n-cv, str cv, str cv]  |
|BK1   | Binh, Korn, 1996    | 2  | 2  | yes     | [str cv, str cv]        |
|DD1   | Das, Dennis, 1998 | 5  | 2  | yes     | [str cv, n-cv]          |
|DGO0  | Dumitrescu, Grosan, Oltean, 2000      | 1  | 2  | yes     | [str cv, str cv]        |
|DGO1  | Dumitrescu, Grosan, Oltean, 2000      | 1  | 2  | yes     | [n-cv, n-cv]            |
|DGO2  | Dumitrescu, Grosan, Oltean, 2000      | 1  | 2  | yes     | [str cv, str cv]      |
|DTLZ1 | Deb, Thiele, Laumanns, Zitzler, 2002             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ2 | Deb, Thiele, Laumanns, Zitzler, 2002             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ3 | Deb, Thiele, Laumanns, Zitzler, 2002             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ4 | Deb, Thiele, Laumanns, Zitzler, 2002             | 7  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|DTLZ5 | Deb, Thiele, Laumanns, Zitzler, 2002             | 9  | 5  | yes     | [n-cv x5]               |
|FA1   | Farhang-Mehr, Azarm, 2002   | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|Far1  | Farina, 2002               | 2  | 2  | yes     | [n-cv, n-cv]            |
|FDS   | Fliege, Drummond, Svaiter, 2009          | 5  | 3  | yes     | [str cv x3]             |
|FF1   | Fonseca, Fleming, 1995    | 2  | 2  | yes     | [n-cv, n-cv]            |
|Hil1  | Hillermeier, 2001          | 2  | 2  | yes     | [n-cv, n-cv]            |
|IKK1  | Ikeda, Kita, Kobayashi, 2001         | 2  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|IM1   | Ishibuchi, Murata, 1998   | 2  | 2  | yes     | [n-cv, n-cv]            |
|JOS1  | Jin, Olhofer, Sendhoff, 2001           | 2  | 2  | yes     | [str cv, str cv]        |
|JOS4  | Jin, Olhofer, Sendhoff, 2001           | 20 | 2  | yes     | [n-cv, n-cv]            |
|KW2   | Kim, Weck, 2005        | 2  | 2  | yes     | [n-cv, n-cv]            |
|LE1   | Lis, Eiben, 1997          | 2  | 2  | yes     | [n-cv, n-cv]            |
|Lov1  | Lovison, 2011               | 2  | 2  | yes     | [str cv, str cv]        |
|Lov2  | Lovison, 2011               | 2  | 2  | yes     | [n-cv, n-cv]            |
|Lov3  | Lovison, 2011               | 2  | 2  | yes     | [str cv, n-cv]          |
|Lov4  | Lovison, 2011               | 2  | 2  | yes     | [n-cv, str cv]          |
|Lov5  | Lovison, 2011               | 3  | 2  | yes     | [n-cv, n-cv]            |
|Lov6  | Lovison, 2011               | 6  | 2  | yes     | [n-cv, n-cv]            |
|LTDZ  | Laumanns, Thiele, Deb, Zitzler, 2002  | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|MGH9  | Moré, Garbow, Hillstrom, 1981         | 3  | 15 | yes     | [n-cv ×15]              |
|MGH16 | Moré, Garbow, Hillstrom, 1981         | 4  | 5  | yes     | [cv ×5]                 |
|MGH26 | Moré, Garbow, Hillstrom, 1981         | 4  | 4  | yes     | [n-cv ×4]               |
|MGH33 | Moré, Garbow, Hillstrom, 1981         | 10 | 10 | yes     | [cv ×10]                |
|MHHM1 | Mao, Hirasawa, Hu, Murata, 2000       | 1  | 3  | yes     | [cv, cv, cv]            |
|MHHM2 | Mao, Hirasawa, Hu, Murata, 2000       | 2  | 3  | yes     | [cv, cv, cv]            |
|MLF1  | Molyneaux, Favrat, Leyland, 2001                      | 1  | 2  | yes     | [n-cv, n-cv]            |
|MLF2  | Molyneaux, Favrat, Leyland, 2001                      | 2  | 2  | yes     | [n-cv, n-cv]            |
|MMR1  | Miglierina, Molho, Recchioni, 2008                    | 2  | 2  | yes     | [cv, n-cv]              |
|MMR2  | Miglierina, Molho, Recchioni, 2008                    | 2  | 2  | yes     | [cv, n-cv]              |
|MMR3  | Miglierina, Molho, Recchioni, 2008                    | 2  | 2  | yes     | [n-cv, n-cv]            |
|MMR4  | Miglierina, Molho, Recchioni, 2008                    | 3  | 2  | yes     | [n-cv, cv]              |
|MOP2  | Van Veldhuizen’s (see Huband et al., 2006)             | 2  | 2  | yes     | [cv, cv]                |
|MOP3  | Van Veldhuizen’s (see Huband et al., 2006)             | 2  | 2  | yes     | [n-cv, cv]              |
|MOP5  | Van Veldhuizen’s (see Huband et al., 2006)             | 2  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|MOP6  | Van Veldhuizen’s (see Huband et al., 2006)             | 2  | 2  | yes     | [cv, n-cv]              |
|MOP7  | Van Veldhuizen’s (see Huband et al., 2006)             | 2  | 3  | yes     | [cv, cv, cv]            |
|PNR   | Preuss, Naujoks, Rudolph, 2006        | 2  | 2  | yes     | [n-cv, str cv]          |
|QV1   | Quagliarella, Vicini, 1998           | n  | 2  | yes     | [n-cv, n-cv]            |
|SD    | Stadler, Dauer, 1992                 | 4  | 2  | yes     | [n-cv, str cv]          |
|SK1   | Socha, Kisiel-Dorohinicki, 2002      | 1  | 2  | yes     | [n-cv, n-cv]            |
|SK2   | Socha, Kisiel-Dorohinicki, 2002      | 4  | 2  | yes     | [cv, n-cv]              |
|SLCDT1| Schütze, Laumanns, Coello, Dellnitz, Talbi, 2008 | 2  | 2  | yes     | [n-cv, n-cv]            |
|SLCDT2| Schütze, Laumanns, Coello, Dellnitz, Talbi, 2008 | 10 | 3  | yes     | [n-cv, n-cv, n-cv]      |
|SP1   | Sefrioui, Perlaux, 2000              | 2  | 2  | yes     | [str cv, str cv]        |
|SSFYY2| Shim, Suh, Furukawa, Yagawa, Yoshimura, 2002 | 1 | 2 | yes | [n-cv, str cv]         |
|TKLY1 | Tan, Khor, Lee, Yang, 2003            | 4  | 2  | yes     | [n-cv, n-cv]            |
|Toi4  | Toint, 1983                           | 4  | 2  | yes     | [n-cv, n-cv]            |
|Toi8  | Toint, 1983                           | 3  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|Toi9  | Toint, 1983                           | 4  | 4  | yes     | [n-cv, n-cv, n-cv, n-cv]|
|Toi10 | Toint, 1983                           | 4  | 3  | yes     | [n-cv, n-cv, n-cv]      |
|VU1   | Valenzuela-Rendón, Uresti-Charre, 1997 | 2 | 2 | yes     | [n-cv, str cv]          |
|VU2   | Valenzuela-Rendón, Uresti-Charre, 1997 | 2 | 2 | yes     | [n-cv, str cv]          |
|ZDT1  | Zitzler, Deb, Thiele, 2000         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT2  | Zitzler, Deb, Thiele, 2000         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT3  | Zitzler, Deb, Thiele, 2000         | 30 | 2  | yes     | [cv, n-cv]              |
|ZDT4  | Zitzler, Deb, Thiele, 2000         | 10 | 2  | yes     | [cv, n-cv]              |
|ZDT6  | Zitzler, Deb, Thiele, 2000         | 10 | 2  | yes     | [n-cv, n-cv]            |
|ZLT1  | Zitzler, Laumanns, Thiele, 2001       | 10 | 5  | yes     | [str cv ×5]             |
