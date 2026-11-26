import Ethica.Pars1.Definitions

/-!
# Part IV, Proposition 8

A conditional reconstruction for one subject and the affects of joy and sadness.
Spinoza's IV.8 starts with what helps or hinders a thing's preservation,
then relates changes in power to affect and awareness.

The premises below record the fragments used by this reconstruction.
Their names indicate the passages they interpret. The proof of IV.8
does not supply independent proofs of those premises.

Source: https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4#Prop._VIII.
-/

namespace EthicaIV.Pars4

inductive Valence where
  | joy
  | sadness

/-- A model of the relevant concepts for a single subject.
    Each affect has a represented cause and a direction of change. -/
structure AffectModel (Thing Affect Idea : Type) where
  subject : Thing
  cause : Affect → Thing
  valence : Affect → Valence
  helpsPreserve : Thing → Thing → Prop
  hindersPreserve : Thing → Thing → Prop
  increasesPower : Thing → Thing → Prop
  diminishesPower : Thing → Thing → Prop
  consciousOf : Idea → Affect → Prop
  sameModification : Idea → Affect → Prop

variable {Thing Affect Idea : Type}

def Good (m : AffectModel Thing Affect Idea) (cause : Thing) : Prop :=
  m.helpsPreserve m.subject cause

def Evil (m : AffectModel Thing Affect Idea) (cause : Thing) : Prop :=
  m.hindersPreserve m.subject cause

/-- The source of an affect falls under the corresponding evaluation. -/
def EvaluatedCause (m : AffectModel Thing Affect Idea) (affect : Affect) : Prop :=
  match m.valence affect with
  | .joy => Good m (m.cause affect)
  | .sadness => Evil m (m.cause affect)

structure Proposition8Premises [Ethica.Pars1.EthicaWorld Thing]
    (m : AffectModel Thing Affect Idea) : Prop where
  subjectIsMode : Ethica.Pars1.Mode m.subject
  /-- Fragment of III.7 as applied in IV.8. -/
  iii7_preservationOfMode : Ethica.Pars1.Mode m.subject →
    ∀ cause : Thing,
      (m.helpsPreserve m.subject cause ↔ m.increasesPower m.subject cause) ∧
      (m.hindersPreserve m.subject cause ↔ m.diminishesPower m.subject cause)
  /-- Direction of the change associated with joy and sadness, following III.11. -/
  iii11_affectDirection : ∀ affect : Affect,
    match m.valence affect with
    | .joy => m.increasesPower m.subject (m.cause affect)
    | .sadness => m.diminishesPower m.subject (m.cause affect)
  /-- Fragment of II.22 used for awareness of an affect. -/
  ii22_awareness : ∀ affect : Affect, ∃ idea : Idea, m.consciousOf idea affect
  /-- Fragment of II.21 and its scholium used in IV.8.
      The idea and affect concern the same modification. -/
  ii21_sameModification : ∀ (idea : Idea) (affect : Affect),
    m.consciousOf idea affect → m.sameModification idea affect

/-- IV.8, conditionally. Awareness concerns the same modification as the
    affect, and the affect's represented cause is good or evil in the
    corresponding sense of preservation. -/
theorem proposition8 [Ethica.Pars1.EthicaWorld Thing]
    (m : AffectModel Thing Affect Idea) (premises : Proposition8Premises m)
    (affect : Affect) :
    ∃ idea : Idea,
      m.consciousOf idea affect ∧ m.sameModification idea affect ∧
      EvaluatedCause m affect := by
  obtain ⟨idea, aware⟩ := premises.ii22_awareness affect
  refine ⟨idea, aware, premises.ii21_sameModification idea affect aware, ?_⟩
  have preservation := premises.iii7_preservationOfMode premises.subjectIsMode (m.cause affect)
  have direction := premises.iii11_affectDirection affect
  cases valenceEq : m.valence affect with
  | joy =>
    simpa [EvaluatedCause, valenceEq, Good] using
      preservation.1.mpr (by simpa [valenceEq] using direction)
  | sadness =>
    simpa [EvaluatedCause, valenceEq, Evil] using
      preservation.2.mpr (by simpa [valenceEq] using direction)

end EthicaIV.Pars4
