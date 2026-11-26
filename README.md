# Ethica IV

A Lean 4 exploration of Spinoza and AI alignment. When does knowing a rule make it govern an action?

[Part IV, Proposition 14](https://en.wikisource.org/wiki/Ethics_(Spinoza)/Part_4) distinguishes the truth of an idea from the force it can have over what we do. IV.7 and IV.15–16 supply the background for the two decision examples in this repository.

- **Decision model.** A concrete agent recognizes that a proposed action is forbidden and still selects it when an immediate incentive outweighs restraint. A second example holds the incentive fixed and shows how weaker restraint can flip the decision. Scores and the tie rule are modeling choices. The model uses “forbidden” as the ground truth for the proposal under study.
- **Payment gate.** A Lean theorem shows that every executed payment has a matching approval when all effects pass through the gate. The match binds the invoice version, amount, currency, and beneficiary account. The model takes the validity of the approval input and complete mediation as assumptions. Deployment would also need to establish that the payment recorded by the ERP is the transaction the gate checked.

The Lean code explores an analogy to the arguments in Part IV. For an existing formal reconstruction of selected arguments in Part I, see [Yuki Nakamura’s work](https://github.com/Nakammura/spinoza-ethica-lean) and the [companion paper](https://arxiv.org/abs/2605.02331).

## Build

With [Elan](https://github.com/leanprover/elan) installed, run:

```sh
lake build
```

The project pins Lean 4.19.0 and has no Mathlib dependency.
