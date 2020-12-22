// SPDX-License-Identifier: MIT
pragma solidity 0.7.x;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () {}
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

abstract contract Token_interface {
    function owner() public view virtual returns (address);

    function decimals() public view virtual returns (uint8);

    function balanceOf(address who) public view virtual returns (uint256);

    function transfer(address _to, uint256 _value) public virtual returns (bool);

    function allowance(address _owner, address _spender) public virtual returns (uint);

    function transferFrom(address _from, address _to, uint _value) public virtual returns (bool);
}

/**
 * @title TokenRecover
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Allow to recover any ERC20 sent into the contract for error
 */
contract TokenRecover is Ownable {

    /**
     * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
     * @param tokenAddress The token contract address
     * @param tokenAmount Number of tokens to be sent
     */
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        Token_interface(tokenAddress).transfer(owner(), tokenAmount);
    }
}

contract AdminRole is Context, Ownable, ReentrancyGuard {
    using Roles for Roles.Role;
    using SafeMath for uint256;

    Roles.Role private _admins;
    address[] private _signatures;

    constructor () {
        _admins.add(address(0x8186a47C412f8112643381EAa3272a66973E32f2));
        _admins.add(address(0xEe3EA17E0Ed56a794e9bAE6F7A6c6b43b93333F5));
    }

    modifier onlyAdmin() {
        require(isAdmin(_msgSender()), "AdminRole: you don't have permission to perform that action");
        _;
    }

    modifier onlyOwnerOrAdmin() {
        require(isAdminOrOwner(_msgSender()), "you don't have permission to perform that action");
        _;
    }

    function isAdminOrOwner(address account) public view returns (bool) {
        return isAdmin(account) || isOwner();
    }

    function isAdmin(address account) public view returns (bool) {
        return _admins.has(account);
    }

    //adding a signature for the next operation
    function addSignature4NextOperation() public onlyOwnerOrAdmin {
        bool exist = false;
        for (uint256 i = 0; i < _signatures.length; i++) {
            if (_signatures[i] == _msgSender()) {
                exist = true;
                break;
            }
        }
        require(!exist, "You signature already exists");
        _signatures.push(_msgSender());
    }

    // removing a signature for the next operation
    function cancelSignature4NextOperation() public onlyOwnerOrAdmin {
        for (uint256 i = 0; i < _signatures.length; i++) {
            if (_signatures[i] == _msgSender()) {
                _remove_signatures(i);
                return;
            }
        }
        require(false, "not found");

    }

    function checkValidMultiSignatures() public view returns (bool){
        return _signatures.length >= 2;
        //all_signatures = 3 (1 for owner + 2 for admin)
    }

    function revokeAllMultiSignatures() public onlyOwnerOrAdmin {
        delete _signatures;
    }

    function checkExistSignature(address account) public view returns (bool){
        bool exist = false;
        for (uint256 i = 0; i < _signatures.length; i++) {
            if (_signatures[i] == account) {
                exist = true;
                break;
            }
        }
        return exist;
    }

    function _remove_signatures(uint index) private {
        if (index >= _signatures.length) return;
        for (uint i = index; i < _signatures.length - 1; i++) {
            _signatures[i] = _signatures[i + 1];
        }
        _signatures.pop();
    }

}


