#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)
#set text(size: 9pt)

#let protein = ">AQP1.PRO\nTLGLLLSCQISILRAVMYIIAQCVGAIVASAIL\n>AQP2.PRO\nTVACLVGCHVSFLRAAFYVAAQLLGAVAGAAIL\n>AQP3.PRO\nTFAMCFLAREPWIKLPIYTLAQTLGAFLGAGIV\n>AQP4.PRO\nTVAMVCTRKISIAKSVFYITAQCLGAIIGAGIL\n>AQP5.PRO\nTLALLIGNQISLLRAVFYVAAQLVGAIAGAGIL\n"

#shade(
  protein,
  format: "fasta",
  theme: "screen",
  commands: (
    similar(colors: "blues", threshold: 45),
    lines(34),
    ruler("top", sequence: 1, every: 10),
    consensus("bottom", scale: "ColdHot", name: "consensus"),
    motif(1, "NPA", text: "motif", bg: "BrickRed", fill: "LightYellow"),
    legend(),
  ),
)
