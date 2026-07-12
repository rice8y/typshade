//! Compact alignment used in the README overview.

#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 3mm)
#set text(size: 9pt)

#let protein = ```
!!AA_MULTIPLE_ALIGNMENT 1.0

 MSF: 60  Type: P  Check: 7883  ..

 Name: 1MBO_A        Len:   60  Check: 4087  Weight:  1.00
 Name: 1HHO_A        Len:   60  Check: 5215  Weight:  1.00
 Name: 1HHO_B        Len:   60  Check: 8017  Weight:  1.00
 Name: 2LHB_A        Len:   60  Check: 2391  Weight:  1.00
 Name: 1MBA_A        Len:   60  Check:  964  Weight:  1.00
 Name: 1ECA_A        Len:   60  Check: 7209  Weight:  1.00

//

1MBO_A        ---------V LSEGEWQLVL HVWAKVEADV -AGHGQDILI RLFKSHPETL
1HHO_A        ---------V LSPADKTNVK AAWGKVGAHA -GEYGAEALE RMFLSFPTTK
1HHO_B        --------VH LTPEEKSAVT ALWGKVNV-- -DEVGGEALG RLLVVYPWTQ
2LHB_A        PIVDTGSVAP LSAAEKTKIR SAWAPVYSTY -ETSGVDILV KFFTSTPAA-
1MBA_A        ---------S LSAAEADLAG KSWAPVFANK -NANGLDFLV ALFEKFPDSA
1ECA_A        ---------M LDQQTINIIK AT-VPVLKEH GVTITTTFYK NLFAKHPEVR

1MBO_A        EKFDRF-K-H
1HHO_A        TYFPHF-DLS
1HHO_B        RFFESFGDLS
2LHB_A        ---------Q
1MBA_A        NFFADF-KGK
1ECA_A        PLFDMG-RQE
```.text

#shade(protein)
