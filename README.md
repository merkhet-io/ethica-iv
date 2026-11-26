# Ethica IV

A small Lean 4 project inspired by Spinoza’s *Ethics*, Part IV. It asks what connects an agent’s recognition of a rule to the action it selects and to the effect the system ultimately permits.

## The connection to Spinoza

In [IV.14](https://spinozaatlas.com/en/text/ethics.IV.P14), Spinoza argues that true knowledge of good and evil can restrain an affect insofar as that knowledge itself acts as an affect. The argument draws on [IV.7](https://spinozaatlas.com/en/text/ethics.IV.P7), which requires a stronger opposing affect. In IV.15–16, he considers how competing desires can overpower a desire grounded in knowledge, especially when that knowledge concerns the future. [Read Part IV](https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4#Prop._XIV.)

This project uses that distinction as an analogy for one narrow alignment question. When an agent reports that an action is forbidden, what makes the decision procedure or the execution system respect the rule? The Lean model uses natural-number scores and a tie-break that favors holding. Those are modeling choices. In particular, holding on a tie is a property of this selector, while Spinoza’s IV.7 speaks of a strictly stronger opposing affect.

## A conditional reconstruction of IV.8

In [IV.8](https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4#Prop._VIII.), Spinoza identifies knowledge of good and evil with joy or sadness insofar as we are conscious of it. This is a premise of IV.14. The reconstruction in [`Proposition8.lean`](EthicaIV/Pars4/Proposition8.lean) models one subject and uses Nakamura’s Part I definition of a mode for that subject.

| Source | Role in the Lean reconstruction |
| --- | --- |
| I, definition 5 | The subject is assumed to be a mode, using Nakamura’s definition. |
| III.7 and IV, definitions 1–2 | Helping or hindering preservation is linked to increasing or diminishing power. The local definitions of good and evil use preservation. |
| III.11 and its scholium | Joy and sadness are associated with changes in power in opposite directions. |
| II.21–22 | An affect has a conscious idea, and that idea concerns the same modification as the affect. |

The Parts II and III fragments are explicit fields of `Proposition8Premises`. From them, `proposition8` derives that each modeled affect has a conscious idea of the same modification and a cause classified as good or evil for the subject, according to the affect’s direction. The relation “concerns the same modification” is a modeling primitive. The theorem gives a conditional result for this reading of IV.8. A reconstruction of IV.14 and proofs of the named premises remain open.

## Alignment examples

The examples in [`EthicaIV.lean`](EthicaIV.lean) use a separate decision model. Recognizing that an action is forbidden adds a configurable amount to the restraint score. The choice depends on that total and the competing incentive.

| Result | What Lean proves |
| --- | --- |
| `effective_restraint_controls_choice` | The selector returns `hold` whenever effective restraint is at least the incentive. Baseline restraint alone also suffices if it already meets that threshold. |
| `recognition_can_change_choice` | With baseline restraint 2, incentive 3, and recognition weight 2, flipping only the recognition flag changes `submit` to `hold`. |
| `recognition_can_be_outweighed` | With the same positive recognition contribution and an incentive of 5, total restraint is 4 and the selector still returns `submit`. |
| `weaker_restraint_can_flip_choice` | With recognition and incentive fixed, reducing baseline restraint can change `hold` to `submit`. The example illustrates the weaker-restraint idea in IV.16 using scores. |
| `execute_iff` | The payment gate returns an effect exactly when the request is on the approval list and the effect equals the request. Equality covers invoice version, amount in minor units, currency, and beneficiary account. |
| `executed_payment_has_approval` | Given a list of effects and the premise that each effect came from the gate under the same approval list, every effect is on that list. |

The recognition flag is supplied to the model. The decision example explores the consequences of assigning recognition a weight. The payment gate separately takes a concrete request and returns an optional payment value. Its examples accept an exact match and reject changes to the amount or beneficiary account.

## Scope of the guarantee

The gate treats its approval list as a trusted snapshot. The proof assumes **complete mediation**, meaning every effect under consideration came from a successful gate call. In a deployment, establishing that premise would require connecting the gate output to the payment actually recorded by the payment system. Approval issuance, expiry, revocation, replay protection, and the ERP integration are outside the current model.

The result is a conditional guarantee about approval matching. The philosophical claims about human affects and the broader alignment of any AI system remain outside its scope.

## Build

Install [Elan](https://github.com/leanprover/elan) and run from the repository root.

```sh
lake build
```

The project pins Lean 4.19.0 and a specific revision of Nakamura’s Lean package. Lake fetches that dependency on the first build. The project does not require Mathlib.

## Related work

Yuki Nakamura’s [*Spinoza’s Ethica in Lean 4*](https://github.com/Nakammura/spinoza-ethica-lean) reconstructs selected arguments from Part I. The [companion paper](https://arxiv.org/abs/2605.02331) uses countermodels to test what follows from particular formalizations of the Principle of Sufficient Reason.
