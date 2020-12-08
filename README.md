# Burning ERC-20 Tokens Smart Contract

## How to test

Burning Owner's flow

1. deploy a ERC-20 Token smart contract
2. mint as many tokens as you want using `mint()` method
3. call `start()` method to make the token be transferable
4. change `_token_exchange_rate` variable in [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn) to set the exchange rate in wei `(default is 1 token = 273789679021000 wei = 0.000273789679021 ETH)`
5. change `token` variable in [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn) to set the recently deployed Token smart contract address (from p.1)
6. deploy [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn)
7. send some ETH to the Token Burn smart contract address from Owner or Admin address
8. call `finishCurrentPhase()` to finish the init phase
9. call `startNextPhase()` to start the phase 1

Tokenholder's flow

10. call Token smart contract `approve(address _spender, uint _value)` method, where _spender is Token Burn smart contract address (from p.6) and _value is the value of tokens which Tokenholder is about to burn

11. option 1: call `refund()` method in Token Burn smart contract, all tokens from amount will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

11. option 2: call `refundValue(amount in uint256)` method in Token Burn smart contract, all tokens from the burnValue's amount field will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

Burning Owner's flow

12. call `finishCurrentPhase()` to finish the phase 1
13. call `startNextPhase()` to start the phase 2

Tokenholder's flow

14. call `register()` method in Token Burn smart contract, only the Tokenholders who burnt their own tokens in phase 1 may claim a remaining ETH stake

Burning Owner's flow

15. call `finishCurrentPhase()` to finish the phase 2
16. call `startNextPhase()` to start the phase 3
17. call `startFinalDistribution()` to run remaining ETH distribution, the Tokenholders will get remaining ETH amount in proportion to their burnt tokens instantly




## How to work with the real WIZ token

1. deploy [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn)
2. top up the smart contract with ETH from the Owner or Admin address
3. call `finishCurrentPhase()` to finish the init phase
4. call `startNextPhase()` to start the phase 1

Tokenholder's flow

5. call Token smart contract `approve(address _spender, uint _value)` method, where `_spender` is Token Burn smart contract address (from p.1) and `_value` is the value of tokens which Tokenholder is about to burn

6. option 1: call `refund()` method in Token Burn smart contract, all tokens from amount will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

6. option 2: call `refundValue(amount in uint256)` method in Token Burn smart contract, all tokens from the burnValue's amount field will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

Burning Owner's flow

7. call `finishCurrentPhase()` to finish the phase 1
8. call `startNextPhase()` to start the phase 2

Tokenholder's flow

9. call `register()` method in Token Burn smart contract, only the Tokenholders who burnt their own tokens in phase 1 may claim a remaining ETH stake

Burning Owner's flow

10. call `finishCurrentPhase()` to finish the phase 2
11. call `startNextPhase()` to start the phase 3
12. call `startFinalDistribution()` to run remaining ETH distribution, the Tokenholders will get remaining ETH amount in proportion to their burnt tokens instantly


## Useful Burning Owner's methods
`addSignature4NextOperation()` — sign the next operation

`refundTokensTransferredDirectly()` — if somebody accidentally sends tokens to this SC directly you may use this method, multisig is mandatory

`cancelSignature4NextOperation()` — cancel the signature for the next operation

`revertPhase()` — this method reverts the current phase to the previous one

`withdrawETH()` — withdraw ETH from this SC, multisig is mandatory
