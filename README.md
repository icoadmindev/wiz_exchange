# Burning ERC-20 Tokens Smart Contract

## How to test

Burning Owner's flow

1. deploy [Token smart contract](https://github.com/icoadmindev/wiz_token_burn), create as many tokens as you want using `mint()` method
2. deploy [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn), send some ETH to this address
3. call `setRate()` method in Token Burn smart contract to set the exchange rate in wei `(default is 1 token = 273789679021000 wei = 0.000273789679021 ETH)`
4. call `setToken()` method with the Token smart contract address
5. call `finishCurrentPhase()` to finish init phase
6. call `startNextPhase()` to run phase 1

Tokenholder's flow

7. call Token smart contract `approve(address _spender, uint _value)` method, where _spender is Token Burn smart contract address and _value is the value of tokens which Tokenholder is about to burn

8. option 1: call `burn_allowanced()` method in Token Burn smart contract, all tokens from amount will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

8. option 2: call `burn_allowanced_value(amount in uint256)` method in Token Burn smart contract, all tokens from the burn_allowanced_value's amount field will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

Burning Owner's flow

9. call `finishCurrentPhase()` to finish 1 phase
10. call `startNextPhase()` to run phase 2

Tokenholder's flow

11. call `request_remaining_amount()` method in Token Burn smart contract, only the Tokenholders who burnt their own tokens in phase 1 may claim a remaining ETH stake

Burning Owner's flow

12. call `finishCurrentPhase()` to finish 2 phase
13. call `startNextPhase()` to run distribution phase, the Tokenholders will get remaining ETH amount in proportion to their burnt tokens instantly




## How to work with the real WIZ token

1. deploy [Token Burn (this) smart contract](https://github.com/icoadmindev/wiz_token_burn), send some ETH to this address
2. call `setRate()` method in Token Burn smart contract to set the exchange rate in wei `(default is 1 token = 273789679021000 wei = 0.000273789679021 ETH)`
3. call `setToken(0x2f9b6779c37df5707249eeb3734bbfc94763fbe2)`
4. call `finishCurrentPhase()` to finish init phase
5. call `startNextPhase()` to run phase 1

Tokenholder's flow

6. call Token smart contract `approve(address _spender, uint _value)` method, where `_spender` is Token Burn smart contract address and `_value` is the value of tokens which Tokenholder is about to burn

7. option 1: call `burn_allowanced()` method in Token Burn smart contract, all tokens from amount will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

7. option 2: call `burn_allowanced_value(amount in uint256)` method in Token Burn smart contract, all tokens from the burn_allowanced_value's amount field will be burnt and the Tokenholder will receive ETH on his/her own ETH address instantly

Burning Owner's flow

8. call `finishCurrentPhase()` to finish 1 phase
9. call `startNextPhase()` to run phase 2

Tokenholder's flow

10. call `request_remaining_amount()` method in Token Burn smart contract, only the Tokenholders who burnt their own tokens in phase 1 may claim a remaining ETH stake

Burning Owner's flow

11. call `finishCurrentPhase()` to finish 2 phase
12. call `startNextPhase()` to run distribution phase, the Tokenholders will get remaining ETH amount in proportion to their burnt tokens instantly


## Useful Burning Owner's methods
`addAdmin()` — add a new admin, multisig is mandatory

`addSignature4NextOperation()` — sign an operation

`cancelSignature4NextOperation()` — cancel the signature

`ethout()` — withdraw ETH from this SC, multisig is mandatory

`hand_transfer_fix_burn()` — if somebody accidentally sends tokens to this SC directly you may use this method, multisig is mandatory

`removeAdmin()` — remove an admin, multisig is mandatory

`revertAbovePhase()` — this method reverts the current phase to the previous one
