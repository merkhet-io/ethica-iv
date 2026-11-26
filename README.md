# Ethica IV

A small Lean 4 project inspired by Spinoza’s *Ethics*, Part IV. It asks what connects an agent’s recognition of a rule to the action it selects and to the effect the system ultimately permits.

## The connection to Spinoza

In [IV.14](https://spinozaatlas.com/en/text/ethics.IV.P14), Spinoza argues that true knowledge of good and evil can restrain an affect insofar as that knowledge itself acts as an affect. The argument draws on [IV.7](https://spinozaatlas.com/en/text/ethics.IV.P7), which requires a stronger opposing affect. In IV.15–16, he considers how competing desires can overpower a desire grounded in knowledge, especially when that knowledge concerns the future. [Read Part IV](https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4#Prop._XIV.)

This project uses that distinction as an analogy for one narrow alignment question. When an agent reports that an action is forbidden, what makes the decision procedure or the execution system respect the rule? The Lean model uses natural-number scores and a tie-break that favors holding. Those are modeling choices. In particular, holding on a tie is a property of this selector, while Spinoza’s IV.7 speaks of a strictly stronger opposing affect.

## What Lean checks

The model is in [`EthicaIV.lean`](EthicaIV.lean).

| Result | What the code establishes |
| --- | --- |
| `restraint_controls_choice` | The selector returns `hold` whenever the restraint score is at least the incentive score. |
| `recognition_allows_violation` | There is a decision with `recognizesForbidden = true` that returns `submit`. The selector reads the two scores only. The recognition flag is an input, with no independent policy evaluation in the model. |
| `weaker_restraint_can_flip_choice` | With recognition and incentive fixed, lowering restraint from 4 to 2 changes `hold` to `submit` when the incentive is 3. This example uses two score assignments to illustrate IV.16. Time and discounting are outside the model. |
| `execute_iff` | The payment gate returns an effect exactly when the request is on the approval list and the effect equals the request. Equality covers invoice version, amount in minor units, currency, and beneficiary account. |
| `executed_payment_has_approval` | Given a list of effects and the premise that each effect came from the gate under the same approval list, every effect is on that list. |

The two models are separate. The decision model ends at `hold` or `submit`. The payment gate takes a concrete request and returns an optional payment value. The examples accept an exact match and reject requests that change the amount or beneficiary account.

## Scope of the guarantee

The gate treats its approval list as a trusted snapshot. The proof assumes **complete mediation**, meaning every effect under consideration came from a successful gate call. In a deployment, establishing that premise would require connecting the gate output to the payment actually recorded by the payment system. Approval issuance, expiry, revocation, replay protection, and the ERP integration are outside the current model.

The result is a conditional guarantee about approval matching. The philosophical claims about human affects and the broader alignment of any AI system remain outside its scope.

## Build

Install [Elan](https://github.com/leanprover/elan) and run from the repository root.

```sh
lake build
```

The project pins Lean 4.19.0 and uses Lean’s standard library.

## Related work

Yuki Nakamura’s [*Spinoza’s Ethica in Lean 4*](https://github.com/Nakammura/spinoza-ethica-lean) reconstructs selected arguments from Part I. The [companion paper](https://arxiv.org/abs/2605.02331) uses countermodels to test what follows from particular formalizations of the Principle of Sufficient Reason.
