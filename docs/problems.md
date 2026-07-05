# Implemented Problems

## Summary Table

The `nvar` and `nobj` columns show the default instance. Dimensions are fixed,
directly variable (`n` selects `nvar`), parametric (DTLZ uses free `k` and `m`),
or coupled (`MGH26` and `Toi9`: `nobj = nvar`; `Toi10`: `nobj = nvar - 1`).
Strict-convexity metadata is shown when available; `—` means the catalog does not expose that metadata for the problem.

|Name  | Description                            |nvar|nobj|Has Jacb?|Strict convexity         |
|------|----------------------------------------|----|----|---------|-------------------------|
|AAS1  | [Amaral, Assunção, Souza, 2025](https://doi.org/10.48550/arXiv.2508.20071)         | 2  | 2  | yes     | — |
|AAS2  | [Amaral, Assunção, Souza, 2025](https://doi.org/10.48550/arXiv.2508.20071)         | 2  | 2  | no      | — |
|AP1   | [Ansary & Panda, 2014](https://doi.org/10.1080/02331934.2014.947500)         | 2  | 3  | yes     | [not str, str, str] |
|AP2   | [Ansary & Panda, 2014](https://doi.org/10.1080/02331934.2014.947500)         | 1  | 2  | yes     | [str, str] |
|AP3   | [Ansary & Panda, 2014](https://doi.org/10.1080/02331934.2014.947500)         | 2  | 2  | yes     | [not str, not str] |
|AP4   | [Ansary & Panda, 2014](https://doi.org/10.1080/02331934.2014.947500)         | 3  | 3  | yes     | [not str, str, str] |
|BK1   | Binh, Korn, 1996 (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))   | 2  | 2  | yes     | [str, str] |
|DD1   | [Das, Dennis, 1998](https://doi.org/10.1137/S1052623496307510) | 5  | 2  | yes     | [str, not str] |
|DGO0  | Dumitrescu, Grosan, Oltean, 2000  (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))    | 1  | 2  | yes     | — |
|DGO1  | Dumitrescu, Grosan, Oltean, 2000  (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))    | 1  | 2  | yes     | [not str, not str] |
|DGO2  | Dumitrescu, Grosan, Oltean, 2000  (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))    | 1  | 2  | yes     | [str, str] |
|DTLZ1 | [Deb, Thiele, Laumanns, Zitzler, 2002](https://doi.org/10.1007/1-84628-137-7_6)             | 7  | 3  | yes     | [not str ×3] |
|DTLZ2 | [Deb, Thiele, Laumanns, Zitzler, 2002](https://doi.org/10.1007/1-84628-137-7_6)             | 7  | 3  | yes     | [not str ×3] |
|DTLZ3 | [Deb, Thiele, Laumanns, Zitzler, 2002](https://doi.org/10.1007/1-84628-137-7_6)             | 7  | 3  | yes     | [not str ×3] |
|DTLZ4 | [Deb, Thiele, Laumanns, Zitzler, 2002](https://doi.org/10.1007/1-84628-137-7_6)             | 7  | 3  | yes     | [not str ×3] |
|DTLZ5 | [Deb, Thiele, Laumanns, Zitzler, 2002](https://doi.org/10.1007/1-84628-137-7_6)             | 9  | 5  | yes     | [not str ×5] |
|FA1   | [Farhang-Mehr, Azarm, 2002](https://doi.org/10.1109/CEC.2002.1007015)  | 3  | 3  | yes     | [not str, not str, not str] |
|Far1  | [Farina, 2002](https://doi.org/10.1109/CEC.2002.1007054)         | 2  | 2  | yes     | [not str, not str] |
|FDS   | [Fliege, Drummond, Svaiter, 2009](https://doi.org/10.1137/08071692X)      | 5  | 3  | yes     | [str, str, str] |
|FF1   | [Fonseca, Fleming, 1995](https://doi.org/10.1162/evco.1995.3.1.1)   | 2  | 2  | yes     | [not str, not str] |
|Hil1  | [Hillermeier, 2001](https://doi.org/10.1023/A:1017536311488)        | 2  | 2  | yes     | [not str, not str] |
|IKK1  | [Ikeda, Kita, Kobayashi, 2001](https://doi.org/10.1109/CEC.2001.934293)     | 2  | 3  | yes     | [not str, not str, not str] |
|IM1   | [Ishibuchi, Murata, 1998](https://doi.org/10.1109/5326.704576)   | 2  | 2  | yes     | [not str, not str] |
|JOS1  | Jin, Olhofer, Sendhoff, 2001           | 2  | 2  | yes     | [str, str] |
|JOS4  | Jin, Olhofer, Sendhoff, 2001           | 20 | 2  | yes     | [not str, not str] |
|KW2   | [Kim, Weck, 2005](https://doi.org/10.1007/s00158-004-0465-1)   | 2  | 2  | yes     | [not str, not str] |
|LE1   | [Lis, Eiben, 1997](https://doi.org/10.1109/ICEC.1997.592269)     | 2  | 2  | yes     | [not str, not str] |
|Lov1  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 2  | 2  | yes     | [str, str] |
|Lov2  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 2  | 2  | yes     | [not str, not str] |
|Lov3  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 2  | 2  | yes     | [str, not str] |
|Lov4  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 2  | 2  | yes     | [not str, str] |
|Lov5  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 3  | 2  | yes     | [not str, not str] |
|Lov6  | [Lovison, 2011](https://doi.org/10.1137/100784746)        | 6  | 2  | yes     | [not str, not str] |
|LTDZ  | [Laumanns, Thiele, Deb, Zitzler, 2002](https://doi.org/10.1162/106365602760234108) | 3  | 3  | yes     | [not str, not str, not str] |
|MGH9  | [Moré, Garbow, Hillstrom, 1981](https://doi.org/10.1145/355934.355936)       | 3  | 15 | yes     | [not str ×15] |
|MGH16 | [Moré, Garbow, Hillstrom, 1981](https://doi.org/10.1145/355934.355936)         | 4  | 5  | yes     | [not str, not str, not str, not str, not str] |
|MGH26 | [Moré, Garbow, Hillstrom, 1981](https://doi.org/10.1145/355934.355936)         | 4  | 4  | yes     | [not str ×4] |
|MGH33 | [Moré, Garbow, Hillstrom, 1981](https://doi.org/10.1145/355934.355936)         | 10 | 10 | yes     | [not str ×10] |
|MHHM1 | [Mao, Hirasawa, Hu, Murata, 2000](https://doi.org/10.1109/ROMAN.2000.892484)     | 1  | 3  | yes     | — |
|MHHM2 | [Mao, Hirasawa, Hu, Murata, 2000](https://doi.org/10.1109/ROMAN.2000.892484)       | 2  | 3  | yes     | [str, str, str] |
|MLF1  | [Molyneaux, Favrat, Leyland, 2001](https://infoscience.epfl.ch/handle/20.500.14299/215484) | 1  | 2  | yes     | [not str, not str] |
|MLF2  | [Molyneaux, Favrat, Leyland, 2001](https://infoscience.epfl.ch/handle/20.500.14299/215484) | 2  | 2  | yes     | [not str, not str] |
|MMR1  | [Miglierina, Molho, Recchioni, 2008](https://doi.org/10.1016/j.ejor.2007.05.015) | 2  | 2  | yes     | [not str, not str] |
|MMR2  | [Miglierina, Molho, Recchioni, 2008](https://doi.org/10.1016/j.ejor.2007.05.015) | 2  | 2  | yes     | [not str, not str] |
|MMR3  | [Miglierina, Molho, Recchioni, 2008](https://doi.org/10.1016/j.ejor.2007.05.015) | 2  | 2  | yes     | [not str, not str] |
|MMR4  | [Miglierina, Molho, Recchioni, 2008](https://doi.org/10.1016/j.ejor.2007.05.015) | 3  | 2  | yes     | [not str, not str] |
|MOP2  | Van Veldhuizen’s (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))          | 2  | 2  | yes     | [not str, not str] |
|MOP3  | Van Veldhuizen’s (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))             | 2  | 2  | yes     | [not str, str] |
|MOP5  | Van Veldhuizen’s (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))             | 2  | 3  | yes     | [not str, not str, not str] |
|MOP6  | Van Veldhuizen’s (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))             | 2  | 2  | yes     | [not str, not str] |
|MOP7  | Van Veldhuizen’s (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417))             | 2  | 3  | yes     | [str, str, str] |
|PNR   | [Preuss, Naujoks, Rudolph, 2006](https://doi.org/10.1007/11844297_52)     | 2  | 2  | yes     | [not str, str] |
|QV1   | [Quagliarella, Vicini, 1998](https://doi.org/10.1109/ICSMC.1998.726485)           | 16 | 2  | yes     | [not str, not str] |
|SD    | [Stadler, Dauer, 1992](https://doi.org/10.2514/5.9781600866234.0209.0249)            | 4  | 2  | yes     | [not str, str] |
|SK1   | [Socha, Kisiel-Dorohinicki, 2002](https://doi.org/10.1109/CEC.2002.1006218)    | 1  | 2  | yes     | [not str, not str] |
|SK2   | [Socha, Kisiel-Dorohinicki, 2002](https://doi.org/10.1109/CEC.2002.1006218)    | 4  | 2  | yes     | [str, not str] |
|SLCDT1| [Schütze, Laumanns, Coello, Dellnitz, Talbi, 2008](https://doi.org/10.1007/s10898-007-9265-7) | 2  | 2  | yes     | [not str, not str] |
|SLCDT2| [Schütze, Laumanns, Coello, Dellnitz, Talbi, 2008](https://doi.org/10.1007/s10898-007-9265-7) | 10 | 3  | yes     | [not str, not str, not str] |
|SP1   | [Sefrioui, Perlaux, 2000](https://doi.org/10.1109/CEC.2000.870339)           | 2  | 2  | yes     | [str, str] |
|SSFYY2| [Shim, Suh, Furukawa, Yagawa, Yoshimura, 2002](https://doi.org/10.1108/02644400210413649) | 1 | 2 | yes | [not str, str] |
|TKLY1 | [Tan, Khor, Lee, Yang, 2003](https://doi.org/10.1023/A:1022863019997)     | 4  | 2  | yes     | [not str, not str] |
|Toi4  | [Toint, 1983](https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf)     | 4  | 2  | yes     | [not str, not str] |
|Toi8  | [Toint, 1983](https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf)     | 3  | 3  | yes     | [not str ×3] |
|Toi9  | [Toint, 1983](https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf)     | 4  | 4  | yes     | [not str ×4] |
|Toi10 | [Toint, 1983](https://perso.unamur.be/~phtoint/pubs/TR83-04.pdf)     | 4  | 3  | yes     | [not str ×3] |
|VU1   | Valenzuela-Rendón, Uresti-Charre, 1997 (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417)) | 2 | 2 | yes     | [not str, str] |
|VU2   | Valenzuela-Rendón, Uresti-Charre, 1997 (see [Huband et al., 2006](https://doi.org/10.1109/TEVC.2005.861417)) | 2 | 2 | yes     | [not str, str] |
|ZDT1  | [Zitzler, Deb, Thiele, 2000](https://doi.org/10.1162/106365600568202)    | 30 | 2  | yes     | [not str, not str] |
|ZDT2  | [Zitzler, Deb, Thiele, 2000](https://doi.org/10.1162/106365600568202)         | 30 | 2  | yes     | [not str, not str] |
|ZDT3  | [Zitzler, Deb, Thiele, 2000](https://doi.org/10.1162/106365600568202)         | 30 | 2  | yes     | [not str, not str] |
|ZDT4  | [Zitzler, Deb, Thiele, 2000](https://doi.org/10.1162/106365600568202)         | 10 | 2  | yes     | [not str, not str] |
|ZDT6  | [Zitzler, Deb, Thiele, 2000](https://doi.org/10.1162/106365600568202)         | 10 | 2  | yes     | [not str, not str] |
|ZLT1  | [Zitzler, Laumanns, Thiele, 2001](https://api.semanticscholar.org/CorpusID:16584254)       | 10 | 5  | yes     | [str, str, str, str, str] |

For more information on the problems, see the [References and Citations](references.md).
