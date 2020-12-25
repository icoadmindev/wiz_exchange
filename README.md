# ERC-20 Refund Token Smart Contract

## How to work with the real WIZ token

1. Deploy the [Refund Smart Contract](https://github.com/icoadmindev/wiz_refund)
2. Top-up the Smart Contract with ETH from the Owner or Admin address
3. Call `finishCurrentPhase()` to finish init phase
4. Call `startNextPhase()` to start phase 1

Tokenholder's flow

5. Call Token Smart Contract `approve(address _spender, uint _value)` method, where `_spender` is Refund Token Smart Contract address (from p.1) and `_value` is the value of tokens which Tokenholder is about to burn

6. Call `refund()` method in Refund Token Smart Contract, all tokens corresponding to the amount will be refunded and the Tokenholder will receive ETH on his/her own ETH address instantly

Refunding Owner's flow to end phase 1

7. Call `finishCurrentPhase()` to finish the phase 1
8. Call `startNextPhase()` to start the phase 2

Tokenholder's flow for phase 2

9. Call `register()` method in Refund Token smart contract, only the Tokenholders who refunded their tokens in phase 1 will be able to stake claim for the remaining ETH 

Refunding Owner's flow to end phase 2

10. Call `finishCurrentPhase()` to finish the phase 2
11. Call `startNextPhase()` to start the phase 3
12. Call `startFinalDistribution()` to start the distribution of the remaining ETH, the Tokenholders will get the remaining ETH amount in proportion to their refunded tokens instantly

## How to test

Refunding Owner's flow

1. Deploy the ERC-20 Token Smart Contract
2. Mint as many tokens as you want using `mint()` method
3. Call `start()` method to make the token transferable
4. Change `_token_exchange_rate` variable in [Refund Smart Contract](https://github.com/icoadmindev/wiz_refund) to set the exchange rate in wei `(default is 1 token = 273789679021000 wei = 0.000273789679021 ETH)`
5. Change `token` variable in [Refund Smart Contract](https://github.com/icoadmindev/wiz_refund) to set the recently deployed Token Smart Contract address (from p.1)
6. Deploy the [Refund Smart Contract](https://github.com/icoadmindev/wiz_refund)
7. Send some ETH to the Refund Smart Contract address from Owner or Admin address
8. call `finishCurrentPhase()` to finish the init phase
9. call `startNextPhase()` to start the phase 1

Tokenholder's flow

10. call Token Smart Contract `approve(address _spender, uint _value)` method, where _spender is Refund Smart Contract address (from p.6) and _value is the value of tokens which Tokenholder is about to burn

11. option 1: call `refund()` method in Refund Smart Contract, all tokens corresponding to the amount will be refunded and the Tokenholder will receive ETH on his/her own ETH address instantly

Refunding Owner's flow

12. call `finishCurrentPhase()` to finish the phase 1
13. call `startNextPhase()` to start the phase 2

Tokenholder's flow

14. call `register()` method in Refund Smart Contract, only the Tokenholders who refunded their own tokens in phase 1 will be able stake claim for the remaining ETH.

Refunding Owner's flow

15. call `finishCurrentPhase()` to finish the phase 2
16. call `startNextPhase()` to start the phase 3
17. call `startFinalDistribution()` to start the distribution of the remaining ETH, the Tokenholders will get remaining ETH amount in proportion to their refunded tokens instantly.
