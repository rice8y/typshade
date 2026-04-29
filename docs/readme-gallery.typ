#import "../package/lib.typ": *

#set page(width: 184mm, height: auto, margin: 8mm, fill: white)
#set text(size: 8pt)

#let protein = ">AQP1.PRO\nTLGLLLSCQISILRAVMYIIAQCVGAIVASAIL\n>AQP2.PRO\nTVACLVGCHVSFLRAAFYVAAQLLGAVAGAAIL\n>AQP3.PRO\nTFAMCFLAREPWIKLPIYTLAQTLGAFLGAGIV\n>AQP4.PRO\nTVAMVCTRKISIAKSVFYITAQCLGAIIGAGIL\n>AQP5.PRO\nTLALLIGNQISLLRAVFYVAAQLVGAIAGAGIL\n"
#let dna = ">AQP1nuc.SEQ\nCCTGGGCATTGAGATCATTGGCACCCTGCA\n>AQP2nuc.SEQ\nTGTGACTGTAGAGCTCTTCCTGACCATGCA\n>AQP3nuc.SEQ\n.CCAATGGCACAGCTGGTATC..TTTGCCA\n>AQP4nuc.SEQ\nGCTCCTGGTGGAGCTAATAATCACTTTCCA\n>AQP5nuc.SEQ\nCATGGTGGTGGAGTTAATCTTGACTTTCCA\n"
#let bars = "1: 24, -12, 8\n2: 42, -30, 16\n3: 18, -18, 28\n4: 36, -8, 12\n5: 12, -26, 20\n6: 32, -20, 30\n7: 16, -16, 12\n8: 46, -22, 8\n9: 26, -12, 18\n10: 20, -18, 24\n11: 34, -24, 10\n12: 28, -16, 18\n"

#shade(
  protein,
  format: "fasta",
  theme: "screen",
  commands: (
    similar(colors: "blues", threshold: 45),
    lines(34),
    ruler("top", sequence: 1, every: 10),
    consensus("bottom", scale: "ColdHot", name: "conservation"),
    motif(1, "NPA", text: "active site", bg: "BrickRed", fill: "LightYellow"),
    motif(1, "NXX[ST]N", text: "motif", bg: "RoyalBlue", fill: "LightYellow"),
    legend(),
  ),
)

#pagebreak()

#shade(
  protein,
  format: "fasta",
  theme: "screen",
  commands: (
    functional("hydropathy"),
    shade-all-residues(),
    lines(34),
    ruler("top", sequence: 1, every: 10),
    consensus("bottom"),
    legend(),
  ),
)

#pagebreak()

#shade(
  dna,
  format: "fasta",
  theme: "print",
  commands: (
    lines(30),
    functional("DNA"),
    sequence-logo(position: "top", colors: "DNA", name: "logo", scale: "leftright", stretch: 1.15),
    consensus("bottom", scale: "ColdHot", name: "conservation"),
    ruler("bottom", sequence: 1, every: 5),
  ),
)
