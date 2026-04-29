#import "../package/lib.typ": *

#set page(width: auto, height: auto, margin: 8pt)
#set text(size: 8pt)

#let protein-source = read("fixtures/tiny-protein.fasta", encoding: none)
#let dna-source = read("fixtures/tiny-dna.fasta", encoding: none)
#let msf-source = read("fixtures/tiny.msf", encoding: none)
#let aln-source = read("fixtures/tiny.aln", encoding: none)
#let pdb-source = read("fixtures/tiny.pdb", encoding: none)

#let protein = alignment-data(protein-source, format: "fasta")
#assert.eq(protein.at("format"), "FASTA")
#assert.eq(protein.at("seq-type"), "P")
#assert.eq(protein.at("columns"), 4)
#assert.eq(protein.at("sequences").len(), 4)
#assert.eq(protein.at("sequences").at(0).at("name"), "Alpha")
#assert.eq(protein.at("sequences").at(0).at("aligned"), "AEF-")
#assert.eq(protein.at("sequences").at(0).at("raw"), "AEF")
#assert.eq(protein.at("sequences").at(0).at("positions"), (1, 2, 3, none))
#assert.eq(protein.at("sequences").at(3).at("name"), "seq4")

#let dna = alignment-data(dna-source, format: "fasta")
#assert.eq(dna.at("format"), "FASTA")
#assert.eq(dna.at("seq-type"), "N")
#assert.eq(dna.at("sequences").len(), 2)

#let msf = alignment-data(msf-source, format: "msf")
#assert.eq(msf.at("format"), "MSF")
#assert.eq(msf.at("seq-type"), "P")
#assert.eq(msf.at("columns"), 4)
#assert.eq(msf.at("sequences").len(), 2)
#assert.eq(msf.at("sequences").at(0).at("name"), "Alpha")
#assert.eq(msf.at("sequences").at(1).at("name"), "Beta")
#assert.eq(msf.at("sequences").map(seq => seq.at("name")).contains("Hidden"), false)

#let aln = alignment-data(aln-source, format: "aln")
#assert.eq(aln.at("format"), "ALN")
#assert.eq(aln.at("columns"), 4)
#assert.eq(aln.at("sequences").len(), 3)
#assert.eq(aln.at("sequences").at(2).at("name"), "Gamma")

#assert.eq(parse-alignment(">A\nACGT\n>B\nA-GT\n", format: "fasta").at("columns"), 4)
#assert.eq(parse-alignment("Alpha AEF-\nBeta ADF-\n", format: "aln").at("sequences").len(), 2)

#assert.eq(selection-preview(protein-source, 1, "1..2", format: "fasta"), "1,2")
#assert.eq(selection-preview(protein-source, "Alpha", "E", format: "fasta"), "2")
#assert.eq(selection-preview(protein-source, 1, "A[ED]", format: "fasta"), "1,2")
#assert.eq(selection-preview(protein-source, 3, "1..3", format: "fasta"), "1,2")

#assert.eq(percent-identity(protein-source, 1, 2, format: "fasta"), 66.7)
#assert.eq(percent-similarity(protein-source, 1, 2, format: "fasta"), 100.0)
#assert.eq(percent-identity(protein-source, 1, 3, format: "fasta"), 50.0)
#assert.eq(percent-identity(protein-source, "Alpha", "Beta", selection: "1..2", format: "fasta"), 50.0)

#let point = pdb-point(pdb-source, 1, distance: 0.2, atom: "CA")
#let line = pdb-line(pdb-source, 1, 2, distance: 0.2, atom-a: "CA", atom-b: "CA")
#let plane = pdb-plane(pdb-source, 1, 2, 3, distance: 0.2, atom-a: "CA", atom-b: "CA", atom-c: "CA")
#assert.eq(pdb-selection(point), "1")
#assert.eq(pdb-selection(line), "1,2")
#assert.eq(pdb-selection(plane), "1,2,3")

== Analysis Tables

#alignment-summary(protein-source, format: "fasta")

#sequence-list(protein-source, format: "fasta")

#selection-table(
  protein-source,
  (name: "Acidic motif", selection: "E"),
  (name: "First two", selection: "1..2"),
  format: "fasta",
)

#similarity-table(protein-source, format: "fasta")