contract WizRefund is AdminRole, TokenRecover {
    using SafeMath for uint256;

    uint256 constant PHASES_COUNT = 4;
    uint256 private _token_exchange_rate = 273789679021000; //0.000273789679021 ETH per 1 token
    uint256 private _totalburnt = 0;
    uint256 public final_distribution_balance;
    uint256 public sum_burnt_amount_registered;

    address payable[] private _participants;

    mapping(address => uint256) private _burnt_amounts;
    mapping(address => bool) private _participants_with_request;
    mapping(address => bool) private _is_final_withdraw;

    struct PhaseParams {
        string NAME;
        bool IS_STARTED;
        bool IS_FINISHED;
    }
    PhaseParams[] public phases;

    Token_interface public token;

    event BurningRequiredValues(uint256 allowed_value, uint256 topay_value, address indexed sc_address, uint256 sc_balance);
    event LogWithdrawETH(address indexed wallet, uint256 amount);
    event LogRefundValue(address indexed wallet, uint256 amount);

    constructor () {

        token = Token_interface(address(0x2F9b6779c37DF5707249eEb3734BbfC94763fBE2));

        // 0 - first
        PhaseParams memory phaseInitialize;
        phaseInitialize.NAME = "Initialize";
        phaseInitialize.IS_STARTED = true;
        phases.push(phaseInitialize);

        // 1 - second
        // tokens exchanging is active in this phase, tokenholders may burn their tokens using
        // one of the following methods:
        // method 1: tokenholder has to call approve(params: this SC address, amount in
        //           uint256) method in Token SC, then he/she has to call refund()
        //           method in this SC, all tokens from amount will be exchanged and the
        //           tokenholder will receive his/her own ETH on his/her own address
        // method 2: tokenholder has to call approve(params: this SC address, amount in
        //           uint256) method in Token SC, then he/she has to call
        //           refundValue(amount in uint256) method in this SC, all tokens
        //           from the refundValue's amount field will be exchanged and the
        //           tokenholder will receive his/her own ETH on his/her own address
        // method 3: if somebody accidentally sends tokens to this SC directly you may use
        //           refundTokensTransferredDirectly(params: tokenholder ETH address, amount in
        //           uint256) method with mandatory multisignatures
        PhaseParams memory phaseFirst;
        phaseFirst.NAME = "the First Phase";
        phases.push(phaseFirst);

        // 2 - third
        // in this phase tokeholders who exchanged their own tokens in phase 1 may claim a
        // remaining ETH stake with register() method
        PhaseParams memory phaseSecond;
        phaseSecond.NAME = "the Second Phase";
        phases.push(phaseSecond);

        // 3 - last
        // this is a final distribution phase. Everyone who left the request during the
        // phase 2 with register() method will get remaining ETH amount
        // in proportion to their exchanged tokens
        PhaseParams memory phaseFinal;
        phaseFinal.NAME = "Final";
        phases.push(phaseFinal);
    }

    //
    // ####################################
    //

    //only owner or admins can top up the smart contract with ETH
    receive() external payable {
        require(isAdminOrOwner(_msgSender()), "the contract can't receive amount from this address");
    }

    // owner or admin may withdraw ETH from this SC, multisig is mandatory
    function withdrawETH(address payable recipient, uint256 value) external onlyOwnerOrAdmin nonReentrant {
        require(checkValidMultiSignatures(), "multisig is mandatory");
        require(address(this).balance >= value, "not enough funds");
        (bool success,) = recipient.call{value : value}("");
        require(success, "Transfer failed");
        emit LogWithdrawETH(msg.sender, value);
        revokeAllMultiSignatures();
    }

    function getExchangeRate() external view returns (uint256){
        return _token_exchange_rate;
    }

    function getBurntAmountByAddress(address holder) public view returns (uint256){
        return _burnt_amounts[holder];
    }

    function getBurntAmountTotal() external view returns (uint256) {
        return _totalburnt;
    }

    function getParticipantAddressByIndex(uint256 index) external view returns (address){
        return _participants[index];
    }

    function getNumberOfParticipants() public view returns (uint256){
        return _participants.length;
    }

    function isRegistration(address participant) public view returns (bool){
        return _participants_with_request[participant];
    }

    //
    // ####################################
    //
    // tokenholder has to call approve(params: this SC address, amount in uint256)
    // method in Token SC, then he/she has to call refund() method in this
    // SC, all tokens from amount will be exchanged and the tokenholder will receive
    // his/her own ETH on his/her own address
    function refund() external {
        address sender = _msgSender();
        uint256 allowed_value = token.allowance(sender, address(this));
        refundValue(allowed_value);
    }
    // tokenholder has to call approve(params: this SC address, amount in uint256)
    // method in Token SC, then he/she has to call refundValue(amount in
    // uint256) method in this SC, all tokens from the refundValue's amount
    // field will be exchanged and the tokenholder will receive his/her own ETH on his/her
    // own address
    function refundValue(uint256 value) public nonReentrant {
        uint256 i = getCurrentPhaseIndex();
        require(i == 1 && !phases[i].IS_FINISHED, "Not Allowed phase");
        // First phase

        address payable sender = _msgSender();
        uint256 allowed_value = token.allowance(sender, address(this));
        bool is_allowed = allowed_value >= value;

        require(is_allowed, "Not Allowed value");

        uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** 18);
        BurningRequiredValues(allowed_value, topay_value, address(this), address(this).balance);
        require(address(this).balance >= topay_value, "Insufficient funds");

        require(token.transferFrom(sender, address(0), value), "Error with transferFrom");

        if (_burnt_amounts[sender] == 0) {
            _participants.push(sender);
        }

        _burnt_amounts[sender] = _burnt_amounts[sender].add(value);
        _totalburnt = _totalburnt.add(value);

        (bool success,) = sender.call{value : topay_value}("");
        require(success, "Transfer failed");
        emit LogRefundValue(msg.sender, topay_value);
    }

    // if somebody accidentally sends tokens to this SC directly you may use
    // burnTokensTransferredDirectly(params: tokenholder ETH address, amount in
    // uint256)
    // requires multisig 2/3
    function refundTokensTransferredDirectly(address payable participant, uint256 value) external onlyOwnerOrAdmin nonReentrant {
        uint256 i = getCurrentPhaseIndex();
        require(i == 1, "Not Allowed phase");
        // First phase

        require(checkValidMultiSignatures(), "multisig is mandatory");

        uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** uint256(token.decimals()));
        require(address(this).balance >= topay_value, "Insufficient funds");

        require(token.transfer(address(0), value), "Error with transfer");

        if (_burnt_amounts[participant] == 0) {
            _participants.push(participant);
        }

        _burnt_amounts[participant] = _burnt_amounts[participant].add(value);
        _totalburnt = _totalburnt.add(value);

        revokeAllMultiSignatures();

        (bool success,) = participant.call{value : topay_value}("");
        require(success, "Transfer failed");
        emit LogRefundValue(participant, topay_value);
    }

    // This is a final distribution after phase 2 is fihished, everyone who left the
    // request with register() method will get remaining ETH amount
    // in proportion to their exchanged tokens
    // requires multisig 2/3
    function startFinalDistribution(uint256 start_index, uint256 end_index) external onlyOwnerOrAdmin nonReentrant {
        require(end_index < getNumberOfParticipants());
        
        uint256 j = getCurrentPhaseIndex();
        require(j == 3 && !phases[j].IS_FINISHED, "Not Allowed phase");
        // Final Phase
        require(checkValidMultiSignatures(), "multisig is mandatory");

        uint256 pointfix = 1000000000000000000;
        // 10^18

        for (uint i = start_index; i <= end_index; i++) {
            if(!isRegistration(_participants[i]) || isFinalWithdraw(_participants[i])){
                continue;
            }
            
            uint256 piece = getBurntAmountByAddress(_participants[i]).mul(pointfix).div(sum_burnt_amount_registered);
            uint256 value = final_distribution_balance.mul(piece).div(pointfix);
            
            if (value > 0) {
                _is_final_withdraw[_participants[i]] = true;
                (bool success,) = _participants[i].call{value : value}("");
                require(success, "Transfer failed");
                emit LogWithdrawETH(_participants[i], value);
            }
        }

        revokeAllMultiSignatures();
    }

    function isFinalWithdraw(address _wallet) public view returns (bool) {
        return _is_final_withdraw[_wallet];
    }
    
    function empty_final_withdraw_data(uint256 start_index, uint256 end_index) external onlyOwnerOrAdmin{
        require(end_index < getNumberOfParticipants());
        
        uint256 i = getCurrentPhaseIndex();
        require(i == 3 && !phases[i].IS_FINISHED, "Not Allowed phase");
        
        for (uint j = start_index; j <= end_index; j++) {
            if(isFinalWithdraw(_participants[j])){
                _is_final_withdraw[_participants[j]] = false;
            }
        }
    }

    // tokeholders who exchanged their own tokens in phase 1 may claim a remaining ETH stake
    function register() external {
        _write_register(_msgSender());
    }

    // admin can claim register() method instead of tokenholder
    function forceRegister(address payable participant) external onlyOwnerOrAdmin {
        _write_register(participant);
    }

    function _write_register(address payable participant) private {
        uint256 i = getCurrentPhaseIndex();
        require(i == 2 && !phases[i].IS_FINISHED, "Not Allowed phase");
        // Second phase

        require(_burnt_amounts[participant] > 0, "This address doesn't have exchanged tokens");

        _participants_with_request[participant] = true;
        sum_burnt_amount_registered  = sum_burnt_amount_registered.add(getBurntAmountByAddress(participant));
    }

    function startNextPhase() external onlyOwnerOrAdmin {
        uint256 i = getCurrentPhaseIndex();
        require((i + 1) < PHASES_COUNT);
        require(phases[i].IS_FINISHED);
        phases[i + 1].IS_STARTED = true;
        if (phases[2].IS_STARTED && !phases[2].IS_FINISHED && phases[1].IS_FINISHED) {
            sum_burnt_amount_registered = 0;
        }else if (phases[3].IS_STARTED && phases[2].IS_FINISHED) {
            final_distribution_balance = address(this).balance;
            // need delete _is_final_withdraw but solidity doesn't support delete of mapping
            // must call empty_final_withdraw_data for range 0 - getNumberOfParticipants()
        }
    }

    function finishCurrentPhase() external onlyOwnerOrAdmin {
        uint256 i = getCurrentPhaseIndex();
        phases[i].IS_FINISHED = true;
    }

    // this method reverts the current phase to the previous one
    function revertPhase() external onlyOwnerOrAdmin {
        uint256 i = getCurrentPhaseIndex();

        require(i > 0, "Initialize phase is active already");

        phases[i].IS_STARTED = false;
        phases[i].IS_FINISHED = false;

        phases[i - 1].IS_STARTED = true;
        phases[i - 1].IS_FINISHED = false;
    }

    function getPhaseName() external view returns (string memory){
        uint256 i = getCurrentPhaseIndex();
        return phases[i].NAME;
    }

    function getCurrentPhaseIndex() public view returns (uint256){
        uint256 current_phase = 0;
        for (uint256 i = 0; i < PHASES_COUNT; i++)
        {
            if (phases[i].IS_STARTED) {
                current_phase = i;
            }
        }
        return current_phase;
    }
}
