/-!
# Ethica IV

Spinoza's Ethics IV.14 asks what gives true knowledge force over action.
This file pairs a small decision model with a payment-gate example.

The decision model interprets competing motives as scores and should be
read as an analogy to IV.7 and IV.14–16. Spinoza's theory of the affects
is richer than this model.

Source: https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4
-/

namespace EthicaIV

inductive Action where
  | hold
  | submit
  deriving DecidableEq, Repr

/-- Recognition and action selection are explicit, distinct parts of the model. -/
structure Decision where
  recognizesForbidden : Bool
  restraint : Nat
  incentive : Nat
  deriving Repr

/-- Ties select the safe action. A stronger incentive selects submission. -/
def Decision.choose (d : Decision) : Action :=
  if d.restraint < d.incentive then .submit else .hold

/-- IV.14 analogy: restraint changes the decision when it matches or beats the incentive. -/
theorem restraint_controls_choice (d : Decision)
    (strongEnough : d.incentive ≤ d.restraint) :
    d.choose = .hold := by
  simp [Decision.choose, Nat.not_lt.mpr strongEnough]

/-- The selector can submit even after correctly identifying the proposal as forbidden. -/
theorem recognition_allows_violation :
    ∃ d : Decision, d.recognizesForbidden = true ∧ d.choose = .submit := by
  exact ⟨⟨true, 2, 3⟩, rfl, by decide⟩

/-- IV.16 analogy: weakening restraint can let the same incentive win. -/
theorem weaker_restraint_can_flip_choice :
    ∃ immediate future : Decision,
      immediate.recognizesForbidden = true ∧
      future.recognizesForbidden = true ∧
      immediate.incentive = future.incentive ∧
      future.restraint < immediate.restraint ∧
      immediate.choose = .hold ∧ future.choose = .submit := by
  exact ⟨⟨true, 4, 3⟩, ⟨true, 2, 3⟩, rfl, rfl, rfl,
    by decide, by decide, by decide⟩

/-- The transaction is the exact tuple the gate checks and emits. -/
structure Payment where
  invoiceVersion : String
  amountMinor : Nat
  currency : String
  beneficiaryAccount : String
  deriving DecidableEq, Repr

/-- The approvals input represents trusted, valid approvals at execution time. -/
def execute (approvals : List Payment) (request : Payment) : Option Payment :=
  if request ∈ approvals then some request else none

theorem execute_iff (approvals : List Payment) (request effect : Payment) :
    execute approvals request = some effect ↔ request ∈ approvals ∧ request = effect := by
  by_cases approved : request ∈ approvals
  · simp [execute, approved]
  · simp [execute, approved]

/-- Complete mediation is explicit: every recorded effect must come from the gate. -/
theorem executed_payment_has_approval
    (approvals : List Payment) (effects : List Payment)
    (allThroughGate : ∀ effect ∈ effects, ∃ request, execute approvals request = some effect) :
    ∀ effect ∈ effects, effect ∈ approvals := by
  intro effect recorded
  obtain ⟨request, emitted⟩ := allThroughGate effect recorded
  obtain ⟨approved, rfl⟩ := (execute_iff approvals request effect).mp emitted
  exact approved

private def approvedPayment : Payment :=
  ⟨"INV-42:v3", 12500, "EUR", "supplier-account"⟩

example : execute [approvedPayment] approvedPayment = some approvedPayment := by
  decide

example :
    execute [approvedPayment] { approvedPayment with amountMinor := 13000 } = none := by
  decide

example :
    execute [approvedPayment]
      { approvedPayment with beneficiaryAccount := "different-account" } = none := by
  decide

end EthicaIV
